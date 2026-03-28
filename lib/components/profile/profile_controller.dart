import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/profile_service.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/kyc_document.dart';
import 'package:brickbuddy/model/updatefile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final profileFormKey = GlobalKey<FormState>();
  ProfileService profileService = Get.put(ProfileService());
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isAadhar = false.obs;
  RxBool isPan = false.obs;
  RxBool isRera = false.obs;
  RxInt age = 0.obs;
  RxInt selectedAge = 0.obs;
  RxList profileRes = [].obs;
  RxInt radioVal = 0.obs;
  RxInt isKycVerified = 0.obs;
  late File imgFile;
  RxString image = ''.obs;
  String fileName = '';

  RxList<KYCDocument> adharFilesList = <KYCDocument>[].obs;
  RxList<KYCDocument> panFilesList = <KYCDocument>[].obs;
  RxList<KYCDocument> reraFilesList = <KYCDocument>[].obs;

  List<KYCDocument> filteredItems = <KYCDocument>[].obs;
  RxBool isDocumentsLoading = false.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  RxBool isProfileLoading = false.obs;

  @override
  void onInit() async {
    await getAgentProfile();
    getKycDetails();
    super.onInit();
  }

  //takeProductImageFromCamera
  void takeProductImageFromCamera() async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropProductImage(picked);
  }

  //selectProductImageFromGallery
  Future selectProductImageFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropProductImage(pickedFile);
  }

  //Croping product Image Functionality
  Future<Null> _cropProductImage(imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.rectangle,
      compressQuality: 60,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: const Color.fromRGBO(138, 56, 247, 1),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      print("croppedFile: ${croppedFile}");
      imageFile = croppedFile;
      image.value = croppedFile.path;
      print("path: ${image.value}");
      imgFile = File(image.value);
      fileName = basename(image.value);
    }

    print("final imageFile file, ${imageFile},${imageFile.runtimeType}");
    print("final imgFile file, $imgFile,${imgFile.runtimeType}");
    print("final image.value file, ${image.value}");
    print("final file, ${image.value.runtimeType}");

    uploadProfile(fileName, image.value);
  }

  uploadProfile(fileName, path) {
    isProfileLoading.value = true;
    profileService.uploadProfile(fileName, path).then((res) async {
      isProfileLoading.value = false;
      print("uploadProfile res: $res");
      CommonService.instance.profileUrl.value = res["data"];
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('profilePic', res["data"]);

      Get.rawSnackbar(
          message: "Profile uploaded successfully",
          backgroundColor: ThemeConstants.successColor);
    }).catchError((err) {
      isProfileLoading.value = false;
      print("uploadProfile err: $err");
    });
  }

  uploadKycDocuments(subType) {
    print("111111111111: $subType");
    print("22222222222: $fileName");
    print("33333333333333: ${image.value}");
    isDocumentsLoading.value = true;
    if (subType == "ADHAR") {
      filteredItems =
          adharFilesList.where((item) => item.path != null).toList();
    }
    if (subType == "PAN") {
      filteredItems = panFilesList.where((item) => item.path != null).toList();
    }
    if (subType == "RERA") {
      filteredItems = reraFilesList.where((item) => item.path != null).toList();
    }
    profileService
        .uploadKYCDocuments(fileName, image.value, subType)
        .then((res) {
      print('subtype........ $subType');
      if (subType == 'RERA') {
        isRera.value = false;
      } else {
        if (subType == 'PAN') {
          isPan.value = false;
        } else {
          isAadhar.value = false;
        }
      }
      getKycDetails();
      print('subtype123........ $subType,${jsonEncode(adharFilesList)}');
      // isDocumentsLoading.value = false;
      print("res: $res");

      Get.rawSnackbar(
          message: res['message'],
          backgroundColor: ThemeConstants.successColor);
      filteredItems.clear();
    }).catchError((err) {
      isDocumentsLoading.value = false;
      print("err: $err");
    });
  }

  saveLeadAge(int age) {
    print("age: $age");
    isLoading.value = true;
    profileService.saveLeadAge(age).then((res) {
      isLoading.value = false;
      print('saveLeadAge res $res');
      Get.rawSnackbar(
          message: res['message'],
          backgroundColor: ThemeConstants.successColor);
    }).catchError((e) {
      print('getLeadDetails error: $e');
      isLoading.value = false;
    });
  }

  getAgentProfile() {
    profileRes.clear();
    isLoading.value = true;
    profileService.getProfile().then((res) {
      setDetails(res['data'][0]);
      profileRes.addAll(res['data']);
      print('profileRes .. $profileRes');
      print('res....${res['data']}');
      selectedAge.value = res['data'][0]['ageConfig'];
      mobileNumberController.text = res['data'][0]['mobileNumber'];
      print('selectedage: ${res['data'][0]['ageConfig']}');
      isLoading.value = false;
    }).catchError((e) {
      print('getProjects error: $e');
      isLoading.value = false;
    });
  }

  setDetails(data) {
    firstNameController.text = data["firstName"];
    lastNameController.text = data['lastName'];
    emailController.text = data['emailId'];
    ageController.text = data['ageConfig'].toString();
    print("age....${ageController.text}");
  }

  updateProfile(firstName, lastName, email, pwd, confirmPwd, image) {
    print('image.. $image,${image.isEmpty},${firstName.isEmpty},$firstName');
    if (pwd != confirmPwd) {
      Get.rawSnackbar(
        message: 'password not matched',
      );
    } else {
      if (email.isNotEmpty) {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
        if (emailValid) {
          isLoading.value = true;
          profileService
              .updateProfile(firstName, lastName, email, pwd, confirmPwd, image)
              .then((res) async {
            print('profile update res ${res['data']}');
            radioVal.value = 0;
            passwordController.text = '';
            confirmPasswordController.text = '';
            SharedPreferences prefs = await SharedPreferences.getInstance();
            // if (image.isNotEmpty) {
            CommonService.instance.profileUrl.value =
                CommonService.instance.profileUrl.value;
            prefs.setString(
                'profilePic', CommonService.instance.profileUrl.value);
            // } else {
            //   prefs.setString(
            //       'profilePic', CommonService.instance.profileUrl.value);
            // }
            prefs.setString('firstName', firstName);
            prefs.setString('lastName', lastName);
            prefs.setString('email', email);
            CommonService.instance.firstName.value = firstName;
            CommonService.instance.lastName.value = lastName;
            // CommonService.instance.email.value = email;
            Get.rawSnackbar(
                message: 'Profile updated successfully',
                backgroundColor: ThemeConstants.successColor);
            getAgentProfile();

            isLoading.value = false;
          }).catchError((e) {
            print('getLeadDetails error: $e');
            isLoading.value = false;
          });
        } else {
          Get.rawSnackbar(message: 'Please enter valid email');
        }
      } else if (profileFormKey.currentState!.validate()) {
        isLoading.value = true;
        profileService
            .updateProfile(firstName, lastName, email, pwd, confirmPwd, image)
            .then((res) async {
          print('profile update res ${res['data']}');
          radioVal.value = 0;
          passwordController.text = '';
          confirmPasswordController.text = '';
          SharedPreferences prefs = await SharedPreferences.getInstance();
          CommonService.instance.profileUrl.value =
              CommonService.instance.profileUrl.value;
          prefs.setString(
              'profilePic', CommonService.instance.profileUrl.value);
          prefs.setString('firstName', firstName);
          prefs.setString('lastName', lastName);
          CommonService.instance.firstName.value = firstName;
          CommonService.instance.lastName.value = lastName;
          Get.rawSnackbar(
              message: 'Profile updated successfully',
              backgroundColor: ThemeConstants.successColor);
          getAgentProfile();
          isLoading.value = false;
        }).catchError((e) {
          print('getLeadDetails error: $e');
          isLoading.value = false;
        });
      }
    }
  }

  getKycDetails() {
    adharFilesList.clear();
    panFilesList.clear();
    reraFilesList.clear();
    isDocumentsLoading.value = true;
    profileService.getKycDetails().then((res) {
      print("getKycDetails res: $res");
      print("getKycDetails 123: ${res["data"][0]["isVerified"]}");
      isDocumentsLoading.value = false;
      res["data"].forEach((d) {
        if (d["adhar"] != null) {
          adharFilesList.add(KYCDocument.fromJson(d["adhar"]));
        }
        if (d["pan"] != null) {
          panFilesList.add(KYCDocument.fromJson(d["pan"]));
        }
        if (d["rera"] != null) {
          reraFilesList.add(KYCDocument.fromJson(d["rera"]));
        }
      });
      for (int i = 0; i < adharFilesList.length - 1; i++) {
        adharFilesList[i].fILEID = '';
      }

      // Update the fileId of the last document
      if (adharFilesList.isNotEmpty) {
        adharFilesList.last.fILEID = CommonService.instance.foreKey.value;
      }
      isKycVerified.value = res["data"][0]["isVerified"];
      print('aadhh.. ${jsonEncode(adharFilesList)}');
    }).catchError((err) {
      isDocumentsLoading.value = false;
      print("getKycDetails err: $err");
    });
  }

  void takeDocumentImageFromCamera(subType) async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.camera);
    cropDocumentImage(picked, subType);
  }

  Future<Null> cropDocumentImage(imageFile, subType) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      cropStyle: CropStyle.rectangle,
      compressQuality: 60,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: const Color.fromRGBO(138, 56, 247, 1),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      print("croppedFile: ${croppedFile}");
      imageFile = croppedFile;
      image.value = croppedFile.path;
      print("path: ${image.value}");
      imgFile = File(image.value);
      fileName = basename(image.value);
    }
    print("final imageFile file, ${imageFile},${imageFile.runtimeType}");
    print("final imgFile file, $imgFile,${imgFile.runtimeType}");
    print("final image.value file, ${image.value}");
    print("final file, ${image.value.runtimeType}");
    print("subtype: $subType");

    if (subType == "ADHAR") {
      KYCDocument kycDocument = KYCDocument();
      kycDocument.nAME = fileName;
      kycDocument.path = image.value;
      kycDocument.uRL = "";

      adharFilesList.add(kycDocument);
      isAadhar.value = true;
    }

    if (subType == "PAN") {
      KYCDocument kycDocument = KYCDocument();
      kycDocument.nAME = fileName;
      kycDocument.path = image.value;
      kycDocument.uRL = "";

      panFilesList.add(kycDocument);
      isPan.value = true;
    }

    if (subType == "RERA") {
      KYCDocument kycDocument = KYCDocument();
      kycDocument.nAME = fileName;
      kycDocument.path = image.value;
      kycDocument.uRL = "";

      reraFilesList.add(kycDocument);
      isRera.value = true;
    }
  }

  Future pickFile(subType) async {
    print("Pick file called");
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'JPEG', 'PNG'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      image.value = result.files.single.path!;
      fileName = basename(image.value);
      print("file: $file, path: ${image.value}, fileName: ${fileName}");
      if (subType == "ADHAR") {
        KYCDocument kycDocument = KYCDocument();
        kycDocument.nAME = fileName;
        kycDocument.path = image.value;
        kycDocument.uRL = "";

        adharFilesList.add(kycDocument);
        isAadhar.value = true;
      }

      if (subType == "PAN") {
        KYCDocument kycDocument = KYCDocument();
        kycDocument.nAME = fileName;
        kycDocument.path = image.value;
        kycDocument.uRL = "";

        panFilesList.add(kycDocument);
        isPan.value = true;
      }

      if (subType == "RERA") {
        KYCDocument kycDocument = KYCDocument();
        kycDocument.nAME = fileName;
        kycDocument.path = image.value;
        kycDocument.uRL = "";

        reraFilesList.add(kycDocument);
        isRera.value = true;
      }
    } else {}
  }

  deleteDocument(id, type) {
    isDocumentsLoading.value = true;
    profileService.deleteDocument(id, type).then((res) {
      //  isDocumentsLoading.value = false;
      print("delete document res: $res");
      Get.rawSnackbar(
          message: res["message"],
          backgroundColor: ThemeConstants.successColor);
      getKycDetails();
    }).catchError((err) {
      isDocumentsLoading.value = false;
      print("deleteDocument Error: $err");
    });
  }

  updateFile(fileId, isAadhar, isPan, isRera) {
    isDocumentsLoading.value = true;

    UpdateFile updateFile = UpdateFile();

    FileDetails fileDetails = FileDetails();
    fileDetails.category =
        categoryController.text != '' ? categoryController.text.split(',') : [];
    fileDetails.description = descriptionController.text;
    fileDetails.title = titleController.text;
    fileDetails.fileId = fileId;

    updateFile.fileDetails = FileDetails();
    updateFile.fileDetails = fileDetails;
    profileService.updateFile(updateFile).then((res) {
      isDocumentsLoading.value = false;
      print("updateFile res: $res}");

      Get.rawSnackbar(
          message: "File updated successfully.",
          backgroundColor: ThemeConstants.successColor);
    }).catchError((error) {
      isDocumentsLoading.value = false;
      print("Error while fetching updateFile: $error");
    });
  }
}

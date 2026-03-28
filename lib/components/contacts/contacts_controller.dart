import 'dart:ffi';
import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/contacts_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/assign_project.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsController extends GetxController {
  ContactService contactService = Get.put(ContactService());

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController primaryNumberController = TextEditingController();
  TextEditingController secondaryNumberController = TextEditingController();
  TextEditingController workinfoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController contactid = TextEditingController();
  TextEditingController notesController = TextEditingController();
  RxBool isLoading = false.obs;
  RxList contactsList = [].obs;
  var contactFormKey = GlobalKey<FormState>();
  late File imgFile;
  RxString image = ''.obs;
  RxString conId = ''.obs;
  RxBool isEdit = false.obs;
  RxBool isEnable = false.obs;
  RxBool issearchValue = false.obs;
  RxBool isCloseDialog = false.obs;
  RxBool isUploading = false.obs;
  RxBool isFabExpanded = false.obs;
  RxBool isContactsLoading = false.obs;

  ProjectsService projectService = Get.put(ProjectsService());

  RxList<dynamic> mobileContactsList = <dynamic>[].obs;

  RxInt pageOffset = 0.obs;

  ScrollController scrollController = ScrollController();
  RxBool isInfiniteLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  String fileName = "";
  RxString profilePic = "".obs;
  RxString pConId = "".obs;
  RxBool hasSelectedContacts = false.obs;
  RxList<dynamic> selectedContacts = <dynamic>[].obs;
  RxList<dynamic> projectsList = <dynamic>[].obs;
  RxString selectedProject = "".obs;
  RxString selectedBuilderId = ''.obs;
  final projectFormKey = GlobalKey<FormState>();

  RxBool isAssignProjectLoading = false.obs;
  RxInt contactsTotalCount = 0.obs;

  void onInit() async {
    scrollController.addListener(scrollListener);
    await getAllContacts();
    getAllProjects();
    super.onInit();
  }

  void scrollListener() {
    print("Scroll listner called");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("reached limit: ${contactsList.length}");
      if (isInfiniteLoading.value == false) {
        if (issearchValue.value) {
          pageOffset.value = pageOffset.value + 10;
          loadMoreSearchContacts();
        } else {
          pageOffset.value = pageOffset.value + 10;
          loadMoreItems();
        }
      }
    }
  }

  loadMoreItems() {
    isInfiniteLoading.value = true;
    contactService.getAllContacts(pageOffset.value).then((res) {
      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
        for (var contact in contactsList) {
          for (var selectedId in selectedContacts) {
            if (contact["conId"] == selectedId) {
              contact["isChecked"] = true;
            }
          }
        }
        //    pageOffset.value = pageOffset.value + 10;
      }
      isInfiniteLoading.value = false;
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("loadMoreItems  err$onError");
    });
  }

  loadMoreSearchContacts() {
    isInfiniteLoading.value = true;
    contactService
        .getAllContactsBySearchValue(pageOffset.value, searchController.text)
        .then((res) {
      isLoading.value = false;
      print("length: ${res['data']['contacts'].length}");
      //  contactsTotalCount.value = res['data']['contacts'].length;
      // contactsList.clear();

      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
        for (var contact in contactsList) {
          for (var selectedId in selectedContacts) {
            if (contact["conId"] == selectedId) {
              contact["isChecked"] = true;
            }
          }
        }
      }
      isInfiniteLoading.value = false;
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("loadMoreItems  err$onError");
    });
  }

  getBuilderIdByProjectId(String projectId, List<dynamic> projects) {
    for (var project in projects) {
      if (project['project']?['PROJECT_ID'] == projectId) {
        selectedBuilderId.value = project['project']?['BUILDER_ID'];
      }
    }
  }

  getAllProjects() {
    contactService.getAllProjects().then((res) {
      print('resof... ${res['data']['projects']}');

      projectsList.addAll(res['data']['projects']);
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("getAllProjects  err$onError");
    });
  }

  getAllContacts() async {
    pageOffset.value = 0;
    contactsList.clear();
    hasSelectedContacts.value ? SizedBox.shrink() : selectedContacts.clear();
    isLoading.value = true;
    await contactService.getAllContacts(pageOffset.value).then((res) async {
      print("contacts: ${res['data']}");
      contactsTotalCount.value = res['data']['count'];
      var obj;
      print('selCont... $selectedContacts');
      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          print("contacts: ${c['firstName']}");
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
        for (var contact in contactsList) {
          for (var selectedId in selectedContacts) {
            if (contact["conId"] == selectedId) {
              contact["isChecked"] = true;
            }
          }
        }
        //  }
        //}
      }
      print('getContacts : $contactsList');
      //  pageOffset.value = 10;
      isLoading.value = false;
    }).catchError((e) {
      print('getContacts error: $e');
      isLoading.value = false;
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  save(img, conId, firstName, lastName, address, email, notes, primaryNumber,
      secondaryNumber, workinfo) {
    contactsList.clear();

    print('inside add contact');
    print('email123 ${email.trim()}');
    //
    if (email.trim().isNotEmpty) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(email)) {
        isCloseDialog.value = false;
        print('email....not valid');
        return Get.rawSnackbar(
          message: 'Enter a valid email.',
        );
      } else {
        isLoading.value = true;
        print('email....else....');
        contactService
            .addcontact('', firstName, lastName, address, email, notes,
                primaryNumber, secondaryNumber, workinfo)
            .then((res) async {
          print('getcontactdetails res ${res['data']}');
          isCloseDialog.value = true;

          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
          } else {
            Navigator.of(Get.context!, rootNavigator: true).pop();
          }

          Get.rawSnackbar(
              message: res["message"],
              backgroundColor: ThemeConstants.successColor);
          print('image3333 $image');
          print('conId ${res['data'][0]["conId"]}');

          if (img != "") {
            image.value = img;
            pConId.value = res['data'][0]["conId"];
            print('xyzz123zz');
            uploadContactPhoto();
            pageOffset.value = 0;
            isFabExpanded.value = false;
            await getAllContacts();
            print('xyzzzz');
          } else {
            pageOffset.value = 0;
            isFabExpanded.value = false;
            // isLoading.value = false;
            await getAllContacts();
          }
          // contactsList.clear();
          // contactsList.addAll(res['data']);
          print('list: $contactsList');
        }).catchError((e) {
          isFabExpanded.value = false;
          print('getcontactdetails error: $e');
          isLoading.value = false;
        });
      }
    } else {
      print('last else......');
      print(
          'details... ,$firstName,$lastName,$address,$email,$notes,$primaryNumber,$secondaryNumber,$workinfo');
      isLoading.value = true;
      contactService
          .addcontact('', firstName, lastName, address, email, notes,
              primaryNumber, secondaryNumber, workinfo)
          .then((res) async {
        isCloseDialog.value = true;

        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        } else {
          Navigator.of(Get.context!, rootNavigator: true).pop();
        }

        print('getcontactdetails res ${res['data']}');

        Get.rawSnackbar(
            message: res["message"],
            backgroundColor: ThemeConstants.successColor);
        print('image3333 $image');
        print('conId ${res['data'][0]["conId"]}');

        if (img != "") {
          image.value = img;
          pConId.value = res['data'][0]["conId"];
          print('xyzz123zz');
          uploadContactPhoto();
          pageOffset.value = 0;
          isFabExpanded.value = false;
          await getAllContacts();
          print('xyzzzz');
        } else {
          pageOffset.value = 0;
          isFabExpanded.value = false;
          // isLoading.value = false;
          await getAllContacts();
        }
        // contactsList.clear();
        // contactsList.addAll(res['data']);
        print('list: $contactsList');
      }).catchError((e) {
        isFabExpanded.value = false;
        print('getcontactdetails error: $e');
        isLoading.value = false;
      });
    }
  }

  delete(conId) async {
    try {
      print('inside delete contact');
      print('id: $conId');
      isLoading.value = true;
      await contactService.deleteContact(conId);
      searchController.text = '';
      Get.rawSnackbar(
        message: 'Contact deleted successfully',
      );
      isLoading.value = true;
      getAllContacts();
      // print('Contact deleted successfully');
    } catch (error) {
      // Handle errors
      print('Error deleting contact: $error');
      // Optionally, you can show an error message here
    }
  }

  updateContact(firstName, lastName, primaryNumber, secondaryNumber, workinfo,
      email, address, notes, conId) {
    pConId.value = conId;
    contactsList.clear();
    if (email.trim().isNotEmpty) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(email)) {
        isCloseDialog.value = false;
        print('email....not valid');
        return Get.rawSnackbar(
          message: 'Enter a valid email.',
        );
      } else {
        print('inside edit contact');
        isLoading.value = true;
        print('Conid: $conId');
        print('Firstname: $firstName');
        print('Lastname: $lastName');
        print('PrimaryNum: $primaryNumber');
        print('SecondaryNum: $secondaryNumber');
        print('Workinfo:$workinfo');
        print('Email:$email');
        print('Address:$address');
        print('Notes:$notes');
        print('img00 ${image.value}');
        contactService
            .editContact(firstName, lastName, primaryNumber, secondaryNumber,
                workinfo, email, address, notes, conId)
            .then((res) async {
          isCloseDialog.value = true;

          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
          } else {
            Navigator.of(Get.context!, rootNavigator: true).pop();
          }
          print('editcontactdetails res ${res}');
          print('imageValue123 ${image.value}');
          searchController.text = '';
          Get.rawSnackbar(
              message: res["message"],
              backgroundColor: ThemeConstants.successColor);
          if (image.value != "") {
            uploadContactPhoto();
            pageOffset.value = 0;
            isFabExpanded.value = false;
          } else {
            // Get.back();
            pageOffset.value = 0;
            isFabExpanded.value = false;

            await getAllContacts();
            isLoading.value = false;
          }
        }).catchError((e) {
          isFabExpanded.value = false;
          Get.rawSnackbar(message: e["message"]);

          Get.back();
          getAllContacts();
        });
      }
    } else {
      isLoading.value = true;
      print('Conid: $conId');
      print('Firstname: $firstName');
      print('Lastname: $lastName');
      print('PrimaryNum: $primaryNumber');
      print('SecondaryNum: $secondaryNumber');
      print('Workinfo:$workinfo');
      print('Email:$email');
      print('Address:$address');
      print('Notes:$notes');
      print('img00 ${image.value}');
      contactService
          .editContact(firstName, lastName, primaryNumber, secondaryNumber,
              workinfo, email, address, notes, conId)
          .then((res) async {
        isCloseDialog.value = true;

        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        } else {
          Navigator.of(Get.context!, rootNavigator: true).pop();
        }
        print('editcontactdetails res ${res}');
        print('imageValue123 ${image.value}');
        searchController.text = '';
        Get.rawSnackbar(
            message: res["message"],
            backgroundColor: ThemeConstants.successColor);
        if (image.value != "") {
          uploadContactPhoto();
          pageOffset.value = 0;
          isFabExpanded.value = false;
        } else {
          // Get.back();
          pageOffset.value = 0;
          isFabExpanded.value = false;

          await getAllContacts();
          isLoading.value = false;
        }
      }).catchError((e) {
        isFabExpanded.value = false;
        Get.rawSnackbar(message: e["message"]);

        Get.back();
        getAllContacts();
      });
    }
  }

  clearData() {
    firstNameController.text = '';
    lastNameController.text = '';
    primaryNumberController.text = '';
    secondaryNumberController.text = '';
    workinfoController.text = '';
    emailController.text = '';
    addressController.text = '';
    image.value = '';
    profilePic.value = '';
    notesController.text = '';
  }

  Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'JPEG', 'PNG'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      image.value = result.files.single.path!;
      String fileName = basename(image.value);
      print("file: $file, path: ${image.value}, fileName: ${fileName}");
      uploadFile(image.value);
    } else {}
  }

  uploadFile(path) {
    isUploading.value = true;
    projectService.uploadCsv(path).then((res) {
      isUploading.value = false;
      print("res: $res");
      Get.rawSnackbar(
          message: res['message'],
          backgroundColor: ThemeConstants.successColor);
      isUploading.value = false;
      ;
    }).catchError((err) {
      isUploading.value = false;
      print("err: $err");
    });
  }

  Future<void> startDownload(fileUrl) async {
    print("download started.... $fileUrl");

    final taskId = await FlutterDownloader.enqueue(
      url: fileUrl,
      savedDir: await getDownloadDirectory(),
      showNotification: true,
      openFileFromNotification: true,
    );
    print("taskId started.... $taskId");
  }

  Future<String> getDownloadDirectory() async {
    return (await getExternalStorageDirectory())!.path;
  }

  launchWhatsappWithMobileNumber(mobileNumber) async {
    final url = "whatsapp://send?phone=$mobileNumber";
    if (await canLaunchUrl(Uri.parse(Uri.encodeFull(url)))) {
      await launchUrl(Uri.parse(Uri.encodeFull(url)));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendSmsToPhone(String phoneNumber) async {
    print('send sms called $phoneNumber');
    String sms1 = "sms:$phoneNumber";
    // launch(sms1);
    // final Uri smsLaunchUri = Uri(
    //   scheme: 'sms',
    //   path: phoneNumber,
    // );

    if (await canLaunch(sms1)) {
      await launch(sms1);
    } else {
      print('Can not launch this url');
    }
  }

  requestPermission() async {
    mobileContactsList.clear();
    print("requestPermission ");
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();
    print("permissionStatus : ${permissionStatus}");
    if (permissionStatus == PermissionStatus.granted) {
      isContactsLoading.value = true;
      Iterable<Contact> contacts = await ContactsService.getContacts();
      for (var contact in contacts) {
        print('Name: ${contact.displayName}');
        print('Phone number: ${contact.phones!}');
        print('givenName: ${contact.givenName}');
        print('middleName: ${contact.middleName}');
        print('familyname: ${contact.familyName}');
        print('emails: ${contact.emails}');
        print("is conatcts: not empty: ${contact.phones!.isNotEmpty}");

        if (contact.phones!.isNotEmpty) {
          var obj = {
            // "CON_ID": DateTime.now().millisecondsSinceEpoch.toString(),
            "FIRST_NAME": contact.givenName ?? "",
            "PRIMARY_NUMBER": contact.phones![0].value.toString(),
            "LAST_NAME":
                ((contact.middleName ?? "") + ' ' + (contact.familyName ?? ""))
                    .trim(),
            "EMAIL":
                contact.emails!.isNotEmpty ? contact.emails![0].toString() : ""
          };
          print('obj... $obj');
          mobileContactsList.add(obj);
        }
      }

      print("contacts prepared length: ${mobileContactsList.length}");

      print("final contact object: ${(mobileContactsList)}");

      contactService.uploadMobileContacts(mobileContactsList).then((res) async {
        isContactsLoading.value = false;
        print("uploadMobileContacts res: $res");
        Get.rawSnackbar(
            message: res["message"],
            backgroundColor: ThemeConstants.successColor);
        pageOffset.value = 0;
        isFabExpanded.value = false;
        await getAllContacts();
      }).catchError((err) {
        isContactsLoading.value = false;
        isFabExpanded.value = false;
        // Get.rawSnackbar(message: "Something went wrong. Please try again");
        print("uploadMobileContacts catchError $err");
      });
    }
  }

  getContactsBySearchValue() {
    pageOffset.value = 0;
    hasSelectedContacts.value ? SizedBox.shrink() : contactsList.clear();
    print("before contacts length: ${contactsList.length}");
    isLoading.value = true;
    contactService
        .getAllContactsBySearchValue(0, searchController.text)
        .then((res) {
      isLoading.value = false;
      issearchValue.value = true;
      print('lenCount ${res['data']}');
      print("length: ${res['data']['contacts'].length}");
      contactsTotalCount.value = res['data']['count'];
      contactsList.clear();

      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
      }
      for (var contact in contactsList) {
        for (var selectedId in selectedContacts) {
          if (contact["conId"] == selectedId) {
            contact["isChecked"] = true;
          }
        }
      }
      // pageOffset.value = 10;
      // contactsList.addAll(res['data']['contacts']);
      print("After contacts length: ${contactsList.length}");
    }).catchError((onError) {
      isLoading.value = false;
      print("getContactsBySearchValue onError: $onError");
    });
  }

  void takePhotoFromCamera() async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropProductImage(picked);
  }

  //selectProductImageFromGallery
  Future selectPhotoFromGallery() async {
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
  }

  uploadContactPhoto() {
    print('upload 012345 $fileName,${image.value},${pConId.value}');
    isLoading.value = true;
    contactService
        .uploadContactPhoto(fileName, image.value, pConId.value)
        .then((res) async {
      //   isLoading.value = false;
      print("uploadContactPhoto success:$res ");
      await getAllContacts();

      // Get.rawSnackbar(
      //     message: "Contact photo uploaded successfully.",
      //     backgroundColor: ThemeConstants.successColor);
    }).catchError((err) {
      isLoading.value = false;
      print("error: $err");
    });
  }

  assignProject(context) {
    isLoading.value = true;
    AssignProject assignProject = AssignProject();

    JobMappingDetails jobMappingDetails = JobMappingDetails();
    jobMappingDetails.agentId = CommonService.instance.agentId.value;
    jobMappingDetails.projectId = selectedProject.value;
    jobMappingDetails.builderId = selectedBuilderId.value;
    jobMappingDetails.contactIds = [];
    selectedContacts.forEach((element) {
      jobMappingDetails.contactIds!.add(element);
    });

    assignProject.jobMappingDetails = jobMappingDetails;

    print("req: ${assignProject.toJson()}");
    contactService.assignProject(assignProject).then((res) async {
      //   isAssignProjectLoading.value = false;
      print("assignProject res $res");
      selectedContacts.clear();
      await getAllContacts();
      Get.rawSnackbar(
          message: res["message"],
          backgroundColor: ThemeConstants.successColor);
      Navigator.pop(context);
    }).catchError((err) {
      isLoading.value = false;
      isAssignProjectLoading.value = false;
      print("assignProject error: ${err}");
      // selectedContacts.clear();
      Get.rawSnackbar(message: err['message']);
    });
  }
}

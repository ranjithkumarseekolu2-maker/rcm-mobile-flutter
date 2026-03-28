import 'dart:io';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/constants/project_layout_file.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/updatefile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProjectDocumentsController extends GetxController {
  late File imgFile;
  RxString image = ''.obs;
  ProjectsService projectService = Get.find();
  RxBool isProjectLayoutLoading = false.obs;

  RxString projectId = ''.obs;

  RxList<ProjectLayoutFile> projectLayoutsList = <ProjectLayoutFile>[].obs;
  List<ProjectLayoutFile> filteredProjectLayoutItems =
      <ProjectLayoutFile>[].obs;

  RxList<ProjectLayoutFile> masterPlansList = <ProjectLayoutFile>[].obs;
  RxList<ProjectLayoutFile> floorPlansList = <ProjectLayoutFile>[].obs;
  RxList<ProjectLayoutFile> statusImagesList = <ProjectLayoutFile>[].obs;
  RxList<ProjectLayoutFile> brochureList = <ProjectLayoutFile>[].obs;
  RxList<ProjectLayoutFile> projectCoverList = <ProjectLayoutFile>[].obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  RxBool isProjectLayout = false.obs;
  RxBool isMasterPlan = false.obs;
  RxBool isFloorPlan = false.obs;
  RxBool isStatusUpdate = false.obs;
  RxBool isBrochure = false.obs;
  RxBool isProjectCover = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      projectId.value = Get.arguments['projectId'];
      getDetailsByProjectId();
      print("projectId: ${projectId.value}");
    }
  }

  //takeProductImageFromCamera
  void takeProductImageFromCamera(type) async {
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropProductImage(picked, type);
  }

  //selectProductImageFromGallery
  Future pickFile(type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'JPEG', 'PNG'],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      image.value = result.files.single.path!;
      String fileName = basename(image.value);
      print("file: $file, path: ${image.value}, fileName: ${fileName}");
      addProjectLayout(fileName, file, image.value, type);
    } else {}
  }

  //Croping product Image Functionality
  Future<Null> _cropProductImage(imageFile, type) async {
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
      String fileName = basename(image.value);
      addProjectLayout(fileName, imgFile, image.value, type);
    }
    print("final file, ${imageFile}");
  }

  addProjectLayout(fileName, imgFile, path, type) {
    ProjectLayoutFile file = ProjectLayoutFile();
    file.name = fileName;
    file.file = imgFile;
    file.path = path;

    if (type == "projectLayout") {
      projectLayoutsList.add(file);
      isProjectLayout.value = true;
    }

    if (type == "masterPlan") {
      masterPlansList.add(file);
      isMasterPlan.value = true;
    }

    if (type == "floorPlan") {
      floorPlansList.add(file);
      isFloorPlan.value = true;
    }

    if (type == "statusWithImages") {
      statusImagesList.add(file);
      isStatusUpdate.value = true;
    }

    if (type == "brochure") {
      brochureList.add(file);
      isBrochure.value = true;
    }

    if (type == "projectCover") {
      projectCoverList.add(file);
      isProjectCover.value = true;
    }
  }

  uploadDocuments(subType) {
    isProjectLayoutLoading.value = true;
    if (subType == "PROJECT_LAYOUT") {
      filteredProjectLayoutItems =
          projectLayoutsList.where((item) => item.path != null).toList();
    }

    if (subType == "FLOOR_PLAN") {
      filteredProjectLayoutItems =
          floorPlansList.where((item) => item.path != null).toList();
    }

    if (subType == "STATUS_IMAGES") {
      filteredProjectLayoutItems =
          statusImagesList.where((item) => item.path != null).toList();
    }
    if (subType == "MASTER_PLAN") {
      filteredProjectLayoutItems =
          masterPlansList.where((item) => item.path != null).toList();
    }
    if (subType == "BROCHURE") {
      filteredProjectLayoutItems =
          brochureList.where((item) => item.path != null).toList();
    }
    if (subType == "LOGO") {
      filteredProjectLayoutItems =
          projectCoverList.where((item) => item.path != null).toList();
    }
    projectService
        .uploadDocuments(filteredProjectLayoutItems, projectId.value, subType)
        .then((res) async {
      isProjectLayoutLoading.value = false;
      if (subType == 'PROJECT_LAYOUT') {
        isProjectLayout.value = false;
      } else {
        if (subType == 'FLOOR_PLAN') {
          isFloorPlan.value = false;
        } else {
          if (subType == 'MASTER_PLAN') {
            isMasterPlan.value = false;
          } else {
            if (subType == 'BROCHURE') {
              isBrochure.value = false;
            } else {
              if (subType == 'STATUS_IMAGES') {
                isStatusUpdate.value = false;
              } else {
                isProjectCover.value = false;
              }
            }
          }
        }
      }
      print("res: $res");
      await getDetailsByProjectId();
      Get.rawSnackbar(
          message: res['message'],
          backgroundColor: ThemeConstants.successColor);
      filteredProjectLayoutItems.clear();
    }).catchError((err) {
      isProjectLayoutLoading.value = false;
      print("err: $err");
    });
  }

  getDetailsByProjectId() {
    isProjectLayoutLoading.value = true;

    projectService.getDetailsByProjectId(projectId.value).then((detailsRes) {
      isProjectLayoutLoading.value = false;
      print(
          "getDetailsByProjectId res: ${detailsRes['data']['projectLayout']}");
      if (detailsRes['data']['projectLayout'] != null) {
        projectLayoutsList.clear();
        detailsRes['data']['projectLayout'].forEach((p) {
          ProjectLayoutFile projectLayoutFile = ProjectLayoutFile();
          projectLayoutFile.name = p['name'];
          projectLayoutFile.url = p['url'];
          projectLayoutFile.fileId = p['fileId'];
          projectLayoutsList.add(projectLayoutFile);
        });
      }
      if (detailsRes['data']['masterPlan'] != null) {
        masterPlansList.clear();
        print("maasterPlan: ${detailsRes['data']['masterPlan'].length}");
        detailsRes['data']['masterPlan'].forEach((p) {
          ProjectLayoutFile projectLayoutFile = ProjectLayoutFile();
          projectLayoutFile.name = p['name'];
          projectLayoutFile.url = p['url'];
          projectLayoutFile.fileId = p['fileId'];
          masterPlansList.add(projectLayoutFile);
        });
      }
      if (detailsRes['data']['floorPlan'] != null) {
        floorPlansList.clear();
        detailsRes['data']['floorPlan'].forEach((p) {
          ProjectLayoutFile projectLayoutFile = ProjectLayoutFile();
          projectLayoutFile.name = p['name'];
          projectLayoutFile.url = p['url'];
          projectLayoutFile.fileId = p['fileId'];
          floorPlansList.add(projectLayoutFile);
        });
      }
      if (detailsRes['data']['statusImages'] != null) {
        statusImagesList.clear();
        detailsRes['data']['statusImages'].forEach((p) {
          ProjectLayoutFile projectLayoutFile = ProjectLayoutFile();
          projectLayoutFile.name = p['name'];
          projectLayoutFile.url = p['url'];
          projectLayoutFile.fileId = p['fileId'];
          statusImagesList.add(projectLayoutFile);
        });
      }

      if (detailsRes['data']['brochure'] != null) {
        brochureList.clear();
        detailsRes['data']['brochure'].forEach((p) {
          ProjectLayoutFile projectLayoutFile = ProjectLayoutFile();
          projectLayoutFile.name = p['name'];
          projectLayoutFile.url = p['url'];
          projectLayoutFile.fileId = p['fileId'];
          brochureList.add(projectLayoutFile);
        });
      }

      if (detailsRes['data']['logo'] != null) {
        projectCoverList.clear();
        detailsRes['data']['logo'].forEach((p) {
          ProjectLayoutFile projectLayoutFile = ProjectLayoutFile();
          projectLayoutFile.name = p['name'];
          projectLayoutFile.url = p['url'];
          projectLayoutFile.fileId = p['fileId'];
          projectCoverList.add(projectLayoutFile);
        });
      }
    }).catchError((error) {
      isProjectLayoutLoading.value = false;
      print("Error while fetching getDetailsByProjectId: $error");
    });
  }

  deleteDocument(fieldId, type) {
    isProjectLayoutLoading.value = true;
    projectService.deleteDocument(projectId.value, fieldId, type).then((res) {
      isProjectLayoutLoading.value = false;
      print("deleteDocument res: ${res}}");
      Get.rawSnackbar(
          message: res['message'],
          backgroundColor: ThemeConstants.successColor);
      getDetailsByProjectId();
    }).catchError((error) {
      isProjectLayoutLoading.value = false;
      print("Error while fetching deleteDocument: $error");
    });
  }

  updateFile(fileId) {
    isProjectLayoutLoading.value = true;

    UpdateFile updateFile = UpdateFile();

    FileDetails fileDetails = FileDetails();
    fileDetails.category =
        categoryController.text != '' ? categoryController.text.split(',') : [];
    fileDetails.description = descriptionController.text;
    fileDetails.title = titleController.text;
    fileDetails.fileId = fileId;

    updateFile.fileDetails = FileDetails();
    updateFile.fileDetails = fileDetails;
    projectService.updateFile(updateFile).then((res) {
      isProjectLayoutLoading.value = false;
      print("updateFile res: $res}");
      Get.rawSnackbar(
          message: "File updated successfully.",
          backgroundColor: ThemeConstants.successColor);
    }).catchError((error) {
      isProjectLayoutLoading.value = false;
      print("Error while fetching updateFile: $error");
    });
  }
}

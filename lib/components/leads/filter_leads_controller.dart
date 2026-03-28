import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:get/get.dart';

class FilterLeadsController extends GetxController {
  RxString selectedStatus = ''.obs;
  RxList allProjects = [].obs;
  RxString selectedProject = ''.obs;
  RxString selectedProjectId = ''.obs;
  RxString selectedBuilder = ''.obs;
  RxString selectedBuilderId = ''.obs;
  RxString selectedActivity = ''.obs;
  RxBool isLeadsLoading = false.obs;
  RxBool isProjectsLoading = false.obs;
  RxBool isBuildersLoading = false.obs;
  RxList projectsList = [].obs;
  ProjectsService projectsService = Get.put(ProjectsService());
  AppConstants appConstants = AppConstants();
  RxString selectedLabel = 'Builder'.obs;
  RxList filteLabels = [
    "Builder",
    "Project",
    "Status",
    "Lead Activity",
  ].obs;

  void onInit() async {
    super.onInit();

    selectedActivity.value = CommonService.instance.selectedActivity.value;
    selectedProject.value = CommonService.instance.selectedProject.value;
    selectedProjectId.value = CommonService.instance.selectedProjectId.value;
    selectedStatus.value = CommonService.instance.selectedStatus.value;
    selectedBuilderId.value = CommonService.instance.selectedBuilderId.value;
    selectedBuilder.value = CommonService.instance.selectedBuilder.value;
    if (CommonService.instance.selectedBuilderId.value != '') {
      await getProjectsByBuilderId();
    } else {
      await getAllProjects();
    }
    await getAllBuilders();
    print('buillllllll ${CommonService.instance.buildersList}');
  }

  getAllProjects() {
    //projectsList.clear();
    projectsList.clear();
    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    appConstants.projectsIds.clear();
    isProjectsLoading.value = true;
    projectsService.getAllProjects().then((res) {
      print('getProjects res ${res['data']}');
      projectsList.addAll(res['data']['projects']);
      //projectsList.addAll(res['data']['projects']);
      res['data']['projects'].forEach((element) {
        CommonService.instance.projectsNamesList.add({
          'name': element['projectName'],
          'id': element['projectId']
          // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
        });
      });
      res['data']['projects'].forEach((element) {
        appConstants.projectsIds.add(
          element['projectId'],
          // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
        );
      });
      print(
          'getProj projList123.. ${CommonService.instance.projectsNamesList}');
      print('getProj projIds.. ${appConstants.projectsIds}');
      // appConstants.projectsIds
      //     .add(res['data']['data']['contacts']['PROJECT_ID']);
      Future.delayed(const Duration(microseconds: 300), () {
        isProjectsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllProjects error: $e');
      isProjectsLoading.value = false;
    });
  }

  getProjectsByBuilderId() {
    //projectsList.clear();
    projectsList.clear();
    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    appConstants.projectsIds.clear();
    isProjectsLoading.value = true;
    projectsService
        .getProjectsByBuilderIdInLeads(
            CommonService.instance.selectedBuilderId.value)
        .then((res) {
      print('getProjectsByBuilderIdInLeads res ${res['data']}');
      // appConstants.projectsNamesList.clear();
      projectsList.addAll(res['data']['projects']);
      //projectsList.addAll(res['data']['projects']);
      res['data']['projects'].forEach((element) {
        CommonService.instance.projectsNamesList.add({
          'name': element['projectName'],
          'id': element['projectId']
          // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
        });
      });

      print('getProj projList123.. ${appConstants.projectsNamesList}');
      // print('getProj projIds.. ${appConstants.projectsIds}');
      // appConstants.projectsIds
      //     .add(res['data']['data']['contacts']['PROJECT_ID']);
      Future.delayed(const Duration(microseconds: 500), () {
        isProjectsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllProjects error: $e');
      isProjectsLoading.value = false;
    });
  }

  getAllBuilders() {
    if (CommonService.instance.buildersList.isNotEmpty) {
      CommonService.instance.buildersList = [].obs;
    }

    isLeadsLoading.value = true;
    projectsService.getBuildersByAgentId().then((res) {
      print('new builders.. res ${res['data']}');
      // projectsList.addAll(res['data']['projects']);
      //projectsList.addAll(res['data']['projects']);
      res['data'].forEach((element) {
        CommonService.instance.buildersList
            .add({'name': element['label'], 'id': element['value']}
                // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
                );
        //  builderList.add({'name': element['label'], 'id': element['value']}
        // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
        //    );
      });
      // res['data']['projects'].forEach((element) {
      //   appConstants.projectsIds.add(
      //     element['projectId'],
      //     // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
      //   );
      // });
      print('new builderslist.. ${CommonService.instance.buildersList}');
      //  print('getProj projIds.. ${appConstants.projectsIds}');
      // appConstants.projectsIds
      //     .add(res['data']['data']['contacts']['PROJECT_ID']);
      Future.delayed(const Duration(microseconds: 200), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllBuilders by agentId error: $e');
      isLeadsLoading.value = false;
    });
  }
}

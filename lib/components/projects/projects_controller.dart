import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:get/get.dart';

class ProjectsController extends GetxController {
  ProjectsService projectsService = Get.put(ProjectsService());
  RxBool isLoading = false.obs;
  RxList projectsList = [].obs;
  TextEditingController builderController = TextEditingController();
  ScrollController scrollController = ScrollController();
  RxString selectedBuilder = ''.obs;
  RxBool isInfiniteLoading = false.obs;
  RxInt pageLimit = 10.obs;
  RxInt pageOffset = 0.obs;
  RxInt pageOffsetForSearch = 0.obs;
  RxInt projectsTotalCount = 0.obs;
  RxBool isSearchProject = false.obs;

  TextEditingController searchController = TextEditingController();

  void onInit() async {
    super.onInit();
    scrollController.addListener(scrollListener);

    await getAllProjects();
    await getBuilders();
  }

  requestToBuilder(id) {
    isLoading.value = true;

    projectsService.requestToBuilder(id).then((res) {
      print("createLead res: $res");
      Get.back();
      if (res['status'] == 200) {
        Get.rawSnackbar(
            message: res["message"],
            backgroundColor: ThemeConstants.successColor);
      } else {
        Get.rawSnackbar(
          message: res["message"],
        );
      }
      Get.toNamed(Routes.projects);
      isLoading.value = false;
    }).catchError((err) {
      isLoading.value = false;
      print("searchLead res: $err");
    });
  }

  getBuilders() {
    projectsService.getAllBuilders().then((buildersRes) {
      CommonService.instance.builders.clear();
      print("buildersRes: $buildersRes");
      //  print("buildername: ${CommonService.instance.builders[0]['registeredName']}");
      CommonService.instance.builders.addAll(buildersRes["data"]);
      print("builders length: ${CommonService.instance.builders.length}");
      print("builders length123: ${CommonService.instance.builders}");
    }).catchError((error) {
      print("Error while fetching getBuilders: $error");
    });
  }

  void scrollListener() {
    print("Scroll listner called");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("reached limit");

      if (isInfiniteLoading.value == false) {
        if (isSearchProject.value) {
          pageOffsetForSearch.value = pageOffsetForSearch.value + 10;
          loadMoreSearchProjects();
        } else {
          pageOffset.value = pageOffset.value + 10;
          loadMoreItems(pageOffset.value);
        }
      }
    }
  }

  loadMoreItems(pageOffset) {
    isInfiniteLoading.value = true;
    print('page... ${pageOffset}');
    projectsService.loadMoreProjects(pageOffset).then((res) {
      print('resProj ${res['data']['projects']}');
      projectsList.addAll(res['data']['projects']);

      isInfiniteLoading.value = false;
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("loadMoreItems  err$onError");
    });
  }

  loadMoreSearchProjects() {
    print('pageOffset12345... ${pageOffsetForSearch.value}');
    isInfiniteLoading.value = true;
    projectsService
        .getProjectsBySearchValue(
            pageOffsetForSearch.value, searchController.text)
        .then((res) {
      print("getProjectsBySearchValue res: ${res}");

      projectsList.addAll(res['data']['projects']);
      //  pageOffsetForSearch.value = pageOffsetForSearch.value + 10;
      isInfiniteLoading.value = false;
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("loadMoreItems  err$onError");
    });
  }

  getAllProjects() {
    projectsList.clear();
    isLoading.value = true;
    projectsService.getProjects().then((res) {
      isLoading.value = false;

      print('getProjects res ${res['data']}');
      projectsList.addAll(res['data']['projects']);
      projectsTotalCount.value = res['data']['count'];
      print('getProjects .. $projectsList');
      print('getProjects len.. ${projectsList.length}');
    }).catchError((e) {
      isLoading.value = false;
      print('getProjects error: ${e}}');
      Get.rawSnackbar(
          message: "Something Went Wrong",
          backgroundColor: ThemeConstants.errorColor);
    });
  }

  deleteProject(jobApplicationId) {
    isLoading.value = true;
    projectsService.deleteProject(jobApplicationId).then((res) async {
      isLoading.value = false;
      await getAllProjects();
      Get.rawSnackbar(
          message: 'Project Deleted Successfully',
          backgroundColor: ThemeConstants.successColor);
    }).catchError((e) {
      isLoading.value = false;
      print('deleteProject error: ${e}}');
    });
  }

  activateProject(projectId) {
    isLoading.value = true;
    projectsService.activateProject(projectId).then((res) async {
      isLoading.value = false;
      await getAllProjects();
      Get.rawSnackbar(
          message: 'Project Activated Successfully',
          backgroundColor: ThemeConstants.successColor);
    }).catchError((e) {
      isLoading.value = false;
      print('deleteProject error: ${e}}');
    });
  }

  openBrowserTab(url) async {
    FlutterWebBrowser.openWebPage(
      url: url,
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.dark,
        toolbarColor: ThemeConstants.primaryColor,
        secondaryToolbarColor: Colors.green,
        addDefaultShareMenuItem: true,
        instantAppsEnabled: true,
        showTitle: false,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
        preferredBarTintColor: Colors.green,
        preferredControlTintColor: Colors.amber,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        modalPresentationCapturesStatusBarAppearance: true,
      ),
    );
  }

  getProjectsBySearchValue() {
    isSearchProject.value = true;
    pageOffsetForSearch.value = 0;
    projectsList.clear();
    isLoading.value = true;
    projectsService
        .getProjectsBySearchValue(pageOffsetForSearch, searchController.text)
        .then((res) {
      print("getProjectsBySearchValue res: ${res}");

      projectsList.clear();
      projectsTotalCount.value = res["data"]["count"];
      projectsList.addAll(res['data']['projects']);

      isLoading.value = false;
    }).catchError((err) {
      isLoading.value = false;
      print("getProjectsBySearchValue err: ${err}");
    });
  }
}

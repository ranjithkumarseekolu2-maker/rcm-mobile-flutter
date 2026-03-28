import 'dart:ffi';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/leads_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/components/leads/filter_leads_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsListingController extends GetxController {
  LeadsService leadsService = Get.put(LeadsService());
  TextEditingController searchController = TextEditingController();

  ProjectsService projectsService = Get.put(ProjectsService());
  AppConstants appConstants = Get.put(AppConstants());
  TextEditingController descriptionController = TextEditingController();
  TextEditingController firstNameContrller = TextEditingController();
  TextEditingController primaryContactContrller = TextEditingController();
  TextEditingController emailContrller = TextEditingController();
  TextEditingController selectedBuilderContrller = TextEditingController();
  TextEditingController selectedProjectContrller = TextEditingController();
  RxString selectedProjectId = ''.obs;

  RxBool isLeadsLoading = false.obs;
  RxList leadsList = [].obs;

  RxString selectedStatus = 'Prequalify'.obs;
  RxList leadDetailsStatusesList = [].obs;
  RxString formattedDateTime = ''.obs;
  var leadFormKey = GlobalKey<FormState>();
  var addLeadFormKey = GlobalKey<FormState>();
  RxString selectedFilteredStatus = ''.obs;
  RxString selectedFilteredProject = ''.obs;
  RxString selectedFilteredActivity = ''.obs;
  RxString selectedFileteredProjectId = ''.obs;
  RxString selectedBuilderId = ''.obs;
  RxString selectedBuilder = ''.obs;
  RxInt selectedStatuesCount = 0.obs;
  RxList builderList = [].obs;
  RxString selectedDropdownProject = ''.obs;
  RxString selectedDropdownBuilder = ''.obs;
  RxString selectedProjBilderId = ''.obs;
  RxString selectedProjMarketingAgencyId = ''.obs;

  ScrollController scrollController = ScrollController();
  RxBool isLeadDetailsUpdated = false.obs;
  RxBool isInfiniteLoading = false.obs;
  RxInt pageLimit = 10.obs;
  RxInt pageOffset = 0.obs;
  RxInt leadsTotalCount = 0.obs;
  RxList projectsList = [].obs;
  RxBool isCreateLeadLoading = false.obs;
  RxBool isSearchLead = false.obs;

  void onInit() async {
    print('Get.argments12345 ${Get.arguments}');
    scrollController.addListener(scrollListener);

    if (Get.arguments != null) {
      if (Get.arguments['status'] == 'Active') {
        if (Get.arguments['builderId'] != null) {
          CommonService.instance.isFilterSelected.value = false;
          CommonService.instance.filterPageOffset.value = 0;
          getFilteredLeads('', '', 'Active', Get.arguments['builderId']);
        } else {
          CommonService.instance.isFilterSelected.value = false;
          CommonService.instance.filterPageOffset.value = 0;
          getFilteredLeads('', '', 'Active', '');
        }
      } else if (Get.arguments['status'] == 'Pre Qualify' ||
          Get.arguments['status'] == 'Qualify' ||
          Get.arguments['status'] == 'Schedule Site Visit' ||
          Get.arguments['status'] == 'Site Visit' ||
          Get.arguments['status'] == 'Negotiation In Progress' ||
          Get.arguments['status'] == 'Payment In Progress' ||
          Get.arguments['status'] == 'Agreement' ||
          Get.arguments['status'] == 'Closed Won' ||
          Get.arguments['status'] == 'Closed Lost') {
        // if (Get.arguments['builderId'] != null) {

        // }
        print(
            'if status0 ${Get.arguments['projectId']},${Get.arguments['projectId'] != null},${Get.arguments['projectId'] != ''}');
        CommonService.instance.filterPageOffset.value = 0;
        selectedFilteredStatus.value = Get.arguments['status'];
        if (Get.arguments['projectId'] != null &&
            Get.arguments['projectId'] != '') {
          print('if project');
          CommonService.instance.isFilterSelected.value = true;
          selectedFileteredProjectId.value = Get.arguments['projectId'];
          getFilteredLeads(
              Get.arguments['status'], Get.arguments['projectId'], '', '');
        } else {
          print('else...');
          if (Get.arguments['builderId'] != null) {
            print('else..builder.');
            CommonService.instance.isFilterSelected.value = true;
            selectedBuilderId.value = Get.arguments['builderId'];
            getFilteredLeads(
                Get.arguments['status'], '', '', Get.arguments['builderId']);
          } else {
            print('calling.....');
            CommonService.instance.isFilterSelected.value = true;
            getFilteredLeads(Get.arguments['status'], '', '', '');
          }
        }
      } else {
        print('last else ..');
        if (Get.arguments['status'] != null) {
          CommonService.instance.isFilterSelected.value = true;
          CommonService.instance.filterPageOffset.value = 0;
          getFilteredLeads('', '', Get.arguments['status'], '');
        } else {
          selectedFilteredStatus.value = Get.arguments['selectedStatus'];
          selectedFilteredProject.value = Get.arguments['selectedProject'];
          selectedFilteredActivity.value = Get.arguments['selectedActivity'];
          selectedFileteredProjectId.value = Get.arguments['selectedProjectId'];
          selectedBuilder.value = Get.arguments['selectedBuilder'];
          selectedBuilderId.value = Get.arguments['selectedBuilderId'];
          await setStatusesCount();
          CommonService.instance.isFilterSelected.value = true;
          getFilteredLeads(
              selectedFilteredStatus.value,
              selectedFileteredProjectId.value,
              selectedFilteredActivity.value,
              selectedBuilderId.value);
        }
      }
    } else {
      CommonService.instance.isFilterSelected.value = false;
      await getAllLeads();
      if (CommonService.instance.selectedBuilderId.value != '') {
        await getProjectsByBuilderId(
            CommonService.instance.selectedBuilderId.value);
      } else {
        await getAllProjects();
      }
      await getAllBuilders();
    }
    super.onInit();
  }

  void scrollListener() {
    print("hey Scroll listner called ");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("reached limit");
      print(
          'object1235  ${CommonService.instance.isFilterSelected.value},${selectedFilteredStatus.value},${selectedBuilderId.value}');
      print(
          'object...........${isInfiniteLoading.value} ${CommonService.instance.filterPageOffset.value}');
      if (CommonService.instance.isFilterSelected.value == true) {
        if (isInfiniteLoading.value == false) {
          loadMoreFilter(
              selectedFilteredStatus.value,
              selectedFileteredProjectId.value,
              selectedFilteredActivity.value,
              selectedBuilderId.value);
        }
      } else {
        if (isInfiniteLoading.value == false) {
          print("loadmoreoffset: ${pageOffset.value}");
          if (isSearchLead.value) {
            pageOffset.value = pageOffset.value + 10;
            loadMoreSearchLeads();
          } else {
            print('else....${Get.arguments}');
            pageOffset.value = pageOffset.value + 10;
            if (Get.arguments != null) {
              if (Get.arguments['status'] == 'Active') {
                if (Get.arguments['builderId'] != null) {
                  loadMoreActiveFilter(
                      Get.arguments['status'], Get.arguments['builderId']);
                } else {
                  loadMoreActiveFilter(
                      Get.arguments['status'], Get.arguments['builderId']);
                }
              } else {
                loadMoreItems();
              }
            } else {
              print('else 123');
              loadMoreItems();
            }
          }
        }
      }
    }
  }

  loadMoreFilter(status, project, activity, builderId) {
    print('check... $status,$project,$activity,$builderId');
    isInfiniteLoading.value = true;
    leadsService
        .getFilteredLeads(status, project, activity, builderId,
            CommonService.instance.filterPageOffset.value)
        .then((res) {
      if (res['data']['data'] != null) {
        leadsList.addAll(res['data']['data']);
        CommonService.instance.filterPageOffset.value =
            CommonService.instance.filterPageOffset.value + 10;
      }
      isInfiniteLoading.value = false;
    }).catchError((e) {
      print('loadMoreFilter error: $e');
      isInfiniteLoading.value = false;
    });
  }

  loadMoreActiveFilter(status, builderId) {
    isInfiniteLoading.value = true;
    leadsService
        .getFilteredLeads('', '', status, builderId,
            CommonService.instance.filterPageOffset.value)
        .then((res) {
      if (res['data']['data'] != null) {
        leadsList.addAll(res['data']['data']);
        CommonService.instance.filterPageOffset.value =
            CommonService.instance.filterPageOffset.value + 10;
      }
      isInfiniteLoading.value = false;
    }).catchError((e) {
      print('loadMoreFilter error: $e');
      isInfiniteLoading.value = false;
    });
  }

  loadMoreItems() {
    isInfiniteLoading.value = true;
    leadsService.getAllLeads(pageOffset.value).then((res) {
      if (res['data']['data'] != null) {
        leadsList.addAll(res['data']['data']);
        //   pageOffset.value = pageOffset.value + 10;
      }
      isInfiniteLoading.value = false;
    }).catchError((e) {
      print('load more items error: $e');
      isInfiniteLoading.value = false;
    });
  }

  loadMoreActiveLeads() {
    isInfiniteLoading.value = true;
    leadsService.getAllLeads(pageOffset.value).then((res) {
      if (res['data']['data'] != null) {
        res['data']['data'].forEach((element) {
          print('elooo $element');
          if (element['agentStatus'] != 'Closed Lost' &&
              element['agentStatus'] != 'Closed Won') {
            leadsList.add(element);
          }
        });
      }
      isInfiniteLoading.value = false;
    }).catchError((e) {
      print('load more items error: $e');
      isInfiniteLoading.value = false;
    });
  }

  loadMoreSearchLeads() {
    isInfiniteLoading.value = true;
    leadsService
        .searchLeads(
            selectedFilteredStatus.value,
            selectedFileteredProjectId.value,
            selectedFilteredActivity.value,
            selectedBuilderId.value,
            pageOffset.value,
            searchController.text)
        .then((res) {
      print("searchLead res: $res");

      leadsList.addAll(res['data']['data']);

      //  pageOffset.value = pageOffset.value + 10;
      isInfiniteLoading.value = false;
    }).catchError((e) {
      print('loadMoreSearch leads error: $e');
      isInfiniteLoading.value = false;
    });
  }

  setStatusesCount() {
    if (selectedFilteredStatus.value.isNotEmpty &&
        selectedFilteredProject.value.isNotEmpty &&
        selectedFilteredActivity.value.isNotEmpty &&
        selectedBuilder.value.isNotEmpty) {
      selectedStatuesCount.value = 4;
      print('elseeeeeeeeee if1');
    } else if (selectedFilteredStatus.value.isNotEmpty &&
            selectedFilteredProject.value.isNotEmpty &&
            selectedBuilder.isNotEmpty &&
            selectedFilteredActivity.value.isEmpty ||
        selectedFilteredStatus.value.isEmpty &&
            selectedFilteredProject.value.isNotEmpty &&
            selectedBuilder.isNotEmpty &&
            selectedFilteredActivity.value.isNotEmpty ||
        selectedFilteredStatus.value.isNotEmpty &&
            selectedFilteredProject.value.isEmpty &&
            selectedBuilder.isNotEmpty &&
            selectedFilteredActivity.value.isNotEmpty ||
        selectedFilteredStatus.value.isNotEmpty &&
            selectedFilteredProject.value.isNotEmpty &&
            selectedBuilder.isEmpty &&
            selectedFilteredActivity.value.isNotEmpty) {
      selectedStatuesCount.value = 3;
      print('elseeeeeeeeee if2');
    } else if (selectedFilteredStatus.value.isEmpty &&
        selectedFilteredProject.value.isEmpty &&
        selectedBuilder.isEmpty &&
        selectedFilteredActivity.value.isEmpty) {
      selectedStatuesCount.value = 0;
      print('elseeeeeeeeee if3');
    } else if (selectedFilteredStatus.value.isEmpty &&
            selectedFilteredProject.value.isEmpty &&
            selectedBuilder.isNotEmpty &&
            selectedFilteredActivity.value.isNotEmpty ||
        selectedFilteredStatus.value.isEmpty &&
            selectedFilteredProject.value.isNotEmpty &&
            selectedBuilder.isEmpty &&
            selectedFilteredActivity.value.isNotEmpty ||
        selectedFilteredStatus.value.isEmpty &&
            selectedFilteredProject.value.isNotEmpty &&
            selectedBuilder.isNotEmpty &&
            selectedFilteredActivity.value.isEmpty ||
        selectedFilteredStatus.value.isNotEmpty &&
            selectedFilteredProject.value.isEmpty &&
            selectedBuilder.isEmpty &&
            selectedFilteredActivity.value.isNotEmpty ||
        selectedFilteredStatus.value.isNotEmpty &&
            selectedFilteredProject.value.isEmpty &&
            selectedBuilder.isNotEmpty &&
            selectedFilteredActivity.value.isEmpty ||
        selectedFilteredStatus.value.isNotEmpty &&
            selectedFilteredProject.value.isNotEmpty &&
            selectedBuilder.isEmpty &&
            selectedFilteredActivity.value.isEmpty) {
      selectedStatuesCount.value = 2;
      print('elseeeeeeeeee if2');
    } else {
      print('elseeeeeeeeee');
      selectedStatuesCount.value = 1;
    }
  }

  String getIdFromName(String name) {
    print('pppName $name');
    // Iterate through the list and find the matching name
    for (var item in projectsList) {
      if (item['projectName'] == name) {
        print('iiiiitem${item['projectId']}');
        selectedProjectId.value = item['projectId'];
        selectedProjBilderId.value = item['builderId'];
        //   selectedProjMarketingAgencyId.value = item['marketingAgencyId'];
        return item['projectId']; // Return the corresponding ID
      }
    }
    return ''; // Return null if no match found
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  getAllLeads() {
    leadsList.clear();
    if (CommonService.instance.buildersList.isNotEmpty) {
      CommonService.instance.buildersList = [].obs;
    }
    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    pageOffset.value = 0;
    isLeadsLoading.value = true;
    leadsService.getAllLeads(pageOffset.value).then((res) {
      print('getLeads res ${res['data']}');

      leadsList.addAll(res['data']['data']);

      leadsTotalCount.value = res["data"]["count"];
      print('getLeads .. $leadsList');
      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllLeads error: $e');

      isLeadsLoading.value = false;
    });
  }

  getActiveLeads() {
    leadsList.clear();
    if (CommonService.instance.buildersList.isNotEmpty) {
      CommonService.instance.buildersList = [].obs;
    }
    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    pageOffset.value = 0;
    isLeadsLoading.value = true;
    leadsService.getAllLeads(pageOffset.value).then((res) {
      print('getLeads res ${res['data']}');
      res['data']['data'].forEach((element) {
        print('elooo $element');
        if (element['agentStatus'] != 'Closed Lost' &&
            element['agentStatus'] != 'Closed Won') {
          leadsList.add(element);
        }
      });
      leadsTotalCount.value = leadsList.length;
      print('getLeads .. $leadsList');
      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllLeads error: $e');

      isLeadsLoading.value = false;
    });
  }

  getFilteredLeads(status, project, activity, builderId) {
    print('dddd $status,$project,$activity,$builderId');

    if (CommonService.instance.buildersList.isNotEmpty) {
      CommonService.instance.buildersList = [].obs;
    }
    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    isLeadsLoading.value = true;
    leadsService
        .getFilteredLeads(status, project, activity, builderId,
            CommonService.instance.filterPageOffset.value)
        .then((res) {
      leadsList.clear();
      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
      print('getFilteredLeads res ${res['data']}');
      leadsList.addAll(res['data']['data']);
      CommonService.instance.filterPageOffset.value =
          CommonService.instance.filterPageOffset.value + 10;
      leadsTotalCount.value = res["data"]["count"];
    }).catchError((e) {
      print('getFilteredLeads error: $e');

      isLeadsLoading.value = false;
    });
  }

  getLeadDetails(leadId) {
    // leadsList.clear();
    isLeadsLoading.value = true;
    leadDetailsStatusesList.clear();
    leadsService.leadDetails(leadId).then((res) {
      print('getLeadDetails res ${res['data']}');
      // leadsList.addAll(res['data']['data']);
      // print('getLeads .. $leadsList');
      // print('getLeads len.. ${leadsList.length}');

      leadDetailsStatusesList.addAll(res['data']);
      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getLeadDetails error: $e');
      isLeadsLoading.value = false;
    });
  }

  save(leadId, description, status) {
    print('GetArgs ${Get.arguments}');
    isLeadsLoading.value = true;
    print('det... $leadId,$description,$status');
    //  leadDetailsStatusesList.clear();
    leadsService.updateDetails(leadId, description, status).then((res) {
      print('getLeadDetails res ${res['data']}');
      isLeadDetailsUpdated.value = true;
      Get.rawSnackbar(
          message: 'Status Updated Successfully',
          backgroundColor: ThemeConstants.successColor);
      // Get.delete<HomeC>(force: true);
      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
      pageOffset.value = 0;

      CommonService.instance.isFilterSelected.value = false;
      selectedStatuesCount.value = 0;
      CommonService.instance.selectedActivity.value = '';
      CommonService.instance.selectedProject.value = '';
      CommonService.instance.selectedStatus.value = '';
      CommonService.instance.selectedProjectId.value = '';
      CommonService.instance.selectedBuilder.value = '';
      CommonService.instance.selectedBuilderId.value = '';
      FilterLeadsController filterLeadsController =
          Get.put(FilterLeadsController());
      filterLeadsController.selectedActivity.value = '';
      filterLeadsController.selectedProject.value = '';
      filterLeadsController.selectedProjectId.value = '';
      filterLeadsController.selectedStatus.value = '';
      filterLeadsController.selectedBuilder.value = '';
      filterLeadsController.selectedBuilderId.value = '';
      CommonService.instance.filterPageOffset.value = 0;
      selectedBuilderId.value = '';
      selectedFilteredStatus.value = '';
      selectedFileteredProjectId.value = '';
      selectedFilteredActivity.value = '';

      getAllLeads();
      // getLeadDetails(leadId);
      // Get.toNamed(Routes.leads);
      // leadsList.addAll(res['data']['data']);
      // print('getLeads .. $leadsList');
      // print('getLeads len.. ${leadsList.length}');
      //  isLoading.value = false;
    }).catchError((e) {
      print('getLeadDetails error: $e');

      isLeadsLoading.value = false;
    });
  }

  // search leadBy name, email and phonenumber
  searchLead() {
    pageOffset.value = 0;
    isSearchLead.value = true;
    isLeadsLoading.value = true;

    leadsList.clear();
    leadsService
        .searchLeads(
            selectedFilteredStatus.value,
            selectedFileteredProjectId.value,
            selectedFilteredActivity.value,
            selectedBuilderId.value,
            0,
            searchController.text)
        .then((res) {
      print("searchLead res: $res");
      leadsList.clear();

      leadsList.addAll(res['data']['data']);
      leadsTotalCount.value = res["data"]["count"];

      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((err) {
      isLeadsLoading.value = false;
      print("searchLead res: $err");
    });
  }

  searchFilteredLead() {
    pageOffset.value = 0;
    isSearchLead.value = true;
    isLeadsLoading.value = true;

    leadsList.clear();
    leadsService
        .searchLeads(
            selectedFilteredStatus.value,
            selectedFileteredProjectId.value,
            selectedFilteredActivity.value,
            selectedBuilderId.value,
            0,
            searchController.text)
        .then((res) {
      print("searchLead res: $res");
      leadsList.clear();

      leadsList.addAll(res['data']['data']);
      leadsTotalCount.value = res["data"]["count"];

      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((err) {
      isLeadsLoading.value = false;
      print("searchLead res: $err");
    });
  }

  // search leadBy name, email and phonenumber
  createLead(firstName, number, projId, email, builderId, agencyId) {
    if (email.isNotEmpty) {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (emailValid) {
        isLeadsLoading.value = true;
        isCreateLeadLoading.value = true;
        leadsService
            .createLead(firstName, number, projId, email)
            .then((res) async {
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
          pageOffset.value = 0;
          await getAllLeads();
          //  isLoading.value = false;
        }).catchError((err) {
          isLeadsLoading.value = false;
          isCreateLeadLoading.value = false;
          print("searchLead res: $err");
        });
      } else {
        Get.rawSnackbar(message: 'Please enter valid email');
      }
    } else {
      isLeadsLoading.value = true;
      isCreateLeadLoading.value = true;
      leadsService
          .createLead(firstName, number, projId, email)
          .then((res) async {
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
        pageOffset.value = 0;
        await getAllLeads();
        //  isLoading.value = false;
      }).catchError((err) {
        isLeadsLoading.value = false;
        isCreateLeadLoading.value = false;
        print("searchLead res: $err");
      });
    }
  }

  clearData() {
    firstNameContrller.text = '';
    primaryContactContrller.text = '';
    emailContrller.text = '';
    selectedProjectContrller.text = '';
    selectedDropdownProject.value = '';
    selectedBuilderContrller.text = '';
    selectedDropdownBuilder.value = '';
    selectedProjBilderId.value = '';
    selectedProjectId.value = '';
  }

  launchWhatsappWithMobileNumber(mobileNumber) async {
    final url = "whatsapp://send?phone=$mobileNumber";
    if (await canLaunchUrl(Uri.parse(Uri.encodeFull(url)))) {
      await launchUrl(Uri.parse(Uri.encodeFull(url)));
    } else {
      throw 'Could not launch $url';
    }
  }

  getAllProjects() {
    //projectsList.clear();
    projectsList.clear();

    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    appConstants.projectsIds.clear();
    isLeadsLoading.value = true;
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
      // res['data']['projects'].forEach((element) {
      //   appConstants.projectsIds.add(
      //     element['projectId'],
      //     // 'id': res['data']['data'][0]['contacts']['PROJECT_ID']
      //   );
      // });
      print(
          'getProj projList123.. ${CommonService.instance.projectsNamesList}');
      print('getProj projIds.. ${appConstants.projectsIds}');
      // appConstants.projectsIds
      //     .add(res['data']['data']['contacts']['PROJECT_ID']);
      Future.delayed(const Duration(milliseconds: 500), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllProjects error: $e');
      isLeadsLoading.value = false;
    });
  }

  getProjectsByBuilderId(builderId) {
    //projectsList.clear();
    projectsList.clear();

    if (CommonService.instance.projectsNamesList.isNotEmpty) {
      CommonService.instance.projectsNamesList = [].obs;
    }
    appConstants.projectsIds.clear();
    isLeadsLoading.value = true;
    projectsService.getProjectsByBuilderIdInLeads(builderId).then((res) {
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

      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllProjects error: $e');
      isLeadsLoading.value = false;
    });
  }

  getAllBuilders() {
    //projectsList.clear();
    projectsList.clear();
    if (CommonService.instance.buildersList.isNotEmpty) {
      CommonService.instance.buildersList = [].obs;
    }
    appConstants.projectsIds.clear();

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
      Future.delayed(const Duration(seconds: 2), () {
        isLeadsLoading.value = false;
      });
    }).catchError((e) {
      print('getAllBuilders by agentId error: $e');
      isLeadsLoading.value = false;
    });
  }
}

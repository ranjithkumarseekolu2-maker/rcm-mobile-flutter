import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/components/leads/filter_leads_component2.dart';
import 'package:brickbuddy/components/leads/filter_leads_controller.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class Filter_leads extends StatefulWidget {
  @override
  FilterLeadsState createState() => FilterLeadsState();
}

class FilterLeadsState extends State<Filter_leads> {
  FilterLeadsController filterLeadsController =
      Get.put(FilterLeadsController());
  AppConstants appConstants = Get.put(AppConstants());
  String selectedItem = 'Lead';
  List<String> leadStatusList = [
    'Prequalify',
    'Qualify',
    'Assess',
    'Site Visit',
    'Confirmed',
    'Agreement',
    'Payment In Progress',
    'Closed Won',
    'Closed Lost',
  ];

  List<String> projectList = [
    'Lake View Apartment',
    'Santhi Apartment',
    'Sun Rise Appartment',
    'Ashan Enclave ',
    'NVR Heights',
    'Ambica Residency'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeConstants.primaryColor,
        title: Text('Filter', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ThemeConstants.whiteColor),
          onPressed: () {
            Get.delete<LeadsListingController>(force: true);
            Get.toNamed(Routes.leads, arguments: {
              'selectedStatus': CommonService.instance.selectedStatus.value,
              'selectedProject': CommonService.instance.selectedProject.value,
              'selectedProjectId':
                  CommonService.instance.selectedProjectId.value,
              'selectedActivity': CommonService.instance.selectedActivity.value,
              'selectedBuilder': CommonService.instance.selectedBuilder.value,
              'selectedBuilderId':
                  CommonService.instance.selectedBuilderId.value,
            });
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: badges.Badge(
              position: badges.BadgePosition.topEnd(top: 0, end: 3),
              badgeAnimation: badges.BadgeAnimation.slide(
                  // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                  // curve: Curves.easeInCubic,
                  ),
              showBadge: CommonService.instance.allNotificationsCount.value > 0
                  ? true
                  : false,
              badgeStyle: badges.BadgeStyle(
                badgeColor: ThemeConstants.errorColor,
              ),
              badgeContent: Text(
                CommonService.instance.allNotificationsCount.toString(),
                style: Styles.whiteSubHeadingStyles4,
              ),
              child: IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: ThemeConstants.whiteColor,
                    size: 25,
                  ),
                  onPressed: () {
                    Get.delete<NotificationsController>(force: true);
                    Get.toNamed(Routes.notificationsComponent);
                  }),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 150,
                  color: ThemeConstants.appBackgroundColor,
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMenuItem('Lead'),
                      buildMenuItem('Project'),
                      buildMenuItem('Lead Activity'),
                      buildMenuItem('Builder'),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(() =>
                        filterLeadsController.isLeadsLoading.value &&
                                selectedItem == 'Project'
                            ? showCustomLoader()
                            : displaySelectedContent()),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: ThemeConstants.greyColor,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.screenPadding,
                vertical: ThemeConstants.screenPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedOutlineButtonWidget(
                    buttonName: 'Clear Filter',
                    onPressed: () {
                      CommonService.instance.selectedActivity.value = '';
                      CommonService.instance.selectedProject.value = '';
                      CommonService.instance.selectedStatus.value = '';
                      CommonService.instance.selectedProjectId.value = '';
                      CommonService.instance.selectedBuilder.value = '';
                      CommonService.instance.selectedBuilderId.value = '';

                      filterLeadsController.selectedActivity.value = '';
                      filterLeadsController.selectedProject.value = '';
                      filterLeadsController.selectedProjectId.value = '';
                      filterLeadsController.selectedStatus.value = '';
                      filterLeadsController.selectedBuilder.value = '';
                      filterLeadsController.selectedBuilderId.value = '';
                      CommonService.instance.filterPageOffset.value = 0;
                      CommonService.instance.isFilterSelected.value = false;
                      Get.delete<LeadsListingController>(force: true);
                      Get.toNamed(
                        Routes.leads,
                      );
                    }),
                RoundedFilledButtonWidget(
                  buttonName: "Filter",
                  isLargeBtn: false,
                  onPressed: () {
                    print("Santhoshi called");
                    if (filterLeadsController.selectedStatus.value.isEmpty &&
                        filterLeadsController.selectedProject.value.isEmpty &&
                        filterLeadsController.selectedProjectId.value.isEmpty &&
                        filterLeadsController.selectedActivity.value.isEmpty &&
                        filterLeadsController.selectedBuilder.value.isEmpty &&
                        filterLeadsController.selectedBuilderId.value.isEmpty) {
                      CommonService.instance.isFilterSelected.value = true;
                      CommonService.instance.filterPageOffset.value = 0;
                      Get.delete<LeadsListingController>(force: true);
                      Get.toNamed(
                        Routes.leads,
                      );
                    } else {
                      CommonService.instance.isFilterSelected.value = true;
                      CommonService.instance.filterPageOffset.value = 0;
                      print(
                          "pageOffset SSSSSSSSSSSSSS: ${CommonService.instance.filterPageOffset.value}");
                      Get.delete<LeadsListingController>(force: true);
                      Get.toNamed(Routes.leads, arguments: {
                        'selectedStatus':
                            CommonService.instance.selectedStatus.value,
                        'selectedProject':
                            CommonService.instance.selectedProject.value,
                        'selectedProjectId':
                            CommonService.instance.selectedProjectId.value,
                        'selectedActivity':
                            CommonService.instance.selectedActivity.value,
                        'selectedBuilder':
                            CommonService.instance.selectedBuilder.value,
                        'selectedBuilderId':
                            CommonService.instance.selectedBuilderId.value,
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem(String title) {
    String displayTitle = title;
    if (title == 'Lead') {
      displayTitle = 'Status';
    } else if (title == 'Lead Activity') {
      displayTitle = 'Activity';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = title;
        });
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              color: selectedItem == title
                  ? ThemeConstants.primaryColor
                  : ThemeConstants.appBackgroundColor.withOpacity(0.8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  displayTitle,
                  style: TextStyle(
                    color: selectedItem == title
                        ? Colors.white
                        : ThemeConstants.primaryColor,
                    fontWeight: selectedItem == title
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: ThemeConstants.greyColor,
            thickness: 2,
          ),
        ],
      ),
    );
  }

  Widget displaySelectedContent() {
    List<Widget> content = [];

    if (selectedItem == 'Lead') {
      content.addAll(
        CommonService.instance.statuses.map((status) {
          return buildStatuses(status);
        }),
      );
    } else if (selectedItem == 'Project') {
      // for (int i = 0; i < projectList.length; i++) {
      content.addAll(CommonService.instance.projectsNamesList.map((project) {
        // print('$projectList[]');
        // buildContentItem(projectList[i]);
        return buildProjects(project['name'], project['id']);
      }));
    } else if (selectedItem == 'Lead Activity') {
      content.addAll(
        CommonService.instance.leadActivityList.map((activity) {
          return buildActivites(activity);
        }),
      );
    } else if (selectedItem == 'Builder') {
      content.addAll(CommonService.instance.buildersList.map((builder) {
        //  print('bubi   ${builder['name']}');
        // buildContentItem(projectList[i]);
        return buildBuilders(builder['name'], builder['id']);
      }));
    }

    return content.length < 13
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: content,
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: content,
            ),
          );
  }

  Widget buildStatuses(String content) {
    // print('ccccc $content');
    // print('ppppp ${AppConstants.projects}');

    return Obx(
      () => GestureDetector(
        onTap: () {
          //  print('selItem.............');
          print('selItem $content');
          if (CommonService.instance.selectedStatus.value != '') {
            print('sseee 111111$content');
            if (CommonService.instance.selectedStatus.value == content) {
              filterLeadsController.selectedStatus.value = '';
              CommonService.instance.selectedStatus.value = '';
              print('sseee 2222${CommonService.instance.selectedStatus.value}');
            } else {
              // print('selItem 3333$content');
              filterLeadsController.selectedStatus.value = content;
              CommonService.instance.selectedStatus.value = content;
              print('sseee 3333${CommonService.instance.selectedStatus.value}');
            }
          } else {
            // print('selItem 4444$content');
            filterLeadsController.selectedStatus.value = content;
            CommonService.instance.selectedStatus.value = content;
            print('sseee 4444${CommonService.instance.selectedStatus.value}');
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: filterLeadsController.selectedStatus.value == content
                ? ThemeConstants.primaryColor
                : Colors.white,
            border: Border.all(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content,
            style: TextStyle(
                color: filterLeadsController.selectedStatus.value == content
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildProjects(name, id) {
    // print('ccccc $content');
    // print('ppppp ${AppConstants.projects}');

    return Obx(
      () => GestureDetector(
        onTap: () {
          if (CommonService.instance.selectedProjectId.value != '') {
            // print('sseee 111111$id');
            if (CommonService.instance.selectedProjectId.value == id) {
              filterLeadsController.selectedProject.value = '';
              CommonService.instance.selectedProject.value = '';
              CommonService.instance.selectedProjectId.value = '';
              filterLeadsController.selectedProjectId.value = '';
              //   print('sseee 2222${CommonService.instance.selectedStatus.value}');
            } else {
              // print('selItem 3333$content');
              filterLeadsController.selectedProject.value = name;
              CommonService.instance.selectedProject.value = name;
              CommonService.instance.selectedProjectId.value = id;
              filterLeadsController.selectedProjectId.value = id;
            }
          } else {
            // print('selItem 4444$content');
            filterLeadsController.selectedProject.value = name;
            CommonService.instance.selectedProject.value = name;
            CommonService.instance.selectedProjectId.value = id;
            filterLeadsController.selectedProjectId.value = id;
            //  print('sseee 4444${CommonService.instance.selectedStatus.value}');
          }
          //  print('pNnnn ${appConstants.projectsNamesList}');

          // print('pIddddd ${appConstants.projectsIds}');

          //     .projectsIds[appConstants.projectsNamesList.indexOf(content)];
          // print('iiiiiii ${appConstants.projectsNamesList.indexOf(content)}');
          // // print('iiiiiii ${appConstants.projectsIds.indexOf(content)}');
          // print(
          //     'kkkk ${appConstants.projectsIds[appConstants.projectsNamesList.indexOf(content)]}');
          // print(
          //     'kkkk ${appConstants.projectsNamesList[appConstants.projectsNamesList.indexOf(content)]}');
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: filterLeadsController.selectedProjectId.value == id
                ? ThemeConstants.primaryColor
                : Colors.white,
            border: Border.all(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            name,
            style: TextStyle(
                color: filterLeadsController.selectedProjectId.value == id
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildBuilders(name, id) {
    print('ccccc $name');
    print('ppppp ${CommonService.instance.selectedBuilder.value}');

    return Obx(
      () => GestureDetector(
        onTap: () {
          // print('selItem $content');
          if (CommonService.instance.selectedBuilderId.value != '') {
            if (CommonService.instance.selectedBuilderId.value == id) {
              filterLeadsController.selectedBuilder.value = '';
              filterLeadsController.selectedBuilderId.value = '';
              CommonService.instance.selectedBuilder.value = '';
              CommonService.instance.selectedBuilderId.value = '';
              filterLeadsController.getAllProjects();
            } else {
              filterLeadsController.selectedBuilder.value = name;
              filterLeadsController.selectedBuilderId.value = id;
              CommonService.instance.selectedBuilder.value = name;
              CommonService.instance.selectedBuilderId.value = id;
              filterLeadsController.getProjectsByBuilderId();
            }
          } else {
            // print('selItem 4444$content');
            filterLeadsController.selectedBuilder.value = name;
            filterLeadsController.selectedBuilderId.value = id;
            CommonService.instance.selectedBuilder.value = name;
            CommonService.instance.selectedBuilderId.value = id;
            filterLeadsController.getProjectsByBuilderId();
          }

          //     .projectsIds[appConstants.projectsNamesList.indexOf(content)];
          // filterLeadsController.selectedProjectId.value = appConstants
          //     .projectsIds[appConstants.projectsNamesList.indexOf(content)];
          // print('iiiiiii ${appConstants.projectsNamesList.indexOf(content)}');
          // // print('iiiiiii ${appConstants.projectsIds.indexOf(content)}');
          // print(
          //     'kkkk ${appConstants.projectsIds[appConstants.projectsNamesList.indexOf(content)]}');
          // print(
          //     'kkkk ${appConstants.projectsNamesList[appConstants.projectsNamesList.indexOf(content)]}');
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: CommonService.instance.selectedBuilderId.value == id
                ? ThemeConstants.primaryColor
                : Colors.white,
            border: Border.all(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            name,
            style: TextStyle(
                color: CommonService.instance.selectedBuilderId.value == id
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget buildActivites(String content) {
    // print('ccccc $content');
    // print('ppppp ${AppConstants.projects}');

    return Obx(
      () => GestureDetector(
        onTap: () {
          if (CommonService.instance.selectedActivity.value != '') {
            print('sseee 111111$content');
            if (CommonService.instance.selectedActivity.value == content) {
              filterLeadsController.selectedActivity.value = '';
              CommonService.instance.selectedActivity.value = '';
            } else {
              filterLeadsController.selectedActivity.value = content;
              CommonService.instance.selectedActivity.value = content;
            }
          } else {
            filterLeadsController.selectedActivity.value = content;
            CommonService.instance.selectedActivity.value = content;
          }
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: filterLeadsController.selectedActivity.value == content
                ? ThemeConstants.primaryColor
                : Colors.white,
            border: Border.all(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'More than ' + content + ' days',
            style: TextStyle(
                color: filterLeadsController.selectedActivity.value == content
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }
}

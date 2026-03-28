import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
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

class FilterLeadsComponent extends StatelessWidget {
  FilterLeadsController filterLeadsController =
      Get.put(FilterLeadsController());

  String selectedItem = 'Lead';
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
            Get.back();
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
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
        child: Column(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ThemeConstants.height20,
          ),
          // filter , sort chips
          //  buildTopBar(),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          Container(
            color: ThemeConstants.greyColor,
            width: Get.width,
            height: 2,
          ),
          // SizedBox(
          //   height: ThemeConstants.height15,
          // ),
          buildFilterBody(),
          Container(
            color: ThemeConstants.greyColor,
            width: Get.width,
            height: 2,
          ),
        ],
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
    ]));
  }

  buildFilterBody() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Expanded(
                child: SizedBox(
              height: Get.height * 0.75,
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                      ),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: filterLeadsController.filteLabels.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Obx(() => InkWell(
                          onTap: () {
                            filterLeadsController.selectedLabel.value =
                                filterLeadsController.filteLabels[index];
                          },
                          child: Container(
                            color: filterLeadsController.selectedLabel.value ==
                                    filterLeadsController.filteLabels[index]
                                ? ThemeConstants.primaryColor
                                : ThemeConstants.whiteColor,
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Center(
                                      child: Text(
                                        '${filterLeadsController.filteLabels[index]}',
                                        style: filterLeadsController
                                                    .selectedLabel.value ==
                                                filterLeadsController
                                                    .filteLabels[index]
                                            ? Styles.whiteSubHeadingStyles3
                                            : Styles.labelStyles,
                                      ),
                                    )),
                                Container(
                                  color: ThemeConstants.greyColor,
                                  height: 1,
                                  width: Get.width,
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
            )),
          ),
          Container(
            color: ThemeConstants.greyColor,
            width: 1,
            height: Get.height * 0.75,
          ),
          Obx(() => Expanded(
              child: filterLeadsController.selectedLabel.value == 'Builder'
                  ? buildBuildersBody()
                  : filterLeadsController.selectedLabel.value == 'Project'
                      ? buildProjectsBody()
                      : filterLeadsController.selectedLabel.value == 'Status'
                          ? buildLeadsBody()
                          : buildLeadActivityBody()))
        ]);
  }

  buildBuildersBody() {
    return filterLeadsController.isLeadsLoading.value
        ? Container(height: Get.height * 0.35, child: showCustomLoader())
        : SizedBox(
            height: Get.height * 0.75,
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                    ),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: CommonService.instance.buildersList.length,
                itemBuilder: (BuildContext ctx, index) {
                  //  print('salesmans....${filterController.salesmans}');
                  return Obx(() => GestureDetector(
                      onTap: () {
                        //  print('selItem.............');

                        if (CommonService.instance.selectedBuilderId.value !=
                            '') {
                          if (CommonService.instance.selectedBuilderId.value ==
                              CommonService.instance.buildersList[index]
                                  ['id']) {
                            filterLeadsController.selectedBuilder.value = '';
                            filterLeadsController.selectedBuilderId.value = '';
                            CommonService.instance.selectedBuilder.value = '';
                            CommonService.instance.selectedBuilderId.value = '';
                            filterLeadsController.getAllProjects();
                          } else {
                            filterLeadsController.selectedBuilder.value =
                                CommonService.instance.buildersList[index]
                                    ['name'];
                            filterLeadsController.selectedBuilderId.value =
                                CommonService.instance.buildersList[index]
                                    ['id'];
                            CommonService.instance.selectedBuilder.value =
                                CommonService.instance.buildersList[index]
                                    ['name'];
                            CommonService.instance.selectedBuilderId.value =
                                CommonService.instance.buildersList[index]
                                    ['id'];
                            filterLeadsController.getProjectsByBuilderId();
                          }
                        } else {
                          // print('selItem 4444$content');
                          filterLeadsController.selectedBuilder.value =
                              CommonService.instance.buildersList[index]
                                  ['name'];
                          filterLeadsController.selectedBuilderId.value =
                              CommonService.instance.buildersList[index]['id'];
                          CommonService.instance.selectedBuilder.value =
                              CommonService.instance.buildersList[index]
                                  ['name'];
                          CommonService.instance.selectedBuilderId.value =
                              CommonService.instance.buildersList[index]['id'];
                          filterLeadsController.getProjectsByBuilderId();
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 20,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: filterLeadsController
                                              .selectedBuilderId.value ==
                                          CommonService.instance
                                              .buildersList[index]['id']
                                      ? ThemeConstants.primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: ThemeConstants.primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  CommonService.instance.buildersList[index]
                                      ['name'],
                                  style: TextStyle(
                                      color: filterLeadsController
                                                  .selectedBuilderId.value ==
                                              CommonService.instance
                                                  .buildersList[index]['id']
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )),
                        ],
                      )));
                }),
          );
  }

  buildProjectsBody() {
    return filterLeadsController.isProjectsLoading.value
        ? Container(height: Get.height * 0.35, child: showCustomLoader())
        : SizedBox(
            height: Get.height * 0.75,
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                    ),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: CommonService.instance.projectsNamesList.length,
                itemBuilder: (BuildContext ctx, index) {
                  //  print('salesmans....${filterController.salesmans}');
                  return Obx(() => GestureDetector(
                      onTap: () {
                        if (CommonService.instance.selectedProjectId.value !=
                            '') {
                          // print('sseee 111111$id');
                          if (CommonService.instance.selectedProjectId.value ==
                              CommonService.instance.projectsNamesList[index]
                                  ['id']) {
                            filterLeadsController.selectedProject.value = '';
                            CommonService.instance.selectedProject.value = '';
                            CommonService.instance.selectedProjectId.value = '';
                            filterLeadsController.selectedProjectId.value = '';
                            //   print('sseee 2222${CommonService.instance.selectedStatus.value}');
                          } else {
                            // print('selItem 3333$content');
                            filterLeadsController.selectedProject.value =
                                CommonService.instance.projectsNamesList[index]
                                    ['name'];
                            CommonService.instance.selectedProject.value =
                                CommonService.instance.projectsNamesList[index]
                                    ['name'];
                            CommonService.instance.selectedProjectId.value =
                                CommonService.instance.projectsNamesList[index]
                                    ['id'];
                            filterLeadsController.selectedProjectId.value =
                                CommonService.instance.projectsNamesList[index]
                                    ['id'];
                          }
                        } else {
                          // print('selItem 4444$content');
                          filterLeadsController.selectedProject.value =
                              CommonService.instance.projectsNamesList[index]
                                  ['name'];
                          CommonService.instance.selectedProject.value =
                              CommonService.instance.projectsNamesList[index]
                                  ['name'];
                          CommonService.instance.selectedProjectId.value =
                              CommonService.instance.projectsNamesList[index]
                                  ['id'];
                          filterLeadsController.selectedProjectId.value =
                              CommonService.instance.projectsNamesList[index]
                                  ['id'];
                          //  print('sseee 4444${CommonService.instance.selectedStatus.value}');
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 20,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: filterLeadsController
                                              .selectedProjectId.value ==
                                          CommonService.instance
                                              .projectsNamesList[index]['id']
                                      ? ThemeConstants.primaryColor
                                      : Colors.white,
                                  border: Border.all(
                                      color: ThemeConstants.primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  CommonService.instance
                                      .projectsNamesList[index]['name'],
                                  style: TextStyle(
                                      color: filterLeadsController
                                                  .selectedProjectId.value ==
                                              CommonService.instance
                                                      .projectsNamesList[index]
                                                  ['id']
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              )),
                        ],
                      )));
                }),
          );
  }

  buildLeadsBody() {
    return SizedBox(
      height: Get.height * 0.75,
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
              ),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: CommonService.instance.statuses.length,
          itemBuilder: (BuildContext ctx, index) {
            //  print('salesmans....${filterController.salesmans}');
            return Obx(() => GestureDetector(
                onTap: () {
                  if (CommonService.instance.selectedStatus.value != '') {
                    if (CommonService.instance.selectedStatus.value ==
                        CommonService.instance.statuses[index]) {
                      filterLeadsController.selectedStatus.value = '';
                      CommonService.instance.selectedStatus.value = '';
                      print(
                          'sseee 2222${CommonService.instance.selectedStatus.value}');
                    } else {
                      // print('selItem 3333$content');
                      filterLeadsController.selectedStatus.value =
                          CommonService.instance.statuses[index];
                      CommonService.instance.selectedStatus.value =
                          CommonService.instance.statuses[index];
                      print(
                          'sseee 3333${CommonService.instance.selectedStatus.value}');
                    }
                  } else {
                    // print('selItem 4444$content');
                    filterLeadsController.selectedStatus.value =
                        CommonService.instance.statuses[index];
                    CommonService.instance.selectedStatus.value =
                        CommonService.instance.statuses[index];
                    print(
                        'sseee 4444${CommonService.instance.selectedStatus.value}');
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ThemeConstants.height10,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 20,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: filterLeadsController.selectedStatus.value ==
                                    CommonService.instance.statuses[index]
                                ? ThemeConstants.primaryColor
                                : Colors.white,
                            border:
                                Border.all(color: ThemeConstants.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            CommonService.instance.statuses[index],
                            style: TextStyle(
                                color: filterLeadsController
                                            .selectedStatus.value ==
                                        CommonService.instance.statuses[index]
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        )),
                  ],
                )));
          }),
    );
  }

  buildLeadActivityBody() {
    return SizedBox(
      height: Get.height * 0.75,
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
              ),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: CommonService.instance.leadActivityList.length,
          itemBuilder: (BuildContext ctx, index) {
            //  print('salesmans....${filterController.salesmans}');
            return Obx(() => GestureDetector(
                onTap: () {
                  if (CommonService.instance.selectedActivity.value != '') {
                    // print('sseee 111111$content');
                    if (CommonService.instance.selectedActivity.value ==
                        CommonService.instance.leadActivityList[index]) {
                      filterLeadsController.selectedActivity.value = '';
                      CommonService.instance.selectedActivity.value = '';
                    } else {
                      filterLeadsController.selectedActivity.value =
                          CommonService.instance.leadActivityList[index];
                      CommonService.instance.selectedActivity.value =
                          CommonService.instance.leadActivityList[index];
                    }
                  } else {
                    filterLeadsController.selectedActivity.value =
                        CommonService.instance.leadActivityList[index];
                    CommonService.instance.selectedActivity.value =
                        CommonService.instance.leadActivityList[index];
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: ThemeConstants.height10,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 20,
                        ),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                filterLeadsController.selectedActivity.value ==
                                        CommonService
                                            .instance.leadActivityList[index]
                                    ? ThemeConstants.primaryColor
                                    : Colors.white,
                            border:
                                Border.all(color: ThemeConstants.primaryColor),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'More than ' +
                                '${CommonService.instance.leadActivityList[index]}' +
                                ' days',
                            style: TextStyle(
                                color: filterLeadsController
                                            .selectedActivity.value ==
                                        CommonService
                                            .instance.leadActivityList[index]
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        )),
                  ],
                )));
          }),
    );
  }
}

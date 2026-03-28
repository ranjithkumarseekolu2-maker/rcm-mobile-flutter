import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/components/project_documents/project_documents_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:badges/badges.dart' as badges;

class ProjectsDocumentsComponent extends StatelessWidget {
  ProjectDocumentsController projectDocumentsController =
      Get.put(ProjectDocumentsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ThemeConstants.primaryColor,
          title: const Text(
            'Project Documents',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: ThemeConstants.whiteColor),
            onPressed: () {
              Get.delete<ProjectsController>();
              Get.toNamed(Routes.projects);
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeAnimation: badges.BadgeAnimation.slide(
                    // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                    // curve: Curves.easeInCubic,
                    ),
                showBadge:
                    CommonService.instance.allNotificationsCount.value > 0
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
                      LineIcons.bell,
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
        body: WillPopScope(
          onWillPop: () async {
            Get.delete<ProjectsController>(force: true);
            Get.toNamed(Routes.projects);
            return false;
          },
          child: Obx(() => LoadingOverlay(
                opacity: 1,
                color: Colors.black54,
                progressIndicator: SpinKitCircle(
                  color: ThemeConstants.whiteColor,
                  size: 50.0,
                ),
                isLoading:
                    projectDocumentsController.isProjectLayoutLoading.value,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.screenPadding10,
                        vertical: ThemeConstants.height10),
                    child: Column(
                      children: [
                        buildProjectLayout(context),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildProjectLayoutFiles(),
                        buildMasterPlan(context),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildMasterPlansFiles(),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildFloorPlan(context),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildFloorPlansFiles(),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildStatusUpdateWithImages(context),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildStatusFiles(),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildBrochure(context),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildBrochureFiles(),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildProjectCover(context),
                        SizedBox(
                          height: ThemeConstants.height20,
                        ),
                        buildProjectCoverFiles(),
                        SizedBox(
                          height: ThemeConstants.height31,
                        ),
                        RoundedOutlineButtonWidget(
                          buttonWidth: Get.width,
                          buttonName: 'Back',
                          onPressed: () {
                            Get.delete<ProjectsController>(force: true);
                            Get.toNamed(Routes.projects);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }

  buildProjectLayoutFiles() {
    return Column(
      children: [
        Obx(() => projectDocumentsController.projectLayoutsList.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectDocumentsController.projectLayoutsList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(6.0));
                },
                itemBuilder: (context, index) {
                  print(
                      'url..... ${projectDocumentsController.projectLayoutsList[index].url},${projectDocumentsController.projectLayoutsList[index].fileId}');
                  return Container(
                    decoration: BoxDecoration(
                        color: ThemeConstants.whiteColor,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              projectDocumentsController
                                  .projectLayoutsList[index].name!,
                              style: Styles.labelStyles,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: projectDocumentsController
                                        .projectLayoutsList[index].url !=
                                    null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          projectDocumentsController
                                              .projectLayoutsList[index]
                                              .fileId);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 23,
                                    ))
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      leading: projectDocumentsController
                                  .projectLayoutsList[index].url !=
                              null
                          ? (projectDocumentsController
                                      .projectLayoutsList[index].url!
                                      .contains(".jpg") ||
                                  projectDocumentsController
                                      .projectLayoutsList[index].url!
                                      .contains(".png"))
                              ? Image.network(
                                  projectDocumentsController
                                      .projectLayoutsList[index].url!,
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                )
                          : (projectDocumentsController.image.value
                                      .contains('.jpg') ||
                                  projectDocumentsController.image.value
                                      .contains('.png'))
                              ? Image.file(
                                  projectDocumentsController
                                      .projectLayoutsList[index].file!,
                                  width: 25,
                                  height: 25,
                                )
                              : Icon(
                                  LineIcons.file,
                                  color: ThemeConstants.iconColor,
                                ),
                      onTap: () {},
                      trailing: InkWell(
                          onTap: () {
                            //DB delete
                            if (projectDocumentsController
                                    .projectLayoutsList[index].url !=
                                null) {
                              projectDocumentsController.deleteDocument(
                                  projectDocumentsController
                                      .projectLayoutsList[index].fileId,
                                  "projectLayout");
                            } else {
                              //local delete
                              projectDocumentsController.projectLayoutsList
                                  .remove(projectDocumentsController
                                      .projectLayoutsList[index]);
                            }
                          },
                          child: Icon(LineIcons.trash,
                              color: ThemeConstants.errorColor, size: 23)),
                    ),
                  );
                },
              )
            : SizedBox.shrink()),
        Obx(() => projectDocumentsController.projectLayoutsList.isNotEmpty &&
                projectDocumentsController.isProjectLayout.value
            ? Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: Get.width * 0.2,
                  height: ThemeConstants.smallBtnHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: ThemeConstants.primaryColor,
                  onPressed: () {
                    projectDocumentsController
                        .uploadDocuments("PROJECT_LAYOUT");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildFloorPlansFiles() {
    return Column(
      children: [
        Obx(() => projectDocumentsController.floorPlansList.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectDocumentsController.floorPlansList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(6.0));
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: ThemeConstants.whiteColor,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              projectDocumentsController
                                  .floorPlansList[index].name!,
                              style: Styles.labelStyles,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: projectDocumentsController
                                        .floorPlansList[index].url !=
                                    null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          projectDocumentsController
                                              .floorPlansList[index].fileId);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 23,
                                    ))
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      leading: projectDocumentsController
                                  .floorPlansList[index].url !=
                              null
                          ? (projectDocumentsController
                                      .floorPlansList[index].url!
                                      .contains(".jpg") ||
                                  projectDocumentsController
                                      .floorPlansList[index].url!
                                      .contains(".png"))
                              ? Image.network(
                                  projectDocumentsController
                                      .floorPlansList[index].url!,
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                )
                          : (projectDocumentsController.image.value
                                      .contains('.jpg') ||
                                  projectDocumentsController.image.value
                                      .contains('.png'))
                              ? Image.file(
                                  projectDocumentsController
                                      .floorPlansList[index].file!,
                                  width: 25,
                                  height: 25,
                                )
                              : Icon(
                                  LineIcons.file,
                                  color: ThemeConstants.iconColor,
                                ),
                      onTap: () {},
                      trailing: InkWell(
                          onTap: () {
                            if (projectDocumentsController
                                    .floorPlansList[index].url !=
                                null) {
                              projectDocumentsController.deleteDocument(
                                  projectDocumentsController
                                      .floorPlansList[index].fileId,
                                  "floorPlan");
                            } else {
                              projectDocumentsController.floorPlansList.remove(
                                  projectDocumentsController
                                      .floorPlansList[index]);
                            }
                          },
                          child: Icon(LineIcons.trash,
                              color: ThemeConstants.errorColor, size: 23)),
                    ),
                  );
                },
              )
            : SizedBox.shrink()),
        Obx(() => projectDocumentsController.floorPlansList.isNotEmpty &&
                projectDocumentsController.isFloorPlan.value
            ? Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: Get.width * 0.2,
                  height: ThemeConstants.smallBtnHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: ThemeConstants.primaryColor,
                  onPressed: () {
                    projectDocumentsController.uploadDocuments("FLOOR_PLAN");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildStatusFiles() {
    return Column(
      children: [
        Obx(() => projectDocumentsController.statusImagesList.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectDocumentsController.statusImagesList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(6.0));
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: ThemeConstants.whiteColor,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              projectDocumentsController
                                  .statusImagesList[index].name!,
                              style: Styles.labelStyles,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: projectDocumentsController
                                        .statusImagesList[index].url !=
                                    null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          projectDocumentsController
                                              .statusImagesList[index].fileId);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 23,
                                    ))
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      leading: projectDocumentsController
                                  .statusImagesList[index].url !=
                              null
                          ? (projectDocumentsController
                                      .statusImagesList[index].url!
                                      .contains(".jpg") ||
                                  projectDocumentsController
                                      .statusImagesList[index].url!
                                      .contains(".png"))
                              ? Image.network(
                                  projectDocumentsController
                                      .statusImagesList[index].url!,
                                  width: 25,
                                  height: 25,
                                )
                              : Icon(
                                  LineIcons.file,
                                  color: ThemeConstants.greyColor,
                                )
                          : (projectDocumentsController.image.value
                                      .contains('.jpg') ||
                                  projectDocumentsController.image.value
                                      .contains('.png'))
                              ? Image.file(
                                  projectDocumentsController
                                      .statusImagesList[index].file!,
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                ),
                      onTap: () {},
                      trailing: InkWell(
                          onTap: () {
                            if (projectDocumentsController
                                    .statusImagesList[index].url !=
                                null) {
                              projectDocumentsController.deleteDocument(
                                  projectDocumentsController
                                      .statusImagesList[index].fileId,
                                  "statusImages");
                            } else {
                              projectDocumentsController.statusImagesList
                                  .remove(projectDocumentsController
                                      .statusImagesList[index]);
                            }
                          },
                          child: Icon(LineIcons.trash,
                              color: ThemeConstants.errorColor, size: 23)),
                    ),
                  );
                },
              )
            : SizedBox.shrink()),
        Obx(() => projectDocumentsController.statusImagesList.isNotEmpty &&
                projectDocumentsController.isStatusUpdate.value
            ? Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: Get.width * 0.2,
                  height: ThemeConstants.smallBtnHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: ThemeConstants.primaryColor,
                  onPressed: () {
                    projectDocumentsController.uploadDocuments("STATUS_IMAGES");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildMasterPlansFiles() {
    return Column(
      children: [
        Obx(() => projectDocumentsController.masterPlansList.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectDocumentsController.masterPlansList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(6.0));
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: ThemeConstants.whiteColor,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              projectDocumentsController
                                  .masterPlansList[index].name!,
                              style: Styles.labelStyles,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: projectDocumentsController
                                        .masterPlansList[index].url !=
                                    null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          projectDocumentsController
                                              .masterPlansList[index].fileId);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 23,
                                    ))
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      leading: projectDocumentsController
                                  .masterPlansList[index].url !=
                              null
                          ? (projectDocumentsController
                                      .masterPlansList[index].url!
                                      .contains(".jpg") ||
                                  projectDocumentsController
                                      .masterPlansList[index].url!
                                      .contains(".png"))
                              ? Image.network(
                                  projectDocumentsController
                                      .masterPlansList[index].url!,
                                  width: 25,
                                  height: 25,
                                )
                              : Icon(
                                  LineIcons.file,
                                  color: ThemeConstants.greyColor,
                                )
                          : (projectDocumentsController.image.value
                                      .contains('.jpg') ||
                                  projectDocumentsController.image.value
                                      .contains('.png'))
                              ? Image.file(
                                  projectDocumentsController
                                      .masterPlansList[index].file!,
                                  width: 25,
                                  height: 25,
                                )
                              : Icon(
                                  LineIcons.file,
                                  color: ThemeConstants.iconColor,
                                ),
                      onTap: () {},
                      trailing: InkWell(
                          onTap: () {
                            if (projectDocumentsController
                                    .masterPlansList[index].url !=
                                null) {
                              print("db call");
                              projectDocumentsController.deleteDocument(
                                  projectDocumentsController
                                      .masterPlansList[index].fileId,
                                  "masterPlan");
                            } else {
                              projectDocumentsController.masterPlansList.remove(
                                  projectDocumentsController
                                      .masterPlansList[index]);
                            }
                          },
                          child: Icon(LineIcons.trash,
                              color: ThemeConstants.errorColor, size: 23)),
                    ),
                  );
                },
              )
            : SizedBox.shrink()),
        Obx(() => projectDocumentsController.masterPlansList.isNotEmpty &&
                projectDocumentsController.isMasterPlan.value
            ? Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: Get.width * 0.2,
                  height: ThemeConstants.smallBtnHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: ThemeConstants.primaryColor,
                  onPressed: () {
                    projectDocumentsController.uploadDocuments("MASTER_PLAN");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildBrochureFiles() {
    return Column(
      children: [
        Obx(() => projectDocumentsController.brochureList.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectDocumentsController.brochureList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(6.0));
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: ThemeConstants.whiteColor,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              projectDocumentsController
                                  .brochureList[index].name!,
                              style: Styles.labelStyles,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: projectDocumentsController
                                        .brochureList[index].url !=
                                    null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          projectDocumentsController
                                              .brochureList[index].fileId);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 23,
                                    ))
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      leading: projectDocumentsController
                                  .brochureList[index].url !=
                              null
                          ? (projectDocumentsController.brochureList[index].url!
                                      .contains(".jpg") ||
                                  projectDocumentsController
                                      .brochureList[index].url!
                                      .contains(".png"))
                              ? Image.network(
                                  projectDocumentsController
                                      .brochureList[index].url!,
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                )
                          : (projectDocumentsController.image.value
                                      .contains('.jpg') ||
                                  projectDocumentsController.image.value
                                      .contains('.png'))
                              ? Image.file(
                                  projectDocumentsController
                                      .brochureList[index].file!,
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                ),
                      onTap: () {},
                      trailing: InkWell(
                          onTap: () {
                            if (projectDocumentsController
                                    .brochureList[index].url !=
                                null) {
                              projectDocumentsController.deleteDocument(
                                  projectDocumentsController
                                      .brochureList[index].fileId,
                                  "brochure");
                            } else {
                              projectDocumentsController.brochureList.remove(
                                  projectDocumentsController
                                      .brochureList[index]);
                            }
                          },
                          child: Icon(LineIcons.trash,
                              color: ThemeConstants.errorColor, size: 23)),
                    ),
                  );
                },
              )
            : SizedBox.shrink()),
        Obx(() => projectDocumentsController.brochureList.isNotEmpty &&
                projectDocumentsController.isBrochure.value
            ? Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: Get.width * 0.2,
                  height: ThemeConstants.smallBtnHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: ThemeConstants.primaryColor,
                  onPressed: () {
                    projectDocumentsController.uploadDocuments("BROCHURE");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildProjectCoverFiles() {
    return Column(
      children: [
        Obx(() => projectDocumentsController.projectCoverList.isNotEmpty
            ? ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: projectDocumentsController.projectCoverList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(padding: EdgeInsets.all(6.0));
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: ThemeConstants.whiteColor,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Text(
                              projectDocumentsController
                                  .projectCoverList[index].name!,
                              style: Styles.labelStyles,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: projectDocumentsController
                                        .projectCoverList[index].url !=
                                    null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          projectDocumentsController
                                              .projectCoverList[index].fileId);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 23,
                                    ))
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                      leading: projectDocumentsController
                                  .projectCoverList[index].url !=
                              null
                          ? (projectDocumentsController
                                      .projectCoverList[index].url!
                                      .contains(".jpg") ||
                                  projectDocumentsController
                                      .projectCoverList[index].url!
                                      .contains(".png"))
                              ? Image.network(
                                  projectDocumentsController
                                      .projectCoverList[index].url!,
                                  width: 25,
                                  height: 25,
                                )
                              : Icon(
                                  LineIcons.file,
                                  color: ThemeConstants.greyColor,
                                )
                          : (projectDocumentsController.image.value
                                      .contains('.jpg') ||
                                  projectDocumentsController.image.value
                                      .contains('.png'))
                              ? Image.file(
                                  projectDocumentsController
                                      .projectCoverList[index].file!,
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                ),
                      onTap: () {},
                      trailing: InkWell(
                          onTap: () {
                            if (projectDocumentsController
                                    .projectCoverList[index].url !=
                                null) {
                              projectDocumentsController.deleteDocument(
                                  projectDocumentsController
                                      .projectCoverList[index].fileId,
                                  "logo");
                            } else {
                              projectDocumentsController.projectCoverList
                                  .remove(projectDocumentsController
                                      .projectCoverList[index]);
                            }
                          },
                          child: Icon(LineIcons.trash,
                              color: ThemeConstants.errorColor, size: 23)),
                    ),
                  );
                },
              )
            : SizedBox.shrink()),
        Obx(() => projectDocumentsController.projectCoverList.isNotEmpty &&
                projectDocumentsController.isProjectCover.value
            ? Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  minWidth: Get.width * 0.2,
                  height: ThemeConstants.smallBtnHeight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: ThemeConstants.primaryColor,
                  onPressed: () {
                    projectDocumentsController.uploadDocuments("LOGO");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  showBottomSheet(context, fileId) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'File Details',
                                        style: Styles.subHeadingStyles,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 30,
                                          color: Color(0XFF7B7B7B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Title',
                                        style: Styles.labelStyles,
                                      ),
                                      SizedBox(
                                        height: ThemeConstants.height10,
                                      ),
                                      TextBoxWidget(
                                          hintText: "Title",
                                          controller: projectDocumentsController
                                              .titleController),
                                      SizedBox(
                                        height: ThemeConstants.height10,
                                      ),
                                      Text(
                                        'Description',
                                        style: Styles.labelStyles,
                                      ),
                                      SizedBox(
                                        height: ThemeConstants.height10,
                                      ),
                                      TextBoxWidget(
                                          hintText: "Description",
                                          controller: projectDocumentsController
                                              .descriptionController),
                                      SizedBox(
                                        height: ThemeConstants.height10,
                                      ),
                                      Text(
                                        'Category',
                                        style: Styles.labelStyles,
                                      ),
                                      SizedBox(
                                        height: ThemeConstants.height10,
                                      ),
                                      TextBoxWidget(
                                          hintText:
                                              "Enter Categories (separated by commas)",
                                          controller: projectDocumentsController
                                              .categoryController),
                                      SizedBox(
                                        height: ThemeConstants.height10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height20,
                                  ),
                                  RoundedFilledButtonWidget(
                                      buttonName: 'Save',
                                      onPressed: () {
                                        Get.back();
                                        projectDocumentsController
                                            .updateFile(fileId);
                                      })
                                ],
                              ))),
                    ]),
                  )),
            ));
  }

  Column buildProjectLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Project Layout ',
          style: Styles.label1Styles,
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        buildImageUploadCard(context, "projectLayout"),
      ],
    );
  }

  Align buildImageUploadCard(BuildContext context, type) {
    return Align(
        alignment: Alignment.center,
        child: InkWell(
            onTap: () {
              openSheet(context, type);
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: [6, 6],
              color: ThemeConstants.greyColor,
              radius: Radius.circular(12),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                child: Container(
                  height: 125,
                  width: 145,
                  color: ThemeConstants.whiteColor,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageConstants.uploadImage,
                        width: 45,
                        height: 45,
                      ),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      Text(
                        "Click here to upload",
                        style: Styles.hint3Styles,
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
                ),
              ),
            )));
  }

  Column buildMasterPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Master Plan ',
          style: Styles.label1Styles,
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        buildImageUploadCard(context, "masterPlan"),
      ],
    );
  }

  Column buildFloorPlan(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Floor Plan ',
          style: Styles.label1Styles,
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        buildImageUploadCard(context, "floorPlan"),
      ],
    );
  }

  Column buildStatusUpdateWithImages(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Status update with images',
          style: Styles.label1Styles,
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        buildImageUploadCard(context, "statusWithImages"),
      ],
    );
  }

  Column buildBrochure(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Brochure',
          style: Styles.label1Styles,
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        buildImageUploadCard(context, "brochure"),
      ],
    );
  }

  Column buildProjectCover(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Project Cover',
          style: Styles.label1Styles,
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        buildImageUploadCard(context, "projectCover"),
      ],
    );
  }

  openSheet(BuildContext context, type) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (context) => Container(
          height: Get.height * 0.2,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
              left: Get.height * 0.022, right: Get.height * 0.022),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: Get.height * 0.022, bottom: Get.height * 0.022),
                child: Center(
                    child: Container(
                  decoration: const BoxDecoration(
                    color: ThemeConstants.greyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  height: 5,
                  width: Get.width * 0.096,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      projectDocumentsController
                          .takeProductImageFromCamera(type);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width10),
                        const Text(
                          'Take a Photo',
                          style:
                              TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      projectDocumentsController.pickFile(type);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width10),
                        Text(
                          'Choose file',
                          style:
                              TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

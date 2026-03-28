import 'dart:io';

import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/components/project_documents/project_documents_controller.dart';
import 'package:brickbuddy/components/projects/create_project_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ProjectCardWidget extends StatelessWidget {
  dynamic item;

  VoidCallback? presssedOnRefer;
  VoidCallback? pressedOnRequest;
  // ProjectCardWidget({required this.item});
  ProjectCardWidget(
      {required this.item, this.presssedOnRefer, this.pressedOnRequest});
  @override
  Widget build(BuildContext context) {
    // print('phonnne0123 ${item['logo']}');
    //  print('phonnne0333 ${item['builder']['IS_VERIFIED']}');
    //   print('phonnne000 ${item['agentBuilderMapping']!=null}');
    //   print('phonnne0111 ${item['agentBuilderMapping'].isNotEmpty}');
    //   print('phonnne0222 ${item['agentBuilderMapping'] != null && item['agentBuilderMapping'].isNotEmpty}');
    // if (item['agentBuilderMapping'] != null &&
    //     item['agentBuilderMapping'].isNotEmpty) {
    //   print('phonnne0344 ${item['agentBuilderMapping'][0]['STATUS']}');
    // }
    // else {
    //   print('agentBuilderMapping is empty or null.');
    // }
    return Card(
      color: item['status'] == 1 ? ThemeConstants.whiteColor : Colors.grey[200],
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 20,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${toBeginningOfSentenceCase(item['projectName'])} ',
                                      style: item['status'] == 1
                                          ? Styles.label2Styles
                                          : Styles
                                              .label7Styles, // Apply your regular project name style here
                                    ),
                                    TextSpan(
                                        text:
                                            '- ${toBeginningOfSentenceCase(item['builder']['REGISTERED_NAME'])}',
                                        style: item['status'] == 1
                                            ? Styles.link1Styles
                                            : TextStyle(
                                                color: ThemeConstants
                                                    .primaryColor70,
                                                fontSize:
                                                    ThemeConstants.fontSize12,
                                                fontFamily:
                                                    ThemeConstants.fontFamily,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            item['status'] == 1
                                ? item['agentBuilderMapping'] != null &&
                                        item['agentBuilderMapping'].isNotEmpty
                                    ? item['builder']['IS_VERIFIED'] != 0 &&
                                            item['agentBuilderMapping'][0]['STATUS'] !=
                                                0
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.green),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.check,
                                                  size: 15,
                                                  color: Colors.white),
                                            ))
                                        : item['builder']['IS_VERIFIED'] != 0 &&
                                                item['agentBuilderMapping'][0]
                                                        ['STATUS'] ==
                                                    0
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Color.fromARGB(
                                                        255, 212, 164, 5)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Icon(Icons.check,
                                                      size: 15,
                                                      color: Colors.white),
                                                ))
                                            : Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(30),
                                                    color: Colors.red),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Icon(Icons.close,
                                                      size: 15,
                                                      color: Colors.white),
                                                ))
                                    : item['builder']['IS_VERIFIED'] != 0
                                        ? Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Color.fromARGB(255, 212, 164, 5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.check,
                                                  size: 15,
                                                  color: Colors.white),
                                            ))
                                        : Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.red),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.close,
                                                  size: 15,
                                                  color: Colors.white),
                                            ))
                                : SizedBox.shrink()
                          ],
                        ),
                        SizedBox(
                          height: ThemeConstants.height4,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 20,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          // item['status'] == 1
                                          //     ? Container(
                                          //         decoration: BoxDecoration(
                                          //             color: Color.fromRGBO(
                                          //                 52, 195, 142, 0.18),
                                          //             borderRadius: BorderRadius.all(
                                          //                 Radius.circular(10.0))),
                                          //         child: Padding(
                                          //           padding: const EdgeInsets.all(6.0),
                                          //           child: Text(
                                          //             "Active",
                                          //             style: Styles.projectStatusStyle,
                                          //           ),
                                          //         ),
                                          //       )
                                          //     : Container(
                                          //         decoration: BoxDecoration(
                                          //             color: ThemeConstants.errorColor,
                                          //             borderRadius: BorderRadius.all(
                                          //                 Radius.circular(10.0))),
                                          //         child: Padding(
                                          //           padding: const EdgeInsets.all(4.0),
                                          //           child: Text(
                                          //             "InActive",
                                          //             style:
                                          //                 Styles.whiteSubHeadingStyles2,
                                          //           ),
                                          //         ),
                                          //       ),
                                          // SizedBox(
                                          //   width: ThemeConstants.width10,
                                          // ),
                                          item['totalProjectArea'] != ''
                                              ? Row(
                                                  children: [
                                                    Icon(
                                                      LineIcons.ruler,
                                                      color: ThemeConstants
                                                          .iconColor,
                                                      size: 20,
                                                    ),
                                                    Text(
                                                      " ${item['totalProjectArea']}",
                                                      style: Styles
                                                          .hintStylesLight,
                                                    ),
                                                  ],
                                                )
                                              : item['totalPlotArea'] != ''
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          LineIcons.ruler,
                                                          color: ThemeConstants
                                                              .iconColor,
                                                          size: 20,
                                                        ),
                                                        Text(
                                                          " ${item['totalPlotArea']}",
                                                          style: Styles
                                                              .hintStylesLight,
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox.shrink(),
                                          item['totalProjectAre'] != '' ||
                                                  item['totalPlotAre'] != ''
                                              ? SizedBox(
                                                  width: ThemeConstants.width10,
                                                )
                                              : SizedBox.shrink(),
                                          Row(
                                            children: [
                                              Icon(
                                                LineIcons.phone,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),
                                              item['builderContactDetails'] !=
                                                      ''
                                                  ? Text(
                                                      " ${toBeginningOfSentenceCase(item['builderContactDetails'])}",
                                                      style: Styles
                                                          .hintStylesLight)
                                                  : Text(
                                                      " ${toBeginningOfSentenceCase(item['pointOfContact'])}",
                                                      style: Styles
                                                          .hintStylesLight),
                                            ],
                                          ),
                                        ],
                                      ),
                                      // item['status'] == 2
                                      //     ? Container(
                                      //         decoration: BoxDecoration(
                                      //             color: ThemeConstants.errorColor,
                                      //             borderRadius:
                                      //                 BorderRadius.circular(10)),
                                      //         child: Padding(
                                      //           padding: EdgeInsets.symmetric(),
                                      //           child: Text('Deleted'),
                                      //         ))
                                      //     : SizedBox.shrink()
                                    ],
                                  ),
                                  SizedBox(height: ThemeConstants.height6),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        LineIcons.mapMarker,
                                        color: ThemeConstants.iconColor,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${item['address']}",
                                          style: Styles.hintStyles,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            item['status'] == 1
                                ? Expanded(
                                    flex: 1,
                                    child: PopupMenuButton<int>(
                                      icon: Icon(
                                        LineIcons.verticalEllipsis,
                                        color: ThemeConstants.iconColor,
                                        size: 20,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onSelected: (v) {
                                        print("onSelected: $v");
                                        if (v == 1) {
                                          print(
                                              'pppppppp ${item['createdBy']}');
                                          print(
                                              'pppppppp ${CommonService.instance.agentId.value}');
                                          Get.delete<CreateProjectController>(
                                              force: true);
                                          Get.toNamed(Routes.createproject,
                                              arguments: {
                                                "projectId": item['projectId']
                                              });
                                        }
                                        if (v == 2) {
                                          ProjectsController
                                              projectsController = Get.find();
                                          projectsController.openBrowserTab(
                                              "${AppConstants.projectViewUrl}projectDetails?id=${item['projectId']}&ref=${CommonService.instance.agentId.value}");
                                          // : projectsController.openBrowserTab(
                                          //     "${AppConstants.projectViewUrl}projectDetails?id=${item['projectId']}&ref=${CommonService.instance.agentId.value}");
                                        }
                                        if (v == 3) {
                                          Get.delete<
                                              ProjectDocumentsController>();
                                          Get.toNamed(Routes.projectDocuments,
                                              arguments: {
                                                "projectId": item['projectId']
                                              });
                                        }
                                        if (v == 4) {
                                          Get.dialog(AppCupertinoDialog(
                                            title: 'Delete'.tr,
                                            subTitle:
                                                'Are you sure you want to delete project ${item['projectName']}?',
                                            isOkBtn: false,
                                            acceptText: 'Yes'.tr,
                                            cancelText: 'No'.tr,
                                            onAccepted: () async {
                                              ProjectsController
                                                  projectsController =
                                                  Get.put(ProjectsController());
                                              projectsController.deleteProject(
                                                  item['jobApplicationId']);
                                              Get.back();

                                              // exit(0);
                                            },
                                            onCanceled: () {
                                              Get.back();
                                            },
                                          ));
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.pen,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Edit")
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.eye,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("View")
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 3,
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.upload,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(" Upload Documents")
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 4,
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.trash,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(" Delete")
                                            ],
                                          ),
                                        ),
                                      ],
                                      elevation: 2,
                                    ),
                                  )
                                : Expanded(
                                    flex: 1,
                                    child: PopupMenuButton<int>(
                                      icon: Icon(
                                        LineIcons.verticalEllipsis,
                                        color: ThemeConstants.iconColor,
                                        size: 20,
                                      ),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      onSelected: (v) {
                                        print("onSelected: $v");
                                        if (v == 1) {
                                          ProjectsController
                                              projectsController =
                                              Get.put(ProjectsController());
                                          projectsController.deleteProject(
                                              item['jobApplicationId']);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              Icon(
                                                LineIcons.trash,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text("Delete")
                                            ],
                                          ),
                                        ),
                                      ],
                                      elevation: 2,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(width: ThemeConstants.width10),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: 1,
                color: const Color.fromRGBO(0, 0, 0, 0.05),
              ),
            ),
            item['status'] == 1 && item['builder']['IS_VERIFIED'] == 0 ||
                    item['status'] == 1 &&
                        item['builder']['IS_VERIFIED'] == 0 &&
                        item['agentBuilderMapping'].isNotEmpty &&
                        item['agentBuilderMapping'][0]['STATUS'] == 0 ||
                    item['status'] == 1 &&
                        item['builder']['IS_VERIFIED'] == 0 &&
                        item['agentBuilderMapping'].isEmpty ||
                    item['status'] == 1 &&
                        item['builder']['IS_VERIFIED'] == 1 &&
                        item['agentBuilderMapping'].isNotEmpty &&
                        item['agentBuilderMapping'][0]['STATUS'] == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.rawSnackbar(
                                message: "This feature will coming soon.");
                          },
                          child: item['status'] == 1
                              ? InkWell(
                                  onTap: presssedOnRefer,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        ImageConstants.refer,
                                        width: 20,
                                        height: 20,
                                        color: ThemeConstants.primaryColor,
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width10,
                                      ),
                                      Text("Refer", style: Styles.linkStyles)
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        ImageConstants.refer,
                                        width: 20,
                                        height: 20,
                                        color: ThemeConstants.primaryColor70,
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width10,
                                      ),
                                      Text("Refer",
                                          style: TextStyle(
                                              color:
                                                  ThemeConstants.primaryColor70,
                                              fontSize:
                                                  ThemeConstants.fontSize12,
                                              fontFamily:
                                                  ThemeConstants.fontFamily,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ),
                        ),
                        item['status'] == 1
                            ? InkWell(
                                onTap: () async {
                                  print('00000000000 ${item['logo']}');

                                  ProjectsController projectsController =
                                      Get.find();

                                  projectsController.isLoading.value = true;
                                  try {
                                    final imageUrl;
                                    // Define the image URL
                                    if (item['logo'].isNotEmpty) {
                                      imageUrl = item['logo'].toString();

                                      // Download the image and save it locally
                                      final response =
                                          await http.get(Uri.parse(imageUrl));

                                      if (response.statusCode == 200) {
                                        // Get the temporary directory
                                        final documentDirectory =
                                            await getTemporaryDirectory();
                                        final imagePath =
                                            '${documentDirectory.path}/shared_image.png';
                                        final imageFile = File(imagePath);

                                        // Write the image bytes to a temporary file
                                        await imageFile
                                            .writeAsBytes(response.bodyBytes);
                                        projectsController.isLoading.value =
                                            false;
                                        // Share the content using Share.shareXFiles and await its completion
                                        await Share.shareXFiles(
                                          [
                                            XFile(imageFile.path)
                                          ], // File to share
                                          text:
                                              "Realtor.works - ${toBeginningOfSentenceCase(item['projectName'])}\n"
                                              "Hello! ${toBeginningOfSentenceCase(CommonService.instance.firstName.value)} has shared about ${toBeginningOfSentenceCase(item['projectName'])} project. "
                                              "To know more about the project details, click here: ${AppConstants.shareUrl}projectDetails?id=${item['projectId']}&ref=${CommonService.instance.agentId.value}",
                                          subject:
                                              "${toBeginningOfSentenceCase(item['projectName'])}",
                                        );
                                      }
                                    } else {
                                      projectsController.isLoading.value =
                                          false;
                                      String shareText =
                                          "Realtor.works - ${toBeginningOfSentenceCase(item['projectName'])}\n"
                                          "Hello! ${toBeginningOfSentenceCase(CommonService.instance.firstName.value)} has shared about ${toBeginningOfSentenceCase(item['projectName'])} project. "
                                          "To know more about the project details, click here: ${AppConstants.shareUrl}projectDetails?id=${item['projectId']}&ref=${CommonService.instance.agentId.value}";

                                      await Share.share(
                                        shareText,
                                        subject: toBeginningOfSentenceCase(
                                            item['projectName']),
                                      ); // Replace with your actual image URL
                                    }
                                  } catch (e) {
                                    projectsController.isLoading.value = false;
                                    print('Error sharing content: $e');
                                  }
                                  // await FlutterShare.share(
                                  //     title:
                                  //         "https://stage1.realtor.works/projectDetails?id=${item['projectId']}",
                                  //     text:
                                  //         "Realtor.works - ${toBeginningOfSentenceCase(item['projectName'])}\nHello! ${toBeginningOfSentenceCase(CommonService.instance.firstName.value)} has shared about ${toBeginningOfSentenceCase(item['projectName'])} project. To know more about the project details, click here",
                                  //     linkUrl:
                                  //         'https://stage1.realtor.works/projectDetails?id=${item['projectId']} ',
                                  //     chooserTitle:
                                  //         "${toBeginningOfSentenceCase(item['projectName'])}");
                                },
                                child: Row(
                                  children: [
                                    LineIcon(
                                      Icons.share,
                                      size: 20,
                                      color: ThemeConstants.primaryColor,
                                    ),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    Text("Share", style: Styles.linkStyles)
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    LineIcon(
                                      Icons.share,
                                      size: 20,
                                      color: ThemeConstants.primaryColor70,
                                    ),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    Text("Share",
                                        style: TextStyle(
                                            color:
                                                ThemeConstants.primaryColor70,
                                            fontSize: ThemeConstants.fontSize12,
                                            fontFamily:
                                                ThemeConstants.fontFamily,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.rawSnackbar(
                                message: "This feature will coming soon.");
                          },
                          child: item['status'] == 1
                              ? InkWell(
                                  onTap: presssedOnRefer,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        ImageConstants.refer,
                                        width: 20,
                                        height: 20,
                                        color: ThemeConstants.primaryColor,
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width10,
                                      ),
                                      Text("Refer", style: Styles.linkStyles)
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        ImageConstants.refer,
                                        width: 20,
                                        height: 20,
                                        color: ThemeConstants.primaryColor70,
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width10,
                                      ),
                                      Text("Refer",
                                          style: TextStyle(
                                              color:
                                                  ThemeConstants.primaryColor70,
                                              fontSize:
                                                  ThemeConstants.fontSize12,
                                              fontFamily:
                                                  ThemeConstants.fontFamily,
                                              fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ),
                        ),
                        item['status'] == 1
                            ? InkWell(
                                onTap: () async {
                                  print('11111111111111111 ${item['logo']}');
                                  ProjectsController projectsController =
                                      Get.find();

                                  projectsController.isLoading.value = true;
                                  print('logo.... ${item['logo']}');
                                  try {
                                    final imageUrl;
                                    // Define the image URL
                                    if (item['logo'] != null) {
                                      imageUrl = item['logo'].toString();
                                      print('logo.... ${item['logo']}');
                                      // Download the image and save it locally
                                      final response =
                                          await http.get(Uri.parse(imageUrl));

                                      if (response.statusCode == 200) {
                                        // Get the temporary directory
                                        final documentDirectory =
                                            await getTemporaryDirectory();
                                        final imagePath =
                                            '${documentDirectory.path}/shared_image.png';
                                        final imageFile = File(imagePath);

                                        // Write the image bytes to a temporary file
                                        await imageFile
                                            .writeAsBytes(response.bodyBytes);
                                        projectsController.isLoading.value =
                                            false;
                                        // Share the content using Share.shareXFiles and await its completion
                                        await Share.shareXFiles(
                                          [
                                            XFile(imageFile.path)
                                          ], // File to share
                                          text:
                                              "Realtor.works - ${toBeginningOfSentenceCase(item['projectName'])}\n"
                                              "Hello! ${toBeginningOfSentenceCase(CommonService.instance.firstName.value)} has shared about ${toBeginningOfSentenceCase(item['projectName'])} project. "
                                              "To know more about the project details, click here: ${AppConstants.shareUrl}projectDetails?id=${item['projectId']}&ref=${CommonService.instance.agentId.value}",
                                          subject:
                                              "${toBeginningOfSentenceCase(item['projectName'])}",
                                        );
                                      } else {
                                        Get.rawSnackbar(
                                            message:
                                                'Failed to download image.');
                                        projectsController.isLoading.value =
                                            false;
                                        print(
                                            'Failed to download image. Status code: ${response.statusCode}');
                                      }
                                    } else {
                                      projectsController.isLoading.value =
                                          false;
                                      String shareText =
                                          "Realtor.works - ${toBeginningOfSentenceCase(item['projectName'])}\n"
                                          "Hello! ${toBeginningOfSentenceCase(CommonService.instance.firstName.value)} has shared about ${toBeginningOfSentenceCase(item['projectName'])} project. "
                                          "To know more about the project details, click here: ${AppConstants.shareUrl}projectDetails?id=${item['projectId']}&ref=${CommonService.instance.agentId.value}";

                                      await Share.share(
                                        shareText,
                                        subject: toBeginningOfSentenceCase(
                                            item['projectName']),
                                      ); // Replace with your actual image URL
                                    }
                                  } catch (e) {
                                    projectsController.isLoading.value = false;
                                    print('Error sharing content: $e');
                                  }
                                  // await FlutterShare.share(
                                  //     title:
                                  //         "https://stage1.realtor.works/projectDetails?id=${item['projectId']}",
                                  //     text:
                                  //         "Realtor.works - ${toBeginningOfSentenceCase(item['projectName'])}\nHello! ${toBeginningOfSentenceCase(CommonService.instance.firstName.value)} has shared about ${toBeginningOfSentenceCase(item['projectName'])} project. To know more about the project details, click here",
                                  //     linkUrl:
                                  //         'https://stage1.realtor.works/projectDetails?id=${item['projectId']} ',
                                  //     chooserTitle:
                                  //         "${toBeginningOfSentenceCase(item['projectName'])}");
                                },
                                child: Row(
                                  children: [
                                    LineIcon(
                                      Icons.share,
                                      size: 20,
                                      color: ThemeConstants.primaryColor,
                                    ),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    Text("Share", style: Styles.linkStyles)
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    LineIcon(
                                      Icons.share,
                                      size: 20,
                                      color: ThemeConstants.primaryColor70,
                                    ),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    Text("Share",
                                        style: TextStyle(
                                            color:
                                                ThemeConstants.primaryColor70,
                                            fontSize: ThemeConstants.fontSize12,
                                            fontFamily:
                                                ThemeConstants.fontFamily,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                        item['status'] == 1
                            ? InkWell(
                                onTap: pressedOnRequest,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .arrow_forward_rounded, // You can choose a different icon if needed
                                      color: ThemeConstants.primaryColor,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    Text("Request Builder",
                                        style: Styles.linkStyles)
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .arrow_forward_rounded, // You can choose a different icon if needed
                                      color: ThemeConstants.primaryColor70,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    Text("Request Builder",
                                        style: TextStyle(
                                            color:
                                                ThemeConstants.primaryColor70,
                                            fontSize: ThemeConstants.fontSize12,
                                            fontFamily:
                                                ThemeConstants.fontFamily,
                                            fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

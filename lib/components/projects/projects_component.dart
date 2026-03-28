import 'dart:ffi';
import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/project_card_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/search_box_widget.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';

import 'package:brickbuddy/components/projects/create_project_component.dart';
import 'package:brickbuddy/components/projects/create_project_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/components/projects/refer/refer_component.dart';
import 'package:brickbuddy/components/projects/refer/refer_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectsComponent extends StatelessWidget {
  ProjectsController projectsController = Get.put(ProjectsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("onWill pop scope calle");
        logout();
        return false;
      },
      child: Scaffold(
          backgroundColor: ThemeConstants.appBackgroundColor,
          bottomNavigationBar: BottombarWidget(),
          floatingActionButton: Obx(
            () => projectsController.isLoading.value
                ? SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          onPressed: () {
                            print('object');

                            Get.delete<CreateProjectController>(force: true);
                            Get.toNamed(Routes.createproject);
                          },
                          backgroundColor: ThemeConstants.primaryColor,
                          child: LineIcon(
                            Icons.add,
                            color: ThemeConstants.whiteColor,
                          ),
                          shape: CircleBorder(),
                        )),
                  ),
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: ThemeConstants.primaryColor,
            title: Text('Projects', style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: ThemeConstants.whiteColor),
              onPressed: () {
                Get.delete<ProjectsController>(force: true);
                Get.to(ProjectsComponent());
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => badges.Badge(
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
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            HomeController homeController = Get.find();
                            prefs.setInt("notidicationsSeen",
                                homeController.notificationsList.length);

                            // HomeController homeController = Get.find();
                            // homeController.storage.write("notidicationsSeen",
                            //     homeController.notificationsList.length);
                            Get.delete<NotificationsController>(force: true);
                            Get.toNamed(Routes.notificationsComponent);
                          }),
                    )),
              ),
            ],
          ),
          body: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.screenPadding),
              child: Column(
                children: [
                  SizedBox(
                    height: ThemeConstants.height10,
                  ),
                  buildSearchBox(),
                  SizedBox(
                    height: ThemeConstants.height10,
                  ),
                  // Request builder...........
                  // buildRequestBuilder(context),
                  SizedBox(
                    height: ThemeConstants.height10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => projectsController.projectsTotalCount.value ==
                                    0 ||
                                projectsController.isLoading.value
                            ? SizedBox.shrink()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${projectsController.projectsTotalCount.value.toString()} Projects",
                                  style: Styles.hint1Styles,
                                ),
                              ),
                      ),
                      // TextButton(
                      //   child: Text(
                      //     '+ Request Project',
                      //     style: Styles.link2Styles,
                      //   ),
                      //   onPressed: () {
                      //     projectsController.builderController.text = '';
                      //     projectsController.selectedBuilder.value = '';
                      //     openAddBuilderBottomSheet(context);
                      //   },
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: ThemeConstants.height10,
                  ),
                  Obx(() => projectsController.isLoading.value
                      ? Container(
                          height: Get.height * 0.5, child: showCustomLoader())
                      : Obx(() => projectsController.projectsList.isNotEmpty
                          ? Expanded(
                              flex: 11,
                              child: SingleChildScrollView(
                                controller: projectsController.scrollController,
                                child: Column(
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: projectsController
                                            .projectsList.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                  onTap: () {},
                                                  child: ProjectCardWidget(
                                                    item: projectsController
                                                        .projectsList[index],
                                                    presssedOnRefer: () {
                                                      print(
                                                          "refer called ${AppConstants.baseUrl}");
                                                      // print(
                                                      //     'object123 ${AppConstants.baseUrl == "https://api.realtor.works//"}');
                                                      Get.delete<
                                                              ReferController>(
                                                          force: true);
                                                      Get.toNamed(
                                                          Routes.referComponent,
                                                          arguments: {
                                                            "projectId":
                                                                projectsController
                                                                            .projectsList[
                                                                        index][
                                                                    "projectId"],
                                                            "projectUrl":
                                                                "${AppConstants.referUrl}projectDetails?id=${projectsController.projectsList[index]["projectId"]}"
                                                          });
                                                    },
                                                    pressedOnRequest: () {
                                                      projectsController
                                                          .builderController
                                                          .text = '';
                                                      projectsController
                                                          .selectedBuilder
                                                          .value = '';
                                                      projectsController
                                                          .requestToBuilder(
                                                              projectsController
                                                                          .projectsList[
                                                                      index][
                                                                  'builderId']);
                                                      //  openAddBuilderBottomSheet(context);
                                                    },
                                                  )),
                                            ],
                                          );
                                        }),
                                    Obx(() => projectsController
                                            .isInfiniteLoading.value
                                        ? showCustomLoader()
                                        : SizedBox.shrink()),
                                    SizedBox(
                                      height: ThemeConstants.height100,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              height: Get.height * 0.7,
                              child: Center(
                                child: Text(
                                    "No Projects Found. Click the '+' button below to Create a New Project."), //
                              ))))
                ],
              ),
            ),
          )),
    );
  }

  buildRequestBuilder(context) {
    return InkWell(
      onTap: () {
        projectsController.builderController.text = '';
        projectsController.selectedBuilder.value = '';
        openAddBuilderBottomSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 30,
          //  width: Get.width,
          decoration: BoxDecoration(
              //  border: Border.all(color: ThemeConstants.primaryColor),
              //  color: const Color.fromARGB(177, 223, 202, 252),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    'Request builder',
                    style: Styles.link1Styles,
                    maxLines: 2,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: ThemeConstants.primaryColor,
                  size: 16,
                  weight: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openAddBuilderBottomSheet(context) {
    return showCupertinoModalBottomSheet(
        useRootNavigator: true,
        //expand: true,
        topRadius: Radius.circular(30),
        context: context,
        builder: (context) =>
            Obx(() => projectsController.isLoading.value == true
                ? showCustomLoader()
                : Material(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.screenPadding,
                          vertical: ThemeConstants.screenPadding),
                      child: Column(
                        children: [
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Buider',
                                    style: Styles.labelStyles,
                                  ),
                                  Text(
                                    ' *',
                                    style: TextStyle(
                                        color: ThemeConstants.errorColor,
                                        decoration: TextDecoration.none,
                                        fontSize: ThemeConstants.fontSize14),
                                  )
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const LineIcon(
                                    Icons.close,
                                    color: ThemeConstants.greyColor,
                                    size: 23,
                                  ))
                            ],
                          ),

                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          buildSelectBuilder(),

                          // DropdownFormFieldWidget(
                          //   isValidationAlways: false,
                          //   hintText: 'Builder Id',
                          //   isRequired: true,
                          //   items: CommonService.instance.builders
                          //       .map<DropdownMenuItem>((item) {
                          //     return DropdownMenuItem(
                          //         value: item['builderId'], //builderId
                          //         child: Padding(
                          //           padding: EdgeInsets.only(left: 0, right: 0),
                          //           child: item['registeredOfcAddress'] != null
                          //               ? Text(
                          //                   item['registeredName'] +
                          //                       ' ,' +
                          //                       item['registeredOfcAddress']
                          //                           .toString() +
                          //                       '',
                          //                   style: Styles.labelStyles,
                          //                 )
                          //               : Text(
                          //                   item['registeredName'],
                          //                   style: Styles.labelStyles,
                          //                 ),
                          //         ));
                          //   }).toList(),
                          //   selectedValue:
                          //       projectsController.selectedBuilder.value != ''
                          //           ? projectsController.selectedBuilder.value
                          //           : null,
                          //   onChange: (value) {
                          //     print("onChange : $value");
                          //     projectsController.selectedBuilder.value = value;
                          //     // leadsListingController
                          //     //         .selectedProjectId.value =
                          //     //     leadsListingController
                          //     //         .getIdFromName(value);
                          //   },
                          // ),

                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          // buildLabel('User Role'),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          SizedBox(
                            height: ThemeConstants.height100,
                          ),
                          RoundedFilledButtonWidget(
                              buttonName: 'Send Request',
                              onPressed: () {
                                projectsController.requestToBuilder(
                                    projectsController.selectedBuilder.value);
                              })
                        ],
                      ),
                    ),
                  )));
  }

  buildSelectBuilder() {
    print('Buiders... ${CommonService.instance.builders}');
    return TypeAheadField(
      controller: projectsController.builderController,
      builder: (context, controller, focusNode) => TextFormField(
        controller: controller,
        focusNode: focusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        validator: (value) {
          if (projectsController.builderController.text == '') {
            return 'Builder is required';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          suffixIcon: Icon(Icons.arrow_drop_down),
          fillColor: ThemeConstants.whiteColor,
          hintText: "Select Builder",
          hintStyle: Styles.hintStyles,
          contentPadding: EdgeInsets.all(
              Get.height * ThemeConstants.textFieldContentPadding),
        ),
      ),
      decorationBuilder: (context, child) => Material(
        type: MaterialType.card,
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: child,
      ),
      itemBuilder: (context, builder) => ListTile(
        title: builder['registeredOfcAddress'] != null
            ? Text(builder["registeredName"] +
                ' ' +
                builder['registeredOfcAddress'].toString() +
                '')
            : Text(builder["registeredName"]),
      ),
      onSelected: (v) {
        print("builderId: ${v["builderId"]}");
        projectsController.selectedBuilder.value = v["builderId"];
        projectsController.builderController.text = v["registeredName"];
        // createProjectController.getProjectsByBuilderId(v["builderId"]);
      },
      suggestionsCallback: suggestionsCallback,
      itemSeparatorBuilder: itemSeparatorBuilder,
    );
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Divider(height: 1);

  Future<List<dynamic>> suggestionsCallback(String pattern) async {
    print('patternnnnnn $pattern');

    return Future.delayed(
      const Duration(seconds: 2),
      () => CommonService.instance.builders.where((b) {
        final nameLower = b["registeredName"].toLowerCase().split(' ').join('');
        final patternLower = pattern.toLowerCase().split(' ').join('');
        return nameLower.contains(patternLower);
      }).toList(),
    );
  }

  static logout() async {
    await Get.dialog(AppCupertinoDialog(
      title: 'Exit'.tr,
      subTitle: 'Are you sure you want to exit app?',
      isOkBtn: false,
      acceptText: 'Yes'.tr,
      cancelText: 'No'.tr,
      onAccepted: () async {
        exit(0);
        // CommonService.confirmLogout();
      },
      onCanceled: () {
        Get.back();
      },
    ));
  }

  buildSearchBox() {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          side: const BorderSide(
            color: Colors.black12,
            width: 1.0,
          )),
      child: TextFormField(
        onChanged: (v) {
          print("onChanged: $v");
          if (v.length >= 1) {
            projectsController.getProjectsBySearchValue();
          } else if (v.isEmpty) {
            projectsController.getAllProjects();
          }
        },
        cursorColor: ThemeConstants.primaryColor,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: 100,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: ThemeConstants.fontSize12,
        ),
        controller: projectsController.searchController,
        decoration: InputDecoration(
          counterText: '',
          fillColor: Colors.white,
          filled: true,
          hintText: "Search",
          prefixIcon: LineIcon(
            Icons.search,
            size: 20,
            color: ThemeConstants.greyColor,
          ),
          suffixIcon: InkWell(
            onTap: () {
              projectsController.searchController.text = "";
              projectsController.getAllProjects();
            },
            child: LineIcon(
              Icons.close,
              size: 20,
              color: ThemeConstants.greyColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          hintStyle: Styles.hintStyles,
          contentPadding: EdgeInsets.all(
              Get.height * ThemeConstants.textFieldContentPadding),
          isDense: true,
          errorStyle: TextStyle(
            fontFamily: ThemeConstants.fontFamily,
            color: ThemeConstants.errorColor,
            fontSize: ThemeConstants.fontSize10,
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
        ),
      ),
    );
  }

  Widget showCustomLoader() {
    return Center(
        child: CircularProgressIndicator(color: ThemeConstants.primaryColor)
        //Image.asset(ImageConstants.loader)

        );
  }
}

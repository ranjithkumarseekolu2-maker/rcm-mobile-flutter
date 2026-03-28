import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/lead_card_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/commons/widgets/search_box_widget.dart';
import 'package:brickbuddy/commons/widgets/text_area_widget.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/components/bottomsheet/modals/modal_with_scroll.dart';
import 'package:brickbuddy/components/bottomsheet/web_frame.dart';
import 'package:badges/badges.dart' as badges;
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/leads/filter_leads_component2.dart';
import 'package:brickbuddy/components/leads/filter_leads_controller.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

class LeadListingComponent extends StatefulWidget {
  LeadsListingController leadsListingController =
      Get.put(LeadsListingController());
  @override
  State<LeadListingComponent> createState() =>
      _ModalBottomSheetComponentState();
}

class _ModalBottomSheetComponentState extends State<LeadListingComponent> {
  TextEditingController myController = TextEditingController();
  LeadsListingController leadsListingController = Get.find();
  AppConstants appConstants = AppConstants();
  dynamic item;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("onWill pop scope calle");
        //  logout();
        return false;
      },
      child: Scaffold(
        backgroundColor: ThemeConstants.appBackgroundColor,
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: ThemeConstants.primaryColor,
          title: Text('Leads', style: TextStyle(color: Colors.white)),
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
        floatingActionButton: Obx(() => leadsListingController
                .isLeadsLoading.value
            ? SizedBox.shrink()
            : FloatingActionButton(
                backgroundColor: ThemeConstants.primaryColor,
                child: Icon(
                  Icons.add,
                  color: ThemeConstants.whiteColor,
                ),
                onPressed: () {
                  leadsListingController.clearData();
                  leadsListingController.getAllProjects();
                  leadsListingController.getAllBuilders();
                  showCupertinoModalBottomSheet(
                      useRootNavigator: true,
                      //expand: true,
                      topRadius: Radius.circular(30),
                      context: context,
                      builder: (context) => Obx(() => LoadingOverlay(
                            opacity: 1,
                            color: Colors.black54,
                            progressIndicator: const SpinKitCircle(
                              color: ThemeConstants.whiteColor,
                              size: 50.0,
                            ),
                            isLoading:
                                leadsListingController.isLeadsLoading.value,
                            child: SingleChildScrollView(
                              child: Material(
                                  child: Form(
                                      key:
                                          leadsListingController.addLeadFormKey,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ThemeConstants.screenPadding,
                                            vertical:
                                                ThemeConstants.screenPadding),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Add lead',
                                                  style: Styles.headingStyles,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: const LineIcon(
                                                      Icons.close,
                                                      color: ThemeConstants
                                                          .greyColor,
                                                      size: 23,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            buildLabel('Builder', true),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            buildSelectBuilder(),

                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),

                                            buildLabel('Project', true),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            leadsListingController
                                                    .isLeadsLoading.value
                                                ? leadsListingController
                                                            .selectedProjectContrller
                                                            .text !=
                                                        ''
                                                    ? customLoader(
                                                        leadsListingController
                                                            .selectedProjectContrller
                                                            .text)
                                                    : customLoader(
                                                        'Select Project')
                                                : buildSelectProject(),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),

                                            buildLabel('First Name', true),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            TextBoxWidget(
                                              isRequired: true,
                                              label: 'First Name',
                                              controller: leadsListingController
                                                  .firstNameContrller,
                                              hintText: 'First Name',
                                            ),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            buildLabel(
                                                'Primary Contact Number', true),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            MobileNumberWidget(
                                              // label: 'Primary contact Number',
                                              isRequired: true,
                                              controller: leadsListingController
                                                  .primaryContactContrller,
                                              hintText:
                                                  'Primary Contact Number',
                                            ),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            buildLabel('Email', false),
                                            SizedBox(
                                              height: ThemeConstants.height10,
                                            ),
                                            TextBoxWidget(
                                              label: 'Email',
                                              isRequired: false,
                                              controller: leadsListingController
                                                  .emailContrller,
                                              hintText: 'Email',
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
                                              buttonName: 'Save',
                                              onPressed: () {
                                                print('hhhhhhhhhhh');
                                                print(
                                                    'hello123456 ${leadsListingController.selectedBuilderContrller.text}');

                                                if (leadsListingController
                                                    .addLeadFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  leadsListingController.createLead(
                                                      leadsListingController
                                                          .firstNameContrller
                                                          .text,
                                                      leadsListingController
                                                          .primaryContactContrller
                                                          .text,
                                                      leadsListingController
                                                          .selectedProjectId
                                                          .value,
                                                      leadsListingController
                                                          .emailContrller.text,
                                                      leadsListingController
                                                          .selectedProjBilderId,
                                                      leadsListingController
                                                          .selectedProjMarketingAgencyId);
                                                }
                                              },
                                            ),
                                            SizedBox(
                                              height: ThemeConstants.height100,
                                            ),

                                            SizedBox(
                                              height: ThemeConstants.height100,
                                            ),
                                          ],
                                        ),
                                      ))),
                            ),
                          )));
                })),
        bottomNavigationBar: const BottombarWidget(),
        body: buildBody(),
      ),
    );
  }

  buildSelectBuilder() {
    return TypeAheadField(
      controller: leadsListingController.selectedBuilderContrller,
      builder: (context, controller, focusNode) => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        focusNode: focusNode,
        autofocus: false,
        validator: (value) {
          if (leadsListingController.selectedBuilderContrller.text == '') {
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
          suffixIcon: leadsListingController.selectedDropdownBuilder.value ==
                      '' ||
                  leadsListingController.selectedDropdownBuilder.value.isEmpty
              ? Icon(Icons.arrow_drop_down)
              : IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () async {
                    leadsListingController.selectedBuilderContrller.text = ' ';

                    //homeController.builderNameController.clear();
                    // CommonService.instance.builders.clear();
                    leadsListingController.selectedDropdownBuilder.value = '';
                    leadsListingController.selectedDropdownProject.value = '';
                    leadsListingController.selectedProjectContrller.text = '';
                    leadsListingController.selectedProjectId.value = '';
                    leadsListingController.getAllProjects();
                  }),

          filled: true,
          fillColor: ThemeConstants.whiteColor,
          hintText: "Select Builder",
          // suffixIcon: Icon(Icons.arrow_drop_down),
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
        title: Text(builder["name"]),
      ),
      onSelected: (v) async {
        print("builderId: ${v["id"]}");

        leadsListingController.selectedDropdownBuilder.value = v["id"];
        leadsListingController.selectedBuilderContrller.text = v["name"];
        leadsListingController.selectedProjectContrller.text = '';
        leadsListingController.selectedProjectId.value = '';
        await leadsListingController.getProjectsByBuilderId(v["id"]);
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
      () => CommonService.instance.buildersList.where((b) {
        final nameLower = b["name"].toLowerCase().split(' ').join('');
        final patternLower = pattern.toLowerCase().split(' ').join('');
        return nameLower.contains(patternLower);
      }).toList(),
    );
  }

  buildSelectProject() {
    return TypeAheadField(
      controller: leadsListingController.selectedProjectContrller,
      builder: (context, controller, focusNode) => TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        autofocus: false,
        validator: (value) {
          if (leadsListingController.selectedProjectContrller.text == '' ||
              leadsListingController.selectedProjectContrller.text.isEmpty) {
            return 'Project is required';
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
          suffixIcon: Obx(() =>
              leadsListingController.selectedDropdownProject.value == '' ||
                      leadsListingController
                          .selectedDropdownProject.value.isEmpty ||
                      leadsListingController
                          .selectedProjectContrller.text.isEmpty ||
                      leadsListingController.selectedProjectContrller.text == ''
                  ? Icon(Icons.arrow_drop_down)
                  : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () async {
                        leadsListingController.selectedProjectContrller.text =
                            ' ';

                        //homeController.builderNameController.clear();
                        // CommonService.instance.builders.clear();
                        // leadsListingController.selectedDropdownBuilder.value = '';
                        leadsListingController.selectedDropdownProject.value =
                            '';
                        leadsListingController.selectedProjectId.value = '';
                      })),

          filled: true,
          fillColor: ThemeConstants.whiteColor,
          hintText: "Select Project",
          // suffixIcon: Icon(Icons.arrow_drop_down),
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
        title: Text(builder["name"]),
      ),
      onSelected: (v) {
        //  print("builderId: ${v["builderId"]}");

        leadsListingController.selectedDropdownProject.value = v["id"];
        leadsListingController.selectedProjectContrller.text = v["name"];
        leadsListingController.selectedProjectId.value = v["id"];

        // leadsListingController.getProjectsByBuilderId(v["id"]);
      },
      suggestionsCallback: suggestionsCallbackForProject,
      itemSeparatorBuilder: itemSeparatorForProject,
    );
  }

  Widget itemSeparatorForProject(BuildContext context, int index) =>
      const Divider(height: 1);

  Future<List<dynamic>> suggestionsCallbackForProject(String pattern) async {
    print('patternnnnnn $pattern');

    return Future.delayed(
      const Duration(seconds: 2),
      () => CommonService.instance.projectsNamesList.where((b) {
        final nameLower = b["name"].toLowerCase().split(' ').join('');
        final patternLower = pattern.toLowerCase().split(' ').join('');
        return nameLower.contains(patternLower);
      }).toList(),
    );
  }

  buildLabel(label, isMandatory) {
    return Row(
      children: [
        Text(
          label,
          style: Styles.labelStyles,
        ),
        isMandatory == true
            ? Text(
                ' *',
                style: TextStyle(
                    color: ThemeConstants.errorColor,
                    decoration: TextDecoration.none,
                    fontSize: ThemeConstants.fontSize14),
              )
            : SizedBox.shrink()
      ],
    );
  }

  Widget buildBody() {
    return Obx(() {
      return Container(
        color: ThemeConstants.appBackgroundColor,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ThemeConstants.height10),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 310, child: buildSearchBox()),
                            buildFilterBadge(),
                          ],
                        ),
                        SizedBox(height: ThemeConstants.height10),
                        if (leadsListingController.leadsTotalCount.value > 0 &&
                            !leadsListingController.isLeadsLoading.value)
                          Text(
                            "${leadsListingController.leadsTotalCount.value} leads",
                            style: Styles.hint1Styles,
                          ),
                        SizedBox(height: ThemeConstants.height10),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ThemeConstants.height10),
                buildLeadsSection(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildFilterBadge() {
    return Obx(() {
      return badges.Badge(
        position: badges.BadgePosition.topEnd(top: 0, end: 0),
        badgeAnimation: badges.BadgeAnimation.slide(),
        showBadge: leadsListingController.selectedStatuesCount.value > 0,
        badgeStyle: badges.BadgeStyle(
          badgeColor: ThemeConstants.primaryColor,
        ),
        badgeContent: Text(
          leadsListingController.selectedStatuesCount.value.toString(),
          style: Styles.whiteSubHeadingStyles4,
        ),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeConstants.greyColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            onPressed: () {
              Get.delete<FilterLeadsController>(force: true);
              Get.to(FilterLeadsComponent());
            },
            icon: Icon(LineIcons.filter,
                color: ThemeConstants.iconColor, size: 20),
          ),
        ),
      );
    });
  }

  Widget buildLeadsSection() {
    return Obx(() {
      if (leadsListingController.isLeadsLoading.value) {
        return Container(height: Get.height * 0.5, child: showCustomLoader());
      }

      if (leadsListingController.leadsList.isNotEmpty) {
        return SizedBox(
          height: Get.height * 0.7,
          child: SingleChildScrollView(
            controller: leadsListingController.scrollController,
            child: buildLeads(),
          ),
        );
      }

      return Container(
        height: Get.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 200.0),
            child: Text(
                "No Leads Found. Click the '+' button below to Create a New Lead."),
          ),
        ),
      );
    });
  }

  buildLeads() {
    // print('object123 ${leadsListingController.leadsList.isEmpty}');
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: leadsListingController.leadsList.length,
            itemBuilder: (BuildContext ctx, index) {
              return Obx(() => Column(
                    children: [
                      InkWell(
                          onTap: () {},
                          child: LeadCardWidget(
                            item: leadsListingController.leadsList[index],
                            onPressedOnPhoneNumber: () {
                              leadsListingController.makePhoneCall(
                                  leadsListingController.leadsList[index]
                                      ['contacts']['PRIMARY_NUMBER']);
                            },
                            onPressedOnWhatsapp: () {
                              leadsListingController
                                  .launchWhatsappWithMobileNumber(
                                      leadsListingController.leadsList[index]
                                          ['contacts']['PRIMARY_NUMBER']);
                            },
                            onPressed: () {
                              leadsListingController.getLeadDetails(
                                  leadsListingController.leadsList[index]
                                      ['contactJobMappingId']);
                              openModalBottomSheet(context,
                                  leadsListingController.leadsList[index]);
                            },
                          )),
                    ],
                  ));
            }),
        Obx(() => leadsListingController.isInfiniteLoading.value
            ? showCustomLoader()
            : SizedBox.shrink()),
        SizedBox(
          height: ThemeConstants.height100,
        )
      ],
    );
  }

  buildSearchBox() {
    return SearchBoxWidget(
        hintText: 'Search',
        controller: leadsListingController.searchController,
        maxLength: 50,
        onClose: () {
          if (leadsListingController.selectedFilteredStatus.value != '' ||
              leadsListingController.selectedFileteredProjectId.value != '' ||
              leadsListingController.selectedFilteredActivity.value != '' ||
              leadsListingController.selectedBuilderId.value != '') {
            leadsListingController.searchController.text = '';
            leadsListingController.pageOffset.value = 0;
            CommonService.instance.filterPageOffset.value = 0;
            leadsListingController.getFilteredLeads(
                leadsListingController.selectedFilteredStatus.value,
                leadsListingController.selectedFileteredProjectId.value,
                leadsListingController.selectedFilteredActivity.value,
                leadsListingController.selectedBuilderId.value);
          } else {
            leadsListingController.searchController.text = '';
            leadsListingController.pageOffset.value = 0;
            leadsListingController.getAllLeads();
          }
        },
        onChanged: (v) {
          if (v!.length >= 1) {
            leadsListingController.leadsList.clear();
            leadsListingController.searchLead();
          } else if (v.isEmpty) {
            leadsListingController.getAllLeads();
          }
          // for (var names in leadsListingController.allLeadsList) {
          //   var leadName = names['contacts']['FIRST_NAME'];

          //   if (leadName.toLowerCase().contains(v.toString().toLowerCase())) {
          //     leadsListingController.leadsList.add(names);
          //   }
          // }
        },
        readOnly: false);
  }

  buildColorIndicationContainers() {
    return Row(children: [
      Expanded(
        flex: 4,
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
            SizedBox(width: ThemeConstants.width8),
            Text(
              'New Lead',
              style: TextStyle(fontSize: ThemeConstants.fontSize11),
            ),
          ],
        ),
      ),
      SizedBox(width: ThemeConstants.width12),
      Expanded(
        flex: 4,
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
                //  border: Border.all(width: 2, color: Colors.green),
              ),
            ),
            SizedBox(width: ThemeConstants.width8),
            Text(
              'Existing',
              style: TextStyle(fontSize: ThemeConstants.fontSize11),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 4,
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
            ),
            SizedBox(width: ThemeConstants.width8),
            Text(
              'Cold Lead',
              style: TextStyle(fontSize: ThemeConstants.fontSize11),
            ),
          ],
        ),
      ),
      SizedBox(width: ThemeConstants.width12),
      Expanded(
        flex: 4,
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                //  border: Border.all(width: 2, color: Colors.green),
              ),
            ),
            SizedBox(width: ThemeConstants.width8),
            Text(
              'Duplicate',
              style: TextStyle(fontSize: ThemeConstants.fontSize11),
            ),
          ],
        ),
      ),
    ]);
  }

  openModalBottomSheet(context, item) {
    leadsListingController.selectedStatus.value = item['agentStatus'];

    //  print('iiiiiii ${item['agentStatus']}');
    leadsListingController.descriptionController.clear();
    return showCupertinoModalBottomSheet(
        //expand: true,
        topRadius: Radius.circular(30),
        context: context,
        builder: (context) => Form(
              key: leadsListingController.leadFormKey,
              child: Obx(
                () => leadsListingController.isLeadsLoading.value
                    ? showCustomLoader()
                    : Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: ThemeConstants.screenPadding),
                          child: Scaffold(
                            backgroundColor: ThemeConstants.appBackgroundColor,
                            body: SingleChildScrollView(
                                child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text(
                                                      'Lead Details',
                                                      style: TextStyle(
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w900),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: ThemeConstants
                                                            .primaryColor,
                                                        size: 25,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ]),
                                              const Divider(
                                                thickness: 1,
                                                color: Color.fromARGB(
                                                    255, 184, 183, 183),
                                              ),
                                              const Text(
                                                'Profile',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      flex: 4,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      223,
                                                                      142,
                                                                      0.6),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            width: 50,
                                                            height: 50,
                                                            // color:Color.fromRGBO(255, 223, 142, 0.6)
                                                            child: Center(
                                                                child: Icon(
                                                              Icons
                                                                  .person_2_outlined,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                ThemeConstants
                                                                    .width20,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Name',
                                                                  style: Styles
                                                                      .greyLabelBoldStyles,
                                                                ),
                                                                item['contacts']
                                                                            [
                                                                            'LAST_NAME'] !=
                                                                        ''
                                                                    ? Text(
                                                                        item['contacts']['FIRST_NAME'] +
                                                                            ' ' +
                                                                            item['contacts']
                                                                                [
                                                                                'LAST_NAME'],
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .visible,
                                                                        style: Styles
                                                                            .label4Styles)
                                                                    : Text(
                                                                        item['contacts']['FIRST_NAME'] ??
                                                                            '',
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .visible,
                                                                        style: Styles
                                                                            .label4Styles),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    width:
                                                        ThemeConstants.width10,
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Row(children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromRGBO(145,
                                                              255, 227, 0.6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        width: 50, height: 50,
                                                        // color:Color.fromRGBO(255, 223, 142, 0.6)
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.phone_in_talk,
                                                          color: Colors.black,
                                                        )),
                                                      ),
                                                      SizedBox(
                                                        width: ThemeConstants
                                                            .width20,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Phone',
                                                            style: Styles
                                                                .greyLabelBoldStyles,
                                                          ),
                                                          Text(
                                                              '${toBeginningOfSentenceCase(item['contacts']['PRIMARY_NUMBER'])}',
                                                              style: Styles
                                                                  .label4Styles)
                                                        ],
                                                      )
                                                    ]),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        211, 208, 231, 0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  width: 50, height: 50,
                                                  // color:Color.fromRGBO(255, 223, 142, 0.6)
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.business,
                                                    color: Colors.black,
                                                  )),
                                                ),
                                                SizedBox(
                                                  width: ThemeConstants.width20,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Project Name',
                                                      style: Styles
                                                          .greyLabelBoldStyles,
                                                    ),
                                                    Text(
                                                        '${toBeginningOfSentenceCase(item['project']['PROJECT_NAME'])}',
                                                        style: Styles
                                                            .label4Styles),
                                                  ],
                                                ),
                                              ]),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color: const Color.fromARGB(
                                                    255, 184, 183, 183),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              // Status Timeline indicator...............
                                              buildTimeLineIndicator(context),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color: const Color.fromARGB(
                                                    255, 184, 183, 183),
                                              ),
                                              Text(
                                                'Update',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Lead Status', // Heading text
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "OpenSans",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ThemeConstants
                                                            .greyColor),
                                                  ),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    '*',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: 220.0,
                                                height: 50.0,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: ThemeConstants
                                                      .primaryColor10,
                                                ),
                                                child: DropdownButtonFormField<
                                                    String>(
                                                  value: leadsListingController
                                                      .selectedStatus.value,
                                                  onChanged:
                                                      (String? newValue) {
                                                    if (newValue != null) {
                                                      setState(() {
                                                        leadsListingController
                                                            .selectedStatus
                                                            .value = newValue;
                                                      });
                                                    }
                                                  },
                                                  items: AppConstants.statuses
                                                      .map((String option) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: option,
                                                      child: Text(
                                                        option,
                                                        style: TextStyle(
                                                            color: ThemeConstants
                                                                .primaryColor),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: '10 members',
                                                    hintStyle: TextStyle(
                                                        color: Colors.white),
                                                    enabledBorder:
                                                        InputBorder.none,
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  icon: Icon(
                                                      Icons.arrow_drop_down,
                                                      color: ThemeConstants
                                                          .primaryColor),
                                                  dropdownColor:
                                                      ThemeConstants.whiteColor,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      'Description', // Heading text
                                                      style: Styles
                                                          .greyLabelBoldStyles),
                                                  SizedBox(
                                                    width: 2,
                                                  ),
                                                  Text(
                                                    '*',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextAreaWidget(
                                                isRequired: true,
                                                label: 'Description',
                                                controller:
                                                    leadsListingController
                                                        .descriptionController,
                                                hintText: 'Enter description',
                                              ),
                                              SizedBox(
                                                height: ThemeConstants.height19,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  RoundedOutlineButtonWidget(
                                                      btnRadius: 10,
                                                      buttonName: 'Cancel',
                                                      onPressed: () {
                                                        // Get.close(0);
                                                        Navigator.pop(context);
                                                      }),
                                                  RoundedFilledButtonWidget(
                                                    buttonName: 'Save',
                                                    isLargeBtn: false,
                                                    onPressed: () async {
                                                      if (leadsListingController
                                                          .leadFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        await leadsListingController.save(
                                                            item[
                                                                'contactJobMappingId'],
                                                            leadsListingController
                                                                .descriptionController
                                                                .text,
                                                            leadsListingController
                                                                .selectedStatus
                                                                .value);
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    //   isLargeBtn: false,
                                                  ),
                                                ],
                                              ),
                                            ])))),
                          ),
                        ),
                      ),
              ),
            ));
  }

  buildTimeLineIndicator(BuildContext context) {
    print('llllllllen ${leadsListingController.leadDetailsStatusesList}');
    print('datee..  ${DateFormat('hh:mm a').format(DateTime.now())}');

    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: leadsListingController.leadDetailsStatusesList.length,
      itemBuilder: (context, index) {
        // var s = leadsListingController.leadDetailsStatusesList[index]
        //         ['createdAt']
        //     .replaceAll('Z', '');
        // var k = s.replaceAll('T', ' ');

        // print(
        //     'ddd $k ${DateTime.parse(leadsListingController.leadDetailsStatusesList[index]['createdAt'])}');
        // print(DateTime.now());
        // print('.... ${DateFormat('hh:mm a').format(DateTime.now())}');
        // print('.... ${DateFormat('hh:mm a').format(DateTime.parse(k))}');
        print(
            'dateTime ${leadsListingController.leadDetailsStatusesList[index]['currentStatus']} ${DateFormat.yMEd().add_jms().format(DateTime.parse(leadsListingController.leadDetailsStatusesList[index]['createdAt']))}');
        print(
            'time.. ${leadsListingController.leadDetailsStatusesList[index]['currentStatus']} ${DateFormat('hh:mm a').format(DateTime.parse(leadsListingController.leadDetailsStatusesList[index]['createdAt']))}');
        return TimelineTile(
          beforeLineStyle: LineStyle(
            color: ThemeConstants.primaryColor,
            thickness: 6,
          ),
          indicatorStyle: IndicatorStyle(
              height: 25,
              width: 30,
              indicator: Container(
                //padding: const EdgeInsets.only(3),
                decoration: BoxDecoration(
                  color: ThemeConstants.primaryColor,
                  shape: BoxShape.circle,
                ),
              )),
          endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 70,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    leadsListingController
                                            .leadDetailsStatusesList[index]
                                        ['currentStatus'],
                                    style: Styles.label4Styles),
                                SizedBox(
                                  width: ThemeConstants.width4,
                                ),
                                Text(
                                  DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(leadsListingController
                                              .leadDetailsStatusesList[index]
                                          ['createdAt'])),
                                  style: Styles.greyLabelStyles3,
                                ),
                              ],
                            ),
                            leadsListingController
                                            .leadDetailsStatusesList[index]
                                        ['description'] !=
                                    null
                                ? SizedBox(
                                    height: ThemeConstants.height2,
                                  )
                                : const SizedBox.shrink(),
                            leadsListingController
                                            .leadDetailsStatusesList[index]
                                        ['description'] !=
                                    null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: ThemeConstants.primaryColor10,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                          leadsListingController
                                                  .leadDetailsStatusesList[
                                              index]['description'],
                                          style: Styles.label5Styles),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

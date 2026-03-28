import 'dart:convert';
import 'dart:io';
import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/commons/widgets/text_box_with_prefixEye.dart';
import 'package:brickbuddy/components/profile/profile_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/city.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../routes/app_pages.dart';

class ProfileComponent extends StatefulWidget {
  ProfileController profileController = Get.put(ProfileController());

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent>
    with SingleTickerProviderStateMixin {
  ProfileController profileController = Get.find();

  late TabController _tabController;

  RxInt _activeIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
    );
    _tabController.addListener(() {
      _activeIndex.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Profile'),
    Tab(text: 'KYC'),
    Tab(text: 'Setting'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: ThemeConstants.whiteColor),
                onPressed: () {
                  print("Back button pressed");
                  bool isAadharUploaded =
                      profileController.adharFilesList.isNotEmpty &&
                          profileController.isAadhar.value;
                  bool isPanUploaded =
                      profileController.panFilesList.isNotEmpty &&
                          profileController.isPan.value;
                  bool isReraUploaded =
                      profileController.reraFilesList.isNotEmpty &&
                          profileController.isRera.value;

                  // Check if any required document is missing
                  if (isAadharUploaded || isPanUploaded || isReraUploaded) {
                    print("Snackbar should appear");
                    Get.rawSnackbar(
                      message: "Please upload image before going back",
                    );

                    return; // Prevents going back
                  }

                  print("Navigating to menu screen");
                  Get.toNamed(Routes.menuScreen);
                },
              ),
              centerTitle: false,
              title: Text(
                'Profile',
                style: TextStyle(color: ThemeConstants.whiteColor),
              ),
              backgroundColor: ThemeConstants.primaryColor,
            ),
            floatingActionButton: Obx(() => Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, right: 10, bottom: 20),
                  child: _activeIndex.value == 0 || _activeIndex.value == 2
                      ? RoundedFilledButtonWidget(
                          buttonName:
                              _activeIndex.value == 0 ? 'Update' : 'Save',
                          onPressed: () {
                            _activeIndex.value == 2
                                ? profileController.saveLeadAge(
                                    profileController.selectedAge.value)
                                : _activeIndex.value == 0
                                    ? profileController.updateProfile(
                                        profileController
                                            .firstNameController.text,
                                        profileController
                                            .lastNameController.text,
                                        profileController.emailController.text,
                                        profileController
                                            .passwordController.text,
                                        profileController
                                            .confirmPasswordController.text,
                                        profileController.image.value)
                                    : SizedBox();
                          },
                          isLargeBtn: true,
                        )
                      : const SizedBox.shrink(),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Form(
              key: profileController.profileFormKey,
              child: Column(
                children: [
                  TabBar(
                    indicatorWeight: 4.0,
                    indicatorColor: ThemeConstants.primaryColor,
                    controller: _tabController,
                    tabs: myTabs
                        .map<Widget>((myTab) => Tab(
                              child: Container(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${myTab.text}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      Obx(() => profileController.isLoading.value
                          ? showCustomLoader()
                          : profileInfo(context)),
                      kyc(),
                      settings(context)
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  kyc() {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          print("Back pressed");

          bool isAadharUploaded = profileController.adharFilesList.isNotEmpty &&
              profileController.isAadhar.value;
          bool isPanUploaded = profileController.panFilesList.isNotEmpty &&
              profileController.isPan.value;
          bool isReraUploaded = profileController.reraFilesList.isNotEmpty &&
              profileController.isRera.value;

          if (isAadharUploaded || isPanUploaded || isReraUploaded) {
            print("Snackbar should appear");
            Get.rawSnackbar(
              message: "Please upload image before going back",
            );

            return; // Prevents going back
          }

          print("Going back");
          Get.back();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.screenPadding,
                vertical: ThemeConstants.screenPadding),
            child: Column(
              children: [
                buildLabel('Adhaar Card', true),
                SizedBox(height: ThemeConstants.height20),
                buildAttachmentsAndBillsDottedBorder("ADHAR"),
                SizedBox(
                  height: ThemeConstants.height10,
                ),
                Obx(() => profileController.adharFilesList.isNotEmpty
                    ? buildAdharFiles()
                    : SizedBox.shrink()),
                SizedBox(height: ThemeConstants.height20),
                buildLabel('Pan Card', true),
                SizedBox(height: ThemeConstants.height20),
                buildAttachmentsAndBillsDottedBorder("PAN"),
                SizedBox(height: ThemeConstants.height20),
                Obx(() => profileController.panFilesList.isNotEmpty
                    ? buildPanFiles()
                    : SizedBox.shrink()),
                SizedBox(height: ThemeConstants.height20),
                buildLabel('RERA', true),
                SizedBox(height: ThemeConstants.height20),
                buildAttachmentsAndBillsDottedBorder("RERA"),
                Obx(() => profileController.reraFilesList.isNotEmpty
                    ? buildReraFiles()
                    : const SizedBox.shrink()),
                SizedBox(height: ThemeConstants.height20),
                SizedBox(height: ThemeConstants.height100),
              ],
            ),
          ),
        ));
  }

  buildAdharFiles() {
    return Column(
      children: [
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: profileController.adharFilesList.length,
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
                          profileController.adharFilesList[index].nAME!,
                          style: Styles.labelStyles,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: profileController.adharFilesList[index].fILEID !=
                                null
                            ? InkWell(
                                onTap: () {
                                  showBottomSheet(
                                      context,
                                      profileController
                                          .adharFilesList[index].fILEID);
                                },
                                child: Icon(
                                  LineIcons.pen,
                                  color: ThemeConstants.iconColor,
                                  size: 20,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ],
                  ),
                  leading: (profileController.adharFilesList[index].uRL!
                              .contains(".jpg") ||
                          profileController.adharFilesList[index].uRL!
                              .contains(".png"))
                      ? Image.network(
                          profileController.adharFilesList[index].uRL!,
                          width: 25,
                          height: 25,
                        )
                      : profileController.adharFilesList[index].path != null
                          ? (profileController.adharFilesList[index].path!
                                      .contains('.jpg') ||
                                  profileController.adharFilesList[index].path!
                                      .contains('.png'))
                              ? Image.file(
                                  File(profileController
                                      .adharFilesList[index].path!),
                                  width: 25,
                                  height: 25,
                                )
                              : LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                )
                          : LineIcon.file(
                              color: ThemeConstants.greyColor,
                            ),
                  onTap: () {},
                  trailing: profileController.isKycVerified.value == 0
                      ? InkWell(
                          onTap: () {
                            print(
                                'object000len ${jsonEncode(profileController.adharFilesList)}');

                            if (profileController
                                    .adharFilesList[index].fILEID !=
                                null) {
                              print(
                                  'aadharIf ${profileController.adharFilesList[index].fILEID}');
                              print(
                                  'aadharIf ${profileController.adharFilesList[index]}');
                              profileController.deleteDocument(
                                  profileController
                                      .adharFilesList[index].fILEID,
                                  "ADHAR");
                            } else {
                              //local delete
                              print('else..........adhar');
                              profileController.adharFilesList.remove(
                                  profileController.adharFilesList[index]);
                            }
                          },
                          child: Icon(
                            LineIcons.trash,
                            color: ThemeConstants.errorColor,
                            size: 20,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              );
            }),
        Obx(() => profileController.adharFilesList.isNotEmpty &&
                profileController.isAadhar.value
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
                    profileController.uploadKycDocuments("ADHAR");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildPanFiles() {
    return Column(
      children: [
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: profileController.panFilesList.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Padding(padding: EdgeInsets.all(6.0));
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
                          profileController.panFilesList[index].nAME!,
                          style: Styles.labelStyles,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            profileController.panFilesList[index].fILEID != null
                                ? InkWell(
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          profileController
                                              .panFilesList[index].fILEID);
                                    },
                                    child: Icon(
                                      LineIcons.pen,
                                      color: ThemeConstants.iconColor,
                                      size: 20,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  leading: (profileController.panFilesList[index].uRL!
                              .contains(".jpg") ||
                          profileController.panFilesList[index].uRL!
                              .contains(".png"))
                      ? Image.network(
                          profileController.panFilesList[index].uRL!,
                          width: 25,
                          height: 25,
                        )
                      : profileController.panFilesList[index].path != null
                          ? (profileController.panFilesList[index].path!
                                      .contains('.jpg') ||
                                  profileController.panFilesList[index].path!
                                      .contains('.png'))
                              ? Image.file(
                                  File(profileController
                                      .panFilesList[index].path!),
                                  width: 25,
                                  height: 25,
                                )
                              : const LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                )
                          : const LineIcon.file(
                              color: ThemeConstants.greyColor,
                            ),
                  onTap: () {},
                  trailing: profileController.isKycVerified.value == 0
                      ? InkWell(
                          onTap: () {
                            //DB delete
                            if (profileController.panFilesList[index].fILEID !=
                                null) {
                              profileController.deleteDocument(
                                  profileController.panFilesList[index].fILEID,
                                  "PAN");
                            } else {
                              profileController.panFilesList.remove(
                                  profileController.panFilesList[index]);
                            }
                          },
                          child: const Icon(
                            LineIcons.trash,
                            color: ThemeConstants.errorColor,
                            size: 20,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              );
            }),
        Obx(() => profileController.panFilesList.isNotEmpty &&
                profileController.isPan.value
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
                    profileController.uploadKycDocuments("PAN");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : const SizedBox.shrink()),
      ],
    );
  }

  buildReraFiles() {
    return Column(
      children: [
        ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: profileController.reraFilesList.length,
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
                          profileController.reraFilesList[index].nAME!,
                          style: Styles.labelStyles,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: profileController.reraFilesList[index].fILEID !=
                                null
                            ? InkWell(
                                onTap: () {
                                  showBottomSheet(
                                      context,
                                      profileController
                                          .reraFilesList[index].fILEID);
                                },
                                child: Icon(
                                  LineIcons.pen,
                                  color: ThemeConstants.iconColor,
                                  size: 20,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  leading: (profileController.reraFilesList[index].uRL!
                              .contains(".jpg") ||
                          profileController.reraFilesList[index].uRL!
                              .contains(".png"))
                      ? Image.network(
                          profileController.reraFilesList[index].uRL!,
                          width: 25,
                          height: 25,
                        )
                      : profileController.reraFilesList[index].path != null
                          ? (profileController.reraFilesList[index].path!
                                      .contains('.jpg') ||
                                  profileController.reraFilesList[index].path!
                                      .contains('.png'))
                              ? Image.file(
                                  File(profileController
                                      .reraFilesList[index].path!),
                                  width: 25,
                                  height: 25,
                                )
                              : const LineIcon.file(
                                  color: ThemeConstants.greyColor,
                                )
                          : const LineIcon.file(
                              color: ThemeConstants.greyColor,
                            ),
                  onTap: () {},
                  trailing: profileController.isKycVerified.value == 0
                      ? InkWell(
                          onTap: () {
                            //DB delete
                            print(
                                'URL123 ${profileController.reraFilesList[index].uRL}');
                            print(
                                'URL234 ${jsonEncode(profileController.reraFilesList)}');
                            print(
                                'URL234 ${profileController.reraFilesList.toJson()}');
                            print(
                                'URL345 ${profileController.reraFilesList[index].fILEID}');
                            if (profileController.reraFilesList[index].fILEID !=
                                null) {
                              profileController.deleteDocument(
                                  profileController.reraFilesList[index].fILEID,
                                  "RERA");
                            } else {
                              //local delete
                              profileController.reraFilesList.remove(
                                  profileController.reraFilesList[index]);
                            }
                          },
                          child: Icon(
                            LineIcons.trash,
                            color: ThemeConstants.errorColor,
                            size: 20,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              );
            }),
        Obx(() => profileController.reraFilesList.isNotEmpty &&
                profileController.isRera.value
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
                    profileController.uploadKycDocuments("RERA");
                  },
                  child: Text("Upload", style: Styles.small2BtnStyle),
                ))
            : SizedBox.shrink()),
      ],
    );
  }

  buildAttachBillsLabelName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'attachBills&SpareParts'.tr,
          style: TextStyle(
            fontSize: ThemeConstants.fontSize15,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '*',
          style: TextStyle(
              fontSize: ThemeConstants.fontSize20,
              fontFamily: 'Montserrat',
              color: Colors.red),
        )
      ],
    );
  }

  GestureDetector buildAttachmentsAndBillsDottedBorder(subType) {
    return GestureDetector(
      onTap: () {
        openDocumentModalBottomSheet(subType);
      },
      child: DottedBorder(
        dashPattern: [8, 4],
        strokeWidth: 2,
        color: ThemeConstants.greyColor,
        child: Container(
          height: ThemeConstants.height100,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 30,
                color: ThemeConstants.greyColor,
              ),
              SizedBox(width: Get.width * 0.05),
              Text(
                'Click here to upload'.tr,
                style: Styles.greyLabelStyles,
              ),
            ],
          ),
        ),
      ),
    );
  }

  settings(context) {
    return Obx(() => profileController.isLoading.value
        ? showCustomLoader()
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.screenPadding,
                vertical: ThemeConstants.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ThemeConstants.height10,
                ),
                buildLabel('Cold Lead Age', true),
                SizedBox(
                  height: ThemeConstants.height10,
                ),
                Obx(
                  () => DropdownFormFieldWidget(
                    hintText: 'Select Cold Lead Age'.tr,
                    isRequired: true,
                    selectedValue: profileController.selectedAge.value,
                    onChange: (value) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    items: AppConstants.leadAge
                        .map<DropdownMenuItem>((dynamic item) {
                      return DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: Text(
                              'Inactive:' + ' Last ' + '$item' + ' Days',
                              style: Styles.labelStyles,
                            ),
                          ),
                          onTap: () {
                            profileController.selectedAge.value = item;
                          },
                          value: item);
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: ThemeConstants.height100,
                )
              ],
            ),
          ));
  }

  profileInfo(context) {
    return Obx(() => LoadingOverlay(
        color: Colors.black54,
        opacity: 1,
        progressIndicator: const SpinKitCircle(
          color: ThemeConstants.whiteColor,
          size: 50.0,
        ),
        isLoading: profileController.isProfileLoading.value,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.screenPadding,
              vertical: ThemeConstants.screenPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [buildPersonInfo(context)],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      buildLabel('First Name', true),
                      SizedBox(
                        height: ThemeConstants.height5,
                      ),
                      TextBoxWidget(
                        controller:
                            widget.profileController.firstNameController,
                        hintText: 'First Name',
                        label: 'First Name',
                        isRequired: true,
                        maxLength: 100,
                        readOnly: false,
                        icon: Icon(
                          Icons.person,
                          color: ThemeConstants.greyColor,
                          size: 18,
                        ),
                      ),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildLabel('Last Name', true),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            Container(
                              child: TextBoxWidget(
                                controller:
                                    widget.profileController.lastNameController,
                                hintText: 'Last Name',
                                label: 'Last Name',
                                isRequired: true,
                                maxLength: 100,
                                readOnly: false,
                                icon: const Icon(
                                  Icons.person,
                                  color: ThemeConstants.greyColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildLabel('Mobile Number', true),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            Container(
                              child: TextBoxWidget(
                                controller: widget
                                    .profileController.mobileNumberController,
                                hintText: 'Mobile Number',
                                label: 'Mobile Number',
                                isRequired: true,
                                maxLength: 100,
                                readOnly: true,
                                icon: const Icon(
                                  Icons.call,
                                  color: ThemeConstants.greyColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildLabel('Email', false),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            Container(
                              child: TextBoxWidget(
                                controller: profileController.emailController,
                                hintText: 'Email',
                                isRequired: false,
                                maxLength: 100,
                                readOnly: false,
                                icon: const Icon(
                                  Icons.mail_outline_outlined,
                                  color: ThemeConstants.greyColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      buildLabel('Change Password', true),
                      SizedBox(
                        height: ThemeConstants.height5,
                      ),
                      buildRadioButtons(),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      profileController.radioVal.value == 1
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLabel('Password', true),
                                      SizedBox(
                                        height: ThemeConstants.height5,
                                      ),
                                      Container(
                                        width: Get.width / 2 - 20,
                                        child: TextBoxWidgetWithPrefixEyeIcon(
                                          controller: profileController
                                              .passwordController,
                                          hintText: 'Password',
                                          label: 'Password',
                                          isRequired: true,
                                          maxLength: 100,
                                          readOnly: false,
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: ThemeConstants.greyColor,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLabel('Confirm Password', true),
                                      SizedBox(
                                        height: ThemeConstants.height5,
                                      ),
                                      Container(
                                        width: Get.width / 2 - 20,
                                        child: TextBoxWidgetWithPrefixEyeIcon(
                                          controller: profileController
                                              .confirmPasswordController,
                                          hintText: 'Confirm Password',
                                          label: 'Confirm Password',
                                          isRequired: true,
                                          maxLength: 100,
                                          readOnly: false,
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color: ThemeConstants.greyColor,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(
                  height: ThemeConstants.height100,
                )
              ],
            ),
          ),
        )));
  }

  buildRadioButtons() {
    return Row(
      children: [
        Radio(
          value: 0,
          groupValue: profileController.radioVal.value,
          onChanged: (int? value) {
            if (value != null) {
              profileController.radioVal.value = value;
            }
          },
        ),
        const Text('No '),
        Radio(
          value: 1,
          groupValue: profileController.radioVal.value,
          onChanged: (int? value) {
            if (value != null) {
              profileController.radioVal.value = value;
            }
          },
        ),
        const Text('Yes '),
      ],
    );
  }

  buildLabel(label, isMandatory) {
    return Row(
      children: [
        Text(
          label,
          style: Styles.label3Styles,
        ),
        isMandatory
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

  buildPersonInfo(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      // SizedBox(height: ThemeConstants.height_0),
      Stack(
        children: [
          Obx(
            () => CommonService.instance.profileUrl.value != ''
                ? Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeConstants.primaryColor70,
                      border: Border.all(color: ThemeConstants.greyColor),
                      image: DecorationImage(
                          image: NetworkImage(
                              CommonService.instance.profileUrl.value)
                          // fit: BoxFit.cover,
                          ),
                    ))
                : Container(
                    width: 150,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      //  color: ThemeConstants.primaryColor70,
                      border: Border.all(color: ThemeConstants.greyColor),
                      image: DecorationImage(
                        image: AssetImage('assets/images/person.png'),
                        // fit: BoxFit.fill,
                      ),
                    )),
          ),
          buildPhotoSection(context),
        ],
      ),
    ]);
  }

  Positioned buildPhotoSection(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: -8,
      child: RawMaterialButton(
        onPressed: () {
          openModalBottomSheet();
        },
        elevation: 2.0,
        fillColor: ThemeConstants.primaryColor,
        child: Icon(
          Icons.camera_alt_outlined,
          color: ThemeConstants.whiteColor,
        ),
        padding: EdgeInsets.all(1.0),
        shape: CircleBorder(),
      ),
    );
  }

  openModalBottomSheet() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (context) => Container(
          height: Get.height * 0.2,
          decoration: BoxDecoration(
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
                  decoration: BoxDecoration(
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
                      Get.back();
                      profileController.takeProductImageFromCamera();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width8),
                        Text(
                          'Take a Photo'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: ThemeConstants.fontFamily),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height24,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      profileController.selectProductImageFromGallery();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width8),
                        Text(
                          'Choose Photo from Gallery'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: ThemeConstants.fontFamily),
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

  openDocumentModalBottomSheet(subType) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (context) => Container(
          height: Get.height * 0.2,
          decoration: BoxDecoration(
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
                  decoration: BoxDecoration(
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
                      Get.back();
                      profileController.takeDocumentImageFromCamera(subType);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width8),
                        Text(
                          'Take a photo'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: ThemeConstants.fontFamily),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height24,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      profileController.pickFile(subType);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width8),
                        const Text(
                          'Choose a File',
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: ThemeConstants.fontFamily),
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
                                          controller: profileController
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
                                          controller: profileController
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
                                          controller: profileController
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
                                        profileController.updateFile(
                                            fileId,
                                            profileController.isAadhar.value,
                                            profileController.isPan.value,
                                            profileController.isRera.value);
                                      })
                                ],
                              ))),
                    ]),
                  )),
            ));
  }
}

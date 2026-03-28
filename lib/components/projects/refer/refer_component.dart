import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:brickbuddy/commons/widgets/refer_card_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/components/projects/projects_component.dart';
import 'package:brickbuddy/components/projects/refer/refer_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:badges/badges.dart' as badges;
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ReferComponent extends StatelessWidget {
  ReferController referController = Get.put(ReferController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("onWill pop scope called");
        Get.toNamed(Routes.projects);
        return false;
      }, 
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: ThemeConstants.primaryColor,
              title: Text('Refer to...',
                  style: TextStyle(color: ThemeConstants.whiteColor)),
                  leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: ThemeConstants.whiteColor),
              onPressed: () {
                Get.delete<ReferController>(force: true);
                Get.to(ProjectsComponent());
              },
            ),
            ),
            body: Obx(() => LoadingOverlay(
                opacity: 1,
                color: Colors.black54,
                progressIndicator: const SpinKitCircle(
                  color: ThemeConstants.whiteColor,
                  size: 50.0,
                ),
                isLoading: referController.isContactsLoading.value,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.screenPadding,
                          vertical: ThemeConstants.screenPadding,
                        ),
                        child: buildSearchBox()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(() => referController.selectedContacts.length == 0
                            ? SizedBox.shrink()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      20, //ThemeConstants.screenPadding,
                                  //  vertical: ThemeConstants.screenPadding,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        referController.selectedContacts.length
                                                    .toString() ==
                                                '1'
                                            ? Text(
                                                "${referController.selectedContacts.length.toString()} Contact Selected",
                                                style: Styles.hint1Styles,
                                              )
                                            : Text(
                                                "${referController.selectedContacts.length.toString()} Contacts Selected",
                                                style: Styles.hint1Styles,
                                              ),
                                        SizedBox(
                                          height: ThemeConstants.height6,
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        referController.selectedContacts
                                            .clear();
                                        referController.getAllContacts();
                                      },
                                      child: Text(
                                        'Clear',
                                        style: Styles.link3Styles,
                                      ),
                                    )
                                  ],
                                ))),
                        SizedBox(height: ThemeConstants.height10),
                      ],
                    ), // Fixed search box
                    Expanded(
                      // This ensures the list takes up the remaining space and scrolls
                      child: SingleChildScrollView(
                        controller: referController.scrollController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: ThemeConstants.screenPadding,
                            //  vertical: ThemeConstants.screenPadding,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: ThemeConstants.height10),
                              Obx(() => referController.isLoading.value == true
                                  ? Container(
                                      height: Get.height * 0.5,
                                      child: showCustomLoader(),
                                    )
                                  : referController.contactsList.isNotEmpty
                                      ? Column(
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount: referController
                                                  .contactsList.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return InkWell(
                                                  child: ReferCardWidget(
                                                    item: referController
                                                        .contactsList[index],
                                                  ),
                                                );
                                              },
                                            ),
                                            Obx(() => referController
                                                    .isInfiniteLoading.value
                                                ? showCustomLoader()
                                                : SizedBox.shrink()),
                                            SizedBox(
                                              height: ThemeConstants.height100,
                                            ),
                                          ],
                                        )
                                      : buildNoContactsWidget()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))),
            bottomNavigationBar: Obx(() => referController
                        .selectedContacts.isNotEmpty &&
                    referController.isLoading.value == false
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ThemeConstants.screenPadding),
                        child: RoundedFilledButtonWidget(
                          buttonName: 'Send',
                          isLargeBtn: true,
                          onPressed: () {
                            if (referController.selectedContacts.isNotEmpty) {
                              referController.refer();
                            } else {
                              Get.rawSnackbar(
                                  message: "Please select contacts");
                            }
                          },
                        ),
                      ),
                      BottombarWidget(),
                    ],
                  )
                : SizedBox.shrink()),
          ),
        ],
      ),
    );
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
        ),
      ),
      child: TextFormField(
        onChanged: (v) {
          print("onChanged: $v");
          if (v.length >= 1) {
            referController.getContactsBySearchValue();
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
        controller: referController.searchController,
        decoration: InputDecoration(
          counterText: '',
          fillColor: Colors.white,
          filled: true,
          hintText: "Search",
          prefixIcon: const LineIcon(
            Icons.search,
            size: 20,
            color: ThemeConstants.greyColor,
          ),
          suffixIcon: InkWell(
            onTap: () {
              referController.searchController.text = "";
              referController.getAllContacts();
            },
            child: LineIcon(
              Icons.close,
              size: 20,
              color: ThemeConstants.greyColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ThemeConstants.primaryColor),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          ),
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
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeConstants.primaryColor),
            borderRadius:
                BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          ),
        ),
      ),
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
}

class buildNoContactsWidget extends StatelessWidget {
  const buildNoContactsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: ThemeConstants.appBackgroundColor,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.screenPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/contact.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: ThemeConstants.height16),
              Text(
                "You don’t have any Contacts yet, Tap + to create a new Contact",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ThemeConstants.fontSize16,
                  color: ThemeConstants.greyColor,
                ),
              ),
              SizedBox(height: ThemeConstants.height16),
              // Additional content
            ],
          ),
        ),
      ),
    );
  }
}

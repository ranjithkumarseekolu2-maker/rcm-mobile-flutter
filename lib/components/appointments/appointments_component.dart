import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/appointments_card_widget.dart';
import 'package:brickbuddy/commons/widgets/rectangular_textbox_filed_widget.dart';
import 'package:brickbuddy/commons/widgets/search_box_widget.dart';
import 'package:brickbuddy/components/appointments/appointments_controller.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/menu/menu_component.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class AppointmentsComponent extends StatefulWidget {
  @override
  State<AppointmentsComponent> createState() =>
      _ModalBottomSheetComponentState();
}

class _ModalBottomSheetComponentState extends State<AppointmentsComponent> {
  AppointmentsController appointmentsController =
      Get.put(AppointmentsController());
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            Get.delete<MenuController>(force: true);
            Get.to(MenuComponent());
            return false;
          },
          child: Scaffold(
            backgroundColor: ThemeConstants.appBackgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: ThemeConstants.whiteColor),
                onPressed: () {
                  Get.delete<MenuController>(force: true);
                  Get.to(MenuComponent());
                },
              ),
              elevation: 0,
              centerTitle: false,
              backgroundColor: ThemeConstants.primaryColor,
              title: Text("Appointments",
                  style: TextStyle(color: ThemeConstants.whiteColor)),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Obx(() => badges.Badge(
                        position: badges.BadgePosition.topEnd(top: 0, end: 3),
                        badgeAnimation: badges.BadgeAnimation.slide(
                            // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                            // curve: Curves.easeInCubic,
                            ),
                        showBadge:
                            CommonService.instance.allNotificationsCount.value >
                                    0
                                ? true
                                : false,
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: ThemeConstants.errorColor,
                        ),
                        badgeContent: Text(
                          CommonService.instance.allNotificationsCount
                              .toString(),
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
                              // homeController.storage.write("notidicationsSeen",
                              //     homeController.notificationsList.length);
                              Get.delete<NotificationsController>(force: true);
                              Get.toNamed(Routes.notificationsComponent);
                            }),
                      )),
                ),
              ],
            ),
            bottomNavigationBar: const BottombarWidget(),
            floatingActionButton:
                Obx(() => appointmentsController.isLoading.value
                    ? SizedBox.shrink()
                    : FloatingActionButton(
                        backgroundColor: ThemeConstants.primaryColor,
                        onPressed: () {
                          appointmentsController.clearData();
                          appointmentsController.openModalBottomSheet(
                              context, "Create");
                        },
                        child: Icon(
                          Icons.add,
                          color: ThemeConstants.whiteColor,
                        ),
                      )),
            body: buildBody(),
          ),
        )
      ],
    );
  }

  buildBody() {
    return SafeArea(
        child: Container(
      color: ThemeConstants.appBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
          child: Column(
            children: [
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Obx(() => appointmentsController.isLoading.value
                  ? Container(
                      height: Get.height * 0.7, child: showCustomLoader())
                  : appointmentsController.isAppointmentLoading.value ==
                              false &&
                          appointmentsController.appointmentList.isEmpty
                      ? Container(
                          height: Get.height * 0.7,
                          child: Center(
                            child: Text(
                                "No Appointments Found. Click the '+' button below to Create a New Appointment."),
                          ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount:
                              appointmentsController.appointmentList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Column(
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: AppointmentsCardWidget(
                                        onPressedOnCall: () {
                                          appointmentsController.makePhoneCall(
                                              appointmentsController
                                                  .appointmentList[index]
                                                  .contact!
                                                  .primaryNumber);
                                        },
                                        item: appointmentsController
                                            .appointmentList[index])),
                              ],
                            );
                          }))
            ],
          ),
        ),
      ),
    ));
  }

  buildSearchBox() {
    return SearchBoxWidget(
        hintText: 'Search for Projects',
        controller: TextEditingController(),
        maxLength: 50,
        readOnly: false);
  }

  buildRemainders() {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          border: Border.all(color: ThemeConstants.greyColor),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
        child: Column(
          children: [
            SizedBox(
              height: ThemeConstants.height10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set Remainder',
                  style: Styles.greyLabelStyles2,
                ),
                CupertinoSwitch(
                  value: appointmentsController.switchValue,
                  onChanged: (value) {
                    print('valll $value');
                    appointmentsController.switchValue = value;
                  },
                ),
              ],
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            Divider(
              color: ThemeConstants.greyColor,
              height: 4,
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaind me before',
                  style: Styles.greyLabelStyles2,
                ),
                DropdownButton(
                  hint: Text(''), // Not necessary for Option 1
                  value: appointmentsController.selectedRemainderTime.value,
                  onChanged: (newValue) {
                    print('nnn $newValue');
                    appointmentsController.selectedRemainderTime.value =
                        newValue.toString();
                  },
                  items: appointmentsController.remainderTime.map((location) {
                    return DropdownMenuItem(
                      child: new Text(location),
                      value: location,
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
          ],
        ),
      ),
    );
  }

  buildProductNameField() {
    return RectangularTextBoxField(
      hintText: 'Select Contact'.tr,
      isSufixIcon: false,
      controller: appointmentsController.selectLeadController,
      // onChange: (v) {
      //   addProductController.textFieldChanges();
      // },
    );
  }
}

import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/components/appointments/appointments_controller.dart';
import 'package:brickbuddy/components/contacts/contacts_controller.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/components/login/login_controller.dart';
import 'package:brickbuddy/components/my_builders/my_builders_component.dart';
import 'package:brickbuddy/components/my_builders/my_builders_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/components/profile/profile_component.dart';
import 'package:brickbuddy/components/profile/profile_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:badges/badges.dart' as badges;
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuComponent extends StatelessWidget {
  // const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("onWill pop scope calle");
        logout();
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: BottombarWidget(),
            appBar: AppBar(
              backgroundColor: ThemeConstants.primaryColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text('Menu', style: TextStyle(color: Colors.white)),
              centerTitle: false,
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
                              HomeController homeController = Get.find();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

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
            body: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ThemeConstants.screenPadding10),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       InkWell(
                      //         onTap: () {
                      //           Get.to(AppointmentsComponent());
                      //         },
                      //         child: Row(
                      //           children: [
                      //             LineIcon(
                      //               Icons.supervised_user_circle,
                      //               size: 28,
                      //              ThemeConstants.greyColor[800],
                      //             ),
                      //             SizedBox(
                      //               width: ThemeConstants.width10,
                      //             ),
                      //             Text(
                      //               'Appointments',
                      //               style: Styles.hint1Styles,
                      //             )
                      //           ],
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: ThemeConstants.height20,
                      // ),
                      // SizedBox(
                      //   height: Get.height * 0.3,
                      // ),
                      // Center(
                      //     child: Text(
                      //   "Version 1.0.0",
                      //   style: Styles.hintStyles,
                      // )),
                      SizedBox(
                        height: ThemeConstants.height10,
                      ),
                      ListTile(
                        leading: Icon(
                          LineIcons.user,
                          size: 28,
                          color: ThemeConstants.iconColor,
                        ),
                        title: Text(
                          'Profile',
                          style: Styles.menuStyles,
                        ),
                        trailing: LineIcon(Icons.arrow_forward_ios,
                            size: 20, color: ThemeConstants.greyColor),
                        onTap: () {
                          Get.delete<ProfileController>(force: true);
                          Get.to(ProfileComponent());
                        },
                      ),

                      // const Divider(),

                      // const Divider(),

                      const Divider(),

                      // const Divider(),
                      ListTile(
                        leading: Icon(
                          LineIcons.userFriends,
                          size: 28,
                          color: ThemeConstants.iconColor,
                        ),
                        title: Text(
                          'My Builders',
                          style: Styles.menuStyles,
                        ),
                        trailing: const LineIcon(Icons.arrow_forward_ios,
                            size: 20, color: ThemeConstants.greyColor),
                        onTap: () {
                          Get.delete<MyBuildersController>();
                          Get.toNamed(Routes.myBuildersComponent);
                        },
                      ),

                      ListTile(
                        leading: Icon(
                          LineIcons.calendar,
                          size: 28,
                          color: ThemeConstants.iconColor,
                        ),
                        title: Text(
                          'Appointments',
                          style: Styles.menuStyles,
                        ),
                        trailing: const LineIcon(Icons.arrow_forward_ios,
                            size: 20, color: ThemeConstants.greyColor),
                        onTap: () {
                          Get.delete<AppointmentsController>();
                          Get.toNamed(Routes.appointmentsScreen);
                        },
                      ),
                      //  ListTile(
                      // leading: Icon(LineIcons.question, size: 28,color: ThemeConstants.iconColor,),
                      // title: Text(
                      //   'Faq',
                      //   style: Styles.menuStyles,
                      // ),
                      // trailing: const LineIcon(Icons.arrow_forward_ios,
                      //     size: 20, color: ThemeConstants.greyColor),
                      // onTap: () {
                      //    Get.toNamed(Routes.faqScreen);
                      // },
                      //),
                      ListTile(
                        leading: Icon(
                          LineIcons.headset,
                          size: 28,
                          color: ThemeConstants.iconColor,
                        ),
                        title: Text(
                          'Contact Support',
                          style: Styles.menuStyles,
                        ),
                        trailing: const LineIcon(Icons.arrow_forward_ios,
                            size: 20, color: ThemeConstants.greyColor),
                        onTap: () {
                          Get.toNamed(Routes.support);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          LineIcons.powerOff,
                          color: ThemeConstants.iconColor,
                          size: 28,
                        ),
                        title: Text(
                          'Logout',
                          style: Styles.menuStyles,
                        ),
                        trailing: const LineIcon(Icons.arrow_forward_ios,
                            size: 20, color: ThemeConstants.greyColor),
                        onTap: () {
                          Get.dialog(AppCupertinoDialog(
                            title: 'Logout',
                            subTitle: 'Are you sure you want to logout now?',
                            isOkBtn: false,
                            acceptText: 'Yes',
                            cancelText: 'No',
                            onAccepted: () async {
                              CommonService.confirmLogout();
                              //  exit(0);
                              // Get.offAllNamed(Routes.loginScreen);
                              // GetStorage().erase();
                            },
                            onCanceled: () {
                              Get.back();
                            },
                          ));
                        },
                      ),
                      SizedBox(
                        height: ThemeConstants.height20,
                      ),
                      Text(
                        "Version 3.1.9", //1.0.2+3
                        style: Styles.hintStyles,
                      ),

                      SizedBox(
                        height: ThemeConstants.height100,
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

logout() async {
  await Get.dialog(AppCupertinoDialog(
    title: 'Exit'.tr,
    subTitle: 'Are you sure you want to exit app?',
    isOkBtn: false,
    acceptText: 'Yes'.tr,
    cancelText: 'No'.tr,
    onAccepted: () async {
      //CommonService.confirmLogout();
      exit(0);
    },
    onCanceled: () {
      Get.back();
    },
  ));
}

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = true;

  bool get isLoggedIn => _isLoggedIn;

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

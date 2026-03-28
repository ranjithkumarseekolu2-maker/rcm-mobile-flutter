import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:brickbuddy/commons/widgets/builders_card_widget.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/menu/menu_component.dart';
import 'package:brickbuddy/components/my_builders/my_builders_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBuildersComponent extends StatelessWidget {
  MyBuildersController myBuildersController = Get.put(MyBuildersController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.appBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ThemeConstants.whiteColor),
          onPressed: () {
            Get.delete<MenuController>(force: true);
            Get.to(MenuComponent());
          },
        ),
        elevation: 0,
        centerTitle: false,
        backgroundColor: ThemeConstants.primaryColor,
        title: Text("My Builders",
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
                        // homeController.storage.write("notidicationsSeen",
                        //     homeController.notificationsList.length);
                        Get.delete<NotificationsController>(force: true);
                        Get.toNamed(Routes.notificationsComponent);
                      }),
                )),
          ),
        ],
      ),
      body: buildBody(),
      bottomNavigationBar: const BottombarWidget(),
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
              Obx(() => myBuildersController.isLoading.value
                  ? Container(
                      height: Get.height * 0.7, child: showCustomLoader())
                  : myBuildersController.isLoading.value == false &&
                          myBuildersController.buildersList.isEmpty
                      ? Container(
                          height: Get.height * 0.7,
                          child: Center(
                            child: Text("No Builders Found."),
                          ))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: myBuildersController.buildersList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Column(
                              children: [
                                InkWell(
                                    onTap: () {},
                                    child: BuildersCardWidget(
                                        onPressedOnCall: () {
                                          myBuildersController.makePhoneCall(
                                              myBuildersController
                                                          .buildersList[index]
                                                      ['builder']
                                                  ['OFC_PRIMARY_CONTACT_NO']);
                                        },
                                        item: myBuildersController
                                            .buildersList[index])),
                              ],
                            );
                          }))
            ],
          ),
        ),
      ),
    ));
  }
}

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/notifications_card_widget.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsComponent extends StatelessWidget {
  NotificationsController notificationsController =
      Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("device back clicked");
        CommonService.instance.allNotificationsCount.value = 0;
        return true;
      },
      child: Scaffold(
        backgroundColor: ThemeConstants.appBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ThemeConstants.whiteColor),
            onPressed: () {
              CommonService.instance.allNotificationsCount.value = 0;
              Get.back();
              // Get.delete<HomeController>(force: true);
              // Get.toNamed(Routes.homeScreen);
            },
          ),
          //automaticallyImplyLeading: false,
          backgroundColor: ThemeConstants.primaryColor,
          title: Text('Notifications',
              style: TextStyle(color: ThemeConstants.whiteColor)),
          centerTitle: false,
        ),
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.screenPadding,
            vertical: ThemeConstants.screenPadding),
        child: Container(
          //  color: ThemeConstants.hintTextColor,
          child: Column(children: [
            Obx(() => notificationsController.isLoading.value
                ? Container(height: Get.height * 0.7, child: showCustomLoader())
                : notificationsController.notificationsList.length == 0
                    ? Container(
                        height: Get.height * 0.7,
                        child: Center(child: Text("No Notifications Found.")))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount:
                            notificationsController.notificationsList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return Column(
                            children: [
                              InkWell(
                                  onTap: () {},
                                  child: NotificationsCardWidget(
                                    item: notificationsController
                                        .notificationsList[index],
                                  )),
                              SizedBox(
                                height: ThemeConstants.height4,
                              )
                            ],
                          );
                        })),
          ]),
        ),
      ),
    );
  }
}

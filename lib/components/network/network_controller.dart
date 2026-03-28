import 'package:brickbuddy/commons/services/network_service.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/splash_screen/splash_controller.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoNetworkController extends GetxController {
  onTryAgain() async {
    var isNetworkState = await NetworkService().checkConnectivityState();

    if (isNetworkState == true) {
      Get.delete<SplashController>(force: true);
      Get.toNamed(Routes.splashScreen);
    } else {
      Get.rawSnackbar(
          message: 'No Connection'.tr,
          borderRadius: 10,
          margin: EdgeInsets.all(15),
          duration: Duration(seconds: 1));
    }
  }
}

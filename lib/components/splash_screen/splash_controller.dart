import 'dart:async';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/network_service.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/network/network_component.dart';
import 'package:brickbuddy/components/network/network_controller.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController with WidgetsBindingObserver {
  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance?.addObserver(this);

    var isNework = await NetworkService().checkConnectivityState();
    if (isNework == true) {
      checkUserExist();
    } else {
      Get.delete<NoNetworkController>(force: true);
      Get.to(NoNetworkComponent());
    }
  }

  checkUserExist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("JwtToken: ${prefs.getString(
      "jwtToken",
    )}");
    var jwtToken = prefs.getString(
      "jwtToken",
    );
    if (jwtToken != null) {
      print('objecta123 ${CommonService.instance.firstName.value}');
      CommonService.instance.jwtToken.value = jwtToken;
      getAgentInfo(jwtToken);
      Timer(const Duration(seconds: 3), () {
        Get.delete<HomeController>(force: true);
        Get.toNamed(Routes.homeScreen);
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Get.toNamed(Routes.loginScreen);
      });
    }
  }

  getAgentInfo(jwtToken) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    print("logId  ${decodedToken["logId"]}");
    CommonService.instance.agentId.value = decodedToken["logId"];
    CommonService.instance.foreKey.value = decodedToken["foreKey"];
    //  CommonService.instance.mobileNumber = decodedToken["mobileNumber"];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('names111 ${prefs.getString('firstName')}');
    if (prefs.getString('firstName') != null) {
      CommonService.instance.firstName.value = prefs.getString('firstName')!;
    } else {
      CommonService.instance.firstName.value =
          toBeginningOfSentenceCase(decodedToken["firstName"]).toString();
    }
    if (prefs.getString('profilePic') != null) {
      CommonService.instance.profileUrl.value = prefs.getString('profilePic')!;
    } else {
      CommonService.instance.profileUrl.value = decodedToken["profilePic"];
    }
    if (prefs.getString('lastName') != null) {
      CommonService.instance.lastName.value = prefs.getString('lastName')!;
    } else {
      CommonService.instance.lastName.value =
          toBeginningOfSentenceCase(decodedToken["lastName"]).toString();
    }
    if (prefs.getString('mobileNumber') != null) {
      CommonService.instance.mobileNumber.value =
          prefs.getString('mobileNumber')!;
    } else {
      CommonService.instance.mobileNumber.value = decodedToken["mobileNumber"];
    }
  }
}

import 'dart:async';

import 'package:brickbuddy/components/network/network_component.dart';
import 'package:brickbuddy/components/splash_screen/splash_controller.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkService {
  ConnectivityResult? connectivityResult;
  late StreamSubscription connectivitySubscription;

  // This method used to check network connection
  Future connectionStream(route) async {
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      connectivityResult = result;
      if (connectivityResult == ConnectivityResult.none) {
        Get.rawSnackbar(
          message: 'No network connection, please try again',
          borderRadius: 10,
          margin: EdgeInsets.all(15),
        );
        Get.to(NoNetworkComponent());
      } else {
        if (route == 'main') {
          Get.delete<SplashController>(force: true);
          Get.toNamed(Routes.splashScreen);
        }
      }
    });
  }

  //To check network conection gives true and false
  Future checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}

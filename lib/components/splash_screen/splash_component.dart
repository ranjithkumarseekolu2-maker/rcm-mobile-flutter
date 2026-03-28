
import 'dart:io';

import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/components/splash_screen/splash_controller.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashComponent extends StatelessWidget {


 SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.primaryColor,
        body:   Center(
      child: Image.asset(
        ImageConstants.appLogo2,
        width: 250,
        height: 250,
        color: ThemeConstants.whiteColor,
      ),
    ));
  }

  
}

import 'dart:io';

import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/components/network/network_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoNetworkComponent extends StatelessWidget {
  NoNetworkController noNetworkController = Get.put(NoNetworkController());

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await Get.dialog(AppCupertinoDialog(
            title: 'exit'.tr,
            subTitle: 'areyousurewanttoexitapp'.tr,
            isOkBtn: false,
            acceptText: 'yes'.tr,
            cancelText: 'no'.tr,
            onAccepted: () async {
              exit(0);
            },
            onCanceled: () {
              Get.back();
            },
          ));

          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: ThemeConstants.primaryColor,
              title: Text('No Connection',
                  style: TextStyle(color: ThemeConstants.whiteColor)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 100,
                    color: ThemeConstants.greyColor,
                  ),
                  Text(
                    'No Connection'.tr,
                    style: Styles.headingStyles,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Please check your internet connectivity and try again'
                          .tr,
                      style: Styles.hint1Styles,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RoundedOutlineButtonWidget(
                    buttonName: 'Try Again'.tr,
                    onPressed: () {
                      noNetworkController.onTryAgain();
                    },
                  )
                ],
              ),
            )));
  }
}

import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar1_widget.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_field_widget.dart';
import 'package:brickbuddy/commons/widgets/password_field_widget.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';
import 'package:brickbuddy/components/login/forgot_details/forgot_details_component.dart';
import 'package:brickbuddy/components/login/forgot_details/forgot_details_controller.dart';
import 'package:brickbuddy/components/login/login_controller.dart';
import 'package:brickbuddy/components/login/signup/signup_component.dart';
import 'package:brickbuddy/components/login/signup/signup_controller.dart';
import 'package:brickbuddy/components/login/signup/signup_intro_component.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moengage_flutter/moengage_flutter.dart';

class LoginComponent extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  SignUpController signUpController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        logout();
        return false;
      },
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }

  buildBody(context) {
    return SafeArea(
      child: Obx(() => loginController.isLoading.value
          ? showCustomLoader()
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                      height: Get.height,
                      width: Get.width,
                      color: ThemeConstants.primaryColor,
                      child: Column(
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/landingImage2.jpg',
                            ),
                          ),
                        ],
                      )),
                  Positioned(
                    left: 0,
                    child: Container(child: buildWelcomeData()),
                  ),
                  Positioned(
                      top: 300,
                      child: Container(
                          height: Get.height,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              )),
                          child: buildTextFields())),
                  Positioned(
                    left: ThemeConstants.screenPadding,
                    right: ThemeConstants.screenPadding,
                    top: Get.height * ThemeConstants.buttonPositionFromTop,
                    child: Column(
                      children: [
                        buildBottomBar1Widget(context),
                        SizedBox(height: ThemeConstants.height15),
                        TextButtonWidget(
                            buttonName: 'Forgot your password?',
                            onPressed: () {
                              Get.delete<ForgotDetailsController>(force: true);
                              Get.to(ForgotDetailsComponent());
                            },
                            textColor: Colors.grey[800],
                            fontSize: ThemeConstants.fontSize13),
                        SizedBox(height: ThemeConstants.height10),
                        buildSignUpLink(context),
                        SizedBox(height: ThemeConstants.height20),
                      ],
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  buildTextFields() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.screenPadding,
          vertical: ThemeConstants.screenPadding),
      child: Form(
        key: loginController.loginFormKey,
        child: Column(
          children: [
            SizedBox(
              height: ThemeConstants.height31,
            ),
            MobileNumberField(
              controller: loginController.phoneNumberController,
              hintText: 'Enter Mobile Number',
              keyboardtype: TextInputType.number,
            ),
            SizedBox(
              height: ThemeConstants.height20,
            ),
            RectangularPasswordTextBoxWidget(
              controller: loginController.passwordController,
              hintText: 'Enter Password',
              formFieldKey: loginController.pwdKey,
            ),
            SizedBox(
              height: ThemeConstants.height100,
            ),
          ],
        ),
      ),
    );
  }

  buildWelcomeData() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.screenPadding,
          vertical: ThemeConstants.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageConstants.appLogo2,
            width: 120,
            height: 120,
            color: ThemeConstants.whiteColor,
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          Text(
            'Welcome ',
            style: TextStyle(
                color: Colors.white,
                fontSize: ThemeConstants.fontSize24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: ThemeConstants.height5,
          ),
          Text(
            'Buddy !',
            style: TextStyle(
                color: Colors.white,
                fontSize: ThemeConstants.fontSize24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: ThemeConstants.height15,
          ),
          Text(
            'Sign in to continue',
            style: TextStyle(
                color: Colors.white,
                fontSize: ThemeConstants.fontSize14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  BottomBar1Widget buildBottomBar1Widget(BuildContext context) {
    return BottomBar1Widget(
      buttonName: 'Login'.tr,
      btnOnPressed: () {
        var properties = MoEProperties();
        properties
            .addAttribute("attrString", "String Value")
            .addAttribute("attrInt", 123)
            .addAttribute("attrBool", true)
            .addAttribute("attrDouble", 12.32)
            .addAttribute("attrLocation", new MoEGeoLocation(12.1, 77.18))
            .addAttribute("attrArray",
                ["item1", "item2", "item3"]).addAttribute('product', {
          'item-id': 123,
          'item-type': 'books',
          'item-cost': {'amount': 100, 'currency': 'USD'}
        }).addAttribute('products', [
          {
            'item-id': 123,
            'item-cost': {'amount': 100, 'currency': 'USD'}
          },
          {
            'item-id': 323,
            'item-cost': {'amount': 90, 'currency': 'USD'}
          }
        ]).addISODateTime("attrDate", "2019-12-02T08:26:21.170Z");
        final MoEngageFlutter _moengagePlugin =
            MoEngageFlutter("CAS6Y3UYSRYJ3CNHZMZ8WTCA");
        _moengagePlugin.initialise();
        _moengagePlugin.trackEvent('loginUser', properties);
        _moengagePlugin.setUniqueId("4567");
        loginController.login();
      },
      textOnPressed: () {},
      buttonTextColor: ThemeConstants.whiteColor,
      backgroundColor: ThemeConstants.primaryColor,
    );
  }

  Row buildSignUpLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButtonWidget(
            buttonName: 'Don\'t have an account'.tr,
            fontSize: ThemeConstants.fontSize13,
            textColor: Colors.grey[800],
            onPressed: () {}),
        SizedBox(
          width: ThemeConstants.width4,
        ),
        TextButtonWidget(
            buttonName: 'Signup now'.tr,
            fontSize: ThemeConstants.fontSize13,
            textColor: ThemeConstants.primaryColor,
            onPressed: () {
              Get.delete<SignUpController>(force: true);
              //  Get.to(SignupComponent());
              Get.to(SignpIntroScreenComponent());
              //  signUpController.signup();
            }),
      ],
    );
  }

  static logout() async {
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
}

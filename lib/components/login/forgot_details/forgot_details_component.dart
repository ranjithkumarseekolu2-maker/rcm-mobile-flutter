import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar1_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_field_widget.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';

import 'package:brickbuddy/components/login/forgot_details/forgot_details_controller.dart';
import 'package:brickbuddy/components/login/forgot_details/verify_otp/otp_verification_controller.dart';
import 'package:brickbuddy/components/login/login_component.dart';
import 'package:brickbuddy/components/login/login_controller.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotDetailsComponent extends StatelessWidget {
  ForgotDetailsController forgotDetailsController =
      Get.put(ForgotDetailsController());
  OtpVerificationController otpVerificationController =
      Get.put(OtpVerificationController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  backgroundColor: ThemeConstants.primaryColor,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // here the desired height
            child: AppBar(
              backgroundColor: ThemeConstants.primaryColor,
              elevation: 0,
              bottomOpacity: 0.0,
              leading: IconButton(
                  onPressed: () {
                    Get.delete<LoginController>(force: true);
                    Get.toNamed(Routes.loginScreen);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ThemeConstants.whiteColor,
                  )),
            )),
        body: buildBody(context));
  }

  buildBody(context) {
    return SafeArea(
      child:
          //SingleChildScrollView(
          Obx(() => forgotDetailsController.isLoading.value
              ? showCustomLoader()
              : SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                          height: Get.height,
                          width: Get.width,
                          color: ThemeConstants.primaryColor,
                          // decoration: BoxDecoration(),
                          child: Column(
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/images/largelandingImage2.jpg',
                                ),
                              ),
                            ],
                          ) //buildWelcomeData(),
                          ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(child: buildData()),
                      ),
                      Positioned(
                          top: 450,
                          //bottom: 10,
                          child: Container(
                              height: Get.height,
                              width: Get.width,
                              decoration: BoxDecoration(
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
                              buttonName: 'Go back to Login',
                              onPressed: () {
                                Get.to(LoginComponent());
                              },
                              textColor: Colors.grey[800],
                              fontSize: ThemeConstants.fontSize13,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  buildData() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.screenPadding,
            vertical: ThemeConstants.screenPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                ImageConstants.appLogo2,
                width: 120,
                height: 120,
                color: ThemeConstants.whiteColor,
              ),
              SizedBox(
                height: ThemeConstants.height52,
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
                height: ThemeConstants.height8,
              ),
              Text(
                'Change password to access',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ThemeConstants.fontSize14,
                    fontWeight: FontWeight.bold),
              )
            ]));
  }

  buildTextFields() {
    // cleardata();
    // forgotDetailsController.mobileNumberController.clear();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
      child: Column(
        children: [
          SizedBox(
            height: ThemeConstants.height31,
          ),
          MobileNumberField(
              hintText: 'Enter Mobile Number',
              controller: forgotDetailsController.mobileNumberController,
              keyboardtype: TextInputType.number),
        ],
      ),
    );
  }

  BottomBar1Widget buildBottomBar1Widget(BuildContext context) {
    return BottomBar1Widget(
      buttonName: 'Send otp'.tr,
      btnOnPressed: () async {
        // Check if mobile number is entered
        if (forgotDetailsController.mobileNumberController.text.isEmpty) {
          // Show snackbar prompting user to enter mobile number
          Get.rawSnackbar(
            message: "Please enter a Mobile Number",
          );
        } else {
          // Call sendOtp if mobile number is entered
          await forgotDetailsController.sendOtp(
            forgotDetailsController.mobileNumberController.text,
          );
        }
      },
      // otpVerificationController.sendOtp(
      //   forgotDetailsController.mobileNumberController.text,
      //   forgotDetailsController.usertypeController.text);
      //  Get.toNamed(Routes.otpverification);
      // forgotDetailsController.forgotpassword(password, mobilenumber, hashCode, usertype)
      //},
      //textButtonName: "Already have an account?".tr,
      textOnPressed: () {
        // Get.delete<ForgotPasswordController>();
        // Get.toNamed(Routes.FORGOTPASSWORDVIEW);
      },
      buttonTextColor: ThemeConstants.whiteColor,
      backgroundColor: ThemeConstants.primaryColor,
      //  textColor: ThemeConstants.primaryColor,
    );
  }
}

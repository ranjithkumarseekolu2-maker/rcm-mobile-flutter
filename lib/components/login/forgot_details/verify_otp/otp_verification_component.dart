import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar1_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_field_widget.dart';
import 'package:brickbuddy/commons/widgets/otp_field_widget.dart';
import 'package:brickbuddy/commons/widgets/password_field_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';
import 'package:brickbuddy/commons/widgets/text_form_field_widget.dart';
import 'package:brickbuddy/components/login/forgot_details/forgot_details_component.dart';
import 'package:brickbuddy/components/login/forgot_details/forgot_details_controller.dart';
import 'package:brickbuddy/components/login/forgot_details/verify_otp/otp_verification_controller.dart';

import 'package:brickbuddy/components/login/login_component.dart';
import 'package:brickbuddy/constants/image_constants.dart';

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Otp_Verification extends StatelessWidget {
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
                    Get.delete<ForgotDetailsController>(force: true);
                    Get.to(ForgotDetailsComponent(), arguments: {
                      'mobileNumber':
                          otpVerificationController.mobileNumber.value
                    });
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ThemeConstants.whiteColor,
                  )),
            )),
        body: Obx(() => otpVerificationController.isLoading.value
            ? showCustomLoader()
            : buildBody(context)));
  }

  buildBody(context) {
    return SafeArea(
        child: SingleChildScrollView(
      //Obx(()=> otpVerificationController.isLoading.value ? showCustomLoader() : SingleChildScrollView(
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
              top: 400,
              //bottom: 10,
              child: Form(
                key: otpVerificationController.loginFormKey,
                child: Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                    child: buildTextFields()),
              )),
          Positioned(
            left: ThemeConstants.screenPadding,
            right: ThemeConstants.screenPadding,
            top: Get.height * ThemeConstants.buttonPositionFromTop,
            child: Column(
              children: [
                // buildBottomBar1Widget(context),
                RoundedFilledButtonWidget(
                  buttonName: 'Verify otp',
                  onPressed: () {
                    if (otpVerificationController.loginFormKey.currentState!
                        .validate()) {
                      otpVerificationController.verifyOtp(
                          otpVerificationController.mobileNumber.value,
                          otpVerificationController.passwordController.text,
                          otpVerificationController.usertypeController.text,
                          otpVerificationController
                              .confirmPasswordController.text,
                          otpVerificationController.otpController.text);
                    }
                  },
                ),
                SizedBox(height: ThemeConstants.height15),
                TextButtonWidget(
                  buttonName: 'Resend otp',
                  onPressed: () {
                    otpVerificationController.sendOtp(
                      otpVerificationController.mobileNumber.value,
                    );
                  },
                  textColor: Colors.grey[800],
                  fontSize: ThemeConstants.fontSize13,
                ),
                SizedBox(height: ThemeConstants.height15),
                TextButtonWidget(
                  buttonName: 'Already have an account? Login',
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
    ));
    // );
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
                height: ThemeConstants.height31,
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
                'Please enter the OTP ',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ThemeConstants.fontSize14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: ThemeConstants.height8,
              ),
              Text(
                'that sent to your phone',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ThemeConstants.fontSize14,
                    fontWeight: FontWeight.bold),
              ),
            ]));
  }

  // buildTextFields() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: ThemeConstants.height31,
  //         ),
  //         // OtpField(
  //         //     hintText: 'Enter otp',
  //         //     controller: otpVerificationController.otpController,
  //         //     keyboardtype: TextInputType.number),
  //         TextFormFieldWidget(
  //           controller: otpVerificationController.otpController,
  //           hintText: 'Enter Otp',
  //         ),
  //       ],
  //     ),
  //   );
  // }
  buildTextFields() {
    otpVerificationController.cleardata();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.screenPadding,
          vertical: ThemeConstants.screenPadding),
      child: Form(
        // key: signUpController.signUpFormKey,
        child: Column(
          children: [
            SizedBox(
              height: ThemeConstants.height10,
            ),
            RectangularPasswordTextBoxWidget(
              controller: otpVerificationController.passwordController,
              hintText: 'Enter password',
              formFieldKey: otpVerificationController.passwordFormKey,
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            RectangularPasswordTextBoxWidget(
              controller: otpVerificationController.confirmPasswordController,
              hintText: 'Confirm your password',
              formFieldKey: otpVerificationController.forgotpasswordFormKey,
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            TextFormFieldWidget(
              hintText: 'Enter otp',
              icon: Icon(Icons.key),
              controller: otpVerificationController.otpController,
            ),
            SizedBox(
              height: ThemeConstants.height52,
            ),
          ],
        ),
      ),
    );
  }

  // BottomBar1Widget buildBottomBar1Widget(BuildContext context) {
  //   return BottomBar1Widget(
  //     buttonName: 'Verify otp'.tr,
  //     btnOnPressed: () {
  //       // loginController.validateLoginForm();
  //     },
  //     //textButtonName: "Already have an account?".tr,
  //     textOnPressed: () {
  //       // Get.delete<ForgotPasswordController>();
  //       // Get.toNamed(Routes.FORGOTPASSWORDVIEW);
  //     },
  //     buttonTextColor: ThemeConstants.whiteColor,
  //     backgroundColor: ThemeConstants.primaryColor,
  //     //  textColor: ThemeConstants.primaryColor,
  //   );

  // }
}

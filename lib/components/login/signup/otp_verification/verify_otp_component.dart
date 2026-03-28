import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/password_field_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';
import 'package:brickbuddy/commons/widgets/text_form_field_widget.dart';

import 'package:brickbuddy/components/login/login_component.dart';
import 'package:brickbuddy/components/login/signup/otp_verification/verify_otp_controller.dart';
import 'package:brickbuddy/components/login/signup/signup_component.dart';
import 'package:brickbuddy/components/login/signup/signup_controller.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyOtpComponent extends StatelessWidget {
  VerifyOtpController otpVerificationController =
      Get.put(VerifyOtpController());
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
                    Get.delete<SignUpController>(force: true);
                    Get.to(SignupComponent(), arguments: {
                      'password': otpVerificationController.password.value,
                      'firstName': otpVerificationController.firstName.value,
                      'lastName': otpVerificationController.lastName.value,
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
              top: 450,
              //bottom: 10,
              child: Form(
                key: otpVerificationController.verifyOtpFormKey,
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
          otpVerificationController.isClickedOnVerify.value
              ? RoundedFilledButtonWidget(
                  buttonName: 'Verify otp',
                  backgroundColor: Color.fromARGB(173, 177, 119, 253),
                  onPressed: () {},
                )
              : Positioned(
                  left: ThemeConstants.screenPadding,
                  right: ThemeConstants.screenPadding,
                  top: Get.height * ThemeConstants.buttonPositionFromTop,
                  child: Column(
                    children: [
                      // buildBottomBar1Widget(context),
                      RoundedFilledButtonWidget(
                        buttonName: 'Verify otp',
                        onPressed: () {
                          print(
                              'mobileNumber... ${otpVerificationController.mobileNumber.value}');
                          otpVerificationController.isClickedOnVerify.value =
                              true;
                          otpVerificationController.verifyOtp(
                            otpVerificationController.mobileNumber.value,
                            otpVerificationController.otpController.text,
                            otpVerificationController.password.value,
                            otpVerificationController.firstName.value,
                            otpVerificationController.lastName.value,
                          );
                        },
                      ),
                      SizedBox(height: ThemeConstants.height15),
                      TextButtonWidget(
                        buttonName: 'Resend otp',
                        onPressed: () {
                          otpVerificationController.sendOtp(
                              otpVerificationController.mobileNumber.value);
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

  buildTextFields() {
    // otpVerificationController.cleardata();
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.screenPadding,
          vertical: ThemeConstants.screenPadding),
      child: Form(
        // key: signUpController.signUpFormKey,
        child: Column(
          children: [
            SizedBox(
              height: ThemeConstants.height31,
            ),
            TextFormFieldWidget(
              hintText: 'Enter Otp',
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
}

import 'package:brickbuddy/commons/services/otp_service.dart';
import 'package:brickbuddy/components/login/forgot_details/verify_otp/otp_verification_component.dart';
import 'package:brickbuddy/components/login/login_controller.dart';

import 'package:brickbuddy/components/login/signup/sucess_component.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController usertypeController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool isLoading = false.obs;
  var passwordFormKey = GlobalKey<FormState>();
  var forgotpasswordFormKey = GlobalKey<FormState>();
  var loginFormKey = GlobalKey<FormState>();
  OtpService otpService = Get.put(OtpService());
  RxString mobileNumber = ''.obs;
  String otp = '';
  RxString isFrom = ''.obs;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      mobileNumber.value = Get.arguments['mobileNumber'];
      isFrom.value = Get.arguments['isFrom'];
      print('Mobile Number: $mobileNumber');
      // verifyOtp(mobileNumber,);
    }
  }

  void verifyOtp(String mobilenumber, String password, String usertype,
      String confirmPassword, String otp) {
    if (password == confirmPassword) {
      isLoading.value = true;
      otpService
          .changepaswwordDetails(
              mobilenumber, password, usertype, confirmPassword, otp)
          .then((res) {
        // HandlisLoe response
        isLoading.value = false;
        print('Response from verifyotpDetails: $res');
        Get.rawSnackbar(
            message: "Password Updated Successfully, Please Login",
            backgroundColor: ThemeConstants.successColor);
        Get.delete<LoginController>(force: true);
        Get.toNamed(Routes.loginScreen);
        // Get.to(SucessComponent());
      }).catchError((onError) {
        isLoading.value = false;
        print("Error while verifying OTP: ${onError.toString()}");
        Get.rawSnackbar(
          message: "Please Enter Correct OTP",
        );
      });
    } else {
      Get.rawSnackbar(message: 'Passwords Do Not Match');
    }
  }

  sendOtp(String mobileNumber) async {
    print("send OTP called for mobile number: $mobileNumber");

    isLoading.value = true;
    try {
      await otpService.sendotpDetails(mobileNumber).then((res) {
        print('sent otp ');
        // Handle response
        print('Response from sendotpDetails: $res');
        if (res['status'] == 200) {
          // isLoading.value = true;
          Future.delayed(const Duration(seconds: 2), () {
            Get.rawSnackbar(
              message: "OTP Has Sent to Requested Mobile Number",
              backgroundColor: ThemeConstants.successColor,
            );

            //  Get.to(Otp_Verification(), arguments: {'isFrom': 'ForgotDetails'});
            isLoading.value = false;
          });
        } else {
          Get.rawSnackbar(
            message: res['message'],
          );
          isLoading.value = false;
        }
      });
    } catch (error) {
      isLoading.value = false;
      print("Error while resending OTP: ${error.toString()}");
      if (error is String && error.contains('400')) {
        // Show snackbar for inactive user account
        Get.rawSnackbar(
            message: "User Account is Inactive. Please Contact Realtor.works",
            backgroundColor: ThemeConstants.errorColor);
      } else {
        // Show generic error snackbar
        Get.rawSnackbar(
            message: "Something Went Wrong",
            backgroundColor: ThemeConstants.errorColor);
      }
    }
  }

  cleardata() {
    passwordController.text = '';
    confirmPasswordController.text = '';
    otpController.text = '';
  }
}

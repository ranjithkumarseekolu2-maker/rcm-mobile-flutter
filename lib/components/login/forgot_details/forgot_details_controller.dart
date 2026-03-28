import 'package:brickbuddy/commons/services/otp_service.dart';
import 'package:brickbuddy/commons/services/signup_service.dart';
import 'package:brickbuddy/components/login/forgot_details/verify_otp/otp_verification_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotDetailsController extends GetxController {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController usertypeController = TextEditingController();
  SignupService signupService = Get.put(SignupService());
  RxBool isLoading = false.obs;
  var loginFormKey = GlobalKey<FormState>();
  OtpService otpService = Get.put(OtpService());

  void onInit() {
    if (Get.arguments != null) {
      print('yes...');
      mobileNumberController.text = Get.arguments['mobileNumber'];
    }
    super.onInit();
  }

  sendOtp(String mobileNumber) async {
    print("send OTP called for mobile number: $mobileNumber");

    isLoading.value = true;
    print("send OTP called for mobile number: $mobileNumber");
    try {
      otpService.sendotpDetails(mobileNumber).then((res) {
        print('sent otp ');
        // Handle response
        print('Response from sendotpDetails: $res');
        if (res['status'] == 200) {
          // isLoading.value = true;

          Get.rawSnackbar(
            message: "OTP Has Sent to Requested Mobile Number",
            backgroundColor: ThemeConstants.successColor,
          );
          Future.delayed(const Duration(seconds: 2), () {
            Get.delete<OtpVerificationController>(force: true);
            Get.toNamed(Routes.otpverification, arguments: {
              'isFrom': 'ForgotDetails',
              'mobileNumber': mobileNumber
            });
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
      // if (error is String && error.contains('400')) {
      //   // Show snackbar for inactive user account
      //   Get.rawSnackbar(
      //       message: "User account is Inactive. Please contact Realtor.works",
      //       backgroundColor: ThemeConstants.errorColor);
      // } else {
      //   // Show generic error snackbar
      //   Get.rawSnackbar(
      //       message: "Something went wrong",
      //       backgroundColor: ThemeConstants.errorColor);
      // }
    }
  }
}

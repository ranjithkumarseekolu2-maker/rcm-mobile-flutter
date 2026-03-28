import 'package:brickbuddy/commons/services/otp_service.dart';
import 'package:brickbuddy/components/login/login_controller.dart';
import 'package:brickbuddy/components/login/signup/otp_verification/verify_otp_component.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyOtpController extends GetxController {
  var verifyOtpFormKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  RxString mobileNumber = ''.obs;
  RxString password = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isClickedOnVerify = false.obs;
  OtpService otpService = Get.put(OtpService());
  void onInit() {
    super.onInit();
    print('....args ${Get.arguments}');
    if (Get.arguments != null) {
      mobileNumber.value = Get.arguments['mobileNumber'];
      password.value = Get.arguments['password'];
      firstName.value = Get.arguments['firstName'];
      lastName.value = Get.arguments['lastName'];
      print('mobileNumber123 $mobileNumber');
    }
    // sendOtp(mobileNumber.value, '');
  }

  void verifyOtp(mobilenumber, otp, password, firstName, lastName) {
    isLoading.value = true;
    otpService
        .verifyOtpDetails(mobilenumber, otp, password, firstName, lastName)
        .then((res) {
      // HandlisLoe response
      isLoading.value = false;
      print('Response from verifyotpDetails: $res');
      if (res['status'] == 200) {
        Get.rawSnackbar(
            message:
                "Congratulations, your account verified successfully created.",
            backgroundColor: ThemeConstants.successColor);
        isClickedOnVerify.value = false;
        Get.delete<LoginController>(force: true);
        Get.toNamed(Routes.loginScreen);
      }
      // Get.to(SucessComponent());
    }).catchError((onError) {
      isLoading.value = false;
      isClickedOnVerify.value = false;
      print("Error while verifying OTP: ${onError.toString()}");
      Get.rawSnackbar(
        message: "Please enter correct otp",
      );
    });
  }

  sendOtp(String mobileNumber) async {
    print("send OTP called for mobile number: $mobileNumber");

    isLoading.value = true;
    try {
      var res = await otpService.sendotp(mobileNumber);
      print('sent otp ');
      // Handle response
      print('Response from sendotpDetails: $res');
      if (res['status'] == 200) {
        isLoading.value = false;
        Get.rawSnackbar(
          message: "Otp has sent to requested Mobile Number",
          backgroundColor: ThemeConstants.successColor,
        );
      } else {
        isLoading.value = false;
        Get.rawSnackbar(
          message: res['message'],
        );
      }
    } catch (error) {
      isLoading.value = false;
      // print("Error while resending OTP: ${error.toString()}");
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

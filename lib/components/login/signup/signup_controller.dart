import 'package:brickbuddy/commons/services/signup_service.dart';
import 'package:brickbuddy/components/login/signup/otp_verification/verify_otp_component.dart';
import 'package:brickbuddy/components/login/signup/otp_verification/verify_otp_controller.dart';

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  SignupService signupService = Get.put(SignupService());
  RxBool isLoading = false.obs;
  RxBool isClickedOnSignUp = false.obs;
  var signUpFormKey = GlobalKey<FormState>();
  var passwordFormKey = GlobalKey<FormState>();
  var confirmpasswordFormKey = GlobalKey<FormState>();
  void onInit() {
    if (Get.arguments != null) {
      mobileNumber.text = Get.arguments['mobileNumber'];
      password.text = Get.arguments['password'];
      confirmPassword.text = Get.arguments['password'];
      firstName.text = Get.arguments['firstName'];
      lastName.text = Get.arguments['lastName'];
    }
    super.onInit();
  }

  void signup(String mobileNumber, String firstName, String lastName,
      String password, String confirmPassword) {
    print("Signup called123.....$mobileNumber $firstName, $lastName,$password");

    isLoading.value = true;
    signupService
        .signupDetails(mobileNumber, firstName, lastName, password)
        .then((res) {
      if (res["status"] == 200) {
        isClickedOnSignUp.value = false;
        Get.delete<VerifyOtpController>(force: true);
        Get.toNamed(Routes.verifyOtpComponent, arguments: {
          'mobileNumber': mobileNumber,
          'password': password,
          'firstName': firstName,
          'lastName': lastName
        });
      } else {
        isClickedOnSignUp.value = false;

        Get.rawSnackbar(message: res['message']);
      }
      isLoading.value = false;
      // Handle response
      print('resSignup$res');
    }).catchError((onError) {
      isLoading.value = false;
      isClickedOnSignUp.value = false;
      print("Error while signup ${onError.toString()}");
      Get.rawSnackbar(message: onError.toString());
    });
  }
}

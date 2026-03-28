import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/login_service.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LogInService logInService = Get.find();

  var loginFormKey = GlobalKey<FormState>();
  final pwdKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;

  void onInit() {
    super.onInit();
  }

  login() {
    print("Login called");
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      Login login = Login();
      login.userDetails = UserDetails();
      login.userDetails!.mobileNumber = phoneNumberController.text;
      login.userDetails!.password = passwordController.text;

      logInService.logIn(login).then((loginRes) async {
        isLoading.value = false;
        print("loginRes : $loginRes");
        print("token: ${loginRes["data"]}");
        CommonService.instance.jwtToken.value = loginRes["data"];
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(CommonService.instance.jwtToken.value);
        print("logId  ${decodedToken["logId"]}");
        print(
            "logId  ${decodedToken["userType"]},${decodedToken["userType"] == 'builder'}");
        if (decodedToken["userType"] == 'builder') {
          Get.rawSnackbar(
            message:
                'The number you used is registered as a builder. Please use a different number to access the agent app.',
          );
          Get.toNamed(Routes.loginScreen);
        } else {
          CommonService.instance.agentId.value = decodedToken["logId"];
          CommonService.instance.foreKey.value = decodedToken["foreKey"];
          CommonService.instance.firstName.value =
              toBeginningOfSentenceCase(decodedToken["firstName"]).toString();
          CommonService.instance.lastName.value =
              toBeginningOfSentenceCase(decodedToken["lastName"]).toString();
          CommonService.instance.mobileNumber.value =
              decodedToken["mobileNumber"];
          CommonService.instance.profileUrl.value = decodedToken["profilePic"];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("jwtToken", CommonService.instance.jwtToken.value);
          Get.rawSnackbar(
              message: loginRes["message"],
              backgroundColor: ThemeConstants.successColor);
          CommonService.instance.selectedIndex.value = 0;
          HomeController homeController = Get.put(HomeController());
          homeController.requestPermission();
          CommonService.instance.onlyLogin.value = true;
          Get.delete<HomeController>(force: true);
          Get.toNamed(Routes.homeScreen);
          //  prefs.setString('mobileNumber', CommonService.instance.mobileNumber.value);
          // GetStorage().write("jwtToken", CommonService.instance.jwtToken.value);
        }
        //  getAgentId(CommonService.instance.jwtToken.value);
      }).catchError((onError) {
        isLoading.value = false;

        print("Error while logging ${onError.toString()}");
        if (onError != null &&
            onError is Map &&
            onError.containsKey('message')) {
          Get.rawSnackbar(message: onError['message']);

          print("getDashboardDetails onError: ${onError['message']}");
        } else {
          Get.rawSnackbar(
              message: "Please enter correct mobile number or password");
        }
      });
    }
  }

  getAgentId(jwtToken) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    print("logId  ${decodedToken["logId"]}");
    print(
        "logId  ${decodedToken["userType"]},${decodedToken["userType"] == 'builder'}");
    if (decodedToken["userType"] == 'builder') {
      Get.toNamed(Routes.loginScreen);
    } else {
      CommonService.instance.agentId.value = decodedToken["logId"];
      CommonService.instance.foreKey.value = decodedToken["foreKey"];
      CommonService.instance.firstName.value =
          toBeginningOfSentenceCase(decodedToken["firstName"]).toString();
      CommonService.instance.lastName.value =
          toBeginningOfSentenceCase(decodedToken["lastName"]).toString();
      CommonService.instance.mobileNumber.value = decodedToken["mobileNumber"];
      CommonService.instance.profileUrl.value = decodedToken["profilePic"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("jwtToken", CommonService.instance.jwtToken.value);
      //  prefs.setString('mobileNumber', CommonService.instance.mobileNumber.value);
      // GetStorage().write("jwtToken", CommonService.instance.jwtToken.value);
    }
  }
}

import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class SignupService {
  Future signupDetails(
      mobileNumber, firstName, lastName, passwordController) async {
    print("signupDetails called");
    try {
      Response response =
          await HttpUtils.getInstance().post('agent/signup', data: {
        "agentDetails": {
          "mobileNumber": "$mobileNumber",
          "firstName": "$firstName",
          "lastName": "$lastName",
          "password": "$passwordController"
        }
      });
      if (response.statusCode == 200) {
        print('signupDetails res 200');
        print('signupDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('signupDetails error ${error.response?.data}');
      return error.response?.data;
    }
  }
}

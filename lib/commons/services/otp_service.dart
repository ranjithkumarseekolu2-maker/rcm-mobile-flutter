import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class OtpService {
  Future changepaswwordDetails(
      mobilenumber, password, usertype, confirmPassword, otp) async {
    print("forgotpwd called");
    print("inside service call : $mobilenumber");
    print("inside service call : $otp");
    print("inside service call : $password");
    print("inside service call : $confirmPassword");
    try {
      Response response = await HttpUtils.getInstance()
          .post('global/verifyOtp/forgotPwd', data: {
        "profileDetails": {
          "password": "$password",
          "mobileNumber": "$mobilenumber",
          "confirmPassword": "$confirmPassword",
          "otp": "$otp",
          "userType": ""
        }
      });
      if (response.statusCode == 200) {
        print('forgotpwd res 200');
        print('forgotpwd res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('forgotpwd error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  // Future changepaswwordDetails(confirmPassword,mobileNumber,otp,password,usertype)
  // async {
  //   print("changepaswwordDetails called");
  //    print("inservice.....$mobileNumber,$otp,$password,$usertype,$confirmPassword");
  //   try {
  //     Response response =
  //         await HttpUtils.getInstance().post('global/verifyOtp/forgotPwd', data: {
  //       "profileDetails": {
  //         "confirmPassword":"$confirmPassword",
  //         "mobileNumber": "$mobileNumber",
  //         "otp":"$otp",
  //         "password": "$password",
  //         "userType":""

  //       }
  //     });
  //     if (response.statusCode == 200) {
  //       print('changepaswwordDetails res 200');
  //       print('changepaswwordDetails res $response.data');
  //       return response.data;
  //     }
  //   } on DioError catch (error) {
  //     print('changepaswwordDetails error ${error.response?.data}');
  //     throw Exception(error.response?.data);
  //   }
  // }
  Future sendotpDetails(mobileNumber) async {
    print("resendotpDetails called $mobileNumber");
    try {
      Response response = await HttpUtils.getInstance()
          .put('global/otp/forgot/password?mobileNumber=$mobileNumber', data: {
        "marketingAgencyDetails": {
          "mobileNumber": "$mobileNumber",
          "userType": "",
        }
      });
      if (response.statusCode == 200) {
        print('resendotpDetails res 200');
        print('resendotpDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('resendotpDetails error ${error.response?.data}');
      return error.response?.data;
    }
  }

  Future sendotp(mobileNumber) async {
    print("resendotpDetails called $mobileNumber");
    try {
      Response response = await HttpUtils.getInstance()
          .put('agent/resend/otp?mobileNumber=$mobileNumber');
      if (response.statusCode == 200) {
        print('resendotpDetails res 200');
        print('resendotpDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('resendotpDetails error ${error.response?.data}');
      return error.response?.data;
    }
  }

  Future verifyOtpDetails(
    mobileNumber,
    otp,
    password,
    firstName,
    lastName,
  ) async {
    print("verifyOtpDetails called ${mobileNumber},${otp}");
    int phoneNmber = int.parse(mobileNumber);
    int verifyOtp = int.parse(otp);
    print(
        "verifyOtpDetails runtimetype ${phoneNmber.runtimeType},${verifyOtp.runtimeType}");
    try {
      Response response = await HttpUtils.getInstance().post(
          'agent/verify/otp?mobileNumber=$phoneNmber&otp=$verifyOtp',
          data: {
            "agentDetails": {
              "firstName": "$firstName",
              "lastName": "$lastName",
              "mobileNumber": "$phoneNmber",
              "password": "$password"
            }
          });
      if (response.statusCode == 200) {
        print('verifyOtpDetails res 200');
        print('verifyOtpDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('verifyOtpDetails error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }
}

import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class LogInService {
  Future logIn(Login login) async {
    print("login : $login");
    print("decoded: ${json.encode(login)}");
    try {
      Response response = await HttpUtils.getInstance()
          .post('global/auth', data: json.encode(login));
      if (response.statusCode == 200) {
        print('logIn res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('logIn error ${error.response?.data}');
      return error.response?.data;
    }
  }

  Future getProjects() async {
    print("getProjects called");
    try {
      Response response = await HttpUtils.getInstance().get(
          'projects/getProject/onAgentId?agentId=${CommonService.instance.agentId.value}&limit=10&offset=0&orderBy=CREATED_AT&orderByType=asc');
      if (response.statusCode == 200) {
        print('getProjects res 200');
        print('getProjects res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getProjects error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }
}

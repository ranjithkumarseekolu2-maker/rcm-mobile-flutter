import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class NotificationsService {
  Future getAllNotifications() async {
    print("getAllNotifications called");
    try {
      Response response = await HttpUtils.getInstance().get(
          'notification/allNotifications?agentId=${CommonService.instance.agentId.value}');
      if (response.statusCode == 200) {
        print('getAllNotifications res 200');
        print('getAllNotifications res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllNotifications error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future updateNotifications() async {
    print("updateNotifications called");
    try {
      Response response = await HttpUtils.getInstance()
          .get('notification/updateViewNotifications');
      if (response.statusCode == 200) {
        print('updateNotifications res 200');

        return response.data;
      }
    } on DioError catch (error) {
      print('updateNotifications error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }
}

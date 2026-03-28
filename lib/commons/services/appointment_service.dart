import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/create_appointment.dart';
import 'package:brickbuddy/model/update_appointment.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class AppointmentService {
  Future getAllAppointments() async {
     try {
      Response response = await HttpUtils.getInstance().get(
          'appointment/allAppointments?agentId=${CommonService.instance.agentId.value}');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllAppointments error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

   Future createAppointment(CreateAppointment createAppointment) async {

    print("createAppointment: ${createAppointment.toJson()}");
    try {
      Response response = await HttpUtils.getInstance().post(
          'appointment/create', data:createAppointment.toJson());
 
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('createAppointment error ${error.response?.data}');
     throw Exception(error.response?.data);
    }
  }


     Future updateAppointment(UpdateAppointment updateAppointment) async {
     try {
      Response response = await HttpUtils.getInstance().put(
          'appointment/update', data:updateAppointment.toJson());
 
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('updateAppointment error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }


    Future getAllLeads() async {
     try {
      Response response = await HttpUtils.getInstance().get(
          'appointment/allLeads?agentId=${CommonService.instance.agentId.value}');

          
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllLeads error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

}
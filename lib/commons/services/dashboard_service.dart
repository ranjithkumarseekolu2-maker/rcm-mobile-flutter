import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/create_appointment.dart';
import 'package:brickbuddy/model/update_appointment.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class DashboardService {
  Future getDashboardDetails() async {
    try {
      Response response = await HttpUtils.getInstance().get(
          'agent/getDashboardDetails?agentId=${CommonService.instance.agentId.value}');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getDashboardDetails error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future updateColdLeadsStatus(status, coldLeadsList) async {
    print('updateColdLeadsStats called $status');
    try {
      Response response = await HttpUtils.getInstance()
          .post('jobMapping/update/$status', data: {"leads": coldLeadsList});
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('updateColdLeadsStats error ${error.response?.data}');
      return error.response?.data;
    }
  }

  Future getInactiveLeads(coldLeadsList) async {
    print('inactive leads called');
    try {
      Response response = await HttpUtils.getInstance().get(
          'jobMapping/getInactiveLeads',
          data: {"inactiveLeadsDetails": coldLeadsList});
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getInactiveLeads error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getDashboardDetailsByBuilderId(builderId) async {
    try {
      Response response = await HttpUtils.getInstance().get(
          'agent/getDashboardDetails?agentId=${CommonService.instance.agentId.value}&builderId=$builderId');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getDashboardDetailsByBuilder error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }
}

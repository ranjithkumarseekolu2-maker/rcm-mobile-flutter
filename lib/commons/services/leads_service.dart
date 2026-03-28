import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class LeadsService {
  Future getAllLeads(pageOffset) async {
    print("getLeads called");
    try {
      Response response = await HttpUtils.getInstance().get(
          'jobMapping?agentId=${CommonService.instance.agentId}&limit=10&offset=$pageOffset&orderBy=CREATED_AT&orderByType=asc');
      if (response.statusCode == 200) {
        print('getLeads res 200');
        print('getLeads res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getLeads error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getFilteredLeads(status, project, activity, builderId, offset) async {
    print("getFilteredLeads called ");
    print('statuses...010 $status,$project,$builderId,$activity,$offset');

    // Base URL
    String baseUrl = 'jobMapping?agentId=${CommonService.instance.agentId}';
    List<String> queryParams = [];

    // Add parameters conditionally
    if (builderId != null && builderId.isNotEmpty) {
      queryParams.add('builderId=$builderId');
    }
    if (status != null && status.isNotEmpty) {
      queryParams.add('agentStatus=$status');
    }
    if (project != null && project.isNotEmpty) {
      queryParams.add('projectId=$project');
    }
    if (activity != null && activity.isNotEmpty && activity != 'Active') {
      queryParams.add('leadActivity=Inactive:%20Last%20$activity%20Days');
    } else if (activity == 'Active') {
      queryParams.add('leadActivity=$activity:%20Last%2030%20Days');
    }

    // Add common query parameters
    queryParams.add('limit=10');
    queryParams.add('offset=$offset');
    queryParams.add('orderBy=CREATED_AT');
    queryParams.add('orderByType=asc');

    // Construct final URL
    String url = '$baseUrl&${queryParams.join('&')}';
    print("Constructed URL: $url");

    try {
      Response response = await HttpUtils.getInstance().get(url);
      if (response.statusCode == 200) {
        print('getFilteredLeads res 200');
        print('getFilteredLeads res ${response.data}');
        return response.data;
      }
    } on DioError catch (error) {
      print('getFilteredLeads error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future leadDetails(leadId) async {
    print("getLeadDetails called");
    try {
      Response response = await HttpUtils.getInstance()
          .post('jobMapping/contactRequest/get', data: {
        "jobMappingDetails": {"contactJobMappingId": "$leadId"}
      });
      if (response.statusCode == 200) {
        print('getLeadDetails res 200');
        print('getLeadDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getLeadDetails error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future updateDetails(leadId, description, status) async {
    print("updateDetails called");
    try {
      Response response =
          await HttpUtils.getInstance().post('jobMapping/update/status', data: {
        "jobMappingDetails": {
          "contactJobMappingId": "$leadId",
          "description": "$description",
          "status": "$status"
        }
      });
      if (response.statusCode == 200) {
        print('updateDetails res 200');
        print('updateDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('updateDetails error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future searchLeads(
      status, project, activity, builderId, offset, searchValue) async {
    print("getLeads called");
    var url;
    print(
        "getFilteredLeads called  "); //'jobMapping?agentId=${CommonService.instance.agentId}&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue'
    print('statuses...010 $status,$project,$builderId,$activity,$offset');
    if (activity == 'Active') {
      if (builderId != null) {
        url =
            'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&leadActivity=$activity:%20Last%2030%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
      } else {
        url =
            'jobMapping?agentId=${CommonService.instance.agentId}&leadActivity=$activity:%20Last%2030%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
      }
    } else if (status.isNotEmpty &&
        project.isEmpty &&
        activity.isEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&agentStatus=$status&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        activity.isEmpty &&
        project.isNotEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&projectId=$project&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        project.isEmpty &&
        activity.isNotEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        activity.isNotEmpty &&
        project.isEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&agentStatus=$status&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        project.isNotEmpty &&
        activity.isEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&projectId=$project&agentStatus=$status&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        activity.isNotEmpty &&
        project.isNotEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&projectId=$project&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        project.isNotEmpty &&
        activity.isNotEmpty &&
        builderId.isEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&projectId=$project&agentStatus=$status&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        project.isEmpty &&
        activity.isEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        project.isEmpty &&
        activity.isEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&agentStatus=$status&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        project.isNotEmpty &&
        activity.isEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&projectId=$project&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        project.isEmpty &&
        activity.isNotEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        project.isEmpty &&
        activity.isNotEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&agentStatus=$status&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isEmpty &&
        project.isNotEmpty &&
        activity.isNotEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&projectId=$project&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        project.isNotEmpty &&
        activity.isNotEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&projectId=$project&agentStatus=$status&leadActivity=Inactive:%20Last%20$activity%20Days&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    } else if (status.isNotEmpty &&
        project.isNotEmpty &&
        activity.isEmpty &&
        builderId.isNotEmpty) {
      url =
          'jobMapping?agentId=${CommonService.instance.agentId}&builderId=$builderId&projectId=$project&agentStatus=$status&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchValue';
    }

    try {
      Response response = await HttpUtils.getInstance().get(url);
      if (response.statusCode == 200) {
        print('getLeads res 200');
        print('getLeads res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getLeads error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future createLead(firstName, number, projId, email) async {
    print("createLead called $firstName,$number,$email,$projId");
    try {
      Response response = await HttpUtils.getInstance().post(
          'jobMapping/createLead?agentId=${CommonService.instance.agentId.value}',
          data: {
            "leadDetails": {
              "firstName": "$firstName",
              "lastName": "",
              "primaryContactNo": "$number",
              "secondaryContactNo": "",
              "email": "$email",
              "address": "",
              "notes": "",
              "workInfo": "",
              "projectId": "$projId"
            }
          });
      if (response.statusCode == 200) {
        print('createLead res 200');
        print('createLead res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('createLead error ${error.response?.data}');
      return error.response?.data;
    }
  }
}

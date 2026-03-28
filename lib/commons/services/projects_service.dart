import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/constants/project_layout_file.dart';
import 'package:brickbuddy/model/createProject.dart';
import 'package:brickbuddy/model/create_builder.dart';
import 'package:brickbuddy/model/refer_buddy.dart';
import 'package:brickbuddy/model/updatefile.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ProjectsService {
  Future getProjects() async {
    print("getProjects called");
    try {
      Response response = await HttpUtils.getInstance().get(
          'projects/getProject/onAgentId?agentId=${CommonService.instance.agentId.value}&limit=10&offset=0&orderBy=CREATED_AT&orderByType=asc');
      if (response.statusCode == 200) {
        print('getProjects res 200');
        //  print('getProjects res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getProjects error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getAllProjects() async {
    print("getAllProjects called");
    try {
      Response response = await HttpUtils.getInstance().get(
          'projects/getProject/onAgentId?agentId=${CommonService.instance.agentId.value}');
      if (response.statusCode == 200) {
        print('getAllProjects res 200');
        //  print('getProjects res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllProjects error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getAllMyBuilders() async {
    print("getAllMyBuilders called");
    try {
      Response response = await HttpUtils.getInstance().get(
          'agent/agentBuilderMapping?agentId=${CommonService.instance.agentId.value}');
      if (response.statusCode == 200) {
        print('getAllMyBuilders res 200');
        //  print('getProjects res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllMyBuilders error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future loadMoreProjects(offset) async {
    print("loadMoreProjects called123 $offset");
    try {
      Response response = await HttpUtils.getInstance().get(
          'projects/getProject/onAgentId?agentId=${CommonService.instance.agentId.value}&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc');
      if (response.statusCode == 200) {
        print('loadMoreProjects res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('loadMoreProjects error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getAllBuilders() async {
    try {
      Response response =
          await HttpUtils.getInstance().get('projects/getAllBuilders');
      if (response.statusCode == 200) {
        print('getAllBuilders res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllBuilders error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getBuildersByAgentId() async {
    try {
      Response response = await HttpUtils.getInstance().get(
          'agent/agentBuilderMapping/buildersDD1?agentId=${CommonService.instance.agentId.value}');
      if (response.statusCode == 200) {
        print('getBuildersByAgentId res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getBuildersByAgentId error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getProjectsByBuilderId(builderId) async {
    try {
      Response response =
          await HttpUtils.getInstance().get('projects?builderId=$builderId');
      if (response.statusCode == 200) {
        print('getProjectsByBuilderId res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getProjectsByBuilderId error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getProjectsByBuilderIdInLeads(builderId) async {
    try {
      Response response = await HttpUtils.getInstance()
          .get('projects/getProject/onAgentId?builderId=$builderId');
      if (response.statusCode == 200) {
        print('getProjectsByBuilderId res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getProjectsByBuilderId error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  getDetailsByProjectId(projectId) async {
    try {
      Response response = await HttpUtils.getInstance()
          .get('projects/getProject?projectId=$projectId');
      if (response.statusCode == 200) {
        print('getDetailsByProjectId res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getDetailsByProjectId error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  getCountries() async {
    try {
      Response response =
          await HttpUtils.getInstance().get('bbUser/master/country');
      if (response.statusCode == 200) {
        print('getCountries res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getCountries error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  getStatesByCountryId(countryId) async {
    try {
      Response response = await HttpUtils.getInstance()
          .get('bbUser/master/state/active/$countryId');
      if (response.statusCode == 200) {
        print('getStates res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getStates error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  getCitiesByStateId(cntId, stateId) async {
    try {
      Response response = await HttpUtils.getInstance()
          .get('bbUser/master/city/active/$cntId/$stateId');
      if (response.statusCode == 200) {
        print('getCities res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getCities error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  getAllAmenities() async {
    try {
      Response response =
          await HttpUtils.getInstance().get('bbUser/master/amenity/active');
      if (response.statusCode == 200) {
        print('getAllAmenities res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllAmenities error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  createProject(Project proj) async {
    try {
      Response response = await HttpUtils.getInstance()
          .post('agent/createProject', data: jsonEncode(proj));
      if (response.statusCode == 200) {
        print('createProject res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('createProject error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  uploadDocuments(List<ProjectLayoutFile> filesList, projectId, subType) async {
    FormData formData = FormData();

    filesList.forEach((f) async {
      var file = MapEntry(
        'file',
        await MultipartFile.fromFile(f.path!, filename: f.name),
      );
      formData.files.add(file);
    });

    try {
      var userId = CommonService.instance.agentId.value;
      print("projectId:$projectId");
      Response response = await HttpUtils.getInstance().post(
          'global/file/uploadFile?type=projectPic&id=$projectId&userType=agent&userId=$userId&subType=$subType',
          data: formData);
      if (response.statusCode == 200) {
        print('uploadDocuments res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('uploadDocuments error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  uploadCsv(path) async {
    print("path: $path");
    var agentId = CommonService.instance.agentId.value;
    FormData formData = FormData();

    formData.files.add(MapEntry('file', await MultipartFile.fromFile(path)));
    try {
      Response response = await HttpUtils.getInstance()
          .post('global/contacts/uploadCsv?agentId=$agentId', data: formData);
      if (response.statusCode == 200) {
        print('uploadCsv res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('uploadCsv error ${error.response?.data}');
      return error.response?.data;
    }
  }

  deleteDocument(projectId, id, type) async {
    var obj = {
      "updatedImages": [id]
    };
    try {
      Response response = await HttpUtils.getInstance()
          .put('projects/updateImages/$projectId/$type', data: obj);
      if (response.statusCode == 200) {
        print('deleteDocument res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('deleteDocument error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  updateFile(UpdateFile updateFile) async {
    try {
      Response response = await HttpUtils.getInstance()
          .put('global/file/updateFile', data: updateFile.toJson());
      if (response.statusCode == 200) {
        print('updateFile res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('updateFile error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  getProjectsBySearchValue(offset, searchTerm) async {
    print('offset123 $offset,$searchTerm');
    try {
      Response response = await HttpUtils.getInstance().get(
          'projects/getProject/onAgentId?agentId=${CommonService.instance.agentId.value}&limit=10&offset=$offset&orderBy=CREATED_AT&orderByType=asc&searchValue=$searchTerm');
      if (response.statusCode == 200) {
        print('getProjectsBySearchValue res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('getProjectsBySearchValue error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  updateProject(projectId, Project proj) async {
    try {
      Response response = await HttpUtils.getInstance()
          .put('projects/$projectId', data: jsonEncode(proj));
      if (response.statusCode == 200) {
        print('updateProject res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('updateProject error ${error.response?.data}');
      return error.response?.data;
    }
  }

  refer(ReferBuddy refer) async {
    print('referapi ${jsonEncode(refer)}');
    try {
      Response response = await HttpUtils.getInstance()
          .post('agent/sendReferral', data: jsonEncode(refer));
      if (response.statusCode == 200) {
        print('refer res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('refer error ${error.response?.data}');
      return error.response?.data;
    }
  }

  createBuilder(CreateBuilder createBuilder) async {
    try {
      Response response = await HttpUtils.getInstance()
          .post('agent/createBuilder', data: jsonEncode(createBuilder));
      if (response.statusCode == 200) {
        print('refer res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('createBuilder error ${error.response?.data}');
      return error.response?.data;
    }
  }

  Future requestToBuilder(builderId) async {
    print('requestToBuilder Called');
    try {
      Response response = await HttpUtils.getInstance()
          .post('/agent/agentbuildermapping', data: {
        "mappingDetails": {
          "agentId": "${CommonService.instance.agentId.value}",
          "builderId": "$builderId"
        }
      });
      if (response.statusCode == 200) {
        print('requestToBuilder res 200');
        print('requestToBuilder res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('requestToBuilder error ${error.response?.data}');
      return error.response?.data;
    }
  }

  deleteProject(jobApplicationId) async {
    print('jobId ${jobApplicationId}');
    try {
      Response response = await HttpUtils.getInstance().put(
          'jobApplication/status/$jobApplicationId',
          data: {"jobApplicationId": "$jobApplicationId", "status": 2});
      if (response.statusCode == 200) {
        print('deleteProject res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('deleteProject error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  activateProject(projectId) async {
    try {
      Response response =
          await HttpUtils.getInstance().put('projects/$projectId/1');
      if (response.statusCode == 200) {
        print('activateProject res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('activateProject error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }
}

import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/constants/project_layout_file.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:brickbuddy/model/updatefile.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ProfileService {
  Future saveLeadAge(int age) async {
    print("saveLeadAge called");

    try {
      Response response = await HttpUtils.getInstance()
          .post('global/edit/ageleads', data: {"leadAgeConfig": age});
      if (response.statusCode == 200) {
        print('saveLeadAge res 200');
        print('saveLeadAge res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('saveLeadAge error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future getProfile() async {
    print("getProfile called ${CommonService.instance.agentId}");
    try {
      Response response = await HttpUtils.getInstance()
          .get('agent?agentId=${CommonService.instance.foreKey.value}');
      if (response.statusCode == 200) {
        print('getProfile res 200');
        print('getProfile res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getProfile error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }
  //global/edit/profile

  Future updateProfile(
      firstName, lastName, email, pwd, confirmPwd, image) async {
    print("updateProfile called $firstName,$lastName,$email,$pwd,$confirmPwd");
    try {
      Response response =
          await HttpUtils.getInstance().post('global/edit/profile', data: {
        "profileDetails": {
          "emailId": "$email",
          "firstName": "$firstName",
          "lastName": "$lastName",
          "logId": "3fad1030-b09b-11ee-ab1e-2db212058265",
          "password": "$pwd",
          "profilePic": "$image",
          "userRole": "Super Admin",
          "userType": "agent"
        }
      });
      if (response.statusCode == 200) {
        print('saveLeadAge res 200');
        print('saveLeadAge res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('saveLeadAge error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  uploadDocuments(fileName, path) async {
    FormData formData = FormData();

    print('pathhh123 ${fileName},${path}');
    var file = MapEntry(
      'file',
      await MultipartFile.fromFile(path!, filename: fileName),
    );
    formData.files.add(file);

    try {
      Response response = await HttpUtils.getInstance().post(
          'global/file/uploadFile?type=profilePic&id=${CommonService.instance.agentId}',
          data: formData);

      if (response.statusCode == 200) {
        print('upload profilePic res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('upload profilePic error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  getKycDetails() async {
    print("foreKey: ${CommonService.instance.foreKey.value}");
    try {
      Response response = await HttpUtils.getInstance().get(
          'global/get/kycDetails?userType=agent&userId=${CommonService.instance.foreKey.value}');
      if (response.statusCode == 200) {
        print('getKycDetails res 200');
        print('getKycDetails res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getKycDetails error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  uploadKYCDocuments(fileName, path, subType) async {
    FormData formData = FormData();

    var file = MapEntry(
      'file',
      await MultipartFile.fromFile(path!, filename: fileName),
    );
    formData.files.add(file);

    print("agentId: ${CommonService.instance.foreKey.value}");

    try {
      Response response = await HttpUtils.getInstance().post(
          'global/file/uploadFile?type=kycUpload&id=${CommonService.instance.foreKey.value}&userType=agent&subType=$subType',
          data: formData);

      if (response.statusCode == 200) {
        print('upload uploadKYCDocuments res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('upload profilePic error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  deleteDocument(id, type) async {
    print('12id123 $id');
    var obj = {
      "updatedImages": [id]
    };
    try {
      Response response = await HttpUtils.getInstance().put(
          'global/updateImages/${CommonService.instance.foreKey.value}/$type',
          data: obj);
      if (response.statusCode == 200) {
        print('deleteDocument KYC res 200');
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

  uploadProfile(fileName, path) async {
    FormData formData = FormData();

    var file = MapEntry(
      'file',
      await MultipartFile.fromFile(path!, filename: fileName),
    );
    formData.files.add(file);

    print("agentId: ${CommonService.instance.agentId.value}");

    try {
      Response response = await HttpUtils.getInstance().post(
          'global/file/uploadFile?type=profilePic&id=${CommonService.instance.agentId.value}',
          data: formData);

      if (response.statusCode == 200) {
        print('upload uploadKYCDocuments res 200');
        return response.data;
      }
    } on DioError catch (error) {
      print('upload profilePic error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }
}

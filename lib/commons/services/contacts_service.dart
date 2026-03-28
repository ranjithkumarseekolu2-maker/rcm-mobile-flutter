import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/model/assign_project.dart';
import 'package:brickbuddy/model/login.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ContactService {
  Future getAllContacts(offset) async {
    print("getContacts called: $offset");
    print(
        "agentId123: ${CommonService.instance.agentId.value}, ${CommonService.instance.jwtToken.value}");
    try {
      Response response = await HttpUtils.getInstance().get(
          'global/contacts?agentId=${CommonService.instance.agentId.value}&limit=10&offset=$offset&orderBy=FIRST_NAME&orderByType=asc');
      if (response.statusCode == 200) {
        print('getContacts res 200');
        print('getContacts res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('getContacts error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future addcontact(contactId, firstName, lastName, address, email, notes,
      primaryNumber, secondaryNumber, workinfo) async {
    print("addcontact called");
    try {
      Response response = await HttpUtils.getInstance().post(
          'global/contacts?agentId=${CommonService.instance.agentId.value}',
          data: {
            "contactDetails": {
              "conId": "",
              "firstName": "$firstName",
              "lastName": "$lastName",
              "address": "$address",
              "email": "$email",
              "notes": "$notes",
              "primaryNumber": "$primaryNumber",
              "secondaryNumber": "$secondaryNumber",
              "workinfo": "$workinfo",
            }
          });
      if (response.statusCode == 200) {
        print('addcontact res 200');
        print('addcontact res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('addcontact error ${error.response?.data}');
      return error.response?.data;
      // throw Exception(error.response?.data);
    }
  }

  Future<void> deleteContact(conId) async {
    print("deleteContact called");
    try {
      Response response = await HttpUtils.getInstance()
          .delete('global/contacts/deleteContacts/$conId');
      if (response.statusCode == 204) {
        // Contact deleted successfully
        print('deleteContact successful');
      } else {
        // Handle other status codes
        print('Failed to delete contact: ${response.statusCode}');
      }
    } on DioError catch (error) {
      print('deleteContact error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  Future editContact(firstName, lastName, primaryNumber, secondaryNumber,
      workinfo, email, address, notes, conId) async {
    print('Conid: $conId');
    print('Firstname: $firstName');
    print('Lastname: $lastName');
    print('PrimaryNum: $primaryNumber');
    print('SecondaryNum: $secondaryNumber');
    print('Workinfo:$workinfo');
    print('Email:$email');
    print('Address:$address');
    print('Notes:$notes');

    try {
      Response response =
          await HttpUtils.getInstance().put('global/contacts/$conId', data: {
        "contactDetails": {
          "conId": "$conId",
          "firstName": "$firstName",
          "lastName": "$lastName",
          "primaryNumber": "$primaryNumber",
          "secondaryNumber": "$secondaryNumber",
          "email": "$email",
          "address": "$address",
          "notes": "$notes",
          "workinfo": "$workinfo",
          "profilePic": null,
          "builderId": null,
          "referredBy": null,
          "projectId": null,
          "createdAt": DateTime.now().toIso8601String(),
          "updatedBy": null,
          "updatedAt": DateTime.now().toIso8601String(),
          "status": 1,
          "createdUser": {
            "FIRST_NAME": "Santhoshi",
            "LAST_NAME": "Srimanthula"
          },
          "profilepic": null
        }
      });
      if (response.statusCode == 200) {
        print('editContact res 200');
        print('editContact res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('editContact error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  uploadMobileContacts(contactsList) async {
    print('contactsList $contactsList');
    try {
      Response response = await HttpUtils.getInstance().post(
          'global/contacts/uploadMobileContacts',
          data: {"contacts": contactsList});
      if (response.statusCode == 200) {
        print('uploadMobileContacts res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('uploadMobileContacts error ${error.response?.data}');
      return error.response?.data;
    }
  }

  Future getAllContactsBySearchValue(offset, searchTerm) async {
    print("getAllContactsBySearchValue called: $offset");
    try {
      Response response = await HttpUtils.getInstance().get(
          '/global/contacts?agentId=${CommonService.instance.agentId.value}&limit=10&offset=$offset&orderBy=FIRST_NAME&orderByType=asc&searchValue=$searchTerm');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllContactsBySearchValue error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  uploadContactPhoto(fileName, path, conId) async {
    print('conId123 $conId');
    print('token123 ${CommonService.instance.jwtToken}');
    FormData formData = FormData();

    var file = MapEntry(
      'file',
      await MultipartFile.fromFile(path!, filename: fileName),
    );
    formData.files.add(file);
    try {
      Response response = await HttpUtils.getInstance()
          .post('global/file/uploadFile?type=contactPic&id=$conId',
              data: formData)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('upload uploadKYCDocuments res 200');
        return response.data;
      } else {
        // Handle server errors
        print('Server Error: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      // Handle timeout
      print('Request Timeout: $e');
    } on DioError catch (error) {
      print('upload profilePic error ${error.response?.data}');
      // throw Exception(error.response?.data);
      return error.response?.data;
    }
  }

  Future getAllProjects() async {
    try {
      Response response =
          await HttpUtils.getInstance().get('projects/getProject/onAgentId');
      if (response.statusCode == 200) {
        return response.data;
      }
    } on DioError catch (error) {
      print('getAllProjects error ${error.response?.data}');
      throw Exception(error.response?.data);
    }
  }

  assignProject(AssignProject assignProject) async {
    try {
      Response response = await HttpUtils.getInstance()
          .post('jobMapping/create/fromBuilder', data: assignProject.toJson());
      if (response.statusCode == 200) {
        print('assignProject res $response.data');
        return response.data;
      }
    } on DioError catch (error) {
      print('assignProject error ${error.response?.data}');
      return error.response?.data;
    }
  }
}

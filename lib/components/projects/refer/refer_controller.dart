import 'dart:io';

import 'package:brickbuddy/commons/services/contacts_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/refer_buddy.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReferController extends GetxController {
  ContactService contactService = Get.put(ContactService());
  ProjectsService projectService = Get.find();

  RxBool isLoading = false.obs;
  RxList contactsList = [].obs;
  RxBool issearchValue = false.obs;
  RxString conId = ''.obs;
  RxBool isEdit = false.obs;
  RxBool isEnable = false.obs;

  RxBool isContactsLoading = false.obs;

  RxList<dynamic> mobileContactsList = <dynamic>[].obs;
  RxList<dynamic> selectedContacts = <dynamic>[].obs;

  RxInt pageOffset = 0.obs;

  ScrollController scrollController = ScrollController();
  RxBool isInfiniteLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  RxString projectId = "".obs;
  RxString projectUrl = "".obs;
  RxList<Contacts> referedContacts = <Contacts>[].obs;

  @override
  void onInit() async {
    print("Get.arguments: ${Get.arguments}");
    if (Get.arguments != null) {
      projectId.value = Get.arguments["projectId"];
      projectUrl.value = Get.arguments["projectUrl"];
    }

    print("project id: ${projectId.value}");
    print("project url: ${projectUrl.value}");
    scrollController.addListener(scrollListener);
    await getAllContacts();
    super.onInit();
  }

  void scrollListener() {
    print("Scroll listner called");
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print("reached limit");
      if (isInfiniteLoading.value == false) {
        if (issearchValue.value) {
          pageOffset.value = pageOffset.value + 10;
          loadMoreSearchContacts();
        } else {
          loadMoreItems();
        }
      }
    }
  }

  loadMoreItems() {
    isInfiniteLoading.value = true;
    contactService.getAllContacts(pageOffset.value).then((res) {
      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });

        pageOffset.value = pageOffset.value + 10;
      }
      isInfiniteLoading.value = false;
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("loadMoreItems  err$onError");
    });
  }

  getAllContacts() {
    contactsList.clear();
    isLoading.value = true;
    contactService.getAllContacts(pageOffset.value).then((res) {
      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          print("contacts: ${c['firstName']}");
          print("contacts: ${c['profilepic']}");
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
      }
      pageOffset.value = 10;
      isLoading.value = false;

      print('refer conList ${contactsList[5]}');
    }).catchError((e) {
      print('getContacts error: $e');
      isLoading.value = false;
    });
  }

  getContactsBySearchValue() {
    contactsList.clear();
    print("before contacts length: ${contactsList.length}");
    isLoading.value = true;
    contactService
        .getAllContactsBySearchValue(0, searchController.text)
        .then((res) {
      isLoading.value = false;
      issearchValue.value = true;
      print("length: ${res['data']['contacts'].length}");
      contactsList.clear();
      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
      }
      print("After contacts length: ${contactsList.length}");
    }).catchError((onError) {
      isLoading.value = false;
      print("getContactsBySearchValue onError: $onError");
    });
  }

  refer() {
    isLoading.value = true;
    print('refer called.... ${projectUrl.value}');
    ReferBuddy refer = ReferBuddy();
    refer.projectId = projectId.value;
    refer.projectUrl = projectUrl.value;
    if (selectedContacts.isNotEmpty) {
      for (var s in selectedContacts) {
        Contacts c = Contacts();
        c.conId = s["conId"];
        c.status = 1;
        c.mobileNumber = s["mobileNumber"];
        referedContacts.add(c);
      }
    }
    refer.contacts = [];
    refer.contacts!.addAll(referedContacts);
    print("refer.contacts ${refer.contacts}");
    print("final referto json: ${refer.toJson()}");
    projectService.refer(refer).then((res) {
      isLoading.value = false;

      print("res: ${res}");
      Get.delete<ProjectsController>(force: true);
      Get.toNamed(Routes.projects);
      Get.rawSnackbar(
          message: res["message"],
          backgroundColor: ThemeConstants.successColor);
    }).catchError((err) {
      isLoading.value = false;

      print("catch error res: ${err}");
    });
  }

  loadMoreSearchContacts() {
    isInfiniteLoading.value = true;
    contactService
        .getAllContactsBySearchValue(pageOffset.value, searchController.text)
        .then((res) {
      isLoading.value = false;
      print("length: ${res['data']['contacts'].length}");
      //  contactsTotalCount.value = res['data']['contacts'].length;
      // contactsList.clear();

      if (res["data"]["contacts"] != null) {
        res["data"]["contacts"].forEach((c) {
          var obj = {
            "conId": c["conId"],
            "firstName": c["firstName"],
            "lastName": c["lastName"],
            "primaryNumber": c["primaryNumber"],
            "secondaryNumber": c["secondaryNumber"],
            "email": c["email"],
            "address": c["address"],
            "notes": c["notes"],
            "workinfo": c["workinfo"],
            "profilePic": c['profilepic'] != null
                ? c['profilepic']['URL']
                : c['profilepic'],
            "isChecked": false
          };
          contactsList.add(obj);
        });
      }
      isInfiniteLoading.value = false;
    }).catchError((onError) {
      isInfiniteLoading.value = false;
      print("loadMoreItems  err$onError");
    });
  }
}

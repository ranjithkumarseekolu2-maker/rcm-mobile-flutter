import 'dart:ffi';
import 'dart:ui';

import 'package:brickbuddy/commons/services/appointment_service.dart';
import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/contacts_service.dart';
import 'package:brickbuddy/commons/services/dashboard_service.dart';
import 'package:brickbuddy/commons/services/notifications_service.dart';
import 'package:brickbuddy/commons/services/profile_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/commons/utils/date_util.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/appointment.dart';
import 'package:brickbuddy/model/notification.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  ProjectsService projectsService = Get.put(ProjectsService());
  DashboardService dashboardService = Get.find();
  AppointmentService appointmentService = Get.find();
  ContactService contactService = Get.find();
  ProfileService profileService = Get.put(ProfileService());
  RxBool isContactsLoading = false.obs;
  RxList<dynamic> mobileContactsList = <dynamic>[].obs;
  RxInt activeLeadsCount = 0.obs;
  RxInt coldLeadsCount = 0.obs;
  RxInt closedLostLeadsCount = 0.obs;
  RxInt closedWonLeadsCount = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isStatusLoading = false.obs;
  RxList projectsList = [].obs;
  RxList projectsNamesList = [].obs;
  RxString selectProject = ''.obs;
  RxString selectProjectId = ''.obs;
  RxString SelectedProjectName = ''.obs;
  RxString selectBuilderId = ''.obs;
  RxList profileRes = [].obs;
  RxList statusCounts = [0, 0, 0, 0, 0, 0, 0, 0, 0].obs;
  TextEditingController projNameController = TextEditingController();
  TextEditingController builderNameController = TextEditingController();
  RxBool isDashboardLoading = false.obs;
  List<ChartData> chartData = <ChartData>[
    ChartData(
      1,
      Color.fromRGBO(152, 196, 253, 1),
    ),
    ChartData(
      2,
      Color.fromRGBO(174, 116, 250, 1),
    ),
    ChartData(
      10,
      Color.fromRGBO(154, 79, 253, 1),
    ),
    ChartData(
      5,
      Color.fromRGBO(150, 77, 247, 1),
    ),
    ChartData(
      0,
      Color.fromRGBO(144, 62, 250, 1),
    ),
    ChartData(
      0,
      Color.fromRGBO(109, 25, 219, 1),
    ),
    ChartData(
      0,
      Color.fromRGBO(94, 10, 204, 1),
    ),
    ChartData(
      1,
      Color.fromRGBO(82, 7, 180, 1),
    ),
    ChartData(
      2,
      Color.fromRGBO(58, 2, 133, 1),
    )
  ];
  RxList appointmentList = [].obs;
  NotificationsService notificationsService = Get.find();
  RxInt touchedIndex = 0.obs;
  RxInt contactsTotalCount = 0.obs;
  final List allStatuses = [
    'Pre Qualify',
    'Qualify',
    'Schedule Site Visit',
    'Site Visit',
    'Negotiation In Progress',
    'Payment In Progress',
    'Agreement',
    'Closed Won',
    'Closed Lost'
  ];

  RxString notificationsCount = "".obs;

  RxList<BuddyNotification> notificationsList = <BuddyNotification>[].obs;
  final Map<String, double> dataMap = {
    'Pre Qualify': 1,
    'Qualify': 1,
    'Schedule Site Visit': 1,
    'Site Visit': 1,
    'Negotiation In Progress': 1,
    'Payment In Progress': 1,
    'Agreement': 1,
    'Closed  Won': 1,
    'Closed Lost': 1,
  };
  RxList coldLeadsList = [].obs;
  RxList inactveLeadsList = [].obs;

  @override
  void onInit() async {
    super.onInit();

    await getDashboardDetails();
    await getAllAppoitments();
    await getAgentProfile();
    await getAllNotifications();
    await getBuilders();

    await getAllContacts();
    CommonService.instance.getEstablishedYears();
  }

  tapOnPieChart(FlTouchEvent event, PieTouchResponse? response) {
    if (response != null) {
      final sectionIndex = response.touchedSection!.touchedSectionIndex;
      final value = response.touchedSection!.touchedSection!.value;
      CommonService.instance.selectedIndex.value = 3;
      Get.delete<LeadsListingController>(force: true);
      Get.toNamed(Routes.leads, arguments: {
        'status': allStatuses[sectionIndex].toString(),
        'projectId': selectProjectId.value,
        'builderId': selectBuilderId.value
      });
      print('selProj $SelectedProjectName');
      print('index... $sectionIndex');
      print('indvalue... $value');
      print('statusIndexbased ${allStatuses[sectionIndex]}');
    }
  }

  getDashboardDetails() {
    isDashboardLoading.value = true;
    projectsList.clear();
    projectsNamesList.clear();
    coldLeadsList.clear();
    dashboardService.getDashboardDetails().then((res) {
      // print("getDashboardDetails333 res: ${res['data']['leadStatusCounts']}");
      // print(
      //     "getDashboardDetails222 res: ${res['data']['leadStatusCounts'].length}");
      // print("getDashboardDetails120 res: ${res['data']['projects']}");
      projectsList.addAll(res['data']['projects']);
      // print('projList $projectsList');
      if (res['data']['projects'].isNotEmpty) {
        SelectedProjectName.value = projectsList[0]['projectName'];
        projectsList.forEach((element) {
          if (element['status'] == 1) {
            projectsNamesList.add({
              'projId': element['projectId'],
              'projName': element['projectName']
            });
          }
        });
      }
      if (res['data']['leadStatusCounts'] != null) {
        statusCounts.clear();
        CommonService.instance.statusCount.clear();
        res['data']['leadStatusCounts'].forEach((e) {
          print('value000 ${e["value"]}');
          statusCounts.add(e["value"]);
          CommonService.instance.statusCount.add(e["value"]);
        });
      }
      // print('projNameList $projectsNamesList');
      // print('resssss ${res['data']['activeLeads'].length}');

      //  print('projList000 ${projectsList[0]['projectName']}');
      activeLeadsCount.value = res['data']['activeLeads'].length;
      coldLeadsCount.value = res['data']['coldLeads'].length;
      closedLostLeadsCount.value = res['data']['closedLost'].length;
      closedWonLeadsCount.value = res['data']['closedWon'].length;
      //  print("status count: ${statusCounts}");
      coldLeadsList.addAll(res['data']['coldLeads']);

      Future.delayed(const Duration(milliseconds: 50),
          () => isDashboardLoading.value = false);
    }).catchError((onError) {
      isLoading.value = false;
      print("getDashboardDetails onError: $onError");
    });
  }

  updateColdLeadsStats(status) {
    print('update cold leads called');
    isLoading.value = true;
    dashboardService
        .updateColdLeadsStatus(status, coldLeadsList)
        .then((res) async {
      print('res....1234.. ${res}');
      await getDashboardDetails();
      Get.rawSnackbar(
          message: res["message"],
          backgroundColor: ThemeConstants.successColor);
      isLoading.value = false;
    }).catchError((e) {
      print('getProjects error: $e');
      isLoading.value = false;
    });
  }

  getBuilders() {
    isLoading.value = true;
    projectsService.getBuildersByAgentId().then((buildersRes) {
      CommonService.instance.builders.clear();
      print("buildersRes: $buildersRes");
      CommonService.instance.builders.addAll(buildersRes["data"]);
      print("builders length: ${CommonService.instance.builders.length}");
      print("builders length123: ${CommonService.instance.builders}");
      Future.delayed(
          const Duration(milliseconds: 500), () => isLoading.value = false);
    }).catchError((error) {
      print("Error while fetching getBuilders: $error");
    });
  }

  getDashboardDetailsByBuilderId(builderId) {
    isLoading.value = true;
    projectsList.clear();
    projectsNamesList.clear();
    dashboardService.getDashboardDetailsByBuilderId(builderId).then((res) {
      print("getDashboardDetailsByBuilder res: $res");
      projectsList.addAll(res['data']['projects']);
      if (res['data']['projects'].isNotEmpty) {
        SelectedProjectName.value = projectsList[0]['projectName'];
        projectsList.forEach((element) {
          if (element['status'] == 1) {
            projectsNamesList.add({
              'projId': element['projectId'],
              'projName': element['projectName']
            });
          }
        });
      }
      if (res['data']['leadStatusCounts'] != null) {
        statusCounts.clear();
        CommonService.instance.statusCount.clear();
        res['data']['leadStatusCounts'].forEach((e) {
          statusCounts.add(e["value"]);
          CommonService.instance.statusCount.add(e["value"]);
        });
      }
      // print('projNameList $projectsNamesList');
      // print('resssss ${res['data']['activeLeads'].length}');
      // print('projList000 ${projectsList[0]['projectName']}');
      activeLeadsCount.value = res['data']['activeLeads'].length;
      coldLeadsCount.value = res['data']['coldLeads'].length;
      closedLostLeadsCount.value = res['data']['closedLost'].length;
      closedWonLeadsCount.value = res['data']['closedWon'].length;
      // print("status count: ${statusCounts}");
      Future.delayed(
          const Duration(milliseconds: 50), () => isLoading.value = false);
    }).catchError((onError) {
      isLoading.value = false;
      print("getDashboardDetails onError: $onError");
    });
  }

  getAllNotifications() async {
    isLoading.value = true;
    notificationsService.getAllNotifications().then((res) async {
      print("getAllNotifications  $res");

      if (res["data"] != null) {
        res["data"]['notificationDetails'].forEach((n) {
          notificationsList.add(BuddyNotification.fromJson(n));
        });

        // print("sssss: ${prefs.read("notidicationsSeen")}");
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // if (prefs.getInt("notidicationsSeen") != null) {
        //   int? notificationsSeen = prefs.getInt("notidicationsSeen");
        //   CommonService.instance.allNotificationsCount.value =
        //       (notificationsList.length - notificationsSeen!);
        // } else {
        CommonService.instance.allNotificationsCount.value =
            res["data"]['unReadNotificationCount'];
        //  }

        print("final: ${CommonService.instance.allNotificationsCount.value}");
      }
      Future.delayed(
          const Duration(milliseconds: 50), () => isLoading.value = false);

      print('notfLen ${notificationsList.length}');
    }).catchError((onError) {
      isLoading.value = false;

      print("getAllNotifications onError: ${onError}");
    });
  }

  getAllContacts() async {
    print('get all contacts called...');

    await contactService.getAllContacts(0).then((res) {
      contactsTotalCount.value = res['data']['count'];
      print('contactsCount000 ${contactsTotalCount.value}');
      requestPermission();
    }).catchError((e) {
      print('getContacts error: $e');
    });
  }

  getAgentProfile() {
    profileRes.clear();
    isLoading.value = true;
    profileService.getProfile().then((res) {
      //  setDetails(res['data'][0]);
      profileRes.addAll(res['data']);
      print('profileRes .. $profileRes');
      print('res....123${res['data'][0]['ageConfig']}');
      CommonService.instance.leadAge.value =
          res['data'][0]['ageConfig'].toString();
      print('res....1234${CommonService.instance.leadAge.value}');
      Future.delayed(
          const Duration(milliseconds: 50), () => isLoading.value = false);
    }).catchError((e) {
      print('getProjects error: $e');
      isLoading.value = false;
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  requestPermission() async {
    print("requestPermission ");
    //   mobileContactsList.clear();
    print("requestPermission ");
    //  PermissionStatus permissionStatus = PermissionStatus.denied;
    PermissionStatus permissionStatus = await Permission.contacts.request();

    print("permissionStatus : ${permissionStatus}");
    if (permissionStatus == PermissionStatus.granted) {
      isContactsLoading.value = true;
      Iterable<Contact> contacts = await ContactsService.getContacts();

      for (var contact in contacts) {
        // print('Name: ${contact.displayName}');
        // print('Phone number: ${contact.phones!}');
        // print('givenName: ${contact.givenName}');
        // print('middleName: ${contact.middleName}');
        // print('familyname: ${contact.familyName}');
        // print('emails: ${contact.emails}');
        // print("is conatcts: not empty: ${contact.phones!.isNotEmpty}");

        if (contact.phones!.isNotEmpty) {
          var obj = {
            // "CON_ID": DateTime.now().millisecondsSinceEpoch.toString(),
            "FIRST_NAME": contact.givenName ?? "",
            "PRIMARY_NUMBER": contact.phones![0].value.toString(),
            "LAST_NAME":
                ((contact.middleName ?? "") + ' ' + (contact.familyName ?? ""))
                    .trim(),

            "EMAIL":
                contact.emails!.isNotEmpty ? contact.emails![0].toString() : ""
          };
          mobileContactsList.add(obj);
        }
      }
      print(
          'contactsCount condition${contactsTotalCount.value},${mobileContactsList.length},${contactsTotalCount.value < mobileContactsList.length}');
      //  if (contactsTotalCount.value < mobileContactsList.length) {
      print('less......');

      //requestPermission();

      contactService.uploadMobileContacts(mobileContactsList).then((res) {
        isContactsLoading.value = false;

        print("uploadMobileContacts res: $res");
        // Get.rawSnackbar(
        //     message: res["message"],
        //     backgroundColor: ThemeConstants.successColor);
      }).catchError((err) {
        isContactsLoading.value = false;

        print("uploadMobileContacts catchError $err");
      });
      //  }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      print('elseeeee iffffff');
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text('Permission Required'),
      //     content: Text(
      //         'Contacts permission is permanently denied. Please enable it in the app settings.'),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //         child: Text('Cancel'),
      //       ),
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //           openAppSettings();
      //         },
      //         child: Text('Open Settings'),
      //       ),
      //     ],
      //   ),
      // );
      print('elseeeee $permissionStatus');
    }
  }

  getPieChartValues(projId, projList) {
    isLoading.value = true;
    statusCounts.clear();
    projectsList.forEach((element) {
      //print('eleoo $element');
      if (element['projectId'] == projId) {
        print('elee11 $element');
        element['leadsByStage'].forEach((key, value) {
          statusCounts.add(value);
        });
      }
    });
    print('llllllllll ${statusCounts}');
    Future.delayed(
        const Duration(milliseconds: 500), () => isLoading.value = false);
  }

  getAllAppoitments() {
    appointmentList.clear();
    isLoading.value = true;
    appointmentService.getAllAppointments().then((res) {
      print("getAllAppoitments res: $res");
      res.forEach((a) {
        print('aaaaa ${a['status']}');
        if (a['status'] == 'SCHEDULED') {
          print('date11111 ${a['startDateTime']}');
          print('date2222 ${DateTime.now()}');
          String timestamp1 =
              a['startDateTime'].replaceAll('T', ' ').replaceAll('Z', '');
          String timestamp2 = DateTime.now().toString();
          DateTime tomorrow = DateTime.now().add(Duration(days: 1));
          print('ppppp ${timestamp1}');
          DateTime dateTime1 = DateTime.parse(timestamp1);
          DateTime dateTime2 = DateTime.parse(timestamp2);
          print('datessss ${dateTime1},${dateTime2}');
          // Compare the two DateTime objects
          if (dateTime1.isAfter(dateTime2) && dateTime1.isBefore(tomorrow)) {
            print(
                "The first timestamp is equal to or greater than the second timestamp. $a");
            appointmentList.add(Appointment.fromJson(a));
          }
        }
      });
      // appointmentList.sort((a, b) {
      //   DateTime dateTimeA = DateTime.parse(a["startDateTime"]);
      //   DateTime dateTimeB = DateTime.parse(b["startDateTime"]);
      //   return dateTimeA.compareTo(dateTimeB);
      // });
      Future.delayed(
          const Duration(milliseconds: 50), () => isLoading.value = false);

      print("appointmentList 123: ${appointmentList}");
    }).catchError((onError) {
      isLoading.value = false;

      print("getAllAppoitments catchError: $onError");
    });
  }

  getDefaultDetails() {
    isStatusLoading.value = true;
    projectsList.clear();
    projectsNamesList.clear();
    dashboardService.getDashboardDetails().then((res) {
      print("getDashboardDetails res: $res");
      projectsList.addAll(res['data']['projects']);
      if (res['data']['projects'].isNotEmpty) {
        SelectedProjectName.value = projectsList[0]['projectName'];
        projectsList.forEach((element) {
          if (element['status'] == 1) {
            projectsNamesList.add({
              'projId': element['projectId'],
              'projName': element['projectName']
            });
          }
        });
      }
      if (res['data']['leadStatusCounts'] != null) {
        statusCounts.clear();
        CommonService.instance.statusCount.clear();
        res['data']['leadStatusCounts'].forEach((e) {
          statusCounts.add(e["value"]);
          CommonService.instance.statusCount.add(e["value"]);
        });
      }
      Future.delayed(const Duration(milliseconds: 50),
          () => isStatusLoading.value = false);
    }).catchError((onError) {
      isStatusLoading.value = false;
      print("getDashboardDetails onError: $onError");
    });
  }

  getInactiveLeads(coldLeadsList) {
    print('inactive... leads.... $coldLeadsList');
    inactveLeadsList.clear();
    isLoading.value = true;
    dashboardService.getInactiveLeads(coldLeadsList).then((res) {
      print('res....1234.. ${res}');
      inactveLeadsList.addAll(res['data']['inactiveLeadsDetails']);

      Get.dialog(AppCupertinoDialog(
        title: 'Confirmation'.tr,
        subTitle:
            "There are currently ${inactveLeadsList.length} inactive leads that haven't shown activity in the last 15 days. Would you like to proceed and move them to 'Closed Lost'?",
        isOkBtn: false,
        acceptText: 'Yes'.tr,
        cancelText: 'No'.tr,
        onAccepted: () async {
          print('clicked..yes..');
          await updateColdLeadsStats(coldLeadsList);
          Get.back();

          // exit(0);
        },
        onCanceled: () {
          print('clicked...No.');
          Get.close(1);
        },
      ));
      CommonService.instance.onlyLogin.value = false;
      isLoading.value = false;
    }).catchError((e) {
      print('getProjects error: $e');
      isLoading.value = false;
    });
  }

  getDefaultStatusDetails(builderId) async {
    isStatusLoading.value = true;
    projectsList.clear();
    projectsNamesList.clear();
    await dashboardService
        .getDashboardDetailsByBuilderId(builderId)
        .then((res) async {
      print("getDashboardDetails res: $res");
      projectsList.addAll(res['data']['projects']);
      if (res['data']['projects'].isNotEmpty) {
        SelectedProjectName.value = projectsList[0]['projectName'];
        projectsList.forEach((element) {
          if (element['status'] == 1) {
            projectsNamesList.add({
              'projId': element['projectId'],
              'projName': element['projectName']
            });
          }
        });
      }
      if (res['data']['leadStatusCounts'] != null) {
        statusCounts.clear();
        CommonService.instance.statusCount.clear();
        res['data']['leadStatusCounts'].forEach((e) {
          statusCounts.add(e["value"]);
          CommonService.instance.statusCount.add(e["value"]);
        });
      }
      Future.delayed(const Duration(milliseconds: 50),
          () => isStatusLoading.value = false);
    }).catchError((onError) {
      isStatusLoading.value = false;
      print("getDashboardDetails onError: $onError");
    });
  }
}

class ChartData {
  ChartData(this.y, [this.color]);

  final double y;
  final Color? color;
}

import 'dart:io';

import 'package:brickbuddy/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CommonService {
  static final CommonService _singleton = CommonService._internal();
  CommonService._internal();
  static CommonService get instance => _singleton;

  RxInt selectedIndex = 0.obs;
  RxString jwtToken = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString agentId = ''.obs;
  RxString foreKey = ''.obs;
  RxString mobileNumber = ''.obs;
  RxString profileUrl = ''.obs;
  RxString leadAge = ''.obs;
  RxInt allNotificationsCount = 0.obs;
  RxString selectedStatus = ''.obs;
  RxString selectedProject = ''.obs;
  RxString selectedProjectId = ''.obs;
  RxString selectedBuilder = ''.obs;
  RxString selectedBuilderId = ''.obs;
  RxString selectedActivity = ''.obs;
  RxList statusCount = [].obs;
  RxList projectsNamesList = [].obs;
  RxList buildersList = [].obs;
  RxBool onlyLogin = false.obs;
  RxList leadActivityList = [
    '15',
    '30',
    '45',
    '60',
  ].obs;
  RxList statuses = [
    'Pre Qualify',
    'Qualify',
    'Schedule Site Visit',
    'Site Visit',
    'Negotiation In Progress',
    'Payment In Progress',
    'Agreement',
    'Closed Won',
    'Closed Lost',
  ].obs;

  RxList<dynamic> builders = <dynamic>[].obs;

  RxBool isFilterSelected = false.obs;
  RxInt filterPageOffset = 0.obs;

  List establishedYears = [];

  getEstablishedYears() {
    var currentYear = DateTime.now().year;
    for (var year = 1970; year <= currentYear; year++) {
      establishedYears
          .add({"label": year.toString(), "value": year.toString()});
    }
  }

  static confirmLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("jwtToken");
    prefs.remove("isCustomer");
    clearCache();
    prefs.clear();
    CommonService.instance.jwtToken.value = '';
    Get.offAllNamed(Routes.loginScreen);
  }

  static Future<void> clearCache() async {
    print('cacheeeeeee');
    // Clear the default cache manager
    await DefaultCacheManager().emptyCache();

    // Get the system's cache directory
    Directory cacheDir = await getTemporaryDirectory();

    // Check if the directory exists and delete it
    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }

    // Recreate the cache directory
    cacheDir.createSync();
  }
}

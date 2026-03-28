import 'package:brickbuddy/commons/services/notifications_service.dart';
import 'package:brickbuddy/model/notification.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  NotificationsService notificationsService = Get.find();

  RxList<BuddyNotification> notificationsList = <BuddyNotification>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    updateNotificationsCount();
    getAllNotifications();
  }

  updateNotificationsCount() {
    notificationsService.updateNotifications().then((res) {
      isLoading.value = false;
    }).catchError((onError) {
      isLoading.value = false;

      print("getAllNotifications onError: ${onError}");
    });
  }

  getAllNotifications() {
    isLoading.value = true;
    notificationsService.getAllNotifications().then((res) {
      isLoading.value = false;

      print("getAllNotifications  $res");

      if (res["data"] != null) {
        res["data"]['notificationDetails'].forEach((n) {
          notificationsList.add(BuddyNotification.fromJson(n));
        });
        sortNotifications();
      }
    }).catchError((onError) {
      isLoading.value = false;

      print("getAllNotifications onError: ${onError}");
    });
  }

  //This method will sort the notifications
  sortNotifications() {
    notificationsList.sort((b, a) {
      int aDate = DateTime.parse(a!.createdAt!).millisecondsSinceEpoch;
      int bDate = DateTime.parse(b!.createdAt!).millisecondsSinceEpoch;
      return aDate.compareTo(bDate);
    });
  }
}

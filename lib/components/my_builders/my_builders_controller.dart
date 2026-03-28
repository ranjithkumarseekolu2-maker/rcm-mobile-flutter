import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBuildersController extends GetxController {
  ProjectsService projectsService = Get.put(ProjectsService());
  RxBool isLoading = false.obs;
  RxList buildersList = [].obs;
  void onInit() {
    super.onInit();
    getMyBuilders();
  }

  getMyBuilders() {
    buildersList.clear();
    isLoading.value = true;
    projectsService.getAllMyBuilders().then((res) {
      print("getMyBuilders res: ${res}");
      buildersList.addAll(res['data']);
      // appointmentList.sort(
      //     (a, b) => b.startDateTime!.compareTo(a.startDateTime.toString()));
      print("appointmentList length: ${buildersList.length}");
      print("appointmentList length: ${buildersList}");
      Future.delayed(const Duration(seconds: 2), () => isLoading.value = false);
    }).catchError((onError) {
      isLoading.value = false;

      print("getAllAppoitments catchError: $onError");
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
}

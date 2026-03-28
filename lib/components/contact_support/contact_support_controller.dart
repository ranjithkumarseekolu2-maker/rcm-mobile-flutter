

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportController extends GetxController {
   //When click on call icon this method invoked to open dail pad
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

}
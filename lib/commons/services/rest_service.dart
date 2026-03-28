import 'dart:io';

import 'package:get/get.dart';


class RestService {
  final GetConnect connect = Get.find<GetConnect>();

  //post request example
  Future<dynamic> preLogin(phoneNumber) async {
    print('preLogin called: $phoneNumber');

    var obj = {"PhoneNumber": phoneNumber};
    Response response = await connect.post(
        'https://avanifarms.ingwalabs.com/api/users/pre-login', obj);
    print("Body ${response.body}");
    print("statusCode ${response.statusCode}");

    return response;
  }

}

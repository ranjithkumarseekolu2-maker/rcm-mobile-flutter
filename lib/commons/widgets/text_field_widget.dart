import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;

  // final TextEditingController controller;
  final TextInputType keyboardtype;

  TextFieldWidget({
    required this.hintText,
    required this.keyboardtype
    // required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      cursorColor: ThemeConstants.primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardtype,
      style: TextStyle(
        fontSize: ThemeConstants.fontSize12,
      ),
      //  controller: controller,
      decoration: InputDecoration(
    hintText: hintText,
    helperMaxLines: 2,
    counterText: '',
    contentPadding:
        EdgeInsets.all(Get.height * ThemeConstants.textFieldContentPadding),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(
          color:  Color.fromARGB(255, 46, 39, 54)
                           ),
      borderRadius: BorderRadius.circular(14.0),
    ),
    hintStyle: Styles.hintStyles,
      ),
      
    ));
  }
}

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MobileNumberWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool isRequired;
  final hintText;

  const MobileNumberWidget(
      {super.key,
      required this.controller,
      this.hintText,
      required this.isRequired});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (isRequired == true) {
          String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
          RegExp regExp = RegExp(pattern);
          if (value!.isEmpty) {
            return '$hintText is required';
          } else if (!regExp.hasMatch(value)) {
            return 'Please enter valid $hintText';
          }
          return null;
        } else {
          return null;
        }
      },
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: ThemeConstants.primaryColor,
      style: Styles.inputTextStyles,
      decoration: InputDecoration(
        fillColor: ThemeConstants.whiteColor,
        filled: true,
        hintText: hintText,
        helperMaxLines: 2,
        counterText: '',
        contentPadding:
            EdgeInsets.all(Get.height * ThemeConstants.textFieldContentPadding),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ThemeConstants.primaryColor),
          borderRadius: BorderRadius.circular(14.0),
        ),
        hintStyle: Styles.hintStyles,
      ),
    );
  }
}

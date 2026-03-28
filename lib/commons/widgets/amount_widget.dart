import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AmountWidget extends StatelessWidget {
  final TextEditingController controller;

  const AmountWidget({
    super.key,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
        RegExp regExp = RegExp(pattern);
        if (value!.isEmpty) {
          return 'Please enter Amount';
        }

        // else if (!regExp.hasMatch(value)) {
        //   return 'Please enter valid Mobile Number';
        // }
        return null;
      },
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      controller: controller,
      keyboardType: TextInputType.number,
      cursorColor: ThemeConstants.primaryColor,
      style: Styles.inputTextStyles,
      decoration: InputDecoration(
        // filled: true,
        // fillColor: Color(0xffF3F1F1),
        hintText: '',
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(
            color: ThemeConstants.greyColor,
            width: 1.0,
          ),
        ),
        hintStyle: Styles.hintStyles,
      ),
    );
  }
}

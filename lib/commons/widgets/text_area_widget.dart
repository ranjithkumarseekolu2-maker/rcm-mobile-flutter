import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';

class TextAreaWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool? isRequired;
  final String? label;

  const TextAreaWidget(
      {this.controller, this.hintText, this.isRequired, this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: Styles.inputTextStyles,
        maxLines: 2,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: ThemeConstants.whiteColor,
          // contentPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.screenPadding,
            vertical: ThemeConstants.screenPadding,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          hintText: hintText,
          isDense: true,
          hintStyle: TextStyle(
            fontSize: ThemeConstants.fontSize12,
            color: ThemeConstants.greyColor,
            fontWeight: FontWeight.w400,
            fontFamily: ThemeConstants.fontFamily,
          ),
        ),
        validator: (value) {
          if (isRequired == true) {
            if (value!.isEmpty || value.trim() == "") {
              return '${label} is required';
            }

            return null;
          }
          return null;
        });
  }
}

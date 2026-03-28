import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String hintText;
  Icon? icon;

  final TextEditingController controller;

  TextFormFieldWidget(
      {required this.hintText, required this.controller, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value!.length == 0) {
          return 'Please ${hintText.toLowerCase()}';
        }
        return null;
      },
      inputFormatters: [new LengthLimitingTextInputFormatter(60)],
      controller: controller,
      keyboardType: TextInputType.text,
      // maxLength: 10,
      cursorColor: ThemeConstants.primaryColor,
      // textAlign: TextAlign.center,
      // style: TextStyle(
      //   fontFamily: ThemeConstants.fontFamily,
      //   fontSize: ThemeConstants.inputTextSize,
      //   // color: ThemeConstants.in,
      // ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon ??
            Icon(
              Icons.person,
              size: 20,
              color: Colors.grey[800],
            ),
        // helperMaxLines: 2,
        // counterText: '',
        // contentPadding: EdgeInsets.only(
        //     left: ThemeConstants.width_15, right: ThemeConstants.width_6),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(color: ThemeConstants.APP_GREY_COLOR_400),
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        //  hintStyle: TextStyle(color: Colors.grey[800]),
        hintStyle: TextStyle(
          fontSize: ThemeConstants.fontSize15,
          color: ThemeConstants.greyColor,
          fontFamily: ThemeConstants.fontFamily,
        ),
      ),
    ));
  }
}

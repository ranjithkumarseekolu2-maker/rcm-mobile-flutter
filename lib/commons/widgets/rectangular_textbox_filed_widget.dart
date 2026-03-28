import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RectangularTextBoxField extends StatelessWidget {
  final String hintText;
  TextInputType? keyboardtype;
  final TextEditingController? controller;
  final maxLength;
  final VoidCallback? onPressed;
  final VoidCallback? locationOnPressed;
  int? minLines;
  bool? isreadOnly = false;
  bool? isSufixIcon = false;
  int? maxLines;
  TextInputFormatter? inputFormatters;
  bool? isPhoneNumberEnabled = true;

  RectangularTextBoxField(
      {required this.hintText,
      this.controller,
      this.maxLength,
      this.keyboardtype,
      this.maxLines,
      this.onPressed,
      this.minLines,
      this.isreadOnly,
      this.isSufixIcon,
      this.isPhoneNumberEnabled,
      this.locationOnPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      readOnly: isreadOnly == true ? true : false,
      enabled: isPhoneNumberEnabled,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp("[a-z A-Z á-ú  Á-Ú  α-ω   A-ω  0-9 .() ]"))
      ],

      minLines: minLines,
      maxLines: maxLines,
      //autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: maxLength != null ? maxLength : 60,
      textCapitalization: TextCapitalization.words,
      controller: controller,
      onTap: locationOnPressed,
      //onChanged: onPressed,

      keyboardType: keyboardtype,
      cursorColor: ThemeConstants.primaryColor,
      // textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: ThemeConstants.fontFamily,
          fontSize: ThemeConstants.inputTextSize,
          color: Color.fromRGBO(102, 102, 102, 1.0)),
      decoration: InputDecoration(
        filled: isPhoneNumberEnabled == true ? true : false,
        fillColor: ThemeConstants.whiteColor,
        hintText: hintText,
        prefixIcon: Icon(
          Icons.person,
          size: 18,
        ),
        suffixIcon: Icon(Icons.arrow_drop_down),
        helperMaxLines: 2,
        counterText: '',
        contentPadding: EdgeInsets.only(
            left: ThemeConstants.width14, right: ThemeConstants.width14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ThemeConstants.greyColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        focusedBorder: OutlineInputBorder(
          borderSide: (isreadOnly == true)
              ? BorderSide(color: ThemeConstants.greyColor)
              : BorderSide(color: ThemeConstants.primaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintStyle: TextStyle(
            color: Color.fromRGBO(102, 102, 102, 1.0),
            fontFamily: ThemeConstants.fontFamily,
            fontSize: ThemeConstants.fontSize14),
      ),
      validator: (value) {
        if (value!.isEmpty || value.trim() == "") {
          return '';
        }
        return null;
      },
    ));
  }
}

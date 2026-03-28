import 'package:brickbuddy/commons/utils/validation_util.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextBoxWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? isRequired;
  final int? maxLength;
  final bool? readOnly;
  final Icon? icon;
  final String? label;
  final bool? isEnable;

  TextBoxWidget(
      {required this.hintText,
      required this.controller,
      this.isRequired,
      this.maxLength,
      this.readOnly,
      this.isEnable = true,
      this.icon,
      this.label});

  @override
  _TextBoxWidgetState createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('iiiiiiiiEnable ${widget.isEnable}');
    return TextFormField(
      enabled: widget.isEnable,
      readOnly: widget.readOnly ?? false,
      cursorColor: ThemeConstants.primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.text,
      style: widget.isEnable == true
          ? Styles.inputTextStyles
          : Styles.greyLabelStyles1, // Styles.inputTextStyles,
      controller: widget.controller,
      decoration: InputDecoration(
          fillColor: ThemeConstants.whiteColor,
          filled: true,
          prefixIcon: widget.icon,
          hintText: widget.hintText,
          helperMaxLines: 2,
          counterText: '',
          contentPadding: EdgeInsets.all(
              Get.height * ThemeConstants.textFieldContentPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(14.0),
          ),
          hintStyle: Styles.hintStyles),
      validator: (value) {
        if (widget.isRequired == true) {
          if (value!.isEmpty || value.trim() == "") {
            return '${widget.label} is required';
          }
          // else if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
          //   return 'Please enter a valid name';
          // } else if (!Validators.isValidName(value)) {
          //   return 'Please enter a valid name';
          // }
          return null;
        }
        return null;
      },
    );
  }
}

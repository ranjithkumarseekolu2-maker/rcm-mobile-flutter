import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressTextBoxWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isRequired;

  AddressTextBoxWidget({
    this.hintText = '',
    required this.controller,
    this.isRequired = false,
  });

  @override
  _AddressTextBoxWidgetState createState() => _AddressTextBoxWidgetState();
}

class _AddressTextBoxWidgetState extends State<AddressTextBoxWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: ThemeConstants.primaryColor,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 100,
      textAlignVertical: TextAlignVertical.bottom,
      keyboardType: TextInputType.text,
      style: TextStyle(
        fontSize: ThemeConstants.fontSize12,
      ),
      controller: widget.controller,
      decoration: InputDecoration(
        counterText: '',
        fillColor: ThemeConstants.whiteColor,
        filled: true,
        hintText: widget.hintText,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        hintStyle: Styles.hintStyles,
        contentPadding:
            EdgeInsets.all(Get.height * ThemeConstants.textFieldContentPadding),
        isDense: true,
        errorStyle: TextStyle(
          fontFamily: ThemeConstants.fontFamily,
          color: ThemeConstants.errorColor,
          fontSize: ThemeConstants.fontSize10,
        ),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(14))),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
      validator: (value) {
        if (widget.isRequired == true) {
          if (value!.isEmpty || value.trim() == "") {
            return '${widget.hintText} is required';
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

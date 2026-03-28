import 'package:brickbuddy/commons/utils/validation_util.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextBoxWidgetWithPrefixEyeIcon extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool? isRequired;
  final int? maxLength;
  final bool? readOnly;
  final Icon? icon;
  final String? label;
  final bool? isEnable;

  TextBoxWidgetWithPrefixEyeIcon(
      {required this.hintText,
      required this.controller,
      this.isRequired,
      this.maxLength,
      this.readOnly,
      this.isEnable,
      this.icon,
      this.label});

  @override
  _TextBoxWidgetState createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidgetWithPrefixEyeIcon> {
  RxBool isVisible = false.obs;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
          obscureText: isVisible.value ? false : true,
          enabled: widget.isEnable,
          cursorColor: ThemeConstants.primaryColor,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.text,
          style: Styles.inputTextStyles,
          controller: widget.controller,
          decoration: InputDecoration(
            fillColor: ThemeConstants.whiteColor,
            filled: true,
            prefixIcon: Obx(() => isVisible.value
                ? IconButton(
                    icon: Icon(
                      Icons.visibility,
                      size: 18,
                      color: Colors.grey[800],
                    ),
                    onPressed: () {
                      isVisible.value = !isVisible.value;
                    })
                : IconButton(
                    icon: Icon(
                      Icons.visibility_off,
                      size: 18,
                      color: Colors.grey[800],
                    ),
                    onPressed: () {
                      isVisible.value = !isVisible.value;
                    })),
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
            hintStyle: Styles.hintStyles,
          ),
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
        ));
  }
}

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBoxWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxLength;
  final bool readOnly;
  VoidCallback? onClose;

  ValueChanged<String?>? onChanged;

  SearchBoxWidget(
      {required this.hintText,
      required this.controller,
      required this.maxLength,
      this.onChanged,
      this.onClose,
      required this.readOnly});

  @override
  _SearchBoxWidgetState createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          side: const BorderSide(
            color: Colors.black12,
            width: 1.0,
          )),
      child: TextFormField(
        onChanged: widget.onChanged,
        cursorColor: ThemeConstants.primaryColor,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        readOnly: widget.readOnly && widget.readOnly == true
            ? widget.readOnly
            : false,
        maxLength: widget.maxLength != 0 ? widget.maxLength : 100,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: ThemeConstants.fontSize12,
        ),
        controller: widget.controller,
        decoration: InputDecoration(
          counterText: '',
          fillColor: Colors.white,
          filled: true,
          hintText: widget.hintText,
          prefixIcon: const Icon(
            Icons.search,
            color: ThemeConstants.greyColor,
            size:20
          ),
          suffixIcon: InkWell(
            onTap: widget.onClose,
            child: const Icon(
              Icons.close,
              color: ThemeConstants.greyColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          hintStyle: Styles.hintStyles,
          contentPadding: EdgeInsets.all(
              Get.height * ThemeConstants.textFieldContentPadding),
          isDense: true,
          errorStyle: TextStyle(
            fontFamily: ThemeConstants.fontFamily,
            color: ThemeConstants.errorColor,
            fontSize: ThemeConstants.fontSize10,
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.buttonRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
        ),
      ),
    );
  }
}

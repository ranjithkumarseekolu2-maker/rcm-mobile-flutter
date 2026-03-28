import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownFormFieldWidget extends StatefulWidget {
  final List<DropdownMenuItem>? items;
  final dynamic selectedValue;
  final String? hintText;
  final String? labelText;
  final Function onChange;
  final bool? isRequired;
  final bool? isReadOnly;
  final Icon? icon;

  final bool? isValidationAlways;
  final VoidCallback? onPressed;

  const DropdownFormFieldWidget(
      {Key? key,
      this.items,
      this.selectedValue,
      this.isReadOnly,
      required this.onChange,
      this.labelText,
      this.hintText,
      this.onPressed,
      this.icon,
      this.isRequired,
      this.isValidationAlways})
      : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: IgnorePointer(
      ignoring: widget.isReadOnly == true ? true : false,
      child: DropdownButtonFormField<dynamic>(
        autovalidateMode: widget.isValidationAlways == true
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          fillColor: ThemeConstants.whiteColor,
          filled: true,
          prefixIcon: widget.icon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.00),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: widget.isReadOnly == true
                      ? ThemeConstants.greyColor
                      : Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          hintStyle: Styles.hintStyles,
          isDense: true,
          errorStyle: TextStyle(
            fontFamily: ThemeConstants.fontFamily,
            // color: ThemeConstants.errorColor,
            fontSize: ThemeConstants.fontSize10,
          ),
          errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color.fromARGB(255, 179, 15, 3)),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 165, 13, 2)),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        isExpanded: true,
        style: Styles.labelStyles,
        iconEnabledColor: Colors.black,
        items: widget.items,
        hint: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            ' ${widget.hintText}',
            style: Styles.hintStyles,
          ),
        ),
        value: widget.selectedValue,
        validator: (value) {
          print('dropdown field value ${widget.selectedValue}');
          if (widget.isRequired == true) {
            if (value == null) {
              return '${widget.hintText} is required';
            }
            return null;
          }
          return null;
        },
        onChanged: (value) {
          if (widget.onChange != null) widget.onChange(value);
        },
      ),
    ));
  }
}

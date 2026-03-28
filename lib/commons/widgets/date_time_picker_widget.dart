import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool? isRequired;
  final Function? onPressed;
  final bool? isEnabled;
  final bool? isTimeEnabled;
  final DateTime? selectedValue;
  DateTime? initialValue;
  DateTime? firstDate;
  String? label;

  

  DatePickerWidget(
      {this.hintText,
      this.controller,
      this.isRequired,
      this.onPressed,
      this.initialValue,
      this.isTimeEnabled,
      this.firstDate,
      this.selectedValue,
      this.isEnabled,
      this.label
      });

  final format = DateFormat("dd-MM-yyyy HH:mm a");

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeConstants.whiteColor,
      // width: Get.width * 0.90,
      child: Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light()
              .copyWith(primary: ThemeConstants.primaryColor),
        ),
        child: DateTimeField(
          initialValue: selectedValue,
          resetIcon: null,
          enabled: isEnabled!,
          textAlign: TextAlign.start,
          //  onChanged: onPressed!,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: ThemeConstants.fontSize15,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            fillColor: ThemeConstants.greyColor,
            filled: isEnabled == false ? true : false,
            // prefixIcon: Icon(
            //   Icons.calendar_today_sharp,
            // ),
            prefix: Text('  '),
            suffixIcon: Container(
              decoration: BoxDecoration(
                  color: ThemeConstants.primaryColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: isTimeEnabled == true
                  ? Icon(
                      Icons.watch_later,
                      color: ThemeConstants.whiteColor,
                    )
                  : Icon(
                      Icons.calendar_today_sharp,
                      color: ThemeConstants.whiteColor,
                    ),
            ),
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.greyColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintStyle: TextStyle(
                color: ThemeConstants.greyColor,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                fontSize: ThemeConstants.fontSize14),
            contentPadding: EdgeInsets.all(0),
            isDense: true,
            errorStyle: TextStyle(
                color: Colors.red, fontSize: ThemeConstants.fontSize10),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          format: format,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime
                    .now(), //FieldValue.serverTimestamp().toDate(),//DateTime(2021),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));

            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
          controller: controller,
          validator: (value) {
            print('value111 $value');

            if (isRequired == true) {
              if (value == null) {
                print('text $value');
                return label! + " is required";
              }
              return null;
            }
            return null;
          },
        ),
      ),
    );
  }
}

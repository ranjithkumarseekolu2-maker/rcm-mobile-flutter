import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class BottomBar1Widget extends StatelessWidget {
  final String buttonName;
  final Color buttonTextColor;
  final Color backgroundColor;
  final VoidCallback btnOnPressed;

  final VoidCallback textOnPressed;

  BottomBar1Widget(
      {required this.backgroundColor,
      required this.buttonName,
      required this.buttonTextColor,
      required this.btnOnPressed,
      required this.textOnPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RoundedFilledButtonWidget(
            buttonName: buttonName,
            onPressed: btnOnPressed,
            backgroundColor: backgroundColor,
            buttonTextColor: buttonTextColor),
        // SizedBox(
        //   height: ThemeConstants.height18,
        // ),
        // TextButtonWidget(
        //   buttonName: textButtonName,
        //   onPressed: textOnPressed,
        //   textColor: Colors.grey[800],
        //   fontSize: ThemeConstants.fontSize13,
        // ),
      ],
    );
  }
}

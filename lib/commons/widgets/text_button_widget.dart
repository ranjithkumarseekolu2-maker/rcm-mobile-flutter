import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class TextButtonWidget extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final double fontSize;
  final Color? textColor;

  const TextButtonWidget(
      {required this.buttonName,
      required this.onPressed,
      required this.textColor,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        buttonName,
        style: TextStyle(
            fontFamily: ThemeConstants.fontFamily,
            fontSize: fontSize != null ? fontSize : ThemeConstants.fontSize15,
            color: textColor != null ? textColor : ThemeConstants.primaryColor,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none),
      ),
    );
  }
}

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedOutlineButtonWidget extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final Color? color;
  final double? btnRadius;
  final Color? borderColor;
  final buttonWidth;

  const RoundedOutlineButtonWidget(
      {required this.buttonName,
      required this.onPressed,
      this.color,
      this.btnRadius,
      this.buttonWidth,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(btnRadius != null
            ? btnRadius ?? ThemeConstants.buttonRadius
            : ThemeConstants.buttonRadius)),
      ),
      child: Container(
        width: buttonWidth ?? Get.width * 0.35,
        height: ThemeConstants.btnHeight,
        decoration: BoxDecoration(
          border: Border.all(color: ThemeConstants.greyColor),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(btnRadius != null
              ? btnRadius ?? ThemeConstants.buttonRadius
              : ThemeConstants.buttonRadius),
        ),
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(ThemeConstants.whiteColor),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(btnRadius != null
                    ? btnRadius ?? ThemeConstants.buttonRadius
                    : ThemeConstants.buttonRadius))),
            side: MaterialStateProperty.all(BorderSide(
                color: borderColor ?? ThemeConstants.primaryColor, width: 1)),
          ),
          onPressed: onPressed,
          child: Text(
            buttonName,
            style: TextStyle(
                color: color ?? ThemeConstants.primaryColor,
                fontSize: ThemeConstants.fontSize12,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

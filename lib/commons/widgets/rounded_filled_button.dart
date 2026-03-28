import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundedFilledButtonWidget extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;
  final bool isLargeBtn;
  final bool? isRemove;
  final Color? backgroundColor;
  final Color? buttonTextColor;

  const RoundedFilledButtonWidget(
      {super.key,
      required this.buttonName,
      this.onPressed,
      this.isLargeBtn = true,
      this.backgroundColor,
      this.buttonTextColor,
      this.isRemove = false});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: isLargeBtn ? Get.width : Get.width * 0.35,
      height: ThemeConstants.btnHeight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: backgroundColor != null
          ? backgroundColor
          : ThemeConstants.primaryColor,
      onPressed: onPressed,
      child: Text(buttonName,
          style: (isLargeBtn) ? Styles.largeBtnStyle : Styles.smallBtnStyle),
    );
  }
}

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RectangleOutlineButtonWidget extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onPressed;
  final bool isLargeBtn;
  final bool? isRemove;
  final Color? backgroundColor;
  final Color? buttonTextColor;

  const RectangleOutlineButtonWidget(
      {super.key,
      required this.buttonName,
      this.onPressed,
      this.isLargeBtn = true,
      this.backgroundColor,
      this.buttonTextColor,
      this.isRemove = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ThemeConstants.primaryColor)),
      width: isLargeBtn ? Get.width : Get.width * 0.35,
      height: ThemeConstants.btnHeight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(buttonName, style: Styles.linkStyles),
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      // shape: RoundedRectangleBorder(

      //   borderRadius: BorderRadius.circular(10),
      // ),
      // color:
      //     backgroundColor != null ? backgroundColor : ThemeConstants.whiteColor,
      //     onPressed: onPressed,
      //     child: Text(buttonName, style: Styles.linkStyles),
      //   ),
    );
  }
}

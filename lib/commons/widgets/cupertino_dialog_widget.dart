import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCupertinoDialog extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? acceptText;
  final String? cancelText;
  final VoidCallback? onAccepted;
  final VoidCallback? onCanceled;
  final VoidCallback? onOkTap;
  final bool? isOkBtn;
  final widget;
  final bool? isRemove;
  final bool? isLeftAlign;
  const AppCupertinoDialog(
      {this.title,
      this.subTitle,
      this.acceptText,
      this.cancelText,
      this.onAccepted,
      this.onCanceled,
      this.isOkBtn,
      this.onOkTap,
      this.widget,
      this.isRemove,
      this.isLeftAlign});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.all(30.00),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
            horizontal: Get.width * 0.055, vertical: Get.height * 0.022),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            title != ''
                ? Align(
                    alignment: isLeftAlign == true
                        ? Alignment.topLeft
                        : Alignment.center,
                    child: Text(
                      title!,
                      style: Styles.headingStyles,
                      textAlign: isLeftAlign == true
                          ? TextAlign.left
                          : TextAlign.center,
                    ),
                  )
                : SizedBox.shrink(),
            SizedBox(
              height: ThemeConstants.height6,
            ),
            Center(
              child: widget ??
                  Text(
                    subTitle!,
                    textAlign:
                        isLeftAlign == true ? TextAlign.left : TextAlign.center,
                  ),
            ),
            SizedBox(
              height: Get.height * 0.022,
            ),
            (isOkBtn!)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedFilledButtonWidget(
                          buttonName: "OK",
                          isLargeBtn: false,
                          onPressed: onOkTap!)
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: Get.width / 2.9,
                          child: RoundedOutlineButtonWidget(
                            onPressed: onCanceled!,
                            buttonName: cancelText!,
                            btnRadius: 10,
                          )),
                      Container(
                        width: Get.width / 2.9,
                        child: RoundedFilledButtonWidget(
                          buttonName: acceptText!,
                          onPressed: onAccepted!,
                          isRemove: isRemove,
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

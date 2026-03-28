import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class BackBtnWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  BackBtnWidget({this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      icon: LineIcon.arrowLeft(
        size: 30,
        color: color,
      ),
      onPressed: onPressed,
    );
  }
}

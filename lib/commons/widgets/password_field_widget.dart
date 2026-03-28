import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RectangularPasswordTextBoxWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  var formFieldKey;
  // final Function onTap;

  RectangularPasswordTextBoxWidget(
      {required this.hintText,
      required this.controller,
      required this.formFieldKey});
  FocusNode focusNode = new FocusNode();

  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<RectangularPasswordTextBoxWidget> {
  RxBool isVisible = false.obs;

  @override
  void initState() {
    super.initState();
    widget.focusNode = new FocusNode();
    widget.focusNode.addListener(() {
      if (!widget.focusNode.hasFocus) {
        widget?.formFieldKey?.currentState?.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx(() => TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: widget.controller,
              focusNode: widget.focusNode,
              key: widget.formFieldKey,
              validator: (password) {
                if (password!.isEmpty || password == "") {
                  return 'Please ${widget.hintText.toLowerCase()}';
                }
                return null;
              },
              keyboardType: TextInputType.text,
              cursorColor: ThemeConstants.primaryColor,
              obscureText: isVisible.value ? false : true,
              //textAlign: TextAlign.center,
              // style: TextStyle(
              //   fontFamily: ThemeConstants.fontFamily,
              //   fontSize: ThemeConstants.inputTextSize,
              //   color: Colors.black,
              // ),
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  // helperMaxLines: 2,
                  // counterText: '',
                  // contentPadding: EdgeInsets.only(
                  //     left: ThemeConstants.width14,
                  //     right: ThemeConstants.width14),
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(10.0),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: ThemeConstants.primaryColor),
                  //   borderRadius: BorderRadius.circular(10.0),
                  // ),
                  hintStyle: TextStyle(
                    fontSize: ThemeConstants.fontSize15,
                    color: ThemeConstants.greyColor,
                    fontFamily: ThemeConstants.fontFamily,
                  ),
                  prefixIcon: Obx(() => isVisible.value
                      ? IconButton(
                          icon: Icon(
                            Icons.visibility,
                            size: 20,
                            color: Colors.grey[800],
                          ),
                          onPressed: () {
                            isVisible.value = !isVisible.value;
                          })
                      : IconButton(
                          icon: Icon(
                            Icons.visibility_off,
                            size: 20,
                            color: Colors.grey[800],
                          ),
                          onPressed: () {
                            isVisible.value = !isVisible.value;
                          }))),
            )));
  }

  checkValidation() {
    print('checkValidation...');
    if (widget.controller != null) {
      print('checkValidation ${widget.controller.value}');
      print('checkValidation ${widget.controller.text}');
      print('checkValidation ${widget.controller.toString()}');
    }
  }
}

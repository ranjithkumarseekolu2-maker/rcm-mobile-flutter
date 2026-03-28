// import 'package:brickbuddy/constants/theme_constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// class OtpField extends StatelessWidget {
//   final String hintText;
//   TextInputType keyboardtype;
//   final TextEditingController controller;

//   OtpField(
//       {required this.hintText,
//       required this.controller,
//       required this.keyboardtype});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: TextFormField(
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       // validator: (value) {
//       //   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//       //   RegExp regExp = new RegExp(pattern);
//       //   if (value!.length == 0) {
//       //     return 'Please enter phone number';
//       //   } else if (!regExp.hasMatch(value)) {
//       //     return 'Please enter valid phone number';
//       //   }
//       //   return null;
//       // },
//       inputFormatters: [new LengthLimitingTextInputFormatter(6)],
//       controller: controller,
//       keyboardType: keyboardtype,
//       maxLength: 10,
//       cursorColor: ThemeConstants.primaryColor,
//       // textAlign: TextAlign.center,
//       // style: TextStyle(
//       //   fontFamily: ThemeConstants.fontFamily,
//       //   fontSize: ThemeConstants.inputTextSize,
//       //   // color: ThemeConstants.in,
//       // ),
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(
//           Icons.key,
//           size: 20,
//           color: Colors.grey[800],
//         ),
//         // helperMaxLines: 2,
//         // counterText: '',
//         // contentPadding: EdgeInsets.only(
//         //     left: ThemeConstants.width_15, right: ThemeConstants.width_6),
//         // border: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(10.0),
//         // ),
//         // focusedBorder: OutlineInputBorder(
//         //   borderSide: BorderSide(color: ThemeConstants.APP_GREY_COLOR_400),
//         //   borderRadius: BorderRadius.circular(10.0),
//         // ),
//         //  hintStyle: TextStyle(color: Colors.grey[800]),
//       ),
//     ));
//   }
// }
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;

  OtpField({
    required this.hintText,
    required this.controller,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [LengthLimitingTextInputFormatter(6)],
        controller: controller,
        keyboardType: keyboardType,
        maxLength: 6, // assuming OTP is typically 6 digits long
        cursorColor: ThemeConstants.primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.key,
            size: 20,
            color: Colors.grey[800],
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter OTP'; // Validation error message
          }
          return null; // Return null if validation succeeds
        },
      ),
    );
  }
}

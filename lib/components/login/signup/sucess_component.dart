import 'package:brickbuddy/commons/widgets/bottom_bar1_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_field_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';
import 'package:brickbuddy/components/login/forgot_details/forgot_details_controller.dart';
import 'package:brickbuddy/components/login/login_component.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SucessComponent extends StatelessWidget {
  ForgotDetailsController forgotDetailsController =
      Get.put(ForgotDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBody(context));
  }

  buildBody(context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: Get.height,
                width: Get.width,
                color: ThemeConstants.primaryColor,
                // decoration: BoxDecoration(),
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/sucessbg.png',
                      ),
                    ),
                  ],
                ) //buildWelcomeData(),
                ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(child: buildData()),
            ),
             Positioned(
              left: 120,
              top: 200,
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Text(
                     'Success !!',
                     style: TextStyle(
                         color: Colors.white,
                         fontSize: ThemeConstants.fontSize24,
                         fontWeight: FontWeight.bold),
                   ),
                   SizedBox(height: ThemeConstants.height10,),
                   Icon(Icons.home,size: 100,color: ThemeConstants.whiteColor,),
                   
                 ],
               ),
             ),
            Positioned(
                top: 500,
                //bottom: 10,
                child: Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                    // child: buildTextFields()
                    )),
            Positioned(
              left: ThemeConstants.screenPadding,
              right: ThemeConstants.screenPadding,
              top: Get.height * ThemeConstants.buttonPositionFromTop,
              child: Column(
                children: [
                                    
                   Text('User Registered Successfully'),
                                     SizedBox(height: ThemeConstants.height20),
                  buildBottomBar1Widget(context),
                  SizedBox(height: ThemeConstants.height15),
                  // Text('User Registered Successfully'),
                  // SizedBox(height: ThemeConstants.height15),
                  // TextButtonWidget(
                  //   buttonName: 'Login',
                  //   onPressed: () {
                     
                  //   },
                  //   textColor: Colors.grey[800],
                  //   fontSize: ThemeConstants.fontSize13,
                  // ),
                  // SizedBox(height: ThemeConstants.height15),
                  // TextButtonWidget(
                  //   buttonName: 'Already have an account? Login',
                  //   onPressed: () {
                  //     Get.to(LoginComponent());
                  //   },
                  //   textColor: Colors.grey[800],
                  //   fontSize: ThemeConstants.fontSize13,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildData() {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.screenPadding,
            vertical: ThemeConstants.screenPadding),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Brick Buddy',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: ThemeConstants.fontSize20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 70,
              ),
              SizedBox(
                height: ThemeConstants.height52,
              ),
              // Center(
              //   child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Success !!',
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: ThemeConstants.fontSize24,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       Icon(Icons.home,size: 100,color: ThemeConstants.whiteColor,),
                    
              //     ],
              //   ),
              // ),
              SizedBox(
                height: ThemeConstants.height5,
              ),
              // Text(
              //   'Buddy !',
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontSize: ThemeConstants.fontSize24,
              //       fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: ThemeConstants.height8,
              // ),
              // Text(
              //   'Please enter the OTP ',
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontSize: ThemeConstants.fontSize14,
              //       fontWeight: FontWeight.bold),
              // ),
              // SizedBox(
              //   height: ThemeConstants.height8,
              // ),
              // Text(
              //   'that sent to your phone',
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontSize: ThemeConstants.fontSize14,
              //       fontWeight: FontWeight.bold),
              // ),
            ]));
  }

  // buildTextFields() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: ThemeConstants.height31,
  //         ),
  //         // MobileNumberField(
  //         //     hintText: 'Enter otp',
  //         //     controller: forgotDetailsController.mobileNumberController,
  //         //     keyboardtype: TextInputType.number),
  //       ],
  //     ),
  //   );
  // }
 

  BottomBar1Widget buildBottomBar1Widget(BuildContext context) {
    return BottomBar1Widget(
      buttonName: 'Login'.tr,
      btnOnPressed: () {
        Get.toNamed(Routes.loginScreen);
        // loginController.validateLoginForm();
      },
      //textButtonName: "Already have an account?".tr,
      textOnPressed: () {
        // Get.delete<ForgotPasswordController>();
        // Get.toNamed(Routes.FORGOTPASSWORDVIEW);
      },
      buttonTextColor: ThemeConstants.whiteColor,
      backgroundColor: ThemeConstants.primaryColor,
      //  textColor: ThemeConstants.primaryColor,
    );
    
  }
}

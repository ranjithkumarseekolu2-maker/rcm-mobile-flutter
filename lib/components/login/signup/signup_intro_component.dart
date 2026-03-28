import 'package:brickbuddy/commons/widgets/rectangle_outline_button_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/rounded_outline_widget.dart';
import 'package:brickbuddy/components/login/login_controller.dart';
import 'package:brickbuddy/components/login/signup/signup_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignpIntroScreenComponent extends StatelessWidget {
  const SignpIntroScreenComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Get.delete<LoginController>(force: true);
              Get.toNamed(Routes.loginScreen);
            },
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.screenPadding),
              child: RoundedFilledButtonWidget(
                buttonName: 'Get Started',
                isLargeBtn: true,
                onPressed: () {
                  Get.delete<SignUpController>(force: true);
                  Get.toNamed(Routes.signupScreen);
                },
              ),
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding),
                child: RectangleOutlineButtonWidget(
                    buttonName: 'I already have an account',
                    // buttonWidth: Get.width,
                    onPressed: () {
                      Get.delete<LoginController>(force: true);
                      Get.toNamed(Routes.loginScreen);
                    })),
            SizedBox(
              height: ThemeConstants.height20,
            ),
          ],
        ),
        body: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.screenPadding),
              child: Text(
                'Join Brickboss',
                style: Styles.appTitleStyles,
              ),
            ),
            Image.asset('assets/images/introImage.png'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.screenPadding),
              child: Text(
                'Create an account and grow your real estate business - manage leads, track deals, and connect with builders, all in one app.',
                style: Styles.inputTextStyles,
              ),
            )
          ]),
        ),
      ),
    );
  }
}

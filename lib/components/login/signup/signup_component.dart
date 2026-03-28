import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar1_widget.dart';
import 'package:brickbuddy/commons/widgets/confirm_password_field_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_field_widget.dart';
import 'package:brickbuddy/commons/widgets/password_field_widget.dart';
import 'package:brickbuddy/commons/widgets/text_button_widget.dart';
import 'package:brickbuddy/commons/widgets/text_form_field_widget.dart';
import 'package:brickbuddy/components/login/login_component.dart';
import 'package:brickbuddy/components/login/login_controller.dart';
import 'package:brickbuddy/components/login/signup/signup_controller.dart';
import 'package:brickbuddy/components/login/signup/signup_intro_component.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupComponent extends StatelessWidget {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print("onWill pop scope called");

          Get.to(SignpIntroScreenComponent());
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            // height:Get.height,
            //   backgroundColor: ThemeConstants.primaryColor,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0), // here the desired height
                child: AppBar(
                  backgroundColor: ThemeConstants.primaryColor,
                  elevation: 0,
                  bottomOpacity: 0.0,
                  leading: IconButton(
                      onPressed: () {
                        Get.to(SignpIntroScreenComponent());
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: ThemeConstants.whiteColor,
                      )),
                )),
            body: Obx(() => signUpController.isLoading.value
                ? showCustomLoader()
                : SingleChildScrollView(child: buildBody(context))),
          ),
        ));
  }

  buildBody(context) {
    return Stack(children: [
      Container(
          height: 900,
          width: Get.width,
          color: ThemeConstants.primaryColor,
          // decoration: BoxDecoration(),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/landingImage2.jpg',
                ),
              ),
            ],
          ) //buildWelcomeData(),
          ),

      Positioned(
          top: 0,
          //bottom: 10,
          child: Container(child: buildWelcomeData())),
      Positioned(
          top: 285,
          //bottom: 10,
          child: Form(
            key: signUpController.signUpFormKey,
            child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: buildTextFields(context)),
          )),
      // Positioned(
      //   left: ThemeConstants.screenPadding,
      //   right: ThemeConstants.screenPadding,
      //   // top: Get.height * ThemeConstants.buttonPositionFromTop,
      //   child:
      // ),
    ]);
  }

  buildTextFields(context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.screenPadding,
          vertical: ThemeConstants.screenPadding),
      child: Column(
        children: [
          SizedBox(
            height: ThemeConstants.height5,
          ),
          TextFormFieldWidget(
            controller: signUpController.firstName,
            hintText: 'Enter First Name',
          ),
          SizedBox(
            height: ThemeConstants.height15,
          ),
          TextFormFieldWidget(
            controller: signUpController.lastName,
            hintText: 'Enter Last Name',
          ),
          SizedBox(
            height: ThemeConstants.height15,
          ),
          MobileNumberField(
            controller: signUpController.mobileNumber,
            hintText: 'Enter Mobile Number',
            keyboardtype: TextInputType.number,
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          RectangularPasswordTextBoxWidget(
            controller: signUpController.password,
            hintText: 'Enter Password',
            formFieldKey: signUpController.passwordFormKey,
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          RectangularPasswordTextBoxWidget(
            controller: signUpController.confirmPassword,
            hintText: 'Confirm your Password',
            formFieldKey: signUpController.confirmpasswordFormKey,
          ),
          SizedBox(
            height: ThemeConstants.height52,
          ),
          Column(
            children: [
              Obx(() => signUpController.isClickedOnSignUp.value
                  ? BottomBar1Widget(
                      backgroundColor: Color.fromARGB(173, 177, 119, 253),
                      btnOnPressed: () {},
                      buttonName: 'Sign Up',
                      buttonTextColor: ThemeConstants.whiteColor,
                      textOnPressed: () {},
                    )
                  : buildBottomBar1Widget(context)),
              SizedBox(height: ThemeConstants.height15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButtonWidget(
                    buttonName: 'Already have an account?',
                    onPressed: () {},
                    textColor: Colors.grey[800],
                    fontSize: ThemeConstants.fontSize13,
                  ),
                  SizedBox(
                    width: ThemeConstants.width4,
                  ),
                  TextButtonWidget(
                    buttonName: 'Login',
                    onPressed: () {
                      Get.to(LoginComponent());
                    },
                    textColor: ThemeConstants.primaryColor,
                    fontSize: ThemeConstants.fontSize13,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  BottomBar1Widget buildBottomBar1Widget(BuildContext context) {
    return BottomBar1Widget(
      buttonName: 'Sign Up'.tr,
      btnOnPressed: () {
        // if (signUpController.mobileNumber.text.isEmpty ||
        //     signUpController.firstName.text.isEmpty ||
        //     signUpController.lastName.text.isEmpty ||
        //     signUpController.password.text.isEmpty ||
        //     signUpController.confirmPassword.text.isEmpty) {
        //   // At least one field is empty, show Snackbar to inform the user
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Please fill out all fields!'),
        //     ),
        //   );
        // } else
        if (signUpController.password.text !=
            signUpController.confirmPassword.text) {
          // Passwords do not match, show Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Passwords do not match!'),
            ),
          );
        } else {
          if (signUpController.signUpFormKey.currentState!.validate()) {
            // Passwords match and all fields are filled, proceed with form submission
            signUpController.isClickedOnSignUp.value = true;
            signUpController.signup(
                signUpController.mobileNumber.text,
                signUpController.firstName.text,
                signUpController.lastName.text,
                signUpController.password.text,
                signUpController.confirmPassword.text);
          }
        }
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

  buildWelcomeData() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeConstants.screenPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            ImageConstants.appLogo2,
            width: 120,
            height: 120,
            color: ThemeConstants.whiteColor,
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          Text(
            'Welcome',
            style: TextStyle(
                color: Colors.white,
                fontSize: ThemeConstants.fontSize24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: ThemeConstants.height5,
          ),
          Text(
            'Buddy !',
            style: TextStyle(
                color: Colors.white,
                fontSize: ThemeConstants.fontSize24,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          Text(
            'Sign up to continue',
            style: TextStyle(
                color: Colors.white,
                fontSize: ThemeConstants.fontSize14,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

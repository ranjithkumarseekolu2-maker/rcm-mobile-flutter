import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/widgets/text_field_widget.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class Add_Contact extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ThemeConstants.primaryColor,
          title: Text('Add Contact', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: ThemeConstants.whiteColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeAnimation: badges.BadgeAnimation.slide(
                    // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                    // curve: Curves.easeInCubic,
                    ),
                showBadge:
                    CommonService.instance.allNotificationsCount.value > 0
                        ? true
                        : false,
                badgeStyle: badges.BadgeStyle(
                  badgeColor: ThemeConstants.errorColor,
                ),
                badgeContent: Text(
                  CommonService.instance.allNotificationsCount.toString(),
                  style: Styles.whiteSubHeadingStyles4,
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.notifications,
                      color: ThemeConstants.whiteColor,
                      size: 25,
                    ),
                    onPressed: () {
                      Get.delete<NotificationsController>(force: true);
                      Get.toNamed(Routes.notificationsComponent);
                    }),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'First Name', // Heading text
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.bold,
                                  color: ThemeConstants.greyColor),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              '*',
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFieldWidget(
                          hintText: 'Enter Name',
                          keyboardtype: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Last Name', // Heading text
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            color: ThemeConstants.greyColor),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFieldWidget(
                                    hintText: 'Enter Name',
                                    keyboardtype: TextInputType.text,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Primary Number', // Heading text
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            color: ThemeConstants.greyColor),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFieldWidget(
                                    hintText: 'Enter Number',
                                    keyboardtype: TextInputType.text,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Secondary Number', // Heading text
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            color: ThemeConstants.greyColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFieldWidget(
                                    hintText: '',
                                    keyboardtype: TextInputType.text,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Work Info', // Heading text
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "OpenSans",
                                            fontWeight: FontWeight.bold,
                                            color: ThemeConstants.greyColor),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFieldWidget(
                                    hintText: '',
                                    keyboardtype: TextInputType.text,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email', // Heading text
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.bold,
                              color: ThemeConstants.greyColor),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFieldWidget(
                          hintText: '',
                          keyboardtype: TextInputType.text,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Address', // Heading text
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.bold,
                              color: ThemeConstants.greyColor),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          maxLines: 4,
                          readOnly: false,
                          decoration: InputDecoration(
                            hintText: 'Enter your address here...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Processing Data')),
                              );
                            }
                          },
                          color: ThemeConstants
                              .primaryColor, // Set the background color to white
                          textColor: ThemeConstants
                              .primaryColor, // Set the text color to purple

                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: ThemeConstants
                                    .primaryColor), // Set the border color to purple
                            borderRadius: BorderRadius.circular(
                                5.0), // Set the border radius to zero
                          ),
                          child: Container(
                              width: 120, // Set the width of the button
                              height: 40, // Set the height of the button

                              child: Center(
                                  child: Text(
                                'Add Contact',
                                style: TextStyle(
                                    color: ThemeConstants.whiteColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16),
                              ))),
                        ),
                      ]),
                ))));
  }
}

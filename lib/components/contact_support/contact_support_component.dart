import 'package:brickbuddy/commons/widgets/back_btn_widget.dart';
import 'package:brickbuddy/components/contact_support/contact_support_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupportComponent extends StatelessWidget {
  CustomerSupportController customerSupportController =
      Get.put(CustomerSupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ThemeConstants.whiteColor),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: false,
        title: Text(
          'Customer Support',
          style: TextStyle(color: ThemeConstants.whiteColor),
        ),
        backgroundColor: ThemeConstants.primaryColor,

        // bottom: TabBar(tabs: [

        // ]),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.15),
                child: Center(
                  child: Text(
                    'Hello, How can we help you?',
                    style: TextStyle(
                        fontSize: ThemeConstants.fontSize24,
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF090F47)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      customerSupportController.makePhoneCall('9891908055');
                    },
                    child: Row(
                      children: [
                        const LineIcon(
                          Icons.call,
                          size: 25,
                        ),
                        SizedBox(
                          width: ThemeConstants.width24,
                        ),
                        Text('Call us on ', style: Styles.label1Styles),
                        Text('+91 9891908055', style: Styles.link1Styles),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height10,
                  ),

                  Divider(),
                  SizedBox(
                    height: ThemeConstants.height10,
                  ),
                  //  InkWell(
                  //   onTap: (){
                  //     launchUrl(Uri.parse("https://api.whatsapp.com/send/?phone=%2B9550203694&text=Hello&type=phone_number&app_absent=0"));
                  //   },
                  //    child: Row(
                  //     children: [
                  //     Image.asset(ImageConstants.whatsapp ,width: 20, height: 20,),
                  //       SizedBox(width: ThemeConstants.width24,),
                  //       Text('Whatsapp Suppport ', style: Styles.label1Styles),
                  //       Text(' +91 987654321 ', style: Styles.link1Styles),
                  //     ],
                  //                ),
                  //  ),
                  // SizedBox(
                  //   height: ThemeConstants.height10,
                  // ),
                  // Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

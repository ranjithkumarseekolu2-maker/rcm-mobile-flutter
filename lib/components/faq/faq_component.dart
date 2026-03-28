 
import 'package:brickbuddy/commons/widgets/back_btn_widget.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQComponent extends StatelessWidget {
  const FAQComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    color: ThemeConstants.whiteColor),
                onPressed: () {
                  Get.back();
                },
              ),
              centerTitle: false,
              title: Text(
                'Faq',
                style: TextStyle(color: ThemeConstants.whiteColor),
              ),
              backgroundColor: ThemeConstants.primaryColor,

              // bottom: TabBar(tabs: [

              // ]),
            ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('1. What makes your organic vegetables different from regular ones available in local markets?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'Our organic vegetables are grown without the use of synthetic pesticides and fertilizers, ensuring a healthier and more sustainable option for you. We prioritize environmentally friendly farming practices to provide you with high-quality, chemical-free produce.',
                  style: Styles.hint1Styles),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('2. How do I place an order on the app?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'Ordering is simple! Navigate to the app, browse our selection of organic vegetables, select the items you want, and proceed to checkout. Follow the easy steps to provide delivery details and complete your purchase.',
                  style: Styles.hint1Styles),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('3. Are the prices on the app the same as in local grocery stores?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'Our prices reflect the high quality and organic nature of our products. While they may vary slightly, we strive to offer competitive rates for premium, organic vegetables. Keep an eye out for special promotions and discounts to make your shopping experience even more affordable.',
                  style: Styles.hint1Styles),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('4. How are the organic vegetables delivered, and what is the delivery time frame?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'We offer doorstep delivery to ensure maximum convenience. Delivery times may vary based on your location, but we aim for prompt and timely service. You can track your order in real-time through the app for added convenience.',
                  style: Styles.hint1Styles),
                 
                  Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('5. What payment options are available on the app?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'We accept various payment methods, including credit/debit cards, digital wallets, and other secure payment options. Choose the one that suits you best during the checkout process.',
                  style: Styles.hint1Styles),
                  Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('6. What if I\'m not satisfied with the quality of the vegetables/fruits received?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'Customer satisfaction is our priority. If you\'re not satisfied with the quality, contact our customer support within a specified time frame, and we\'ll work to address and resolve the issue promptly.',
                  style: Styles.hint1Styles),
                  Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              Text('7. How do you ensure the freshness of the vegetables/fruits during delivery?', style: Styles.label1Styles),
              SizedBox(
                height: ThemeConstants.height6,
              ),
              Text(
                  'We employ efficient packaging and delivery practices to maintain the freshness of our organic vegetables. Our packaging is designed to preserve the quality and nutritional value of the produce until it reaches your doorstep.',
                  style: Styles.hint1Styles),
                  Divider(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

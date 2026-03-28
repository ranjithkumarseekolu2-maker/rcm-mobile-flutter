import 'package:brickbuddy/components/upload_kyc_documents/upload_kyc_documents_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../commons/widgets/rounded_filled_button.dart';
import '../../commons/widgets/rounded_outline_widget.dart';

class UploadKycDocumentsComponent extends StatelessWidget {
  UploadKycDocumentsController uploadAttachmentsController =
      Get.put(UploadKycDocumentsController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ThemeConstants.screenPadding),
              child: Column(
                children: [buildUploadAttachments(context)],
              ),
            ),
          ),
        ),
        Positioned(
          left: ThemeConstants.screenPadding,
          right: ThemeConstants.screenPadding,
          top: Get.height * 0.9,
          child: Obx(() => RoundedFilledButtonWidget(
              buttonName: 'add'.tr, onPressed: () {})),
        )
      ],
    );
  }

  buildUploadAttachments(BuildContext context) {
    return Container(
      width: Get.width,
      child: Column(
        children: [
          SizedBox(
            height: ThemeConstants.height20,
          ),
          Center(
            child: Icon(
              Icons.cloud_upload_outlined,
              size: 100,
              color: ThemeConstants.greyColor,
            ),
          ),
          Text(
            "letsUploadBills&Warranties".tr,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: ThemeConstants.fontSize16,
                fontWeight: FontWeight.w600,
                color: ThemeConstants.greyColor),
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTakeaPhoto(),
              SizedBox(
                width: ThemeConstants.width10,
              ),
              buildGallery(),
            ],
          ),
          SizedBox(
            height: ThemeConstants.height20,
          ),
        ],
      ),
    );
  }

  GestureDetector buildTakeaPhoto() {
    return GestureDetector(
      onTap: () {
        // uploadAttachmentsController.takePhotoFromCamera();
      },
      child: Container(
        width: Get.width * 0.4,
        height: ThemeConstants.btnHeight,
        child: RoundedOutlineButtonWidget(
          buttonName: 'camera'.tr,
          color: ThemeConstants.primaryColor,
          onPressed: () {},
          // icon: Icon(
          //   Icons.camera_alt,
          // ),
        ),
      ),
    );
  }

  GestureDetector buildGallery() {
    return GestureDetector(
      onTap: () {
        // uploadAttachmentsController.selectedFilePath.value = '';
        // uploadAttachmentsController.imageFileObj.value = '';
        // uploadAttachmentsController.selectImageFromGallery();
      },
      child: Container(
        width: Get.width * 0.4,
        height: ThemeConstants.btnHeight,
        child: RoundedOutlineButtonWidget(
          onPressed: () {},
          buttonName: 'file'.tr,
          color: ThemeConstants.primaryColor,
          // icon: Icon(Icons.file_copy),
        ),
      ),
    );
  }
}

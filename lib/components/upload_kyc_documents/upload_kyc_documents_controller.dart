import 'dart:io';

import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadKycDocumentsController extends GetxController {
  // image variables
  final ImagePicker picker = ImagePicker();
  // File _image;
  RxString imageFileObj = ''.obs;
  RxString storageRef = ''.obs;
  RxString selectedFilePath = ''.obs;
  //TakePhotoFromCamera
  // Future takePhotoFromCamera() async {
  //   XFile? photo = await picker.pickImage(source: ImageSource.camera);
  //   _image = File(photo!.path);
  //   _cropImage(_image);
  // }

  // //Croping Image Functionality
  // Future<Null> _cropImage(File imageFile) async {
  //   File croppedFile = await ImageCropper().cropImage(
  //       sourcePath: imageFile.path,
  //       cropStyle: CropStyle.rectangle,
  //       compressQuality: 60,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //               CropAspectRatioPreset.original,
  //             ]
  //           : [
  //               CropAspectRatioPreset.original,
  //             ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Crop Image',
  //           toolbarColor: ThemeConstants.primaryColor,
  //           activeControlsWidgetColor: ThemeConstants.primaryColor,
  //           toolbarWidgetColor: Colors.white,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Crop Image',
  //       ));
  //   if (croppedFile != null) {
  //     imageFile = croppedFile;
  //     _image = imageFile;
  //     print("_image => ...$_image.");
  //     print("imageFile.path from side_bar_widget => ...${imageFile.path}.");
  //     imageFileObj.value = _image.path;
  //     // textFieldChanges();
  //     print("  pic${imageFileObj.value}");
  //   }
//  }
}

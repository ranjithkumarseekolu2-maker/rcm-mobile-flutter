import 'package:brickbuddy/components/projects/refer/refer_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class ReferCardWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  final dynamic item;
  RxBool checkedValue = false.obs;
  ReferController referController = Get.find();

  ReferCardWidget({this.onPressed, required this.item});

  String getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    String lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    return '$firstInitial$lastInitial'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    print('ppIc0 ${item['profilePic'] != null}');
    print('ppIc1 ${item['profilePic'] != ''}');
    print('ppIc2 ${item['profilePic']}');
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeConstants.primaryColor,
                            ),
                            child: item['profilePic'] != null
                                ? ClipOval(
                                    child: Image.network(
                                      item['profilePic'],
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Text(
                                          getInitials(item['firstName'] ?? '',
                                              item['lastName'] ?? ''),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      getInitials(item['firstName'] ?? '',
                                          item['lastName'] ?? ''),
                                      style: TextStyle(
                                        color: ThemeConstants.whiteColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                item['lastName'] != ''
                                    ? Text(
                                        item['firstName'] +
                                            ' ' +
                                            item['lastName'],
                                        style: Styles.label2Styles,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                        item['firstName'] ?? '',
                                        style: Styles.label2Styles,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                SizedBox(
                                  height: ThemeConstants.height4,
                                ),
                                Text(
                                  item['primaryNumber'] ?? '',
                                  style: Styles.hintStyles,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Obx(() => Checkbox(
                    value: checkedValue.value,
                    activeColor: ThemeConstants.primaryColor,
                    onChanged: (v) {
                      print(v);
                      checkedValue.value = v!;
                      if (checkedValue.value == true) {
                        referController.selectedContacts.add({
                          "conId": item["conId"],
                          "mobileNumber": item["primaryNumber"],
                          "status": 1
                        });
                      } else {
                        // remove the item from list , if exist.
                        if (referController.selectedContacts.isNotEmpty) {
                          var contact = referController.selectedContacts
                              .firstWhere((C) => C["conId"] == item["conId"],
                                  orElse: () => null);
                          print("hey ite found: ${contact}");
                          referController.selectedContacts.remove(contact);
                        }
                      }
                      print(
                          " final selected conatcts length: ${referController.selectedContacts.length}");
                      print(
                          "selected conatcts length: ${referController.selectedContacts.toJson()}");
                    })),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

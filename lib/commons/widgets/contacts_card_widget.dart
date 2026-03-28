import 'package:brickbuddy/components/contacts/contacts_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class ContactsCardWidget extends StatelessWidget {
  ContactsController contactsController = Get.put(ContactsController());
  final VoidCallback? onPressed;
  final VoidCallback? onPressedEdit;
  final VoidCallback? onPressedDelete;
  final VoidCallback? onPressedCall;
  final VoidCallback? onPressedMessage;
  final VoidCallback? onPressedWhatsapp;
  final dynamic item;
  final RxBool checkedValue = false.obs;

  ContactsCardWidget(
      {this.onPressed,
      this.onPressedEdit,
      this.onPressedDelete,
      this.onPressedCall,
      this.onPressedMessage,
      this.onPressedWhatsapp,
      required this.item});

  String getInitials(String firstName, String lastName) {
    String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    String lastInitial = (lastName.isNotEmpty)
        ? lastName[0] == "-"
            ? ""
            : lastName[0]
        : "";
    return '$firstInitial$lastInitial'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    print("item: isChecked  profilePic ${item["profilePic"]}");
    print("item: isChecked  22222222222222222222222 $item");
    checkedValue.value = item["isChecked"];
    return Card(
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Obx(() => Checkbox(
                      value: checkedValue.value,
                      activeColor: ThemeConstants.primaryColor,
                      onChanged: (v) {
                        print(v);
                        checkedValue.value = v!;
                        if (checkedValue.value == true) {
                          item["isChecked"] = true;
                          contactsController.selectedContacts
                              .add("${item["conId"]}");
                          contactsController.selectedContacts.refresh();
                        } else {
                          // remove the item from list , if exist.
                          if (contactsController.selectedContacts.isNotEmpty) {
                            var contact = contactsController.selectedContacts
                                .firstWhere((C) => C == item["conId"],
                                    orElse: () => null);
                            print("hey ite found: ${contact}");
                            contactsController.selectedContacts.remove(contact);
                            item["isChecked"] = false;
                          }
                        }
                        print(
                            " final selected conatcts length: ${contactsController.selectedContacts.length}");
                        print(
                            "selected conatcts length: ${contactsController.selectedContacts.toJson()}");
                      })),
                ),
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
                            child: item['profilePic'] != null &&
                                    item['profilePic'] != ''
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
                PopupMenuButton<int>(
                  icon: Icon(
                    LineIcons.verticalEllipsis,
                    color: ThemeConstants.iconColor,
                    size: 20,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.pen,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Edit",
                          ),
                        ],
                      ),
                      onTap: onPressedEdit,
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.trash,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(width: 10),
                          Text("Delete"),
                        ],
                      ),
                      onTap: onPressedDelete,
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.phone,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(width: 10),
                          Text("Call"),
                        ],
                      ),
                      onTap: onPressedCall,
                    ),
                    PopupMenuItem(
                      value: 3,
                      child: Row(
                        children: [
                          Icon(
                            LineIcons.whatSApp,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(width: 10),
                          Text("Whatsapp"),
                        ],
                      ),
                      onTap: onPressedWhatsapp,
                    ),
                    PopupMenuItem(
                      value: 4,
                      child: Row(
                        children: [
                          Icon(
                            Icons.message_outlined,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(width: 10),
                          Text("Message"),
                        ],
                      ),
                      onTap: onPressedMessage,
                    ),
                  ],
                  elevation: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

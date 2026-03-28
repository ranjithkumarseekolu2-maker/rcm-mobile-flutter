import 'dart:io';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:brickbuddy/commons/widgets/contacts_card_widget.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_area_widget.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/components/bottomsheet/modals/modal_with_scroll.dart';
import 'package:brickbuddy/components/bottomsheet/web_frame.dart';
import 'package:brickbuddy/components/contacts/contacts_controller.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/image_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:badges/badges.dart' as badges;
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ContactsComponent extends StatelessWidget {
//   const ContactsComponent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         print("onWill pop scope calle");
//         logout();
//         return false;
//       },
//       child:

//        MaterialApp(
//         theme: ThemeData(platform: TargetPlatform.iOS),
//         darkTheme: ThemeData.dark().copyWith(platform: TargetPlatform.iOS),
//         title: 'BottomSheet Modals',
//         builder: (context, Widget? child) => WebFrame(
//           child: CupertinoTheme(
//             data: CupertinoThemeData(
//               brightness: Theme.of(context).brightness,
//               scaffoldBackgroundColor: CupertinoColors.systemBackground,
//             ),
//             child: child!,
//           ),
//         ),
//         onGenerateRoute: (RouteSettings settings) {
//           switch (settings.name) {
//             case '/':
//               return MaterialWithModalsPageRoute(
//                   builder: (_) => ContactsComponent(), settings: settings);
//           }
//           return MaterialPageRoute(
//             builder: (context) => Scaffold(
//               body: CupertinoScaffold(
//                 body: Builder(
//                   builder: (context) => CupertinoPageScaffold(
//                     navigationBar: CupertinoNavigationBar(
//                       transitionBetweenRoutes: false,
//                       middle: Text('Normal Navigation Presentation'),
//                       trailing: GestureDetector(
//                         child: Icon(Icons.arrow_upward),
//                         onTap: () =>
//                             CupertinoScaffold.showCupertinoModalBottomSheet(
//                           expand: true,
//                           context: context,
//                           backgroundColor: Colors.transparent,
//                           builder: (context) => Stack(
//                             children: <Widget>[
//                               ModalWithScroll(),
//                               Positioned(
//                                 height: 40,
//                                 left: 40,
//                                 right: 40,
//                                 bottom: 20,
//                                 child: MaterialButton(
//                                   onPressed: () => Navigator.of(context)
//                                       .popUntil((route) =>
//                                           route.settings.name == '/'),
//                                   child: Text('Pop back home'),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     child: Center(
//                       child: Container(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             settings: settings,
//           );
//         },
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }

logout() async {
  await Get.dialog(AppCupertinoDialog(
    title: 'Exit'.tr,
    subTitle: 'Are you sure you want to exit app?',
    isOkBtn: false,
    acceptText: 'Yes'.tr,
    cancelText: 'No'.tr,
    onAccepted: () async {
      exit(0);
      //CommonService.confirmLogout();
    },
    onCanceled: () {
      Get.back();
    },
  ));
}

class ContactsComponent extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<ContactsComponent> {
  ContactsController contactsController = Get.put(ContactsController());

  int? selectedButtonIndex;
  String conId = '';
  var detailsRes;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("onWill pop scope calle");
        logout();
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              backgroundColor: ThemeConstants.primaryColor,
              title: Text('Contacts',
                  style: TextStyle(color: ThemeConstants.whiteColor)),
              // leading: IconButton(
              //   icon: Icon(Icons.arrow_back_ios, color: ThemeConstants.whiteColor),
              //   onPressed: () {
              //     Get.back();
              //   },
              // ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => badges.Badge(
                        position: badges.BadgePosition.topEnd(top: 0, end: 3),
                        badgeAnimation: badges.BadgeAnimation.slide(
                            // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                            // curve: Curves.easeInCubic,
                            ),
                        showBadge:
                            CommonService.instance.allNotificationsCount.value >
                                    0
                                ? true
                                : false,
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: ThemeConstants.errorColor,
                        ),
                        badgeContent: Text(
                          CommonService.instance.allNotificationsCount
                              .toString(),
                          style: Styles.whiteSubHeadingStyles4,
                        ),
                        child: IconButton(
                            icon: Icon(
                              LineIcons.bell,
                              color: ThemeConstants.whiteColor,
                              size: 25,
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              HomeController homeController = Get.find();
                              prefs.setInt("notidicationsSeen",
                                  homeController.notificationsList.length);

                              // HomeController homeController = Get.find();
                              // homeController.storage.write("notidicationsSeen",
                              //     homeController.notificationsList.length);
                              Get.delete<NotificationsController>(force: true);
                              Get.toNamed(Routes.notificationsComponent);
                            }),
                      )),
                ),
              ],
            ),
            body: Obx(() => LoadingOverlay(
                opacity: 1,
                color: Colors.black54,
                progressIndicator: const SpinKitCircle(
                  color: ThemeConstants.whiteColor,
                  size: 50.0,
                ),
                isLoading: contactsController.isContactsLoading.value,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding,
                    vertical: ThemeConstants.screenPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => contactsController.selectedContacts.isNotEmpty
                          ? Column(
                              children: [
                                Container(child: buildSearchBox()),
                                SizedBox(height: ThemeConstants.height10),
                                Obx(() => contactsController
                                        .selectedContacts.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  contactsController
                                                              .selectedContacts
                                                              .length
                                                              .toString() ==
                                                          '1'
                                                      ? Text(
                                                          "${contactsController.selectedContacts.length.toString()} Contact Selected",
                                                          style: Styles
                                                              .hint1Styles,
                                                        )
                                                      : Text(
                                                          "${contactsController.selectedContacts.length.toString()} Contacts Selected",
                                                          style: Styles
                                                              .hint1Styles,
                                                        ),
                                                  SizedBox(
                                                    height:
                                                        ThemeConstants.height6,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      contactsController
                                                          .selectedContacts
                                                          .clear();
                                                      contactsController
                                                          .getAllContacts();
                                                    },
                                                    child: Text(
                                                      'Clear',
                                                      style: Styles.link3Styles,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              RoundedFilledButtonWidget(
                                                buttonName: "Assign Project",
                                                backgroundColor:
                                                    ThemeConstants.primaryColor,
                                                isLargeBtn: false,
                                                buttonTextColor:
                                                    ThemeConstants.whiteColor,
                                                onPressed: () {
                                                  contactsController
                                                      .selectedProject
                                                      .value = "";
                                                  openAssignprojectSheet(
                                                      context);
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.height10),
                                        ],
                                      )
                                    : const SizedBox.shrink()),
                              ],
                            )
                          : Flexible(
                              flex: 2,
                              child: buildSearchBox(),
                            )),
                      SizedBox(height: ThemeConstants.height10),
                      Obx(
                        () => contactsController.contactsTotalCount.value ==
                                    0 ||
                                contactsController.isLoading.value ||
                                contactsController.selectedContacts.isNotEmpty
                            ? SizedBox.shrink()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  "${contactsController.contactsTotalCount.value.toString()} Contacts",
                                  style: Styles.hint1Styles,
                                ),
                              ),
                      ),
                      SizedBox(height: ThemeConstants.height10),
                      Expanded(
                        flex: 13,
                        child: SingleChildScrollView(
                          controller: contactsController.scrollController,
                          child: Column(
                            children: [
                              Obx(() => (contactsController.isLoading.value ==
                                      true)
                                  ? Container(
                                      height: Get.height * 0.5,
                                      child: showCustomLoader())
                                  : contactsController.contactsList.isNotEmpty
                                      ? Column(
                                          children: [
                                            ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: contactsController
                                                  .contactsList.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return Obx(() => InkWell(
                                                      child: ContactsCardWidget(
                                                        item: contactsController
                                                                .contactsList[
                                                            index],
                                                        onPressedMessage: () {
                                                          contactsController.sendSmsToPhone(
                                                              contactsController
                                                                          .contactsList[
                                                                      index][
                                                                  'primaryNumber']);
                                                        },
                                                        onPressedWhatsapp: () {
                                                          contactsController
                                                              .launchWhatsappWithMobileNumber(
                                                                  contactsController
                                                                              .contactsList[
                                                                          index]
                                                                      [
                                                                      'primaryNumber']);
                                                        },
                                                        onPressedEdit: () {
                                                          print(
                                                              "onEdit called: ${contactsController.contactsList[index]}");
                                                          print(
                                                              "onEdit called22222: ${contactsController.contactsList[index]['profilePic']}");

                                                          contactsController
                                                              .isEdit
                                                              .value = true;

                                                          print(
                                                              'firstname: ${contactsController.contactsList[index]['firstName']}');
                                                          print(
                                                              'conid: ${contactsController.contactsList[index]['conId']}');
                                                          print(
                                                              'lastname: ${contactsController.contactsList[index]['lastName']}');
                                                          print(
                                                              'primarynum: ${contactsController.contactsList[index]['primaryNumber']}');
                                                          print(
                                                              'secnum: ${contactsController.contactsList[index]['secondaryNumber']}');
                                                          print(
                                                              'workinfo: ${contactsController.contactsList[index]['workinfo']}');
                                                          print(
                                                              'email: ${contactsController.contactsList[index]['email']}');
                                                          print(
                                                              'address: ${contactsController.contactsList[index]['address']}');
                                                          print(
                                                              'notes: ${contactsController.contactsList[index]['notes']}');

                                                          contactsController
                                                              .firstNameController
                                                              .text = contactsController
                                                                  .contactsList[
                                                              index]['firstName'];
                                                          contactsController
                                                              .lastNameController
                                                              .text = contactsController
                                                                  .contactsList[
                                                              index]['lastName'];
                                                          contactsController
                                                              .primaryNumberController
                                                              .text = contactsController
                                                                      .contactsList[
                                                                  index]
                                                              ['primaryNumber'];
                                                          contactsController
                                                              .secondaryNumberController
                                                              .text = contactsController
                                                                          .contactsList[
                                                                      index][
                                                                  'secondaryNumber'] ??
                                                              "";
                                                          contactsController
                                                              .workinfoController
                                                              .text = contactsController
                                                                          .contactsList[
                                                                      index][
                                                                  'workinfo'] ??
                                                              "";
                                                          contactsController
                                                                  .emailController
                                                                  .text =
                                                              contactsController
                                                                              .contactsList[
                                                                          index]
                                                                      [
                                                                      'email'] ??
                                                                  "";
                                                          contactsController
                                                              .addressController
                                                              .text = contactsController
                                                                          .contactsList[
                                                                      index]
                                                                  ['address'] ??
                                                              "";
                                                          contactsController
                                                                  .notesController
                                                                  .text =
                                                              contactsController
                                                                              .contactsList[
                                                                          index]
                                                                      [
                                                                      'notes'] ??
                                                                  "";
                                                          contactsController
                                                                  .contactid
                                                                  .text =
                                                              contactsController
                                                                      .contactsList[
                                                                  index]['conId'];
                                                          if (contactsController
                                                                          .contactsList[
                                                                      index][
                                                                  'profilePic'] !=
                                                              null) {
                                                            contactsController
                                                                .profilePic
                                                                .value = contactsController
                                                                            .contactsList[
                                                                        index][
                                                                    'profilePic']
                                                                //     ['URL']
                                                                ??
                                                                "";
                                                          } else {
                                                            contactsController
                                                                .profilePic
                                                                .value = "";
                                                            contactsController
                                                                .image
                                                                .value = "";
                                                          }

                                                          openModalBottomSheet(
                                                              context);
                                                        },
                                                        onPressedDelete: () {
                                                          Get.dialog(
                                                              AppCupertinoDialog(
                                                            title: 'Delete'.tr,
                                                            subTitle:
                                                                'Are you sure you want to delete?',
                                                            isOkBtn: false,
                                                            acceptText:
                                                                'Yes'.tr,
                                                            cancelText: 'No'.tr,
                                                            onAccepted:
                                                                () async {
                                                              // exit(0);
                                                              print(
                                                                  'onaccepteddelete');
                                                              // if (Get.isDialogOpen ??
                                                              //     false) {
                                                              Get.close(0);
                                                              // }
                                                              String contactId =
                                                                  contactsController
                                                                              .contactsList[
                                                                          index]
                                                                      ['conId'];
                                                              print(
                                                                  'conId: $contactId');

                                                              await contactsController
                                                                  .delete(
                                                                      contactId);
                                                              //  print('error123${contactsController.contactsList[0]['contacts'][index]['conId']}');
                                                              print(
                                                                  'conid: ${contactsController.contactsList[index]['conId']}');

                                                              // contactsController.delete(
                                                              //     contactsController
                                                              //                 .contactsList[
                                                              //             index]
                                                              //         [
                                                              //         'conId']);
                                                              //  contactsController.delete(contactsController.contactsList[0]['contacts'][index]['conId']);

                                                              // Get.back();
                                                              //  contactsController.getAllContacts();
                                                            },
                                                            //                         onAccepted: () async {
                                                            //   print('onaccepteddelete');
                                                            //   print('conid: ${contactsController.contactsList[index]['conId']}');
                                                            //   // Delete the contact
                                                            //   await contactsController.delete(contactsController.contactsList[index]['conId']);

                                                            //   // Close the dialog
                                                            //   Get.back();

                                                            //   // Navigate back
                                                            //   Get.back();
                                                            // },

                                                            onCanceled: () {
                                                              Get.back();
                                                            },
                                                          ));
                                                        },
                                                        onPressedCall: () {
                                                          contactsController.makePhoneCall(
                                                              contactsController
                                                                          .contactsList[
                                                                      index][
                                                                  'primaryNumber']);
                                                        },
                                                      ),
                                                    ));
                                              },
                                            ),
                                            Obx(() => contactsController
                                                    .isInfiniteLoading.value
                                                ? showCustomLoader()
                                                : SizedBox.shrink()),
                                            SizedBox(
                                              height: ThemeConstants.height100,
                                            )
                                          ],
                                        )
                                      : buildNoContactsWidget()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
            bottomNavigationBar: BottombarWidget(),
            floatingActionButton: Obx(
              () => contactsController.isLoading.value
                  ? SizedBox.shrink()
                  : contactsController.isFabExpanded.value
                      ? buildExpandedFab()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                contactsController.isFabExpanded.value = true;
                              });
                            },
                            backgroundColor: ThemeConstants.primaryColor,
                            child: Icon(LineIcons.plus,
                                color: ThemeConstants.whiteColor,
                                size: ThemeConstants.height31),
                            shape: CircleBorder(),
                          ),
                        ),
            ),
          )
        ],
      ),
    );
  }

  static logout() async {
    await Get.dialog(AppCupertinoDialog(
      title: 'Exit'.tr,
      subTitle: 'Are you sure you want to exit app?',
      isOkBtn: false,
      acceptText: 'Yes'.tr,
      cancelText: 'No'.tr,
      onAccepted: () async {
        // CommonService.confirmLogout();
        exit(0);
      },
      onCanceled: () {
        Get.back();
      },
    ));
  }

  Widget buildExpandedFab() {
    // Set the second option as selected by default (index 1)
    selectedButtonIndex ??= 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        buildOption("Sync From Contacts", Icons.sync, Colors.blue, Icons.people,
            "People", 0),
        SizedBox(
          height: ThemeConstants.height12,
        ),
        // buildOption("Import from CSV", Icons.file_download, Colors.blue,
        //     Icons.file_download, "Import File", 1),
        // SizedBox(
        //   height: ThemeConstants.height12,
        // ),
        buildOption("New Contact", Icons.person_add, Colors.blue,
            Icons.person_add, "New Contact", 1),
        SizedBox(
          height: ThemeConstants.height12,
        ),
        SizedBox(
            height: ThemeConstants.height10), // Add a SizedBox with width 10
        FloatingActionButton(
          onPressed: () {
            setState(() {
              contactsController.isFabExpanded.value = false;
            });
          },
          backgroundColor: ThemeConstants.primaryColor,
          child: Icon(Icons.close,
              color: Colors.white, size: ThemeConstants.fontSize24),
          shape: CircleBorder(),
        ),
      ],
    );
  }

  buildSearchBox() {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(ThemeConstants.searchRadius)),
          side: const BorderSide(
            color: Colors.black12,
            width: 1.0,
          )),
      child: TextFormField(
        onChanged: (v) {
          print("onChanged: $v");
          if (v.length >= 1) {
            contactsController.getContactsBySearchValue();
          } else if (v.isEmpty) {
            contactsController.getAllContacts();
          }
        },
        cursorColor: ThemeConstants.primaryColor,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: 100,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.text,
        style: Styles.inputTextStyles,
        controller: contactsController.searchController,
        decoration: InputDecoration(
          counterText: '',
          fillColor: Colors.white,
          filled: true,
          hintText: "Search",
          prefixIcon: const LineIcon(
            Icons.search,
            size: 20,
            color: ThemeConstants.greyColor,
          ),
          suffixIcon: InkWell(
            onTap: () {
              contactsController.issearchValue.value = false;
              print('seleConts ${contactsController.selectedContacts}');
              if (contactsController.selectedContacts.isEmpty) {
                contactsController.searchController.text = "";
                contactsController.hasSelectedContacts.value = false;
                contactsController.getAllContacts();
              } else {
                contactsController.hasSelectedContacts.value = true;
                contactsController.searchController.text = "";
                //  contactsController.pageOffset.value = 0;
                contactsController.getAllContacts();
              }
            },
            child: LineIcon(
              Icons.close,
              size: 20,
              color: ThemeConstants.greyColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          hintStyle: Styles.hintStyles,
          contentPadding: EdgeInsets.all(
              Get.height * ThemeConstants.textFieldContentPadding),
          isDense: true,
          errorStyle: TextStyle(
            fontFamily: ThemeConstants.fontFamily,
            color: ThemeConstants.errorColor,
            fontSize: ThemeConstants.fontSize10,
          ),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.all(
                  Radius.circular(ThemeConstants.searchRadius))),
        ),
      ),
    );
  }

  Widget buildOption(String containerText, IconData containerIcon,
      Color containerIconColor, IconData fabIcon, String fabText, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(width: ThemeConstants.width10),
        buildContainerWithText(
            containerText, containerIcon, containerIconColor),
        SizedBox(width: ThemeConstants.width10),
        buildMiniFab(
          fabIcon, fabText, index,
          //  {
          //   // Handle the onPressed logic here for each index
          //   if (index == 0) {
          //     print('Button with index 0 pressed');
          //     Get.toNamed(Routes.addcontact);
          //   } else {
          //     // Handle other index cases if needed
          //   }
          // }
        ),
      ],
    );
  }

  Widget buildMiniFab(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        print("index 1111111111111: $index");
        setState(() {
          // Set the selected button
          selectedButtonIndex = index;
        });

        if (index == 0) {
          print("Sync From Contacts");
          contactsController.requestPermission();
        }

        if (index == 1) {
          contactsController.isEdit.value = false;
          contactsController.clearData();
          openModalBottomSheet(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: selectedButtonIndex == index
              ? Colors.blue
              : ThemeConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child:
              Icon(icon, color: Colors.white, size: ThemeConstants.fontSize24),
        ),
      ),
    );
  }

  // Widget buildContainerWithText(String text, IconData icon, Color iconColor) {
  //   return Container(
  //     color: Colors.white,
  //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     child: Row(
  //       children: [
  //         Icon(icon, color: iconColor),
  //         SizedBox(width: 8),
  //         Text(text, style: TextStyle(color: iconColor)),
  //       ],
  //     ),
  //   );
  // }
  Widget buildContainerWithText(String text, IconData icon, Color iconColor) {
    return Container(
      color: ThemeConstants.whiteColor,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Remove the icon part
          Text(
            text,
            style: TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold, // Make the text bold
            ),
          ),
        ],
      ),
    );
  }

  openImportBottomSheet(context) {
    return showCupertinoModalBottomSheet(
      topRadius: const Radius.circular(30),
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: contactsController.contactFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ThemeConstants.height20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Import from CSV',
                      style: Styles.headingStyles,
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height100,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.back();
                            contactsController.pickFile();
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            dashPattern: [6, 6],
                            color: ThemeConstants.greyColor,
                            radius: const Radius.circular(12),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                height: 125,
                                width: 145,
                                color: ThemeConstants.whiteColor,
                                child: Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      ImageConstants.uploadImage,
                                      width: 45,
                                      height: 45,
                                    ),
                                    SizedBox(
                                      height: ThemeConstants.height10,
                                    ),
                                    Text(
                                      "Click here to upload",
                                      style: Styles.hint3Styles,
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: ThemeConstants.height20,
                      ),
                      InkWell(
                        onTap: () {
                          contactsController.startDownload(
                              "https://brickboss.app/SampleContacts.csv");
                        },
                        child: Text(
                          "Download Sample Csv",
                          style: Styles.link1Styles,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  openAssignprojectSheet(context) {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child:
                                  //Obx(() =>
                                  // contactsController
                                  //         .isAssignProjectLoading.value
                                  //     ? showCustomLoader()
                                  //   :
                                  Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Assign Project',
                                        style: Styles.subHeadingStyles,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 30,
                                          color: Color(0XFF7B7B7B),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height20,
                                  ),
                                  Form(
                                    key: contactsController.projectFormKey,
                                    child: Obx(() => DropdownFormFieldWidget(
                                          hintText: 'Select  Project',
                                          isRequired: true,
                                          icon: Icon(
                                            Icons.person,
                                            color: ThemeConstants.greyColor,
                                          ),
                                          selectedValue: contactsController
                                                      .selectedProject.value !=
                                                  ''
                                              ? contactsController
                                                  .selectedProject.value
                                              : null,
                                          onChange: (value) {
                                            print("selected value: $value");
                                            contactsController
                                                .selectedProject.value = value;
                                            contactsController
                                                .getBuilderIdByProjectId(
                                                    contactsController
                                                        .selectedProject.value,
                                                    contactsController
                                                        .projectsList);
                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                          },
                                          items: contactsController.projectsList
                                              .map<DropdownMenuItem>(
                                                  (dynamic item) {
                                            return DropdownMenuItem(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0, right: 0),
                                                  child:
                                                      Text(item["projectName"]),
                                                ),
                                                value: item["projectId"]);
                                          }).toList(),
                                        )),
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height20,
                                  ),
                                  RoundedFilledButtonWidget(
                                      buttonName: 'Assign',
                                      onPressed: () {
                                        Get.close(0);
                                        if (contactsController
                                            .projectFormKey.currentState!
                                            .validate()) {
                                          contactsController
                                              .assignProject(context);
                                        } else {}
                                      })
                                ],
                              ))),
                    ]),
                  )),
            ));
  }

  openModalBottomSheet(context) {
    return showCupertinoModalBottomSheet(
        //expand: true,
        topRadius: Radius.circular(30),
        context: context,
        builder: (context) => Container(
              // height: MediaQuery.of(context).copyWith().size.height * 0.85,
              child: WillPopScope(
                onWillPop: () async {
                  contactsController.isFabExpanded.value = false;
                  Navigator.pop(context);
                  return false;
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ThemeConstants.screenPadding),
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Form(
                        key: contactsController.contactFormKey,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ThemeConstants.height20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => contactsController.isEdit.value
                                    ? Text(
                                        'Update contact',
                                        style: Styles.headingStyles,
                                      )
                                    : Text(
                                        'Add Contact',
                                        style: Styles.headingStyles,
                                      )),
                                InkWell(
                                    onTap: () {
                                      contactsController.isFabExpanded.value =
                                          false;
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      LineIcons.times,
                                      color: ThemeConstants.iconColor,
                                      size: 20,
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Stack(
                                children: [
                                  Obx(() =>
                                      contactsController.isEdit.value == true
                                          ? buildEditModePic()
                                          : buildAddModePic()),
                                  buildPhotoSection(context),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildLabel('First Name', true),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            TextBoxWidget(
                              controller:
                                  contactsController.firstNameController,
                              hintText: 'First Name',
                              isRequired: true,
                              maxLength: 100,
                              label: 'Name',
                              readOnly: false,
                              icon: Icon(
                                Icons.person,
                                color: ThemeConstants.greyColor,
                                size: ThemeConstants.fontSize18,
                              ),
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLabel('Last Name', false),
                                      SizedBox(
                                        height: ThemeConstants.height5,
                                      ),
                                      Container(
                                        width: Get.width / 2 - 20,
                                        child: TextBoxWidget(
                                          controller: contactsController
                                              .lastNameController,
                                          hintText: 'Last Name',
                                          isRequired: false,
                                          maxLength: 100,
                                          readOnly: false,
                                          icon: Icon(
                                            Icons.person,
                                            color: ThemeConstants.greyColor,
                                            size: ThemeConstants.fontSize18,
                                          ),
                                        ),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLabel('Primary Contact', true),
                                      SizedBox(
                                        height: ThemeConstants.height5,
                                      ),
                                      Container(
                                        width: Get.width / 2 - 20,
                                        child: MobileNumberWidget(
                                            hintText: 'Primary Contact',
                                            controller: contactsController
                                                .primaryNumberController,
                                            isRequired: true
                                            // hintText: 'Primary Contact',
                                            // isRequired: true,
                                            // maxLength: 10,
                                            // readOnly: false,
                                            // icon: Icon(
                                            //   Icons.call,
                                            //   color: ThemeConstants.greyColor,
                                            //   size: ThemeConstants.fontSize18,
                                            // ),
                                            ),
                                      ),
                                    ]),
                              ],
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLabel('Secondary Contact', false),
                                      SizedBox(
                                        height: ThemeConstants.height5,
                                      ),
                                      Container(
                                        width: Get.width / 2 - 20,
                                        child: MobileNumberWidget(
                                            hintText: 'Secondary Contact',
                                            controller: contactsController
                                                .secondaryNumberController,
                                            isRequired: false

                                            // hintText: 'Secondary Contact',
                                            // isRequired: true,
                                            // maxLength: 100,
                                            // readOnly: false,
                                            // icon: Icon(
                                            //   Icons.call,
                                            //   color: ThemeConstants.greyColor,
                                            //   size: ThemeConstants.fontSize18,
                                            // ),
                                            ),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildLabel('Work Info', false),
                                      SizedBox(
                                        height: ThemeConstants.height5,
                                      ),
                                      Container(
                                        width: Get.width / 2 - 20,
                                        child: TextBoxWidget(
                                          controller: contactsController
                                              .workinfoController,
                                          hintText: 'Work Info',
                                          isRequired: false,
                                          maxLength: 100,
                                          readOnly: false,
                                          // icon: Icon(Icons.call),
                                        ),
                                      ),
                                    ]),
                              ],
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildLabel('Email', false),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            TextBoxWidget(
                              controller: contactsController.emailController,
                              hintText: 'Email',
                              isRequired: false,
                              maxLength: 100,
                              readOnly: false,
                              icon: Icon(
                                Icons.mail,
                                size: ThemeConstants.fontSize18,
                                color: ThemeConstants.greyColor,
                              ),
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildLabel('Address', false),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            TextAreaWidget(
                              hintText: 'Address',
                              controller: contactsController.addressController,
                            ),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildLabel('Notes', false),
                            SizedBox(
                              height: ThemeConstants.height5,
                            ),
                            TextAreaWidget(
                              hintText: 'Notes',
                              controller: contactsController.notesController,
                            ),
                            SizedBox(
                              height: ThemeConstants.height31,
                            ),
                            Obx(() => contactsController.isEdit.value == false
                                ? contactsController.isLoading.value
                                    ? RoundedFilledButtonWidget(
                                        buttonName: 'Add contact',
                                        backgroundColor:
                                            ThemeConstants.primaryColor20,
                                        onPressed: () async {})
                                    : RoundedFilledButtonWidget(
                                        buttonName: 'Add contact',
                                        onPressed: () async {
                                          // if (contactsController.contactFormKey.currentState!.validate()) {
                                          // Check if First Name and Primary Contact are not empty
                                          if (contactsController
                                              .contactFormKey.currentState!
                                              .validate()) {
                                            // if (contactsController
                                            //         .firstNameController.text.isNotEmpty &&
                                            //     contactsController.primaryNumberController
                                            //         .text.isNotEmpty) {
                                            await contactsController.save(
                                              contactsController.image.value,
                                              contactsController.conId,
                                              contactsController
                                                  .firstNameController.text,
                                              contactsController
                                                  .lastNameController.text,
                                              contactsController
                                                  .addressController.text,
                                              contactsController
                                                  .emailController.text,
                                              contactsController
                                                  .notesController.text,
                                              contactsController
                                                  .primaryNumberController.text,
                                              contactsController
                                                  .secondaryNumberController
                                                  .text,
                                              contactsController
                                                  .workinfoController.text,
                                            );
                                            // Close the modal bottom sheet
                                            if (contactsController
                                                    .isCloseDialog.value ==
                                                true) {
                                              Get.back();

                                              // Reset the form
                                              contactsController.clearData();
                                            }
                                          }
                                          //}
                                          // else {
                                          //   Get.rawSnackbar(
                                          //       message:
                                          //           "Please fill all required details");
                                          // }

                                          // contactsController.getAllContacts();
                                        },
                                      )
                                : contactsController.isLoading.value
                                    ? RoundedFilledButtonWidget(
                                        buttonName: 'Update',
                                        backgroundColor:
                                            ThemeConstants.primaryColor20,
                                        onPressed: () {})
                                    : RoundedFilledButtonWidget(
                                        buttonName: 'Update',
                                        onPressed: () {
                                          print("Contatc updating started");
                                          print(
                                              "primary number: ${contactsController.primaryNumberController.text}");
                                          contactsController.updateContact(
                                            contactsController
                                                .firstNameController.text,
                                            contactsController
                                                .lastNameController.text,
                                            contactsController
                                                .primaryNumberController.text,
                                            contactsController
                                                .secondaryNumberController.text,
                                            contactsController
                                                .workinfoController.text,
                                            contactsController
                                                .emailController.text,
                                            contactsController
                                                .addressController.text,
                                            contactsController
                                                .notesController.text,
                                            contactsController.contactid.text,
                                          );
                                          if (contactsController
                                                  .isCloseDialog.value ==
                                              true) {
                                            Get.back();
                                          }
                                          //contactsController.getAllContacts();
                                        },
                                      ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  buildEditModePic() {
    return Obx(() => contactsController.profilePic.value != ""
        ? Container(
            width: 145,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeConstants.primaryColor70,
              border: Border.all(color: ThemeConstants.greyColor),
              image: DecorationImage(
                image: NetworkImage((contactsController.profilePic.value)),
                fit: BoxFit.cover,
              ),
            ))
        : Obx(() => contactsController.image.value != ""
            ? Container(
                width: 145,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeConstants.primaryColor70,
                  border: Border.all(color: ThemeConstants.greyColor),
                  image: DecorationImage(
                    image: FileImage(File(contactsController.image.value)),
                    fit: BoxFit.cover,
                  ),
                ))
            : Container(
                width: 145,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ThemeConstants.whiteColor,
                  border: Border.all(color: ThemeConstants.greyColor),
                ),
                child: Icon(LineIcons.user,
                    color: ThemeConstants.iconColor, size: 30))));
  }

  buildAddModePic() {
    return Obx(() => contactsController.image.value != ""
        ? Container(
            width: 145,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeConstants.primaryColor70,
              border: Border.all(color: ThemeConstants.greyColor),
              image: DecorationImage(
                  image: FileImage(File(contactsController.image.value))
                  // fit: BoxFit.cover,
                  ),
            ))
        : Container(
            width: 145,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeConstants.whiteColor,
              border: Border.all(color: ThemeConstants.greyColor),
            ),
            child: Icon(LineIcons.user,
                color: ThemeConstants.iconColor, size: 30)));
  }

  buildPhotoSection(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: RawMaterialButton(
        onPressed: () {
          openPhotoModalBottomSheet();
        },
        elevation: 2.0,
        fillColor: ThemeConstants.primaryColor,
        child: Icon(
          Icons.camera_alt_outlined,
          color: const Color.fromRGBO(255, 255, 255, 1),
        ),
        padding: EdgeInsets.all(1.0),
        shape: CircleBorder(),
      ),
    );
  }

  openPhotoModalBottomSheet() {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (context) => Container(
          height: Get.height * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
              left: Get.height * 0.022, right: Get.height * 0.022),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: Get.height * 0.022, bottom: Get.height * 0.022),
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                    color: ThemeConstants.greyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  height: 5,
                  width: Get.width * 0.096,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      contactsController.image.value = "";
                      if (contactsController.isEdit.value == true) {
                        contactsController.profilePic.value = "";
                      }
                      Navigator.pop(context);

                      contactsController.takePhotoFromCamera();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width8),
                        Text(
                          'Take a Photo'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: ThemeConstants.fontFamily),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height24,
                  ),
                  GestureDetector(
                    onTap: () {
                      contactsController.image.value = "";
                      if (contactsController.isEdit.value == true) {
                        contactsController.profilePic.value = "";
                      }
                      Navigator.pop(context);

                      contactsController.selectPhotoFromGallery();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width8),
                        Text(
                          'Choose Photo From Gallery'.tr,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: ThemeConstants.fontFamily),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  buildLabel(label, isMandatory) {
    return Row(
      children: [
        Text(
          label,
          style: Styles.label3Styles,
        ),
        isMandatory
            ? Text(
                ' *',
                style: TextStyle(
                    color: ThemeConstants.errorColor,
                    decoration: TextDecoration.none,
                    fontSize: ThemeConstants.fontSize14),
              )
            : SizedBox.shrink()
      ],
    );
  }

  openSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (context) => Container(
          height: Get.height * 0.2,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
              left: Get.height * 0.022, right: Get.height * 0.022),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: Get.height * 0.022, bottom: Get.height * 0.022),
                child: Center(
                    child: Container(
                  decoration: const BoxDecoration(
                    color: ThemeConstants.greyColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  height: 5,
                  width: Get.width * 0.096,
                )),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                      // contactsController.takeProductImageFromCamera();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width10),
                        const Text(
                          'Take a Photo',
                          style:
                              TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: ThemeConstants.height20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      // contactsController
                      //     .selectProductImageFromGallery();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: ThemeConstants.greyColor,
                        ),
                        SizedBox(width: ThemeConstants.width10),
                        Text(
                          'Choose Photo From Gallery',
                          style:
                              TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

class buildNoContactsWidget extends StatelessWidget {
  const buildNoContactsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: ThemeConstants.appBackgroundColor,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.screenPadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/contact.png',
                width: 150,
                height: 150,
              ),
              SizedBox(height: ThemeConstants.height16),
              Text(
                "You don’t have any Contacts yet, Tap + to Create a New Contact",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ThemeConstants.fontSize16,
                  color: ThemeConstants.greyColor,
                ),
              ),
              SizedBox(height: ThemeConstants.height16),
              // Additional content
            ],
          ),
        ),
      ),
    );
  }
}

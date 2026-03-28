import 'dart:ffi';

import 'package:brickbuddy/commons/utils/date_util.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_area_widget.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/components/appointments/appointments_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/appointment.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppointmentsCardWidget extends StatefulWidget {
  final Appointment? item;
  VoidCallback? onPressedOnCall;
  AppointmentsCardWidget({super.key, this.item, this.onPressedOnCall});

  @override
  State<AppointmentsCardWidget> createState() => _AppointmentsCardWidgetState();
}

class _AppointmentsCardWidgetState extends State<AppointmentsCardWidget> {
  AppointmentsController appointmentController = Get.find();

  TextEditingController appointmentDateEditingController =
      TextEditingController();

  RxString appointmentStartDate = "".obs;
  TimeOfDay timeOfDay = TimeOfDay(hour: 8, minute: 0);
  RxString formattedTimeValue = ''.obs;
  String formattedDateString = '';
  RxString formattedTimeString = ''.obs;
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String inputString =
        DateTimeUtils.formatMeetingTime(widget.item!.startDateTime);

    // Split the input string by space to separate time and AM/PM indicator
    List<String> components = inputString.split(' ');

    // Split the time component by colon to separate hours and minutes
    List<String> timeComponents = components[0].split(':');

    // Parse the hour component as an integer
    int hour = int.parse(timeComponents[0]);

    // Check if the hour is less than 10 and greater than 0 (indicating AM)
    if (hour < 10 && hour > 0) {
      // Add leading zero to the hour
      timeComponents[0] = '0$hour';
    } else if (hour == 0) {
      // Handle midnight (12:00 AM)
      timeComponents[0] = '12';
    } else if (hour > 12) {
      // Subtract 12 to switch to 12-hour format
      hour -= 12;
      // Add leading zero to the hour if it's less than 10
      if (hour < 10) {
        timeComponents[0] = '0$hour';
      } else {
        timeComponents[0] = hour.toString();
      }
    }

    // Construct the formatted string
    String formattedString = "${timeComponents.join(':')} ${components[1]}";

    return Card(
      color: widget.item!.status == "cancelled" ||
              widget.item!.status == "completed"
          ? Colors.grey[200]
          : ThemeConstants.whiteColor,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.item!.userName != null
                                      ? Text(
                                          toBeginningOfSentenceCase(
                                                  widget.item!.userName!) ??
                                              "",
                                          style: widget.item!.status ==
                                                      "cancelled" ||
                                                  widget.item!.status ==
                                                      "completed"
                                              ? TextStyle(
                                                  color: Colors.black54,
                                                  fontSize:
                                                      ThemeConstants.fontSize14,
                                                  fontFamily:
                                                      ThemeConstants.fontFamily,
                                                  fontWeight: FontWeight.bold)
                                              : Styles.label2Styles,
                                        )
                                      : Text("-"),
                                  SizedBox(
                                    height: ThemeConstants.height6,
                                  ),
                                  Text(
                                    toBeginningOfSentenceCase(
                                            widget.item!.title!)
                                        .toString(),
                                    style: Styles.hintStylesLight,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  widget.item!.location! != ""
                                      ? SizedBox(
                                          height: ThemeConstants.height6,
                                        )
                                      : SizedBox.shrink(),
                                  widget.item!.location! != ""
                                      ? Row(
                                          children: [
                                            Icon(
                                              LineIcons.mapMarker,
                                              color: ThemeConstants.iconColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: ThemeConstants.width2,
                                            ),
                                            Expanded(
                                              child: Text(
                                                toBeginningOfSentenceCase(
                                                        widget.item!.location!)
                                                    .toString(),
                                                style: Styles.hintStylesLight,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  SizedBox(
                                    height: ThemeConstants.height10,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            LineIcons.calendar,
                                            size: 20,
                                            color: ThemeConstants.iconColor,
                                          ),
                                          SizedBox(
                                            width: ThemeConstants.width4,
                                          ),
                                          Text(
                                            DateTimeUtils.formatMeetingDate(
                                                widget.item!.startDateTime),
                                            style: Styles.hintStylesLight,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: ThemeConstants.width10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            LineIcons.clock,
                                            size: 20,
                                            color: ThemeConstants.iconColor,
                                          ),
                                          SizedBox(
                                            width: ThemeConstants.width4,
                                          ),
                                          Text(
                                            formattedString,
                                            //  DateTimeUtils.formatMeetingTime(item!.startDateTime),
                                            style: Styles.hintStylesLight,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            widget.item!.status == "cancelled" ||
                                    widget.item!.status == "completed"
                                ? PopupMenuButton<int>(
                                    icon: Icon(
                                      LineIcons.verticalEllipsis,
                                      color: ThemeConstants.iconColor,
                                      size: 20,
                                    ),

                                    // iconColor: Colors.black,
                                    surfaceTintColor: ThemeConstants.whiteColor,
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    onSelected: (v) {
                                      print("v: $v");

                                      if (v == 1) {
                                        appointmentController
                                            .updateAppointmentStatus(
                                                widget.item!, "deleted");
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        // row has two child icon and text
                                        child: Row(
                                          children: [
                                            Icon(
                                              LineIcons.trash,
                                              color: ThemeConstants.errorColor,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Delete")
                                          ],
                                        ),
                                      ),
                                    ],
                                    elevation: 2,
                                  )
                                : Row(
                                    children: [
                                      widget.item!.status == "SCHEDULED"
                                          ? PopupMenuButton<int>(
                                              icon: Icon(
                                                LineIcons.verticalEllipsis,
                                                color: ThemeConstants.iconColor,
                                                size: 20,
                                              ),

                                              // iconColor: Colors.black,
                                              surfaceTintColor:
                                                  ThemeConstants.whiteColor,
                                              constraints: BoxConstraints(),
                                              padding: EdgeInsets.zero,
                                              onSelected: (v) {
                                                print("v: $v");
                                                if (v == 1) {
                                                  print(
                                                      '......date ${widget.item!.userName}');
                                                  DateTime formatStartDate =
                                                      DateTime.parse(widget
                                                          .item!
                                                          .startDateTime!);

                                                  // Format the DateTime object into the desired date format
                                                  String formattedDate =
                                                      DateFormat("dd-MM-yyyy")
                                                          .format(
                                                              formatStartDate);
                                                  //

                                                  // Format the DateTime object into the desired time format
                                                  String formattedTime =
                                                      DateFormat("hh:mm a")
                                                          .format(
                                                              formatStartDate);
                                                  formattedDateString =
                                                      formattedDate;
                                                  formattedTimeValue.value =
                                                      formattedTime;
                                                  print(
                                                      'Original datetime string: $formattedDate');
                                                  print(
                                                      'Formatted date string: $formattedDate');
                                                  //patchValues
                                                  appointmentController
                                                          .titleController
                                                          .text =
                                                      widget.item!.title
                                                          .toString();
                                                  // appointmentController
                                                  //         .descriptionController
                                                  //         .text =
                                                  //     item!.description.toString();
                                                  appointmentController
                                                          .addressController
                                                          .text =
                                                      widget.item!.location
                                                          .toString();

                                                  appointmentStartDate.value =
                                                      widget
                                                          .item!.startDateTime!;

                                                  appointmentDateEditingController
                                                      .text = DateFormat(
                                                              "dd-MM-yyyy")
                                                          .format(DateTime
                                                              .parse(widget
                                                                  .item!
                                                                  .startDateTime!)) +
                                                      ' ' +
                                                      formattedString;

                                                  appointmentController
                                                          .selectedLead.value =
                                                      widget.item!.userId!;
                                                  openModalBottomSheetA(
                                                      context);
                                                }
                                                if (v == 2) {
                                                  appointmentController
                                                      .updateAppointmentStatus(
                                                          widget.item!,
                                                          "completed");
                                                }
                                                if (v == 3) {
                                                  appointmentController
                                                      .updateAppointmentStatus(
                                                          widget.item!,
                                                          "cancelled");
                                                }

                                                if (v == 4) {
                                                  appointmentController
                                                      .updateAppointmentStatus(
                                                          widget.item!,
                                                          "deleted");
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        LineIcons.pen,
                                                        color: ThemeConstants
                                                            .iconColor,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Edit")
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        LineIcons.checkCircle,
                                                        color: ThemeConstants
                                                            .iconColor,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Completed")
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 3,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        LineIcons.times,
                                                        color: ThemeConstants
                                                            .iconColor,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        // sized box with width 10
                                                        width: 10,
                                                      ),
                                                      Text("Cancelled")
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 4,
                                                  // row has two child icon and text
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        LineIcons.trash,
                                                        color: ThemeConstants
                                                            .errorColor,
                                                        size: 20,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Delete")
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              elevation: 2,
                                            )
                                          : widget.item!.status ==
                                                      "cancelled" ||
                                                  widget.item!.status ==
                                                      "completed"
                                              ? PopupMenuButton<int>(
                                                  icon: Icon(
                                                    LineIcons.verticalEllipsis,
                                                    color: ThemeConstants
                                                        .iconColor,
                                                    size: 20,
                                                  ),
                                                  surfaceTintColor:
                                                      ThemeConstants.whiteColor,
                                                  constraints: BoxConstraints(),
                                                  padding: EdgeInsets.zero,
                                                  onSelected: (v) {
                                                    print("v: $v");

                                                    if (v == 4) {
                                                      appointmentController
                                                          .updateAppointmentStatus(
                                                              widget.item!,
                                                              "deleted");
                                                    }
                                                  },
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      value: 4,
                                                      // row has two child icon and text
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            LineIcons.trash,
                                                            color:
                                                                ThemeConstants
                                                                    .errorColor,
                                                            size: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text("Delete")
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  elevation: 2,
                                                )
                                              : Text("data")
                                    ],
                                  ),
                          ],
                        ),

                        //SizedBox(height:ThemeConstants.height6),
                      ],
                    )),
                SizedBox(width: ThemeConstants.width10),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 1,
                color: const Color.fromRGBO(0, 0, 0, 0.05),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.item!.status == "cancelled" ||
                        widget.item!.status == "completed"
                    ? InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Icon(
                              LineIcons.phone,
                              color: ThemeConstants.primaryColor70,
                              size: 15,
                            ),
                            SizedBox(
                              width: ThemeConstants.width4,
                            ),
                            Text(
                              widget.item!.contact!.primaryNumber,
                              style: TextStyle(
                                  color: ThemeConstants.primaryColor70,
                                  fontSize: ThemeConstants.fontSize12,
                                  fontFamily: ThemeConstants.fontFamily,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    : InkWell(
                        onTap: widget.onPressedOnCall,
                        child: Row(
                          children: [
                            Icon(
                              LineIcons.phone,
                              color: ThemeConstants.primaryColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: ThemeConstants.width4,
                            ),
                            Text(
                              widget.item!.contact!.primaryNumber,
                              style: Styles.linkStyles,
                            ),
                          ],
                        ),
                      ),
                Container(
                  decoration: BoxDecoration(
                      color: widget.item!.status! == 'completed'
                          ? Color.fromARGB(255, 209, 252, 211)
                          : widget.item!.status! == 'deleted' ||
                                  widget.item!.status! == 'cancelled'
                              ? Color.fromARGB(255, 255, 210, 207)
                              : Color.fromARGB(255, 199, 230, 253),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 6.0),
                    child: Text(
                      toBeginningOfSentenceCase(
                          widget.item!.status!.toLowerCase())!,
                      style: TextStyle(
                          color: widget.item!.status! == 'deleted' ||
                                  widget.item!.status! == 'cancelled'
                              ? Color.fromARGB(255, 155, 13, 3)
                              : (widget.item!.status! == 'completed')
                                  ? Color.fromARGB(255, 3, 141, 10)
                                  : Colors.blue,
                          fontSize: ThemeConstants.fontSize10),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  openModalBottomSheetA(context) {
    return showCupertinoModalBottomSheet(
      useRootNavigator: true,
      //expand: true,
      topRadius: Radius.circular(30),
      context: context,
      builder: (context) => Obx(() => appointmentController
                  .isAppointmentLoading.value ==
              true
          ? showCustomLoader()
          : Container(
              // height: MediaQuery.of(context).copyWith().size.height * 0.85,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Form(
                      key: appointmentController.apointmentFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: ThemeConstants.height20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Update Appointment',
                                style: Styles.headingStyles,
                              ),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const LineIcon(
                                    Icons.close,
                                    color: ThemeConstants.greyColor,
                                    size: 23,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          buildLabel('Selected Contact'),
                          SizedBox(
                            height: ThemeConstants.height4,
                          ),
                          Text(
                            widget.item!.userName!,
                            style: Styles.hintStyles,
                          ),

                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          Text(
                            'Appointment Details',
                            style: Styles.label1Styles,
                          ),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          buildDateAndTime(),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          buildLabel('Title'),
                          SizedBox(
                            height: ThemeConstants.height4,
                          ),
                          TextBoxWidget(
                            hintText: "",
                            controller: appointmentController.titleController,
                            isRequired: true,
                            label: "Title",
                          ),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          // buildLabel('Description'),
                          // SizedBox(
                          //   height: ThemeConstants.height4,
                          // ),
                          // TextAreaWidget(
                          //   hintText: 'Enter description',
                          //   controller:
                          //       appointmentController.descriptionController,
                          //   isRequired: false,
                          // ),
                          // SizedBox(
                          //   height: ThemeConstants.height10,
                          // ),
                          buildLabel('Address'),
                          SizedBox(
                            height: ThemeConstants.height4,
                          ),
                          TextAreaWidget(
                            hintText: 'Enter address',
                            controller: appointmentController.addressController,
                            isRequired: true,
                            label: "Address",
                          ),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          SizedBox(
                            height: ThemeConstants.height100,
                          ),
                          RoundedFilledButtonWidget(
                            buttonName: 'Update Appointment',
                            onPressed: () {
                              if (appointmentController
                                  .apointmentFormKey.currentState!
                                  .validate()) {
                                appointmentController.isLoading.value = true;

                                Appointment appointment = Appointment();
                                appointment.appointmentId =
                                    widget.item!.appointmentId;
                                appointment.title =
                                    appointmentController.titleController.text;
                                appointment.description = appointmentController
                                    .descriptionController.text;
                                appointment.startDateTime =
                                    appointmentStartDate.value;
                                appointment.endDateTime =
                                    appointmentStartDate.value;
                                ;
                                appointment.location = appointmentController
                                    .addressController.text;

                                appointmentController
                                    .updateAppointment(appointment);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
    );
  }

  buildLabel(label) {
    return Row(
      children: [
        Text(
          label,
          style: Styles.labelStyles,
        ),
        label == "Description" || label == "Selected Lead"
            ? SizedBox.shrink()
            : Text(
                ' *',
                style: TextStyle(
                    color: ThemeConstants.errorColor,
                    decoration: TextDecoration.none,
                    fontSize: ThemeConstants.fontSize14),
              )
      ],
    );
  }

  buildDateAndTime() {
    return Column(
      children: [
        buildLabel('Date & Time'),
        SizedBox(
          height: ThemeConstants.height4,
        ),

        // Container(
        //   color: ThemeConstants.whiteColor,
        //   // width: Get.width * 0.90,
        //   child: Theme(
        //     data: ThemeData.light().copyWith(
        //       colorScheme: ColorScheme.light()
        //           .copyWith(primary: ThemeConstants.primaryColor),
        //     ),
        //     child: DateTimeField(
        //       autovalidateMode: AutovalidateMode.always,
        //       resetIcon: null,
        //       keyboardType: TextInputType.datetime,
        //       enabled: true,
        //       initialValue: DateTime.now(),
        //       textAlign: TextAlign.start,
        //       onChanged: (v) {
        //         print('vvvvvv000 $v,${appointmentDateEditingController.text}}');
        //         // appointmentStartDate.value = v!.toIso8601String();
        //         String originalString = appointmentDateEditingController.text;

        //         // Split the original string by space to get date and time components
        //         List<String> components = originalString.split(' ');

        //         // Extract date components
        //         List<String> dateComponents = components[0].split('-');

        //         // Rearrange date components to match desired format
        //         String formattedDate =
        //             '${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]}';

        //         // Concatenate rearranged date and time components along with remaining part
        //         String formattedString =
        //             '$formattedDate ${components[1]} ${components[2]}';
        //         List<String> comp = formattedString.split(' ');

        //         // Concatenate the time part with seconds and milliseconds
        //         String dateAfterFormat = '${comp[0]}T${comp[1]}:00.000';
        //         appointmentStartDate.value = '${comp[0]}T${comp[1]}:00.000';
        //         //  appointmentDateEditingController.text = formattedString;
        //         print('Original string123: $formattedString');
        //         print('Formatted string234: $dateAfterFormat');
        //       },
        //       style: TextStyle(
        //         fontFamily: 'Montserrat',
        //         fontSize: ThemeConstants.fontSize15,
        //         color: Colors.black,
        //       ),
        //       decoration: InputDecoration(
        //         fillColor: ThemeConstants.whiteColor,
        //         filled: true,
        //         prefix: Text('  '),
        //         suffixIcon: Container(
        //           decoration: BoxDecoration(
        //               color: ThemeConstants.primaryColor,
        //               borderRadius: BorderRadius.only(
        //                   topRight: Radius.circular(10),
        //                   bottomRight: Radius.circular(10))),
        //           child: Icon(
        //             Icons.watch_later,
        //             color: ThemeConstants.whiteColor,
        //           ),
        //         ),
        //         hintText: "Select Date",
        //         enabledBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: ThemeConstants.greyColor),
        //             borderRadius: BorderRadius.all(Radius.circular(10))),
        //         border: OutlineInputBorder(
        //           borderRadius: BorderRadius.circular(10.0),
        //         ),
        //         focusedBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: ThemeConstants.primaryColor),
        //             borderRadius: BorderRadius.all(Radius.circular(10))),
        //         hintStyle: TextStyle(
        //             color: ThemeConstants.greyColor,
        //             fontFamily: 'Montserrat',
        //             fontWeight: FontWeight.w400,
        //             fontSize: ThemeConstants.fontSize14),
        //         contentPadding: EdgeInsets.all(0),
        //         isDense: true,
        //         errorStyle: TextStyle(
        //             color: Colors.red, fontSize: ThemeConstants.fontSize10),
        //         errorBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: ThemeConstants.primaryColor),
        //             borderRadius: BorderRadius.all(Radius.circular(5))),
        //         focusedErrorBorder: OutlineInputBorder(
        //             borderSide: BorderSide(color: ThemeConstants.primaryColor),
        //             borderRadius: BorderRadius.all(Radius.circular(5))),
        //       ),
        //       format: DateFormat("dd-MM-yyyy HH:mm a"),
        //       onShowPicker: (context, currentValue) async {
        //         final date = await showDatePicker(
        //             context: context,
        //             firstDate: DateTime.now(),
        //             initialDate: currentValue ?? DateTime.now(),
        //             lastDate: DateTime(2100));

        //         if (date != null) {
        //           final time = await showTimePicker(
        //             context: context,
        //             initialTime: TimeOfDay.now(),
        //             builder: (BuildContext context, Widget? child) {
        //               return MediaQuery(
        //                 data: MediaQuery.of(context)
        //                     .copyWith(alwaysUse24HourFormat: false),
        //                 child: child!,
        //               );
        //             },
        //           );
        //           print('ttttttttt $time');
        //           return DateTimeField.combine(date, time);
        //         } else {
        //           return currentValue;
        //         }
        //       },
        //       controller: appointmentDateEditingController,
        //       validator: (value) {
        //         print('value111 $value');

        //         if (value == null) {
        //           print('text $value');
        //           return "Start Date is required";
        //         }
        //         return null;
        //       },
        //     ),
        //   ),
        // )

        Obx(() => InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: dateTime,
                  initialDatePickerMode: DatePickerMode.day,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101));

              if (picked != null) {
                dateTime = picked;

                // Format the DateTime object into the desired format
                formattedDateString = DateFormat("dd-MM-yyyy").format(dateTime);
                //assign the chosen date to the controller
                showTimePicker(context: context, initialTime: TimeOfDay.now())
                    .then((dynamic value) {
                  print('val123 ${value.format(context).toString()}');
                  setState(() {
                    formattedTimeValue.value = value.format(context).toString();
                  });

                  // Parse the input time string
                  DateFormat inputFormat = DateFormat("hh:mm a");
                  DateTime dTime =
                      inputFormat.parse(value.format(context).toString());

                  // Format the DateTime object into the desired format
                  DateFormat outputFormat = DateFormat("HH:mm:ss.SSS");
                  formattedTimeString.value = outputFormat.format(dTime);
                  print('val12345 ${formattedTimeString.value}');
                  var finalizedDate = (dateTime.toString().split(' ')[0] +
                          'T' +
                          formattedTimeString.value)
                      .replaceAll('Z', '');
                  appointmentStartDate.value = finalizedDate.toString();
                  print('formTime0 $finalizedDate');
                });
              }
              print('formTime $formattedTimeString');

              print('formTime0123 ${appointmentStartDate.value}');
            },
            child: Container(
                width: Get.width,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: ThemeConstants.greyColor),
                    borderRadius: BorderRadius.circular(10)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: formattedTimeValue.value.isNotEmpty
                          ? Text(
                              formattedDateString.toString() +
                                  ' ' +
                                  '${formattedTimeValue.value}',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: ThemeConstants.fontSize15,
                                color: Colors.black,
                              ),
                            )
                          : Text(
                              'Select Date',
                              style: TextStyle(
                                fontSize: ThemeConstants.fontSize12,
                                color: ThemeConstants.greyColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: ThemeConstants.fontFamily,
                              ),
                            ),
                    ))))),
      ],
    );
  }
}

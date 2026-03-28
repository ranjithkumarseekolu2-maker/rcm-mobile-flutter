import 'package:brickbuddy/commons/services/appointment_service.dart';
import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_area_widget.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/appointment.dart';
import 'package:brickbuddy/model/create_appointment.dart';
import 'package:brickbuddy/model/update_appointment.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentsController extends GetxController {
  TextEditingController selectLeadController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  RxBool hasSelectedLead = false.obs;
  var apointmentFormKey = GlobalKey<FormState>();
  bool switchValue = true;
  List<String> remainderTime = ['10 Minutes', '20 Minutes', '30 Minutes'];
  RxString selectedRemainderTime = '10 Minutes'.obs;

  AppointmentService appointmentService = Get.find();
  RxList leadsList = [].obs;
  RxString selectedLead = "".obs;
  RxString startDate = "".obs;
  RxList<Appointment> appointmentList = <Appointment>[].obs;

  RxBool isLoading = false.obs;

  RxBool isAppointmentLoading = false.obs;

  void onInit() async {
    super.onInit();
    await getAllAppoitments();
    await getAllLeads();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  getAllAppoitments() {
    appointmentList.clear();
    isLoading.value = true;
    appointmentService.getAllAppointments().then((res) {
      print("getAllAppoitments res: ${res}");
      res.forEach((a) {
        if (a['status'] != "deleted") {
          appointmentList.add(Appointment.fromJson(a));
        }
      });
      appointmentList.sort(
          (a, b) => b.startDateTime!.compareTo(a.startDateTime.toString()));
      print("appointmentList length: ${appointmentList.length}");
      Future.delayed(const Duration(seconds: 2), () => isLoading.value = false);
    }).catchError((onError) {
      isLoading.value = false;

      print("getAllAppoitments catchError: $onError");
    });
  }

  getAllLeads() {
    appointmentService.getAllLeads().then((res) {
      print("getAllLeads res: $res");
      if (res != null) {
        res.forEach((l) {
          leadsList.add(l);
        });
      }
      leadsList.sort((a, b) => a['firstName'].compareTo(b['firstName']));
      print('llllllll $leadsList');
    }).catchError((onError) {
      print("getAllLeads catchError: $onError");
    });
  }

  sortByFirstName(contacts) {
    return contacts.sort((a, b) => {a.firstName.localeCompare(b.firstName)});
  }

  createAppointment() {
    int t = DateTime.now().compareTo(DateTime.parse(startDate.value));
    if (t <= 0) {
      print("1111 selectedLead ${startDate.value}");
      print("1111 selectedLead ${selectedLead.value}");

      isAppointmentLoading.value = true;
      CreateAppointment createAppointment = CreateAppointment();
      createAppointment.agentId = CommonService.instance.agentId.value;
      createAppointment.description = "";
      createAppointment.endDateTime = startDate.value;
      createAppointment.location = addressController.text;
      createAppointment.title = titleController.text;
      createAppointment.userId = selectedLead.value.split("_")[0];
      createAppointment.startDateTime = startDate.value;
      createAppointment.userName = selectLeadController.text;

      print("createAppointment toJson() ====> ${createAppointment.toJson()}");
      appointmentService.createAppointment(createAppointment).then((res) {
        isAppointmentLoading.value = false;
        print("createAppointment res: $res");
        Get.rawSnackbar(
            message: "Appointment Created Successfully.",
            backgroundColor: ThemeConstants.successColor);
        Get.delete<AppointmentsController>();
        Get.toNamed(Routes.appointmentsScreen);
      }).catchError((onError) {
        isAppointmentLoading.value = false;
        print("createAppointment catchError: $onError");
        Get.rawSnackbar(message: onError.toString());
      });
    } else {
      Get.rawSnackbar(
        message: 'Please select future date and time',
      );
    }
  }

  updateAppointmentStatus(Appointment appointment, status) {
    print("23:123 ${appointment.startDateTime}");
    isLoading.value = true;
    print("update Appointment : ${appointment.toJson()}");
    UpdateAppointment updateAppointment = UpdateAppointment();
    updateAppointment.id = appointment.appointmentId;
    updateAppointment.title = appointment.title;
    updateAppointment.description = "";
    updateAppointment.startDateTime = appointment.startDateTime;
    updateAppointment.endDateTime = appointment.endDateTime;
    updateAppointment.location = appointment.location;
    updateAppointment.status = status;
    appointmentService.updateAppointment(updateAppointment).then((res) {
      isLoading.value = false;
      print("updateAppointment res: $res");
      Get.rawSnackbar(
          message: "Appointment $status  Successfully",
          backgroundColor: ThemeConstants.successColor);
      getAllAppoitments();
    }).catchError((onError) {
      isLoading.value = false;
      print("updateAppointment catchError: $onError");
    });
    // } else {
    //   Get.rawSnackbar(message: 'Please select future date or time');
    // }
  }

  updateAppointment(Appointment appointment) {
    String timestamp1 =
        appointment.startDateTime!.replaceAll('T', ' ').replaceAll('Z', '');
    String timestamp2 = DateTime.now().toString();
    print('ppppp ${timestamp1}');
    DateTime dateTime1 = DateTime.parse(timestamp1);
    DateTime dateTime2 = DateTime.parse(timestamp2);
    print('datessss ${dateTime1},${dateTime2}');
    // Compare the two DateTime objects
    if (dateTime1.isAfter(dateTime2)) {
      isAppointmentLoading.value = true;
      print("update Appointment : ${appointment.toJson()}");
      UpdateAppointment updateAppointment = UpdateAppointment();
      updateAppointment.id = appointment.appointmentId;
      updateAppointment.title = appointment.title;
      updateAppointment.description = "";
      updateAppointment.startDateTime = appointment.startDateTime;
      updateAppointment.endDateTime = appointment.endDateTime;
      updateAppointment.location = appointment.location;
      updateAppointment.status = "SCHEDULED";
      // print(
      //     "The first timestamp is equal to or greater than the second timestamp. $a");
      // appointmentList.add(Appointment.fromJson(a));

      appointmentService.updateAppointment(updateAppointment).then((res) {
        isAppointmentLoading.value = false;
        print("updateAppointment res: $res");
        Get.rawSnackbar(
            message: "Appointment Updated Successfully",
            backgroundColor: ThemeConstants.successColor);
        Get.delete<AppointmentsController>();
        Get.toNamed(Routes.appointmentsScreen);
      }).catchError((onError) {
        isAppointmentLoading.value = false;
        print("updateAppointment catchError: $onError");
      });
    } else {
      Get.rawSnackbar(message: 'Please select future date');
    }
  }

  clearData() {
    selectedLead.value = '';
    dateController.text = '';
    titleController.text = "";
    selectLeadController.text = '';
    descriptionController.text = "";
    addressController.text = "";
  }

  openModalBottomSheet(context, action) {
    return showCupertinoModalBottomSheet(
      useRootNavigator: true,
      //expand: true,
      topRadius: Radius.circular(30),
      context: context,
      builder: (context) => Obx(() => isAppointmentLoading.value == true
          ? showCustomLoader()
          : Container(
              // height: MediaQuery.of(context).copyWith().size.height * 0.85,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Form(
                      key: apointmentFormKey,
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
                                action + ' appointment',
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
                          buildLabel('Select Contact'),
                          SizedBox(
                            height: ThemeConstants.height4,
                          ),
                          buildSelectLead(),
                          // Obx(() => DropdownFormFieldWidget(
                          //       hintText: 'Select contact',
                          //       isRequired: true,
                          //       icon: Icon(
                          //         Icons.person,
                          //         color: ThemeConstants.greyColor,
                          //       ),
                          //       selectedValue: selectedLead.value != ''
                          //           ? selectedLead.value
                          //           : null,
                          //       onChange: (value) {
                          //         print("selected value: $value");
                          //         selectedLead.value = value;
                          //         FocusScope.of(context)
                          //             .requestFocus(new FocusNode());
                          //       },
                          //       items: leadsList
                          //           .map<DropdownMenuItem>((dynamic item) {
                          //         return DropdownMenuItem(
                          //             child: Padding(
                          //               padding: const EdgeInsets.only(
                          //                   left: 0, right: 0),
                          //               child: Text(item["firstName"]),
                          //             ),
                          //             value: item["conId"] +
                          //                 "_" +
                          //                 item["firstName"]);
                          //       }).toList(),
                          //     )),
                          SizedBox(
                            height: ThemeConstants.height10,
                          ),
                          Text(
                            'Appointment details',
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
                            hintText: "Title",
                            controller: titleController,
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
                          //   controller: descriptionController,
                          //   isRequired: false,
                          // ),
                          //                     SizedBox(
                          //   height: ThemeConstants.height10,
                          // ),
                          buildLabel('Address'),

                          SizedBox(
                            height: ThemeConstants.height4,
                          ),
                          TextAreaWidget(
                            hintText: 'Address',
                            controller: addressController,
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
                            buttonName: 'Create Appointment',
                            onPressed: () {
                              if (apointmentFormKey.currentState!.validate()) {
                                isLoading.value = true;
                                createAppointment();
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

  buildSelectLead() {
    //print('Buiders... ${CommonService.instance.builders}');
    return TypeAheadField(
      controller: selectLeadController,
      builder: (context, controller, focusNode) => TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        autofocus: false,
        validator: (value) {
          if (selectLeadController.text == '') {
            return 'Contact is required';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          suffixIcon: Obx(() => selectedLead.value.isNotEmpty
              ? InkWell(
                  onTap: () {
                    selectLeadController.text = ' ';
                    selectedLead.value = '';
                  },
                  child: Icon(
                    Icons.close,
                    size: 18,
                  ))
              : Icon(Icons.arrow_drop_down)),
          fillColor: ThemeConstants.whiteColor,
          hintText: "Select Contact",
          hintStyle: Styles.hintStyles,
          contentPadding: EdgeInsets.all(
              Get.height * ThemeConstants.textFieldContentPadding),
        ),
      ),
      decorationBuilder: (context, child) => Material(
        type: MaterialType.card,
        elevation: 4,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: child,
      ),
      itemBuilder: (context, builder) => ListTile(
        title: builder['lastName'] != ''
            ? Text(
                builder["firstName"] + ' ' + builder["lastName"],
              )
            : Text(
                builder["firstName"] ?? '',
              ),
        //     ? Text(builder["registeredName"] +
        //         ' ' +
        //         builder['registeredOfcAddress'].toString() +
        //         '')
        //     : Text(builder["registeredName"]),
      ),
      onSelected: (v) {
        selectedLead.value = v["conId"] + "_" + v["firstName"];
        selectLeadController.text = v['firstName'] + ' ' + v['lastName'];
        print("builderId123: ${selectedLead.value.isNotEmpty}");
        if (selectLeadController.text.isNotEmpty) {
          hasSelectedLead.value = true;
        }
        // projectsController.selectedBuilder.value = v["builderId"];
        // projectsController.builderController.text = v["registeredName"];
        // createProjectController.getProjectsByBuilderId(v["builderId"]);
      },
      suggestionsCallback: suggestionsCallback,
      itemSeparatorBuilder: itemSeparatorBuilder,
    );
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Divider(height: 1);

  Future<List<dynamic>> suggestionsCallback(String pattern) async {
    print('patternnnnnn $pattern $leadsList');

    return Future.delayed(
      const Duration(seconds: 2),
      () => leadsList.where((b) {
        final nameLower = b['firstName'].toLowerCase().split(' ').join('');
        final patternLower = pattern.toLowerCase().split(' ').join('');
        return nameLower.contains(patternLower);
      }).toList(),
    );
  }

  buildLabel(label) {
    return Row(
      children: [
        Text(
          label,
          style: Styles.labelStyles,
        ),
        label == "Description"
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
        buildLabel('Select Date & Time'),
        SizedBox(
          height: ThemeConstants.height4,
        ),
        Container(
          color: ThemeConstants.whiteColor,
          // width: Get.width * 0.90,
          child: Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light()
                  .copyWith(primary: ThemeConstants.primaryColor),
            ),
            child: DateTimeField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              resetIcon: null,
              enabled: true,
              initialValue: null,
              textAlign: TextAlign.start,
              onChanged: (v) {
                print("v: $v");

                // DateTime oneDayAgo = v!.subtract(Duration(days: 1));
                // startDate.value = oneDayAgo.toIso8601String();
                String originalString = dateController.text;

                // Split the original string by space to get date and time components
                List<String> components = originalString.split(' ');

                // Extract date components
                List<String> dateComponents = components[0].split('-');

                // Rearrange date components to match desired format
                String formattedDate =
                    '${dateComponents[2]}-${dateComponents[1]}-${dateComponents[0]}';

                // Concatenate rearranged date and time components along with remaining part
                String formattedString =
                    '$formattedDate ${components[1]} ${components[2]}';
                List<String> comp = formattedString.split(' ');

                // Concatenate the time part with seconds and milliseconds
                String dateAfterFormat = '${comp[0]}T${comp[1]}:00.000';
                startDate.value = '${comp[0]}T${comp[1]}:00.000';

                print("666start date: ${startDate.value}");
              },
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: ThemeConstants.fontSize15,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: ThemeConstants.whiteColor,
                filled: true,
                prefix: Text('  '),
                suffixIcon: Container(
                  decoration: BoxDecoration(
                      color: ThemeConstants.primaryColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Icon(
                    Icons.watch_later,
                    color: ThemeConstants.whiteColor,
                  ),
                ),
                hintText: "Select Date & Time",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeConstants.greyColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeConstants.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintStyle: TextStyle(
                    color: ThemeConstants.greyColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: ThemeConstants.fontSize14),
                contentPadding: EdgeInsets.all(0),
                isDense: true,
                // errorStyle: TextStyle(
                //     color: ThemeConstants.errorColor,
                //     fontSize: ThemeConstants.fontSize10),
                // errorBorder: OutlineInputBorder(
                //     borderSide: BorderSide(color: ThemeConstants.errorColor),
                //     borderRadius: BorderRadius.all(Radius.circular(5))),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ThemeConstants.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              format: DateFormat("dd-MM-yyyy HH:mm a"),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));

                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
              controller: dateController,
              validator: (value) {
                print('value111 $value');

                if (value == null) {
                  print('text $value');
                  return "Start Date is required";
                }
                return null;
              },
            ),
          ),
        )
      ],
    );
  }
}

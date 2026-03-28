import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/date_util.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/components/appointments/appointments_controller.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

TextEditingController textEditingController = TextEditingController();
TextEditingController builderNameController = TextEditingController();
HomeController homeController = Get.put(HomeController());
final List<Color> colorList = [
  Color.fromRGBO(152, 192, 253, 1),
  Color.fromRGBO(79, 117, 173, 1),
  Color.fromRGBO(212, 180, 253, 1),
  Color.fromRGBO(173, 114, 250, 1),
  Color.fromRGBO(252, 185, 158, 1),
  Color.fromRGBO(255, 133, 84, 1),
  Color.fromRGBO(59, 55, 253, 1),
  Color.fromRGBO(84, 253, 149, 1),
  Color.fromRGBO(212, 3, 3, 1),
];

showLoadingDialog() {
  return Get.dialog(
    const LoadingDialog(color: ThemeConstants.primaryColor),
    barrierDismissible: false,
    useSafeArea: false,
  );
}

closeLoadingDialog() {
  if (Get.isDialogOpen == true) {
    Get.back();
  }
}

class LoadingDialog extends StatelessWidget {
  final Color color;
  const LoadingDialog({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
          child: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        )),
      )),
    );
  }
}

Widget showCustomLoader() {
  return Center(
      child: CircularProgressIndicator(color: ThemeConstants.primaryColor)
      //Image.asset(ImageConstants.loader)

      );
}

Widget customLoader(label) {
  return Center(
    child: TextBoxWidget(
      isRequired: true,
      label: label,
      controller: textEditingController,
      hintText: label,
    ),
    //Image.asset(ImageConstants.loader)
  );
}

Widget dashboardLoader() {
  return SingleChildScrollView(
    child: Column(
      children: [
        buildBuilderSearchBar(),
        Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 4, // Adjust elevation as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            // Set other properties of your container

            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        CommonService.instance.selectedIndex.value = 3;
                        Get.delete<LeadsListingController>(force: true);
                        Get.toNamed(Routes.leads);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 252, 239, 252),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Active leads',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 8,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: ThemeConstants.fontFamily,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 8,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ThemeConstants.width8,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        CommonService.instance.selectedIndex.value = 3;

                        Get.delete<LeadsListingController>(force: true);
                        Get.toNamed(Routes.leads, arguments: {
                          'status': CommonService.instance.leadAge.value
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 243, 252),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Cold leads ',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 8,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: ThemeConstants.fontFamily,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 8,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ThemeConstants.width8,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        CommonService.instance.selectedIndex.value = 3;

                        Get.delete<LeadsListingController>(force: true);
                        Get.toNamed(Routes.leads, arguments: {
                          'status': 'Closed Won',
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 249, 252, 234),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Closed won ',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 8,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: ThemeConstants.fontFamily,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 8,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ThemeConstants.width8,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        CommonService.instance.selectedIndex.value = 3;

                        Get.delete<LeadsListingController>(force: true);
                        Get.toNamed(Routes.leads, arguments: {
                          'status': 'Closed Lost',
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 250, 234, 234),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Closed lost ',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 8,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: ThemeConstants.fontFamily,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 8,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: ThemeConstants.height4,
        ),
        buildChartCard(),
      ],
    ),
  );
}

_buildCard(item) {
  return Container(
    margin: EdgeInsets.all(5.0),
    // width: MediaQuery.of(context).size.width / 2 - 30, // Adjust width to fit two cards
    width: Get.width * 0.75,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: ThemeConstants.width4,
          decoration: BoxDecoration(
            color: item!.status == 'completed'
                ? ThemeConstants.successColor
                : item!.status == 'SCHEDULED'
                    ? ThemeConstants.primaryColor
                    : ThemeConstants.errorColor, // Adjust color as needed
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0),
              bottomLeft: Radius.circular(10.0),
            ),
          ),
        ),
        SizedBox(width: ThemeConstants.width2), // Spacer
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                      item!.userName != null
                          ? toBeginningOfSentenceCase(item!.userName!)
                              .toString()
                          : '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.subHeadingStyles),
                ),
                SizedBox(height: ThemeConstants.height5),
                Expanded(
                  child: Text(
                      item!.userName != null
                          ? toBeginningOfSentenceCase(item!.title!).toString()
                          : '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.hintStyles),
                ),
                //  SizedBox(height: ThemeConstants.height5), // Spacer
                item!.location != null
                    ? Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  LineIcons.mapMarker,
                                  size: 20,
                                  color: ThemeConstants.iconColor,
                                ),
                                SizedBox(
                                  width: ThemeConstants.width4,
                                ),
                                Text(item!.location!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.hintStyles),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                homeController.makePhoneCall(
                                    item!.contact!.primaryNumber);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    LineIcons.phone,
                                    color: ThemeConstants.primaryColor,
                                    size: 15,
                                  ),
                                  Text(item!.contact!.primaryNumber,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.linkStyles),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(height: ThemeConstants.height5),
                Container(
                  height: 1,
                  color: const Color.fromRGBO(0, 0, 0, 0.05),
                ),
                // Divider(
                //   color: const Color.fromRGBO(0, 0, 0, 0.05),
                //   thickness: 1,
                //   height: 1,
                // ),
                SizedBox(height: ThemeConstants.height5),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LineIcons.calendar,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(
                            width: ThemeConstants.width6,
                          ),
                          Text(
                            DateTimeUtils.formatMeetingDate(
                                item!.startDateTime),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.label7Styles,
                          ),
                          //  Text('Hyderabad'),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            LineIcons.clock,
                            size: 20,
                            color: ThemeConstants.iconColor,
                          ),
                          SizedBox(
                            width: ThemeConstants.width6,
                          ),
                          Text(
                            DateTimeUtils.formatMeetingTime(
                                item!.startDateTime),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.label7Styles,
                          ),
                          //  Text('Hyderabad'),
                        ],
                      ),
                    ],
                  ),
                ),

                //SizedBox(height: ThemeConstants.height10),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget itemSeparatorBuilder(BuildContext context, int index) =>
    const Divider(height: 1);

Future<List<dynamic>> suggestionsCallback(String pattern) async {
  print('patternnnnnn $pattern ');

  return Future.delayed(
    const Duration(seconds: 2),
    () => homeController.projectsNamesList.where((b) {
      final nameLower = b['projName'].toLowerCase().split(' ').join('');
      final patternLower = pattern.toLowerCase().split(' ').join('');
      return nameLower.contains(patternLower);
    }).toList(),
  );
}

Widget itemSeparatorBuilderBuilder(BuildContext context, int index) =>
    const Divider(height: 1);

Future<List<dynamic>> suggestionsCallbackbuilder(String pattern) async {
  print('patternnnnnn ${CommonService.instance.builders} ');
  // suggestionsController. refresh();
  //  var a = suggestionsController.suggestions!;
  // print('aaaaaaa sugg $a');
  return Future.delayed(
    const Duration(seconds: 2),
    () => CommonService.instance.builders.where((b) {
      final nameLower = b['label'].toLowerCase().split(' ').join('');
      final patternLower = pattern.toLowerCase().split(' ').join('');
      return nameLower.contains(patternLower);
    }).toList(),
  );
}

buildBuilderSearchBar() {
  builderNameController.text = '';
  return Padding(
      padding: EdgeInsets.symmetric(
          vertical: ThemeConstants.screenPadding,
          horizontal: ThemeConstants.screenPadding),
      child: TypeAheadField(
        controller: builderNameController,
        //  focusNode: fsNode,
        builder: (context, controller, focusNode) => TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeConstants.primaryColor),
              borderRadius: BorderRadius.circular(14.0),
            ),
            filled: true,
            suffixIcon: homeController.selectBuilderId.value == '' ||
                    homeController.selectBuilderId.value.isEmpty
                ? Icon(Icons.arrow_drop_down)
                : IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      homeController.builderNameController.text = '';

                      homeController.builderNameController.clear();
                      // CommonService.instance.builders.clear();
                      homeController.projNameController.text = '';
                      homeController.selectProjectId.value = '';

                      homeController.selectBuilderId.value = '';

                      await homeController.getDashboardDetails();

                      //  _suggestionsController.close();
                      //  homeController.builderNameController.
                      //   await homeController.getBuilders();
                      //   fsNode.unfocus();
                      // Request focus again to refresh suggestions
                      //   fsNode.requestFocus();
                      // homeController.statusCounts.addAll(
                      //     CommonService.instance.statusCount);
                    }),
            fillColor: ThemeConstants.whiteColor,
            hintText: "Select Builder",
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
        itemBuilder: (context, builder) =>
            ListTile(title: Text(builder["label"])
                //  builder['registeredOfcAddress'] != null
                //     ? Text(builder["registeredName"] +
                //         ' ' +
                //         builder['registeredOfcAddress'].toString() +
                //         '')
                //     : Text(builder["registeredName"]),
                ),
        onSelected: (v) {
          //  print("builderId: ${selectedLead.value}");
          homeController.selectBuilderId.value = v['value'];
          homeController.getDashboardDetailsByBuilderId(v['value']);
          //     v['projId'], homeController.projectsList);
          // projectsController.selectedBuilder.value = v["builderId"];
          homeController.builderNameController.text = v["label"];
          // createProjectController.getProjectsByBuilderId(v["builderId"]);
        },
        suggestionsCallback: suggestionsCallbackbuilder,
        //   suggestionsController: _suggestionsController,
        itemSeparatorBuilder: itemSeparatorBuilderBuilder,
      ));
}

buildChartCard() {
  RxList statusess = [0, 0, 0, 0, 0, 0, 0, 0, 0].obs;
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          //  color: ThemeConstants.appBackgroundColor,
          // Add your main content here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown widget here
                        TypeAheadField(
                          controller: homeController.projNameController,
                          // focusNode: _focusNode,
                          builder: (context, controller, focusNode) =>
                              TextField(
                            controller: controller,
                            focusNode: focusNode,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: ThemeConstants.primaryColor),
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              filled: true,
                              suffixIcon:
                                  homeController.selectProjectId.value == '' ||
                                          homeController
                                              .selectProjectId.value.isEmpty
                                      ? Icon(Icons.arrow_drop_down)
                                      : IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () async {
                                            homeController
                                                .projNameController.text = '';
                                            if (homeController
                                                    .selectBuilderId.value !=
                                                '') {
                                              await homeController
                                                  .getDefaultStatusDetails(
                                                      homeController
                                                          .selectBuilderId
                                                          .value);
                                            } else {
                                              await homeController
                                                  .getDefaultDetails();
                                            }
                                            homeController
                                                .selectProjectId.value = '';
                                            // _focusNode.unfocus();
                                            // _focusNode.requestFocus();
                                            // homeController.statusCounts.addAll(
                                            //     CommonService.instance.statusCount);
                                          }),
                              fillColor: const Color.fromRGBO(255, 255, 255, 1),
                              hintText: "Select Project",
                              hintStyle: Styles.hintStyles,
                              contentPadding: EdgeInsets.all(Get.height *
                                  ThemeConstants.textFieldContentPadding),
                            ),
                          ),
                          decorationBuilder: (context, child) => Material(
                            type: MaterialType.card,
                            elevation: 4,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: child,
                          ),
                          itemBuilder: (context, builder) => ListTile(
                              title: Text(builder["projName"])
                              //  builder['registeredOfcAddress'] != null
                              //     ? Text(builder["registeredName"] +
                              //         ' ' +
                              //         builder['registeredOfcAddress'].toString() +
                              //         '')
                              //     : Text(builder["registeredName"]),
                              ),
                          onSelected: (v) {
                            //  print("builderId: ${selectedLead.value}");
                            homeController.selectProjectId.value = v['projId'];
                            homeController.getPieChartValues(
                                v['projId'], homeController.projectsList);
                            // projectsController.selectedBuilder.value = v["builderId"];
                            homeController.projNameController.text =
                                v["projName"];
                            // createProjectController.getProjectsByBuilderId(v["builderId"]);
                          },
                          suggestionsCallback: suggestionsCallback,
                          itemSeparatorBuilder: itemSeparatorBuilder,
                        ),
                        // Container(
                        //   // Half of the screen width
                        //   height: Get.height / 20,

                        //   child: DropdownFormFieldWidget(
                        //     hintText: 'Select a Project',
                        //     // suffixIcon: homeController.selectProject.value != ''
                        //     //     ? Icon(Icons.close)
                        //     //     : Icon(Icons.arrow_drop_down),
                        //     // onPressed: () {
                        //     //   homeController.selectProject.value = '';
                        //     //   homeController.selectProjectId.value = '';
                        //     //   // homeController.getPieChartValues(
                        //     //   //     '', homeController.projectsList);
                        //     // },
                        //     items: homeController.projectsNamesList
                        //         .map<DropdownMenuItem>((dynamic item) {
                        //       return DropdownMenuItem(
                        //         child: Padding(
                        //           padding:
                        //               const EdgeInsets.only(left: 0, right: 0),
                        //           child: Text(item['projName']),
                        //         ),
                        //         value: item,
                        //       );
                        //     }).toList(),
                        //     selectedValue:
                        //         homeController.selectProject.value != ''
                        //             ? homeController.selectProject.value
                        //             : null,
                        //     onChange: (value) {
                        //       // FocusScope.of(context)
                        //       //     .requestFocus(FocusNode());
                        //       print('value.... $value');
                        //       // homeController.selectProject.value =
                        //       //     value['projName'];
                        //       homeController.selectProjectId.value =
                        //           value['projId'];
                        //       homeController.getPieChartValues(
                        //           value['projId'], homeController.projectsList);
                        //     },
                        //     isRequired: true,
                        //   ),
                        // ),
                        SizedBox(
                          height: ThemeConstants.height10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: PieChart(
                                      swapAnimationDuration:
                                          const Duration(seconds: 1),
                                      swapAnimationCurve: Curves.easeInOutQuint,
                                      PieChartData(
                                        pieTouchData: PieTouchData(
                                          touchCallback:
                                              homeController.tapOnPieChart,
                                        ),
                                        sections: List.generate(
                                            homeController.statusCounts.length,
                                            (index) {
                                          return PieChartSectionData(
                                              // value:
                                              //     double.parse(homeController.statusCounts[index]),
                                              color: colorList[index],
                                              title: '${statusess[index]}',
                                              titleStyle:
                                                  Styles.whiteSubHeadingStyles4
                                              // radius: 100, // Radius of each section
                                              );
                                        }),
                                        // [
                                        //   PieChartSectionData(value: 45, color: Colors.orange),
                                        //   PieChartSectionData(value: 20, color: Colors.grey),
                                        //   PieChartSectionData(value: 25, color: Colors.green),
                                        //   PieChartSectionData(value: 10, color: Colors.red),
                                        //   PieChartSectionData(value: 15, color: Colors.yellow),
                                        // ]
                                      )),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: 190,
                                child: SingleChildScrollView(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    (homeController.dataMap.length / 3)
                                        .ceil(), // Adjust the divisor to fit your data
                                    (index) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: homeController.dataMap.keys
                                            .skip(index * 3)
                                            .take(3)
                                            .map((key) {
                                          final colorIndex = homeController
                                                  .dataMap.keys
                                                  .toList()
                                                  .indexOf(key) %
                                              colorList.length;
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: ThemeConstants.width35,
                                                  height:
                                                      ThemeConstants.height15,
                                                  color: colorList[colorIndex],
                                                ),
                                                SizedBox(
                                                    width:
                                                        ThemeConstants.width10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        key,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Styles
                                                            .greyLabelStyles4,
                                                      ),
                                                      SizedBox(
                                                        height: ThemeConstants
                                                            .height4,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: ThemeConstants.height15),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: ThemeConstants.screenPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Appointments',
                style: Styles.headingStyles,
              ),
              homeController.appointmentList.length == 0
                  ? SizedBox.shrink()
                  : TextButton(
                      onPressed: () {
                        CommonService.instance.selectedIndex.value = 4;
                        Get.delete<AppointmentsController>(force: true);
                        Get.toNamed(Routes.appointmentsScreen);
                      },
                      child: Text(
                        'View All',
                        style: Styles.linkStyles,
                      ))
            ],
          ),
        ),
        SizedBox(
          height: ThemeConstants.height5,
        ),
        homeController.appointmentList.length == 0
            ? Container(
                height: Get.height * .2,
                child: Center(
                    child: ListView.builder(
                  itemCount: 2, // Number of shimmer items
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 200.0, // Adjust shimmer card size
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    );
                  },
                )),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding),
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 20.0),
                  height: Get.height / 3, // Adjust height as needed
                  child: ListView.builder(
                      itemCount: homeController.appointmentList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctx, index) {
                        return _buildCard(
                            homeController.appointmentList[index]);
                      }),
                ),
              )
      ],
    ),
  );
}

Widget projectsLoader() {
  return buildChartCard();
}

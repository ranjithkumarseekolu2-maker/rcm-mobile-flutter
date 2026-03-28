import 'dart:io';
import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/shimmers/custom_shimmer.dart';
import 'package:brickbuddy/commons/utils/date_util.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/bottom_bar_widget.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/components/appointments/appointments_controller.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/components/leads/leads_listing_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeComponent extends StatelessWidget {
  HomeController homeController = Get.put(HomeController());
  // List<ChartData> chartData = <ChartData>[
  //   ChartData('Rent', 1000, Colors.teal),
  //   ChartData('Food', 2500, Colors.lightBlue),
  //   ChartData('Savings', 760, Colors.brown),
  //   ChartData('Tax', 1897, Colors.grey),
  //   ChartData('Others', 2987, Colors.blueGrey)
  // ];
  // Define colors for the slices
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

  @override
  Widget build(BuildContext context) {
    if (CommonService.instance.onlyLogin.value == true &&
        homeController.coldLeadsList.isNotEmpty) {
      homeController.getInactiveLeads(homeController.coldLeadsList);
    }
    return SafeArea(
        child: Obx(() => LoadingOverlay(
              opacity: 1,
              color: Colors.black54,
              progressIndicator: const SpinKitCircle(
                color: ThemeConstants.whiteColor,
                size: 50.0,
              ),
              isLoading: homeController.isDashboardLoading.value ||
                  homeController.isStatusLoading.value ||
                  homeController.isLoading.value,
              child: Scaffold(
                  // appBar: PreferredSize(
                  //   preferredSize: Size.fromHeight(70.0), // here the desired height
                  //   child: AppBar(
                  //     backgroundColor: ThemeConstants.primaryColor,
                  //     leading: CommonService.instance.profileUrl.value.isNotEmpty
                  //         ? CircleAvatar(
                  //             radius: 25,
                  //             backgroundImage:
                  //                 NetworkImage(CommonService.instance.profileUrl.value))
                  //         : Padding(
                  //             padding: const EdgeInsets.only(left: 10.0, top: 20),
                  //             child: CircleAvatar(
                  //                 radius: 25,
                  //                 backgroundImage: AssetImage('assets/images/person.png')),
                  //           ),
                  //     title: Padding(
                  //       padding: const EdgeInsets.only(top: 20),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text('Welcome', style: Styles.whiteheadingStyles),
                  //           Text(
                  //             '${toBeginningOfSentenceCase(CommonService.instance.firstName.value)}' +
                  //                 ' ' +
                  //                 '${CommonService.instance.lastName.value}',
                  //             style: Styles.whiteheadingStyles,
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //     actions: [
                  //       Padding(
                  //         padding: const EdgeInsets.only(top: 20),
                  //         child: badges.Badge(
                  //           position: badges.BadgePosition.topEnd(top: 0, end: 3),
                  //           badgeAnimation: badges.BadgeAnimation.slide(
                  //               // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                  //               // curve: Curves.easeInCubic,
                  //               ),
                  //           showBadge:
                  //               CommonService.instance.allNotificationsCount.value > 0
                  //                   ? true
                  //                   : false,
                  //           badgeStyle: badges.BadgeStyle(
                  //             badgeColor: ThemeConstants.errorColor,
                  //           ),
                  //           badgeContent: Text(
                  //             CommonService.instance.allNotificationsCount.toString(),
                  //             style: Styles.whiteSubHeadingStyles4,
                  //           ),
                  //           child: IconButton(
                  //               icon: Icon(
                  //                 LineIcons.bell,
                  //                 color: ThemeConstants.whiteColor,
                  //                 size: 28,
                  //               ),
                  //               onPressed: () async {
                  //                 SharedPreferences prefs =
                  //                     await SharedPreferences.getInstance();
                  //                 HomeController homeController = Get.find();
                  //                 prefs.setInt("notidicationsSeen",
                  //                     homeController.notificationsList.length);
                  //                 Get.delete<NotificationsController>(force: true);
                  //                 Get.toNamed(Routes.notificationsComponent);
                  //               }),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  resizeToAvoidBottomInset: false,
                  bottomNavigationBar: const BottombarWidget(),
                  body: WillPopScope(
                    onWillPop: () async {
                      logout();
                      return false;
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('hello'),
                        buildUserInfoCard(),

                        homeController.isLoading.value
                            ? Container(
                                height: Get.height * 0.7,
                                child: dashboardLoader())
                            : Expanded(
                                child: SingleChildScrollView(
                                    child: buildCountsCard(context))),
                      ],
                    ),
                  )),
            )));
  }

  buildAppointmentsCard() {
    // Sort the appointment list by startDateTime in ascending order (earliest first)
    homeController.appointmentList
        .sort((a, b) => a.startDate.compareTo(b.startDate));

    return Column(
      children: [
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
              homeController.appointmentList.isEmpty
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
        homeController.appointmentList.isEmpty
            ? Container(
                height: Get.height * .2,
                child: Center(child: Text('No Appointments Found')),
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.screenPadding),
                child: Container(
                  height: Get.height / 6, // Adjust height as needed
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
    );
  }

  buildBuilderSearchBar() {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: ThemeConstants.screenPadding,
            horizontal: ThemeConstants.screenPadding),
        child: TypeAheadField(
          controller: homeController.builderNameController,
          focusNode: fsNode,
          builder: (context, controller, focusNode) => TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: ThemeConstants.primaryColor),
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
                        await homeController.getDefaultDetails();
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
          onSelected: (v) async {
            //  print("builderId: ${selectedLead.value}");
            homeController.selectBuilderId.value = v['value'];
            await homeController.getDashboardDetailsByBuilderId(v['value']);
            //     v['projId'], homeController.projectsList);
            // projectsController.selectedBuilder.value = v["builderId"];
            homeController.selectProjectId.value = '';
            homeController.projNameController.text = '';

            homeController.builderNameController.text = v["label"];
            // createProjectController.getProjectsByBuilderId(v["builderId"]);
          },
          suggestionsCallback: suggestionsCallbackbuilder,
          //   suggestionsController: _suggestionsController,
          itemSeparatorBuilder: itemSeparatorBuilderBuilder,
        ));
  }

  buildCountsCard(context) {
    return Column(
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
                        homeController.requestPermission();
                        CommonService.instance.selectedIndex.value = 3;
                        Get.delete<LeadsListingController>(force: true);
                        //  Get.toNamed(Routes.leads);
                        if (homeController.selectBuilderId.value.isNotEmpty) {
                          Get.toNamed(Routes.leads, arguments: {
                            'status': 'Active',
                            'builderId': homeController.selectBuilderId.value
                          });
                        } else {
                          Get.toNamed(Routes.leads, arguments: {
                            'status': 'Active',
                          });
                        }
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
                                homeController.activeLeadsCount.value
                                    .toString(),
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
                        showIconPopup(context);
                        // CommonService.instance.selectedIndex.value = 3;

                        // Get.delete<LeadsListingController>(force: true);
                        // Get.toNamed(Routes.leads, arguments: {
                        //   'status': CommonService.instance.leadAge.value
                        // });
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
                                homeController.coldLeadsCount.value.toString(),
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Cold leads  ',
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
                          'builderId': homeController.selectBuilderId.value
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
                                homeController.closedWonLeadsCount.value
                                    .toString(),
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Closed won',
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
                          'builderId': homeController.selectBuilderId.value
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
                                homeController.closedLostLeadsCount.value
                                    .toString(),
                                style: TextStyle(
                                    fontSize: ThemeConstants.fontSize24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Closed lost',
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
        homeController.isStatusLoading.value
            ? Container(child: Center(child: projectsLoader()))
            : buildChartCard(),
      ],
    );
  }

  buildUserInfoCard() {
    print('vvvvvvv ${CommonService.instance.profileUrl.value}');
    return Container(
      height: 100,
      child: Stack(
        children: <Widget>[
          //  buildCard(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 190, // Height of the app bar
              color: ThemeConstants.primaryColor,
            ),
          ),
          Positioned(
              top: 25,
              child: InkWell(
                onTap: () {
                  CommonService.instance.selectedIndex.value = 4;
                  Get.delete<MenuController>(force: true);
                  Get.toNamed(Routes.menuScreen);
                },
                child: Padding(
                    padding: EdgeInsets.only(left: 16.0, top: 0),
                    child: Row(
                      children: [
                        CommonService.instance.profileUrl.value.isNotEmpty
                            ? CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
                                    CommonService.instance.profileUrl.value))
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage('assets/images/person.png')),
                        SizedBox(
                          width: ThemeConstants.width20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome', style: Styles.whiteheadingStyles),
                            Text(
                              '${CommonService.instance.firstName.value}' +
                                  ' ' +
                                  '${CommonService.instance.lastName.value}',
                              style: Styles.whiteheadingStyles,
                            )
                          ],
                        )
                      ],
                    )),
              )),
          Positioned(
              top: 30,
              right: 20,
              child: badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                badgeAnimation: badges.BadgeAnimation.slide(
                    // disappearanceFadeAnimationDuration: Duration(milliseconds: 200),
                    // curve: Curves.easeInCubic,
                    ),
                showBadge:
                    CommonService.instance.allNotificationsCount.value > 0
                        ? true
                        : false,
                badgeStyle: badges.BadgeStyle(
                  badgeColor: ThemeConstants.errorColor,
                ),
                badgeContent: Text(
                  CommonService.instance.allNotificationsCount.toString(),
                  style: Styles.whiteSubHeadingStyles4,
                ),
                child: IconButton(
                    icon: Icon(
                      LineIcons.bell,
                      color: ThemeConstants.whiteColor,
                      size: 28,
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      HomeController homeController = Get.find();
                      prefs.setInt("notidicationsSeen",
                          homeController.notificationsList.length);
                      Get.delete<NotificationsController>(force: true);
                      Get.toNamed(Routes.notificationsComponent);
                    }),
              )),
        ],
      ),
    );
  }

  FocusNode _focusNode = FocusNode();
  FocusNode fsNode = FocusNode();
  buildChartCard() {
    return Container(
      // height: 330,
      //  color: ThemeConstants.appBackgroundColor,
      // Add your main content here
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dropdown widget here
                    TypeAheadField(
                      controller: homeController.projNameController,
                      focusNode: _focusNode,
                      builder: (context, controller, focusNode) => TextField(
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
                          suffixIcon: homeController.selectProjectId.value ==
                                      '' ||
                                  homeController.selectProjectId.value.isEmpty
                              ? Icon(Icons.arrow_drop_down)
                              : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () async {
                                    homeController.projNameController.text = '';
                                    if (homeController.selectBuilderId.value !=
                                        '') {
                                      await homeController
                                          .getDefaultStatusDetails(
                                              homeController
                                                  .selectBuilderId.value);
                                    } else {
                                      await homeController.getDefaultDetails();
                                    }
                                    homeController.selectProjectId.value = '';
                                    // _focusNode.unfocus();
                                    // _focusNode.requestFocus();
                                    // homeController.statusCounts.addAll(
                                    //     CommonService.instance.statusCount);
                                  }),
                          fillColor: ThemeConstants.whiteColor,
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
                        homeController.projNameController.text = v["projName"];
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
                    buildPiechartData(),

                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 35,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Flexible(
                    //         flex: 1,
                    //         child: AspectRatio(
                    //           aspectRatio: 2,
                    //           child: PieChart(
                    //             swapAnimationDuration:
                    //                 const Duration(
                    //                     seconds: 1),
                    //             swapAnimationCurve:
                    //                 Curves.easeInOutQuint,
                    //             PieChartData(
                    //               // pieTouchData:
                    //               //     PieTouchData(
                    //               //   enabled: true,
                    //               //   touchCallback:
                    //               //       (FlTouchEvent
                    //               //               event,
                    //               //           pieTouchResponse) {
                    //               //     // if (!event
                    //               //     //         .isInterestedForInteractions ||
                    //               //     //     pieTouchResponse ==
                    //               //     //         null ||
                    //               //     //     pieTouchResponse
                    //               //     //             .touchedSection ==
                    //               //     //         null) {
                    //               //     //   homeController
                    //               //     //       .touchedIndex
                    //               //     //       .value = -1;
                    //               //     //   return;
                    //               //     // }
                    //               //     // homeController
                    //               //     //         .touchedIndex
                    //               //     //         .value =
                    //               //     //     pieTouchResponse
                    //               //     //         .touchedSection!
                    //               //     //         .touchedSectionIndex;
                    //               //     print(
                    //               //         'pieTouchResponse ${pieTouchResponse}');
                    //               //   },
                    //               // ),

                    //               pieTouchData:
                    //                   PieTouchData(
                    //                 mouseCursorResolver:
                    //                     (event,
                    //                         response) {
                    //                   print('ppppp');
                    //                   return response == null
                    //                       ? MouseCursor
                    //                           .defer
                    //                       : SystemMouseCursors
                    //                           .click;
                    //                 },
                    //                 touchCallback:
                    //                     homeController
                    //                         .tapOnPieChart,
                    //               ),

                    //               centerSpaceRadius: 30,
                    //               borderData:
                    //                   FlBorderData(
                    //                       show: true),
                    //               sectionsSpace: 1,
                    //               sections: List.generate(
                    //                 homeController
                    //                     .dataMap.length,
                    //                 (index) {
                    //                   final value =
                    //                       homeController
                    //                               .dataMap
                    //                               .values
                    //                               .toList()[
                    //                           index];
                    //                   return PieChartSectionData(
                    //                       radius:
                    //                           Get.width /
                    //                               5.5,
                    //                       color: colorList[
                    //                           index %
                    //                               colorList
                    //                                   .length],
                    //                       value: value,
                    //                       title: homeController
                    //                           .statusCounts[
                    //                               index]
                    //                           .toString(),
                    //                       titleStyle: Styles
                    //                           .whiteSubHeadingStyles);
                    //                 },
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(width: 50),
                    //       Flexible(
                    //         flex: 2,
                    //         child: SingleChildScrollView(
                    //             child: Column(
                    //           crossAxisAlignment:
                    //               CrossAxisAlignment
                    //                   .start,
                    //           children: List.generate(
                    //             (homeController.dataMap
                    //                         .length /
                    //                     3)
                    //                 .ceil(), // Adjust the divisor to fit your data
                    //             (index) {
                    //               return Column(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment
                    //                         .start,
                    //                 children:
                    //                     homeController
                    //                         .dataMap.keys
                    //                         .skip(
                    //                             index * 3)
                    //                         .take(3)
                    //                         .map((key) {
                    //                   final colorIndex =
                    //                       homeController
                    //                               .dataMap
                    //                               .keys
                    //                               .toList()
                    //                               .indexOf(
                    //                                   key) %
                    //                           colorList
                    //                               .length;
                    //                   return Container(
                    //                     padding: EdgeInsets
                    //                         .symmetric(
                    //                             horizontal:
                    //                                 8),
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment
                    //                               .start,
                    //                       children: [
                    //                         Container(
                    //                           width: ThemeConstants
                    //                               .width35,
                    //                           height: ThemeConstants
                    //                               .height15,
                    //                           color: colorList[
                    //                               colorIndex],
                    //                         ),
                    //                         SizedBox(
                    //                             width: ThemeConstants
                    //                                 .width10),
                    //                         Expanded(
                    //                           child:
                    //                               Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment
                    //                                     .start,
                    //                             children: [
                    //                               Text(
                    //                                 key,
                    //                                 maxLines:
                    //                                     1,
                    //                                 overflow:
                    //                                     TextOverflow.ellipsis,
                    //                                 style:
                    //                                     Styles.greyLabelStyles4,
                    //                               ),
                    //                               SizedBox(
                    //                                 height:
                    //                                     ThemeConstants.height4,
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   );
                    //                 }).toList(),
                    //               );
                    //             },
                    //           ),
                    //         )),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: ThemeConstants.height15),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ThemeConstants.height10,
            ),
            buildAppointmentsCard()
          ],
        ),
      ),
    );
  }

  buildPiechartData() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: 190,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: PieChart(
                  swapAnimationDuration: const Duration(seconds: 1),
                  swapAnimationCurve: Curves.easeInOutQuint,
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: homeController.tapOnPieChart,
                    ),
                    sections: List.generate(homeController.statusCounts.length,
                        (index) {
                      return PieChartSectionData(
                          // value:
                          //     double.parse(homeController.statusCounts[index]),
                          color: colorList[index],
                          title: '${homeController.statusCounts[index]}',
                          titleStyle: Styles.whiteSubHeadingStyles4
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: homeController.dataMap.keys
                        .skip(index * 3)
                        .take(3)
                        .map((key) {
                      final colorIndex =
                          homeController.dataMap.keys.toList().indexOf(key) %
                              colorList.length;
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: ThemeConstants.width35,
                              height: ThemeConstants.height15,
                              color: colorList[colorIndex],
                            ),
                            SizedBox(width: ThemeConstants.width10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    key,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.greyLabelStyles4,
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height4,
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

  static logout() async {
    await Get.dialog(AppCupertinoDialog(
      title: 'Exit'.tr,
      subTitle: 'Are you sure you want to exit app?',
      isOkBtn: false,
      acceptText: 'Yes'.tr,
      cancelText: 'No'.tr,
      onAccepted: () async {
        //CommonService.confirmLogout();
        exit(0);
      },
      onCanceled: () {
        Get.back();
      },
    ));
  }

  Widget _buildCard(item) {
    print('....startTime... ${item!.startDateTime}');
    return Container(
      margin: EdgeInsets.all(5.0),
      // width: MediaQuery.of(context).size.width / 2 - 30, // Adjust width to fit two cards
      width: Get.width * 0.78,
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
                            Row(
                              children: [
                                Icon(
                                  LineIcons.calendar,
                                  size: 18,
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
                                  style: Styles.label8Styles,
                                ),
                                //  Text('Hyderabad'),
                              ],
                            ),
                            Row(
                              children: [
                                // Icon(
                                //   LineIcons.clock,
                                //   size: 18,
                                //   color: ThemeConstants.iconColor,
                                // ),
                                SizedBox(
                                  width: ThemeConstants.width6,
                                ),
                                Text(
                                  DateTimeUtils.formatMeetingTime(
                                      item!.startDateTime),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.label8Styles,
                                ),
                              ],
                            ), //  Text('Hyderabad'),
                          ],
                        ),
                        SizedBox(
                          width: ThemeConstants.width6,
                        ),
                        InkWell(
                          onTap: () {
                            homeController
                                .makePhoneCall(item!.contact!.primaryNumber);
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

  void showIconPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Wrap(
                spacing: 16, // Horizontal spacing between items
                runSpacing: 16, // Vertical spacing between items
                alignment: WrapAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.blue)),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Icon(Icons.close,
                              size: 15, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_circle_left_outlined,
                            size: 40, color: Colors.grey[600]),
                        onPressed: () {
                          homeController.updateColdLeadsStats('previousStage');
                          Navigator.of(context).pop();
                        },
                      ),
                      Text('Previous Stage')
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.pause_circle,
                            size: 40, color: Colors.grey[600]),
                        onPressed: () {
                          homeController.updateColdLeadsStats('sameStage');
                          Navigator.of(context).pop();
                        },
                      ),
                      Text('Same Stage')
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_down_alt,
                            size: 40, color: Colors.grey[600]),
                        onPressed: () {
                          homeController.updateColdLeadsStats('closedLost');
                          Navigator.of(context).pop();
                        },
                      ),
                      Text('Closed Lost')
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.settings,
                            size: 40, color: Colors.grey[600]),
                        onPressed: () {
                          print('ontapped...leads routing');
                          CommonService.instance.selectedIndex.value = 3;
                          Get.delete<LeadsListingController>(force: true);
                          Get.toNamed(Routes.leads, arguments: {
                            'isFrom': 'Manage',
                            'selectedActivity': '30',
                            'selectedStatus': '',
                            'selectedProject': '',
                            'selectedProjectId':
                                homeController.selectProjectId.value,
                            'selectedBuilder': '',
                            'selectedBuilderId':
                                homeController.selectBuilderId.value
                          });
                        },
                      ),
                      Text('Manage Leads')
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  buildBodyShimmerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ThemeConstants.height20),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: CustomWidget.rectangular(
                  height: 20,
                )),
            SizedBox(width: ThemeConstants.width10),
            Expanded(
              flex: 1,
              child: CustomWidget.rectangular(
                height: 20,
              ),
            ),
            SizedBox(width: ThemeConstants.width6),
            Expanded(
              flex: 1,
              child: CustomWidget.rectangular(
                height: 20,
              ),
            ),
            SizedBox(width: ThemeConstants.width6),
            Expanded(
              flex: 1,
              child: CustomWidget.rectangular(
                height: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeConstants.height6),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: CustomWidget.rectangular(
                  height: 20,
                )),
            SizedBox(width: ThemeConstants.width10),
            Expanded(
              flex: 2,
              child: CustomWidget.rectangular(
                height: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeConstants.height6),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: CustomWidget.rectangular(
                  height: 20,
                )),
            SizedBox(width: ThemeConstants.width10),
            Expanded(
              flex: 2,
              child: CustomWidget.rectangular(
                height: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: ThemeConstants.height31),
      ],
    );
  }
}

class SalesData {
  final String apartment;
  final double sales;

  SalesData(this.apartment, this.sales);
}

// class ChartData {
//   ChartData(this.x, this.y, [this.color]);
//   final String x;
//   final double y;
//   final Color? color;
//}

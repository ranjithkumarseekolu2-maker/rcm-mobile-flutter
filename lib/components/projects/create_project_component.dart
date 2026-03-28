import 'dart:convert';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/utils/loader_util.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';

import 'package:brickbuddy/components/create_builder/create_builder_controller.dart';
import 'package:brickbuddy/components/notifications/notifications_controller.dart';
import 'package:brickbuddy/components/projects/create_project_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/createProject.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateProject extends StatelessWidget {
  bool showAdditionalInfo = false;
  CreateProjectController createProjectController =
      Get.put(CreateProjectController());

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.387140, 78.491684),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    RegulatoryAspects regulatoryAspects = RegulatoryAspects();
    return Scaffold(
        backgroundColor: Color.fromRGBO(246, 246, 246, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ThemeConstants.primaryColor,
          title: Obx(() => createProjectController.isUpdateMode.value == true
              ? Text(
                  'Update project',
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  'Add project',
                  style: TextStyle(color: Colors.white),
                )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: ThemeConstants.whiteColor),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                      size: 25,
                    ),
                    onPressed: () {
                      Get.delete<NotificationsController>(force: true);
                      Get.toNamed(Routes.notificationsComponent);
                    }),
              ),
            ),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            Get.toNamed(Routes.projects);
            return false;
          },
          child: Obx(() => LoadingOverlay(
                color: Colors.black54,
                opacity: 1,
                progressIndicator: SpinKitCircle(
                  color: ThemeConstants.whiteColor,
                  size: 50.0,
                ),
                isLoading: createProjectController.isDetailsLoading.value,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.screenPadding),
                    child: Form(
                      //  autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: createProjectController.projectFormKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildBuilder(),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildSelectBuilder(),
                            createProjectController.builderId.value == '' ||
                                    createProjectController.builderId.isEmpty
                                ? InkWell(
                                    onTap: () {
                                      Get.delete<CreateBuilderController>();
                                      Get.toNamed(
                                          Routes.createBuilderComponent);
                                    },
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Create Builder",
                                          style: Styles.linkStyles,
                                        )),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            buildSelectProject(),
                            SizedBox(
                              height: ThemeConstants.height10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildGMap(),
                                SizedBox(
                                  height: ThemeConstants.height10,
                                ),
                                buidProjectName(),
                                SizedBox(
                                  height: ThemeConstants.height10,
                                ),
                                buildAddress(),

                                // Row(
                                //   children: [
                                //     buidProjectName(),
                                //     SizedBox(
                                //       width: ThemeConstants.width10,
                                //     ),
                                //     buildProjectType()
                                //   ],
                                // ),
                                SizedBox(
                                  height: ThemeConstants.height10,
                                ),
                                Row(
                                  children: [
                                    buildProjectType(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildTransactionType(),

                                    //  buidProjectFacing(),
                                  ],
                                ),
                                SizedBox(
                                  height: ThemeConstants.height10,
                                ),
                                createProjectController
                                            .selectedTransactionType.value ==
                                        'Resale'
                                    ? buildPropertyAge()
                                    : SizedBox.shrink(),
                                createProjectController
                                            .selectedTransactionType.value ==
                                        'Resale'
                                    ? SizedBox(
                                        height: ThemeConstants.height10,
                                      )
                                    : SizedBox.shrink(),
                                createProjectController
                                            .selectedProjectType.value ==
                                        'Farm Houses'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildPlotArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildCarpetArea(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                          Row(
                                            children: [
                                              buildBuildArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buidProjectFacing()
                                              //buildPlotPrice(),
                                              // buildPosessionDateField(),
                                            ],
                                          ),
                                          //  SizedBox(height: ThemeConstants.height10),

                                          SizedBox(
                                              height: ThemeConstants.height10),
                                          buildFullWidthPlotPrice(),
                                          SizedBox(
                                              height: ThemeConstants.height10),
                                          Row(
                                            children: [
                                              buildNumberOfFloors(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildFloorDetails()
                                              // buildConfiguration()
                                            ],
                                          ),
                                          SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink(),

                                createProjectController
                                            .selectedProjectType.value ==
                                        'Residential'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildProjectArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildNumberOfTowers(),

                                              //    buildTotalNoOfUnits(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                          Row(
                                            children: [
                                              buildTotalNoOfUnits(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildSmallWidthConfiguration(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                          Row(children: [
                                            minBuiltUpArea(),
                                            SizedBox(
                                              width: ThemeConstants.width10,
                                            ),
                                            maxBuiltUpArea(),
                                          ]),
                                        
                                          SizedBox(
                                              height: ThemeConstants.height10),
                                          Row(
                                            children: [
                                              buildMinPrice(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildMaxPrice(),
                                            ],
                                          ),

                                          SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                          Row(children: [
                                            buidProjectFacing(),
                                            SizedBox(
                                              width: ThemeConstants.width10,
                                            ),
                                          ]),
                                          // SizedBox(
                                          //     height:
                                          //         ThemeConstants.height10),
                                          // buildConfiguration(),
                                          SizedBox(
                                              height: ThemeConstants.height10),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                createProjectController
                                            .selectedProjectType.value ==
                                        'Farm Lands'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildTotalPlotArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildDimensions()
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          Row(
                                            children: [
                                              //  buildBoundaryWall(),
                                              buildFloorsAllowedForConstruction(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildBoundaryWall()
                                              //   buildNoOfOpenSides()
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          // buildLargeFloorsAllowedForConstruction(),
                                          // SizedBox(
                                          //     height:
                                          //         ThemeConstants.width10),
                                          Row(
                                            children: [
                                              buildNoOfOpenSides(),
                                              //
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildCornerPlot(),
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          Row(
                                            children: [
                                              buidProjectFacing(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildPlotPrice(),
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                createProjectController
                                            .selectedProjectType.value ==
                                        'Plotting'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildTotalPlotArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buidProjectFacing()
                                              // buildDimensions()
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          buildFullWidthDimensions(),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          Row(
                                            children: [
                                              buildBoundaryWall(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildNoOfOpenSides()
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          Row(
                                            children: [
                                              buildFloorsAllowedForConstruction(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildPlotPrice()
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                createProjectController
                                            .selectedProjectType.value ==
                                        'Independent House'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildBuiltUpArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buidProjectFacing()
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          Row(
                                            children: [
                                              buildNumberOfFloors(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildFurnshingStatus(),
                                            ],
                                          ),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          buildFullWidthPlotPrice(),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                createProjectController
                                            .selectedProjectType.value ==
                                        'Commercial'
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              buildProjectArea(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildSmallWidthConfiguration()
                                            ],
                                          ),
                                      SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                          Row(children: [
                                            minBuiltUpArea(),
                                            SizedBox(
                                              width: ThemeConstants.width10,
                                            ),
                                            maxBuiltUpArea(),
                                          ]),   SizedBox(
                                            height: ThemeConstants.height10,
                                          ),
                                          Row(children: [
                                            buidProjectFacing(),
                                            SizedBox(
                                              width: ThemeConstants.width10,
                                            ),
                                          ]),

                                          
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          buildExpectedRentValue(),
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                          Row(
                                            children: [
                                              buildMinPrice(),
                                              SizedBox(
                                                width: ThemeConstants.width10,
                                              ),
                                              buildMaxPrice()
                                            ],
                                          ),

                                          
                                          SizedBox(
                                              height: ThemeConstants.width10),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                Row(
                                  children: [
                                    buildPosessionStatus(),
                                    // SizedBox(
                                    //   width: ThemeConstants.width10,
                                    // ),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.width10),
                                createProjectController
                                            .selectedPossesionSttus.value ==
                                        "Under Construction"
                                    ? Column(
                                        children: [
                                          createProjectController
                                                  .possessionDateController
                                                  .text
                                                  .isNotEmpty
                                              ? buildPosessionDateFieldWithoutValidation()
                                              : buildPosessionDateField(),
                                          SizedBox(
                                              height: ThemeConstants.height10),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                buildAboutProject(),
                                SizedBox(height: ThemeConstants.height10),
                                // buildAboutLocation(),
                                // SizedBox(height: ThemeConstants.height10),
                                //buildLocationAdvantage(),
                                SizedBox(height: ThemeConstants.height10),
                                buildCountry(),
                                SizedBox(height: ThemeConstants.height10),
                                buildStates(),
                                SizedBox(height: ThemeConstants.height10),
                                buildCities(),
                                SizedBox(height: ThemeConstants.height10),
                                Row(
                                  children: [
                                    //buildGST(),
                                    // SizedBox(
                                    //   width: ThemeConstants.width10,
                                    // ),
                                    buildPointOfContact(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       "Landmark",
                                //       style: Styles.labelStyles,
                                //     ),
                                //     InkWell(
                                //         onTap: () {
                                //           ((createProjectController
                                //                               .isAgentCreated
                                //                               .value ||
                                //                           createProjectController
                                //                                   .isUpdateMode
                                //                                   .value ==
                                //                               false) &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject
                                //                               .value ==
                                //                           false) ||
                                //                   (createProjectController
                                //                               .isAgentCreated
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isUpdateMode
                                //                               .value ==
                                //                           false &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject
                                //                               .value ==
                                //                           true) ||
                                //                   (createProjectController
                                //                               .isAgentCreated
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isUpdateMode
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject
                                //                               .value ==
                                //                           true)
                                //               ? showAddBottomSheet(context)
                                //               : SizedBox.shrink();
                                //         },
                                //         child: Text(
                                //           "Add New +",
                                //           style: Styles.link1Styles,
                                //         )),
                                //   ],
                                // ),
                                // buildLandmarks(),
                                // SizedBox(height: ThemeConstants.height10),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           "Regulatory Aspects",
                                //           style: Styles.labelStyles,
                                //         ),
                                //       ],
                                //     ),
                                //     InkWell(
                                //         onTap: () {
                                //           ((createProjectController
                                //                               .isAgentCreated.value ||
                                //                           createProjectController
                                //                                   .isUpdateMode.value ==
                                //                               false) &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject.value ==
                                //                           false) ||
                                //                   (createProjectController.isAgentCreated
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isUpdateMode
                                //                               .value ==
                                //                           false &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject
                                //                               .value ==
                                //                           true) ||
                                //                   (createProjectController
                                //                               .isAgentCreated
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isUpdateMode
                                //                               .value ==
                                //                           false &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject
                                //                               .value ==
                                //                           true) ||
                                //                   (createProjectController
                                //                               .isAgentCreated
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isUpdateMode
                                //                               .value ==
                                //                           true &&
                                //                       createProjectController
                                //                               .isSelectedBuilderProject
                                //                               .value ==
                                //                           true)
                                //               ? showAddRegulatoryBottomSheet(
                                //                   context)
                                //               : SizedBox.shrink();
                                //         },
                                //         child: Text(
                                //           "Add New +",
                                //           style: Styles.link1Styles,
                                //         )),
                                //   ],
                                // ),
                                // SizedBox(height: ThemeConstants.height10),
                                // buildRegularAspectsList(),
                                // SizedBox(height: ThemeConstants.height10),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           "Amenities",
                                //           style: Styles.labelStyles,
                                //         ),
                                //         Text(
                                //           "*",
                                //           style: Styles.errorStyles,
                                //         )
                                //       ],
                                //     ),
                                //     Obx(
                                //         () =>
                                //             createProjectController
                                //                     .allAmenitiesList
                                //                     .isNotEmpty
                                //                 ? InkWell(
                                //                     onTap: () async {
                                //                       createProjectController
                                //                           .addAmenities();
                                //                       //SizedBox.shrink();
                                //                       ((createProjectController
                                //                                           .isAgentCreated
                                //                                           .value ||
                                //                                       createProjectController.isUpdateMode.value ==
                                //                                           false) &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       false) ||
                                //                               (createProjectController.isAgentCreated.value == true &&
                                //                                   createProjectController
                                //                                           .isUpdateMode
                                //                                           .value ==
                                //                                       false &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       true) ||
                                //                               (createProjectController.isAgentCreated.value == true &&
                                //                                   createProjectController
                                //                                           .isUpdateMode
                                //                                           .value ==
                                //                                       false &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       true) ||
                                //                               (createProjectController.isAgentCreated.value == true &&
                                //                                   createProjectController
                                //                                           .isUpdateMode
                                //                                           .value ==
                                //                                       true &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       true)
                                //                           ? showAddAmenitiesBottomSheet(
                                //                               context)
                                //                           : SizedBox
                                //                               .shrink();
                                //                     },
                                //                     child: Text(
                                //                       "Add New +",
                                //                       style: Styles
                                //                           .link1Styles,
                                //                     ))
                                //                 : SizedBox.shrink()),
                                //   ],
                                // ),
                                // SizedBox(height: ThemeConstants.height10),
                                // buildAmenitiesList(),
                                // SizedBox(height: ThemeConstants.height10),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Row(
                                //       children: [
                                //         Text(
                                //           "Specifications",
                                //           style: Styles.labelStyles,
                                //         ),
                                //         Text(
                                //           "*",
                                //           style: Styles.errorStyles,
                                //         )
                                //       ],
                                //     ),
                                //     Obx(
                                //         () =>
                                //             createProjectController
                                //                     .allSpecalitiesList
                                //                     .isNotEmpty
                                //                 ? InkWell(
                                //                     onTap: () async {
                                //                       await createProjectController
                                //                           .addSpecificationsEditMode();
                                //                       //  : SizedBox.shrink();
                                //                       ((createProjectController
                                //                                           .isAgentCreated
                                //                                           .value ||
                                //                                       createProjectController.isUpdateMode.value ==
                                //                                           false) &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       false) ||
                                //                               (createProjectController.isAgentCreated.value == true &&
                                //                                   createProjectController
                                //                                           .isUpdateMode
                                //                                           .value ==
                                //                                       false &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       true) ||
                                //                               (createProjectController.isAgentCreated.value == true &&
                                //                                   createProjectController
                                //                                           .isUpdateMode
                                //                                           .value ==
                                //                                       false &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       true) ||
                                //                               (createProjectController.isAgentCreated.value == true &&
                                //                                   createProjectController
                                //                                           .isUpdateMode
                                //                                           .value ==
                                //                                       true &&
                                //                                   createProjectController
                                //                                           .isSelectedBuilderProject
                                //                                           .value ==
                                //                                       true)
                                //                           ? showAddSpecificationsBottomSheet(
                                //                               context)
                                //                           : SizedBox
                                //                               .shrink();
                                //                     },
                                //                     child: Text(
                                //                       "Add New +",
                                //                       style: Styles
                                //                           .link1Styles,
                                //                     ))
                                //                 : SizedBox.shrink()),
                                //   ],
                                // ),
                                // SizedBox(height: ThemeConstants.height10),
                                // buildSpecificationsList(),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        createProjectController
                                            .showAdditionalInfo
                                            .toggle(); // Toggle the visibility
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Add Additional Information +",
                                            style: Styles.link1Styles,
                                          ),
                                          Obx(() {
                                            return Icon(
                                              createProjectController
                                                      .showAdditionalInfo.value
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                    Obx(() {
                                      return createProjectController
                                              .showAdditionalInfo.value
                                          ? Column(
                                              children: [
                                                buildAboutLocation(),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                buildLocationAdvantage(),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                buildGST(),
                                                SizedBox(
                                                  width: ThemeConstants.width10,
                                                ),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Landmarks",
                                                        style:
                                                            Styles.labelStyles),
                                                    InkWell(
                                                        onTap: () {
                                                          ((createProjectController
                                                                              .isAgentCreated.value ||
                                                                          createProjectController.isUpdateMode.value ==
                                                                              false) &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          false) ||
                                                                  (createProjectController.isAgentCreated.value == true &&
                                                                      createProjectController
                                                                              .isUpdateMode
                                                                              .value ==
                                                                          false &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          true) ||
                                                                  (createProjectController.isAgentCreated.value == true &&
                                                                      createProjectController
                                                                              .isUpdateMode
                                                                              .value ==
                                                                          true &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          true)
                                                              ? showAddBottomSheet(
                                                                  context)
                                                              : SizedBox
                                                                  .shrink();
                                                        },
                                                        child: Text(
                                                          "Add New +",
                                                          style: Styles
                                                              .link1Styles,
                                                        )),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                buildLandmarks(),

                                                // Regulatory Aspects Section
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Regulatory Aspects",
                                                        style:
                                                            Styles.labelStyles),
                                                    InkWell(
                                                        onTap: () {
                                                          ((createProjectController
                                                                              .isAgentCreated
                                                                              .value ||
                                                                          createProjectController.isUpdateMode.value ==
                                                                              false) &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          false) ||
                                                                  (createProjectController.isAgentCreated.value == true &&
                                                                      createProjectController
                                                                              .isUpdateMode
                                                                              .value ==
                                                                          false &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          true) ||
                                                                  (createProjectController.isAgentCreated.value == true &&
                                                                      createProjectController
                                                                              .isUpdateMode
                                                                              .value ==
                                                                          false &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          true) ||
                                                                  (createProjectController.isAgentCreated.value == true &&
                                                                      createProjectController
                                                                              .isUpdateMode
                                                                              .value ==
                                                                          true &&
                                                                      createProjectController
                                                                              .isSelectedBuilderProject
                                                                              .value ==
                                                                          true)
                                                              ? showAddRegulatoryBottomSheet(
                                                                  context)
                                                              : SizedBox
                                                                  .shrink();
                                                        },
                                                        child: Text(
                                                          "Add New +",
                                                          style: Styles
                                                              .link1Styles,
                                                        ))
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                buildRegularAspectsList(),

                                                // Amenities Section
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Amenities",
                                                            style: Styles
                                                                .labelStyles),
                                                        //  Text("*", style: Styles.errorStyles),
                                                      ],
                                                    ),
                                                    Obx(() {
                                                      return createProjectController
                                                              .allAmenitiesList
                                                              .isNotEmpty
                                                          ? InkWell(
                                                              onTap: () async {
                                                                createProjectController
                                                                    .addAmenities();
                                                                //SizedBox.shrink();
                                                                ((createProjectController.isAgentCreated.value || createProjectController.isUpdateMode.value == false) &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                false) ||
                                                                        (createProjectController.isAgentCreated.value == true &&
                                                                            createProjectController.isUpdateMode.value ==
                                                                                false &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                true) ||
                                                                        (createProjectController.isAgentCreated.value == true &&
                                                                            createProjectController.isUpdateMode.value ==
                                                                                false &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                true) ||
                                                                        (createProjectController.isAgentCreated.value == true &&
                                                                            createProjectController.isUpdateMode.value ==
                                                                                true &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                true)
                                                                    ? showAddAmenitiesBottomSheet(
                                                                        context)
                                                                    : SizedBox
                                                                        .shrink();
                                                              },
                                                              child: Text(
                                                                "Add New +",
                                                                style: Styles
                                                                    .link1Styles,
                                                              ))
                                                          : SizedBox.shrink();
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                buildAmenitiesList(),

                                                // Specifications Section
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Specifications",
                                                            style: Styles
                                                                .labelStyles),
                                                        //  Text("*", style: Styles.errorStyles),
                                                      ],
                                                    ),
                                                    Obx(() {
                                                      return createProjectController
                                                              .allSpecalitiesList
                                                              .isNotEmpty
                                                          ? InkWell(
                                                              onTap: () async {
                                                                await createProjectController
                                                                    .addSpecificationsEditMode();
                                                                //  : SizedBox.shrink();
                                                                ((createProjectController.isAgentCreated.value || createProjectController.isUpdateMode.value == false) &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                false) ||
                                                                        (createProjectController.isAgentCreated.value == true &&
                                                                            createProjectController.isUpdateMode.value ==
                                                                                false &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                true) ||
                                                                        (createProjectController.isAgentCreated.value == true &&
                                                                            createProjectController.isUpdateMode.value ==
                                                                                false &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                true) ||
                                                                        (createProjectController.isAgentCreated.value == true &&
                                                                            createProjectController.isUpdateMode.value ==
                                                                                true &&
                                                                            createProjectController.isSelectedBuilderProject.value ==
                                                                                true)
                                                                    ? showAddSpecificationsBottomSheet(
                                                                        context)
                                                                    : SizedBox
                                                                        .shrink();
                                                              },
                                                              child: Text(
                                                                "Add New +",
                                                                style: Styles
                                                                    .link1Styles,
                                                              ))
                                                          : SizedBox.shrink();
                                                    }),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: ThemeConstants
                                                        .height10),
                                                buildSpecificationsList(),
                                              ],
                                            )
                                          : SizedBox
                                              .shrink(); // Hide content if not visible
                                    }),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),
                                SizedBox(height: ThemeConstants.height10),
                                RoundedFilledButtonWidget(
                                  buttonName: "Save",
                                  onPressed: () {
                                    // if (createProjectController
                                    //     .regulatoryAspectsList.isEmpty) {
                                    //   regulatoryAspects.value = '';
                                    //   regulatoryAspects.name = '';
                                    //   createProjectController
                                    //       .regulatoryAspectsList
                                    //       .add(regulatoryAspects);
                                    // }
                                    createProjectController.save();
                                  },
                                ),
                                SizedBox(height: ThemeConstants.height10),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              )),
        ));
  }

  buildRegularAspectsList() {
    // print('reg... ${createProjectController.regulatoryAspectsList.length}');
    // print('reg...123 ${createProjectController.regulatoryAspectsList}');
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: ThemeConstants.greyColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Name',
                    style: Styles.label1Styles,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    'Id',
                    style: Styles.label1Styles,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Action',
                    style: Styles.label1Styles,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ThemeConstants.greyColor),
          Obx(() => createProjectController.regulatoryAspectsList.length != 0
              ? buildRegulatoryAspectTable()
              : SizedBox.shrink()),
        ],
      ),
    );
  }

  Container buildAmenitiesList() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: ThemeConstants.greyColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Name',
                    style: Styles.label1Styles,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    'Feature',
                    style: Styles.label1Styles,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Action',
                    style: Styles.label1Styles,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ThemeConstants.greyColor),
          buildAmenitiesListTable(),
        ],
      ),
    );
  }

  buildSpecificationsList() {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: ThemeConstants.greyColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'Name',
                    style: Styles.label1Styles,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Text(
                    'Feature',
                    style: Styles.label1Styles,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Action',
                    style: Styles.label1Styles,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ThemeConstants.greyColor),
          buildSpecificationsListTable(),
        ],
      ),
    );
  }

  buildSpecificationsListTable() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: ThemeConstants.greyColor,
              );
            },
            shrinkWrap: true,
            itemCount: createProjectController.specificationsList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          createProjectController
                              .specificationsList[index].name!,
                          style: createProjectController.isAgentCreated.value &&
                                  createProjectController.isUpdateMode.value
                              ? Styles.labelStyles
                              : createProjectController
                                              .isAgentCreated.value ==
                                          false &&
                                      createProjectController
                                              .isUpdateMode.value ==
                                          false &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          false
                                  ? Styles.labelStyles
                                  : (createProjectController
                                                  .isAgentCreated.value ==
                                              true &&
                                          createProjectController
                                                  .isUpdateMode.value ==
                                              false &&
                                          createProjectController
                                                  .isSelectedBuilderProject
                                                  .value ==
                                              true)
                                      ? Styles.labelStyles
                                      : Styles.greyLabelStyles1,
                        )),
                    Expanded(
                      flex: 6,
                      child: Wrap(
                          runSpacing: 8.0,
                          spacing: 4.0,
                          children: createProjectController
                              .specificationsList[index].features!
                              .map((item) => Text(
                                    item.name! + " ",
                                    textAlign: TextAlign.left,
                                    style: createProjectController.isAgentCreated
                                                .value &&
                                            createProjectController
                                                .isUpdateMode.value
                                        ? Styles.labelStyles
                                        : createProjectController
                                                        .isAgentCreated.value ==
                                                    false &&
                                                createProjectController
                                                        .isUpdateMode.value ==
                                                    false &&
                                                createProjectController
                                                        .isSelectedBuilderProject
                                                        .value ==
                                                    false
                                            ? Styles.labelStyles
                                            : (createProjectController
                                                            .isAgentCreated
                                                            .value ==
                                                        true &&
                                                    createProjectController
                                                            .isUpdateMode
                                                            .value ==
                                                        false &&
                                                    createProjectController
                                                            .isSelectedBuilderProject
                                                            .value ==
                                                        true)
                                                ? Styles.labelStyles
                                                : Styles.greyLabelStyles1,
                                  ))
                              .toList()),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          ((createProjectController.isAgentCreated.value || createProjectController.isUpdateMode.value == false) && createProjectController.isSelectedBuilderProject.value == false) ||
                                  (createProjectController.isAgentCreated.value == true &&
                                      createProjectController
                                              .isUpdateMode.value ==
                                          false &&
                                      createProjectController.isSelectedBuilderProject.value ==
                                          true)
                              ? createProjectController.specificationsList
                                  .remove(createProjectController
                                      .specificationsList[index])
                              : (createProjectController.isAgentCreated.value == true &&
                                          createProjectController.isUpdateMode.value ==
                                              false &&
                                          createProjectController.isSelectedBuilderProject.value ==
                                              true) ||
                                      (createProjectController.isAgentCreated.value == true &&
                                          createProjectController.isUpdateMode.value ==
                                              false &&
                                          createProjectController.isSelectedBuilderProject.value ==
                                              true) ||
                                      (createProjectController.isAgentCreated.value == true &&
                                          createProjectController.isUpdateMode.value == true &&
                                          createProjectController.isSelectedBuilderProject.value == true)
                                  ? createProjectController.specificationsList.remove(createProjectController.specificationsList[index])
                                  : SizedBox.shrink();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            LineIcons.trash,
                            color: createProjectController
                                        .isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? ThemeConstants.errorColor
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? ThemeConstants.errorColor
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? ThemeConstants.errorColor
                                        : ThemeConstants.greyColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  buildRegulatoryAspectTable() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: ThemeConstants.greyColor,
              );
            },
            shrinkWrap: true,
            itemCount: createProjectController.regulatoryAspectsList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          createProjectController
                                      .regulatoryAspectsList[index].name !=
                                  null
                              ? createProjectController
                                  .regulatoryAspectsList[index].name!
                              : '',
                          style: createProjectController.isAgentCreated.value &&
                                  createProjectController.isUpdateMode.value
                              ? Styles.labelStyles
                              : createProjectController
                                              .isAgentCreated.value ==
                                          false &&
                                      createProjectController
                                              .isUpdateMode.value ==
                                          false &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          false
                                  ? Styles.labelStyles
                                  : (createProjectController
                                                  .isAgentCreated.value ==
                                              true &&
                                          createProjectController
                                                  .isUpdateMode.value ==
                                              false &&
                                          createProjectController
                                                  .isSelectedBuilderProject
                                                  .value ==
                                              true)
                                      ? Styles.labelStyles
                                      : Styles.greyLabelStyles1,
                        )),
                    Expanded(
                        flex: 4,
                        child: Text(
                          createProjectController
                                      .regulatoryAspectsList[index].value !=
                                  null
                              ? createProjectController
                                  .regulatoryAspectsList[index].value!
                              : '',
                          style: createProjectController.isAgentCreated.value &&
                                  createProjectController.isUpdateMode.value
                              ? Styles.labelStyles
                              : createProjectController
                                              .isAgentCreated.value ==
                                          false &&
                                      createProjectController
                                              .isUpdateMode.value ==
                                          false &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          false
                                  ? Styles.labelStyles
                                  : (createProjectController
                                                  .isAgentCreated.value ==
                                              true &&
                                          createProjectController
                                                  .isUpdateMode.value ==
                                              false &&
                                          createProjectController
                                                  .isSelectedBuilderProject
                                                  .value ==
                                              true)
                                      ? Styles.labelStyles
                                      : Styles.greyLabelStyles1,
                        )),
                    createProjectController.regulatoryAspectsList[index].name !=
                            null
                        ? Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                ((createProjectController.isAgentCreated.value ||
                                                createProjectController.isUpdateMode.value ==
                                                    false) &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                false) ||
                                        (createProjectController.isAgentCreated.value == true &&
                                            createProjectController.isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true) ||
                                        (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController.isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true) ||
                                        (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                true &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                    ? createProjectController
                                        .regulatoryAspectsList
                                        .remove(createProjectController.regulatoryAspectsList[index])
                                    : SizedBox.shrink();
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  LineIcons.trash,
                                  color: createProjectController
                                              .isAgentCreated.value &&
                                          createProjectController
                                              .isUpdateMode.value
                                      ? ThemeConstants.errorColor
                                      : createProjectController
                                                      .isAgentCreated.value ==
                                                  false &&
                                              createProjectController.isUpdateMode
                                                      .value ==
                                                  false &&
                                              createProjectController
                                                      .isSelectedBuilderProject
                                                      .value ==
                                                  false
                                          ? ThemeConstants.errorColor
                                          : (createProjectController.isAgentCreated
                                                          .value ==
                                                      true &&
                                                  createProjectController
                                                          .isUpdateMode.value ==
                                                      false &&
                                                  createProjectController
                                                          .isSelectedBuilderProject
                                                          .value ==
                                                      true)
                                              ? ThemeConstants.errorColor
                                              : ThemeConstants.greyColor,
                                  size: 20,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ));
  }

  buildAmenitiesListTable() {
    return Obx(() => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: ThemeConstants.greyColor,
              );
            },
            shrinkWrap: true,
            itemCount: createProjectController.amenitiesList.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 4,
                        child: Text(
                          createProjectController.amenitiesList[index].name!,
                          style: createProjectController.isAgentCreated.value &&
                                  createProjectController.isUpdateMode.value
                              ? Styles.labelStyles
                              : createProjectController
                                              .isAgentCreated.value ==
                                          false &&
                                      createProjectController
                                              .isUpdateMode.value ==
                                          false &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          false
                                  ? Styles.labelStyles
                                  : (createProjectController
                                                  .isAgentCreated.value ==
                                              true &&
                                          createProjectController
                                                  .isUpdateMode.value ==
                                              false &&
                                          createProjectController
                                                  .isSelectedBuilderProject
                                                  .value ==
                                              true)
                                      ? Styles.labelStyles
                                      : Styles.greyLabelStyles1,
                        )),
                    Expanded(
                      flex: 6,
                      child: Wrap(
                          runSpacing: 8.0,
                          spacing: 4.0,
                          children: createProjectController
                              .amenitiesList[index].features!
                              .map((item) => Text(
                                    item.name! + " ",
                                    textAlign: TextAlign.left,
                                    style: createProjectController.isAgentCreated
                                                .value &&
                                            createProjectController
                                                .isUpdateMode.value
                                        ? Styles.labelStyles
                                        : createProjectController
                                                        .isAgentCreated.value ==
                                                    false &&
                                                createProjectController
                                                        .isUpdateMode.value ==
                                                    false &&
                                                createProjectController
                                                        .isSelectedBuilderProject
                                                        .value ==
                                                    false
                                            ? Styles.labelStyles
                                            : (createProjectController
                                                            .isAgentCreated
                                                            .value ==
                                                        true &&
                                                    createProjectController
                                                            .isUpdateMode
                                                            .value ==
                                                        false &&
                                                    createProjectController
                                                            .isSelectedBuilderProject
                                                            .value ==
                                                        true)
                                                ? Styles.labelStyles
                                                : Styles.greyLabelStyles1,
                                  ))
                              .toList()),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          ((createProjectController.isAgentCreated.value ||
                                          createProjectController.isUpdateMode.value ==
                                              false) &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          false) ||
                                  (createProjectController.isAgentCreated.value ==
                                          true &&
                                      createProjectController.isUpdateMode.value ==
                                          false &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          true) ||
                                  (createProjectController.isAgentCreated.value ==
                                          true &&
                                      createProjectController.isUpdateMode.value ==
                                          false &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          true) ||
                                  (createProjectController
                                              .isAgentCreated.value ==
                                          true &&
                                      createProjectController.isUpdateMode.value ==
                                          true &&
                                      createProjectController
                                              .isSelectedBuilderProject.value ==
                                          true)
                              ? createProjectController.amenitiesList.remove(
                                  createProjectController.amenitiesList[index])
                              : SizedBox.shrink();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            LineIcons.trash,
                            color: createProjectController
                                        .isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? ThemeConstants.errorColor
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? ThemeConstants.errorColor
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? ThemeConstants.errorColor
                                        : ThemeConstants.greyColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  showAddBottomSheet(context) {
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Landmark',
                                        style: Styles.subHeadingStyles,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.back();
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
                                    height: ThemeConstants.height10,
                                  ),
                                  Form(
                                    key:
                                        createProjectController.landMarkFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Enter Landmark',
                                          style: Styles.labelStyles,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        TextBoxWidget(
                                          isEnable: createProjectController
                                                      .isAgentCreated.value &&
                                                  createProjectController
                                                      .isUpdateMode.value
                                              ? true
                                              : createProjectController
                                                              .isAgentCreated
                                                              .value ==
                                                          false &&
                                                      createProjectController
                                                              .isUpdateMode
                                                              .value ==
                                                          false
                                                  ? true
                                                  : false,
                                          hintText: "",
                                          controller: createProjectController
                                              .landMarkNameController,
                                          label: "Landmark",
                                          isRequired: true,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height10,
                                  ),
                                  RoundedFilledButtonWidget(
                                      buttonName: 'Save',
                                      onPressed: () {
                                        if (createProjectController
                                            .landMarkFormKey.currentState!
                                            .validate()) {
                                          createProjectController.addLandMark();
                                        }
                                      })
                                ],
                              ))),
                    ]),
                  )),
            ));
  }

  showAddRegulatoryBottomSheet(context) {
    RegulatoryAspects regulatoryAspects = RegulatoryAspects();
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Regulatory Aspects',
                                        style: Styles.subHeadingStyles,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.back();
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
                                    height: ThemeConstants.height10,
                                  ),
                                  Form(
                                    key: createProjectController
                                        .regulatoryFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Regulatory Name',
                                          style: Styles.labelStyles,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        TextBoxWidget(
                                            isEnable: createProjectController
                                                        .isAgentCreated.value &&
                                                    createProjectController
                                                        .isUpdateMode.value
                                                ? true
                                                : createProjectController
                                                                .isAgentCreated
                                                                .value ==
                                                            false &&
                                                        createProjectController
                                                                .isUpdateMode
                                                                .value ==
                                                            false
                                                    ? true
                                                    : false,
                                            hintText: "Regulatory Name",
                                            controller: createProjectController
                                                .regulatoryNameController,
                                            isRequired: true,
                                            label: "Regulatory Name"),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        Text(
                                          'Regulatory Id',
                                          style: Styles.labelStyles,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        TextBoxWidget(
                                            isEnable: createProjectController
                                                        .isAgentCreated.value &&
                                                    createProjectController
                                                        .isUpdateMode.value
                                                ? true
                                                : createProjectController
                                                                .isAgentCreated
                                                                .value ==
                                                            false &&
                                                        createProjectController
                                                                .isUpdateMode
                                                                .value ==
                                                            false
                                                    ? true
                                                    : false,
                                            hintText: "Regulatory Id",
                                            controller: createProjectController
                                                .regulatoryIdController,
                                            isRequired: true,
                                            label: "Regulatory Id"),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height10,
                                  ),
                                  RoundedFilledButtonWidget(
                                      buttonName: 'Save',
                                      onPressed: () {
                                        if (createProjectController
                                            .regulatoryFormKey!.currentState!
                                            .validate()) {
                                          regulatoryAspects.name =
                                              createProjectController
                                                  .regulatoryNameController
                                                  .text;
                                          regulatoryAspects.value =
                                              createProjectController
                                                  .regulatoryIdController.text;
                                          createProjectController
                                              .addRegulatoryAspects(
                                                  regulatoryAspects);
                                        }
                                      })
                                ],
                              ))),
                    ]),
                  )),
            ));
  }

  showAddAmenitiesBottomSheet(context) {
    Amenities amenity = Amenities();
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
                              child: Form(
                                key: createProjectController.amenitiesFormKey,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Add Amenities',
                                          style: Styles.subHeadingStyles,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            createProjectController
                                                .amenityFeatureList
                                                .clear();
                                            Get.back();
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
                                      height: ThemeConstants.height10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Amenity Name',
                                          style: Styles.labelStyles,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height6,
                                        ),
                                        Obx(() => DropdownFormFieldWidget(
                                              isReadOnly: createProjectController
                                                          .isAgentCreated
                                                          .value &&
                                                      createProjectController
                                                          .isUpdateMode.value
                                                  ? false
                                                  : createProjectController
                                                                  .isAgentCreated
                                                                  .value ==
                                                              false &&
                                                          createProjectController
                                                                  .isUpdateMode
                                                                  .value ==
                                                              false
                                                      ? false
                                                      : true,
                                              hintText: 'Amenity Name',
                                              isRequired: true,
                                              items: createProjectController
                                                  .allAmenitiesList
                                                  .map<DropdownMenuItem>(
                                                      (Amenities item) {
                                                return DropdownMenuItem(
                                                    value: item,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0, right: 0),
                                                      child: Text(
                                                        item.name!,
                                                        style:
                                                            Styles.labelStyles,
                                                      ),
                                                    ));
                                              }).toList(),
                                              selectedValue:
                                                  createProjectController
                                                              .selectedAmenity
                                                              .value !=
                                                          ''
                                                      ? createProjectController
                                                          .selectedAmenity.value
                                                      : null,
                                              onChange: (value) {
                                                print(
                                                    "value: ${value.features.length}");

                                                createProjectController
                                                    .selectedAmenityFeature
                                                    .value = value.features[0];

                                                createProjectController
                                                    .amenityFeatureList
                                                    .clear();
                                                createProjectController
                                                    .amenityFeatureList
                                                    .addAll(value.features);

                                                amenity.name = value.name;
                                                amenity.amenitySpecificationId =
                                                    value
                                                        .amenitySpecificationId;
                                                amenity.type = "Amenity";

                                                print(
                                                    "features aminity: ${jsonEncode(createProjectController.amenityFeatureList)}");
                                              },
                                            )),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        Obx(() => createProjectController
                                                .amenityFeatureList.isNotEmpty
                                            ? Text(
                                                'Amenity Features',
                                                style: Styles.labelStyles,
                                              )
                                            : SizedBox.shrink()),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        Obx(() => createProjectController
                                                .amenityFeatureList.isNotEmpty
                                            ? MultiSelectDialogField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (values) {
                                                  if (values == null ||
                                                      values.isEmpty) {
                                                    return "Please select features";
                                                  }

                                                  return null;
                                                },
                                                items: createProjectController
                                                    .amenityFeatureList
                                                    .map((feature) =>
                                                        MultiSelectItem<
                                                                Feature>(
                                                            feature,
                                                            feature.name!))
                                                    .toList(),
                                                title: Text(amenity.name!),
                                                selectedColor: Colors.blue,
                                                decoration: BoxDecoration(
                                                  color:
                                                      ThemeConstants.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  border: Border.all(
                                                    color: ThemeConstants
                                                        .greyColor,
                                                    width: 2,
                                                  ),
                                                ),
                                                buttonIcon: LineIcon(
                                                    Icons.arrow_drop_down),
                                                buttonText: Text("Select",
                                                    style: Styles.labelStyles),
                                                onConfirm: (results) {
                                                  print("results: $results");
                                                  amenity.features = [];
                                                  results.forEach((r) {
                                                    Feature f = Feature();
                                                    f.logo = r.logo;
                                                    f.name = r.name;
                                                    amenity.features!.add(f);
                                                  });
                                                },
                                              )
                                            : SizedBox.shrink()),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: ThemeConstants.height10,
                                    ),
                                    RoundedFilledButtonWidget(
                                        buttonName: 'Save',
                                        onPressed: () {
                                          if (createProjectController
                                              .amenitiesFormKey.currentState!
                                              .validate()) {
                                            Get.back();
                                            createProjectController
                                                .addAmenity(amenity);
                                          }
                                        })
                                  ],
                                ),
                              ))),
                    ]),
                  )),
            ));
  }

  showAddSpecificationsBottomSheet(context) {
    Specifications specifications = Specifications();
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
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Add Specifications',
                                        style: Styles.subHeadingStyles,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          createProjectController
                                              .specalityFeatureList
                                              .clear();
                                          Get.back();
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
                                    height: ThemeConstants.height10,
                                  ),
                                  Form(
                                    key: createProjectController
                                        .specificationsFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name',
                                          style: Styles.labelStyles,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height6,
                                        ),
                                        Obx(() => DropdownFormFieldWidget(
                                              isReadOnly: createProjectController
                                                          .isAgentCreated
                                                          .value &&
                                                      createProjectController
                                                          .isUpdateMode.value
                                                  ? false
                                                  : createProjectController
                                                                  .isAgentCreated
                                                                  .value ==
                                                              false &&
                                                          createProjectController
                                                                  .isUpdateMode
                                                                  .value ==
                                                              false
                                                      ? false
                                                      : true,

                                              hintText: ' Specification Name',
                                              isRequired: true,
                                              items: createProjectController
                                                  .allSpecalitiesList
                                                  .map<DropdownMenuItem>(
                                                      (item) {
                                                return DropdownMenuItem(
                                                    value: item,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 0),
                                                      child: Text(
                                                        item.name!,
                                                        style:
                                                            Styles.labelStyles,
                                                      ),
                                                    ));
                                              }).toList(),
                                              //  selectedValue: createProjectController.selectedSpecificationName.value.isNotEmpty ? createProjectController.selectedSpecificationName.value : null,
                                              onChange: (value) {
                                                print(
                                                    "specalityFeatureList : ${value}");
                                                // createProjectController
                                                //     .selectedSpecificationFeature
                                                //     .value = value.features[0];
                                                createProjectController
                                                    .specalityFeatureList
                                                    .clear();
                                                createProjectController
                                                    .specalityFeatureList
                                                    .addAll(value.features);

                                                specifications.name =
                                                    value.name;
                                                specifications
                                                        .amenitySpecificationId =
                                                    value
                                                        .amenitySpecificationId;
                                                specifications.type =
                                                    "Specification";
                                              },
                                            )),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        Obx(() => createProjectController
                                                .specalityFeatureList.isNotEmpty
                                            ? Text(
                                                'Specification Features',
                                                style: Styles.labelStyles,
                                              )
                                            : SizedBox.shrink()),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        Obx(() => createProjectController
                                                .specalityFeatureList.isNotEmpty
                                            ? MultiSelectDialogField(
                                                items: createProjectController
                                                    .specalityFeatureList
                                                    .map((f) => MultiSelectItem<
                                                        Feature>(f, f.name!))
                                                    .toList(),
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                validator: (values) {
                                                  if (values == null ||
                                                      values.isEmpty) {
                                                    return "Please select features";
                                                  }

                                                  return null;
                                                },
                                                title:
                                                    Text(specifications.name!),
                                                selectedColor: Colors.blue,
                                                decoration: BoxDecoration(
                                                  color:
                                                      ThemeConstants.whiteColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  border: Border.all(
                                                    color: ThemeConstants
                                                        .greyColor,
                                                    width: 2,
                                                  ),
                                                ),
                                                buttonIcon: LineIcon(
                                                    Icons.arrow_drop_down),
                                                buttonText: Text("Select",
                                                    style: Styles.label1Styles),
                                                onConfirm: (results) {
                                                  print("results: $results");
                                                  specifications.features = [];
                                                  results.forEach((r) {
                                                    Feature f = Feature();
                                                    f.logo = r.logo;
                                                    f.name = r.name;
                                                    specifications.features!
                                                        .add(f);
                                                  });
                                                },
                                              )
                                            : SizedBox.shrink()),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                        SizedBox(
                                          height: ThemeConstants.height10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: ThemeConstants.height10,
                                  ),
                                  RoundedFilledButtonWidget(
                                      buttonName: 'Save',
                                      onPressed: () {
                                        if (createProjectController
                                            .specificationsFormKey.currentState!
                                            .validate()) {
                                          Get.back();
                                          createProjectController
                                              .addSpecification(specifications);
                                        }
                                      })
                                ],
                              ))),
                    ]),
                  )),
            ));
  }

  buildLandmarks() {
    return Obx(() => Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(createProjectController.landMarksList.length,
              (index) {
            return Chip(
              label: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(createProjectController.landMarksList[index]),
              ),
              backgroundColor: Color.fromARGB(255, 134, 94, 194),
              labelStyle: Styles.labelStyles,
              deleteIcon: Icon(
                LineIcons.trash,
                color: createProjectController.isAgentCreated.value &&
                        createProjectController.isUpdateMode.value
                    ? ThemeConstants.errorColor
                    : createProjectController.isAgentCreated.value == false &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                false
                        ? ThemeConstants.errorColor
                        : (createProjectController.isAgentCreated.value ==
                                    true &&
                                createProjectController.isUpdateMode.value ==
                                    false &&
                                createProjectController
                                        .isSelectedBuilderProject.value ==
                                    true)
                            ? ThemeConstants.errorColor
                            : ThemeConstants.greyColor,
                size: 20,
              ),
              onDeleted: () {
                ((createProjectController.isAgentCreated.value ||
                                createProjectController.isUpdateMode.value ==
                                    false) &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                false) ||
                        (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true) ||
                        (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true) ||
                        (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                true &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                    ? createProjectController.landMarksList
                        .remove(createProjectController.landMarksList[index])
                    : SizedBox.shrink();
              },
            );
          }).toList(),
        ));
  }

  Stack buildAddress() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Address', style: Styles.labelStyles),
                Text("*", style: Styles.errorStyles)
              ],
            ),
            SizedBox(height: ThemeConstants.height4),
            TextFormField(
                enabled: createProjectController.isAgentCreated.value &&
                        createProjectController.isUpdateMode.value
                    ? true
                    : createProjectController.isAgentCreated.value == false &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                false
                        ? true
                        : (createProjectController.isAgentCreated.value ==
                                    true &&
                                createProjectController.isUpdateMode.value ==
                                    false &&
                                createProjectController
                                        .isSelectedBuilderProject.value ==
                                    true)
                            ? true
                            : false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                cursorColor: ThemeConstants.primaryColor,
                controller: createProjectController.searchtermController,
                onChanged: (value) =>
                    createProjectController.searchPlaces(value),
                decoration: InputDecoration(
                    fillColor: ThemeConstants.whiteColor,
                    filled: true,
                    contentPadding: EdgeInsets.all(
                        Get.height * ThemeConstants.textFieldContentPadding),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: ThemeConstants.primaryColor),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    isDense: true,
                    hintText: 'Search for Location',
                    hintStyle: Styles.hintStyles),
                validator: (value) {
                  if (value!.isEmpty || value.trim() == "") {
                    return 'Address is required';
                  }
                }),
          ],
        ),
        Obx(() => createProjectController.searchResults.isNotEmpty
            ? Container(
                margin: const EdgeInsets.only(top: 70),
                height: createProjectController.searchResults.isNotEmpty
                    ? 300.0
                    : 0.0,
                child: ListView.builder(
                    itemCount: createProjectController.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          createProjectController
                              .searchResults[index].description,
                        ),
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          print(
                              'selected location${createProjectController.searchResults}');
                          print(createProjectController
                              .searchResults[index].placeId);
                          createProjectController.setSelectedLocation(
                              createProjectController
                                  .searchResults[index].placeId);
                          createProjectController.searchtermController.text =
                              createProjectController
                                  .searchResults[index].description;
                        },
                      );
                    }),
              )
            : SizedBox.shrink()),
      ],
    );
  }

  Container buildGMap() {
    return Container(
      height: 175,
      width: Get.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          createProjectController.mapController.complete(controller);
        },
        markers: Set.from(createProjectController.myMarker),
        onTap: createProjectController.handleTap,
      ),
    );
  }

  buildLocationAdvantage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location Advantage', style: Styles.labelStyles),
        SizedBox(height: ThemeConstants.height10),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Location Advantage',
            controller: createProjectController.locationAdvantageController),
      ],
    );
  }

  buildAboutLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Location', style: Styles.labelStyles),
        SizedBox(height: ThemeConstants.height10),
        TextBoxWidget(
          isEnable: createProjectController.isAgentCreated.value &&
                  createProjectController.isUpdateMode.value
              ? true
              : createProjectController.isAgentCreated.value == false &&
                      createProjectController.isUpdateMode.value == false &&
                      createProjectController.isSelectedBuilderProject.value ==
                          false
                  ? true
                  : (createProjectController.isAgentCreated.value == true &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              true)
                      ? true
                      : false,
          hintText: 'About Location',
          controller: createProjectController.aboutLocationController,
        ),
      ],
    );
  }

  Expanded buildMaxPrice() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Max Price', style: Styles.labelStyles),
              SizedBox(width: ThemeConstants.width2),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Max Price',
              controller: createProjectController.maxPriceController,
              isRequired: true,
              label: "Max Price")
        ],
      ),
    );
  }

  buildGST() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('GST', style: Styles.labelStyles),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'GST',
            controller: createProjectController.gstController)
      ],
    );
  }

  Expanded buildPointOfContact() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Point Of Contact', style: Styles.labelStyles),
              SizedBox(width: ThemeConstants.width2),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          MobileNumberWidget(
              hintText: 'Point Of Contact',
              controller: createProjectController.pocController,
              isRequired: true)
          // TextBoxWidget(
          //     // isEnable:
          //     //     createProjectController.isAgentCreated.value ? true : false,
          //     hintText: 'Point of Contact',
          //     controller: createProjectController.pocController,
          //     isRequired: true,
          //     label: "Point of Contact")
        ],
      ),
    );
  }

  Expanded buildMinPrice() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Min Price', style: Styles.labelStyles),
              SizedBox(width: ThemeConstants.width2),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Min Price',
            controller: createProjectController.minPriceController,
            isRequired: true,
            label: "Min Price",
          )
        ],
      ),
    );
  }

  buildAboutProject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('About Project', style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(height: ThemeConstants.height4),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'About Project',
            controller: createProjectController.aboutProjectController,
            isRequired: true,
            label: "About Project")
      ],
    );
  }

  buildCarpetArea() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Carpet Area', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.height4),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Carpet Area',
              controller: createProjectController.carpetAreaController,
              isRequired: true,
              label: "Carpet Area")
        ],
      ),
    );
  }

  buildPropertyAge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Property Age', style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(height: ThemeConstants.height4),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Property Age',
            controller: createProjectController.propertyAgeController,
            isRequired: true,
            label: "Property Age")
      ],
    );
  }

  Expanded buildBuildArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Build Up Area', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Build Up area',
            controller: createProjectController.builtUpAreaontroller,
            isRequired: true,
            label: "Build Up area",
          )
        ],
      ),
    );
  }

  Expanded buildTotalNoOfUnits() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Total No. of Units', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Total No. of Units',
              controller: createProjectController.totalNoOfUnitsController,
              isRequired: true,
              label: "Total No. of Units")
        ],
      ),
    );
  }

  Expanded buildPlotPrice() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Price', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Price',
              controller: createProjectController.plotPriceController,
              isRequired: true,
              label: "Price")
        ],
      ),
    );
  }

  buildFullWidthPlotPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Price', style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text(
              '*',
              style: TextStyle(color: Colors.red),
            )
          ],
        ),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Price',
            controller: createProjectController.plotPriceController,
            isRequired: true,
            label: "Price")
      ],
    );
  }

  Expanded buildProjectArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Total Project Area', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Total Project Area',
              controller: createProjectController.totalProjectAreaController,
              isRequired: true,
              label: 'Total Project Area')
        ],
      ),
    );
  }

  Expanded buildTotalPlotArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Total Plot Area', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Total Plot Area',
              controller: createProjectController.plotAreaController,
              isRequired: true,
              label: 'Total Plot Area')
        ],
      ),
    );
  }

  Expanded buildDimensions() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Dimensions', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Dimensions',
              controller: createProjectController.dimensionsController,
              isRequired: true,
              label: 'Dimensions')
        ],
      ),
    );
  }

  buildFullWidthDimensions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Dimensions', // Heading text
                style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Dimensions',
            controller: createProjectController.dimensionsController,
            isRequired: true,
            label: 'Dimensions')
      ],
    );
  }

  Expanded buildBoundaryWall() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Text('Boundary Wall Present?',
                    // Heading text
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.labelStyles),
              ),
              Expanded(child: Text('*', style: Styles.errorStyles))
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          // TextBoxWidget(
          //     isEnable: createProjectController.isAgentCreated.value &&
          //             createProjectController.isUpdateMode.value
          //         ? true
          //         : createProjectController.isAgentCreated.value == false &&
          //                 createProjectController.isUpdateMode.value == false &&
          //                 createProjectController
          //                         .isSelectedBuilderProject.value ==
          //                     false
          //             ? true
          //             : (createProjectController.isAgentCreated.value == true &&
          //                     createProjectController.isUpdateMode.value ==
          //                         false &&
          //                     createProjectController
          //                             .isSelectedBuilderProject.value ==
          //                         true)
          //                 ? true
          //                 : false,
          //     hintText: 'Boundary wall present?',
          //     controller: createProjectController.boundaryWallPresentController,
          //     isRequired: true,
          //     label: 'Boundary wall present?')

          Obx(() => DropdownFormFieldWidget(
              isReadOnly:
                  createProjectController.isAgentCreated.value &&
                          createProjectController.isUpdateMode.value
                      ? false
                      : createProjectController.isAgentCreated.value == false &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  false
                          ? false
                          : (createProjectController.isAgentCreated.value ==
                                      true &&
                                  createProjectController.isUpdateMode.value ==
                                      false &&
                                  createProjectController.isSelectedBuilderProject
                                          .value ==
                                      true)
                              ? false
                              : true,
              isValidationAlways: createProjectController
                          .boundaryWallPresent.value !=
                      ''
                  ? true
                  : false,
              hintText: 'Boundary wall p..',
              isRequired:
                  createProjectController
                              .isUpdateMode.value ==
                          true
                      ? false
                      : true,
              items:
                  AppConstants.constructionDone.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"].toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createProjectController.boundaryWallPresent.value != ''
                      ? createProjectController.boundaryWallPresent.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.boundaryWallPresent.value = value;
              }
              //: () {},
              )),
        ],
      ),
    );
  }

  Expanded buildNoOfOpenSides() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Number of Open Sides', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Number of Open Sides',
              controller: createProjectController.noOfOpenSidesController,
              isRequired: true,
              label: 'Number of Open Sides')
        ],
      ),
    );
  }

  Expanded buildWidthOffacingRoad() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Width of facing road', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Width of facing road',
              controller: createProjectController.widthOffacingRoadController,
              isRequired: true,
              label: 'Width of facing road')
        ],
      ),
    );
  }

  Expanded buildFloorsAllowedForConstruction() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Floors Allowed for Construction',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // Heading text
                    style: Styles.labelStyles),
              ),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Floors Allowed for Construction',
              controller: createProjectController
                  .floorsAllowedForConstructionController,
              isRequired: true,
              label: 'Floors Allowed for Construction')
        ],
      ),
    );
  }

  buildLargeFloorsAllowedForConstruction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Floors Allowed for Construction',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Heading text
                  style: Styles.labelStyles),
            ),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Floors Allowed for Construction',
            controller:
                createProjectController.floorsAllowedForConstructionController,
            isRequired: true,
            label: 'Floors Allowed for Construction')
      ],
    );
  }

  Expanded buildCornerPlot() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Any Construction Done', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          // TextBoxWidget(
          //     isEnable: createProjectController.isAgentCreated.value &&
          //             createProjectController.isUpdateMode.value
          //         ? true
          //         : createProjectController.isAgentCreated.value == false &&
          //                 createProjectController.isUpdateMode.value == false &&
          //                 createProjectController
          //                         .isSelectedBuilderProject.value ==
          //                     false
          //             ? true
          //             : (createProjectController.isAgentCreated.value == true &&
          //                     createProjectController.isUpdateMode.value ==
          //                         false &&
          //                     createProjectController
          //                             .isSelectedBuilderProject.value ==
          //                         true)
          //                 ? true
          //                 : false,
          //     hintText: 'Corner plot',
          //     controller: createProjectController.cornerPlotController,
          //     isRequired: true,
          //     label: 'Corner plot')

          Obx(() => DropdownFormFieldWidget(
              isReadOnly:
                  createProjectController.isAgentCreated.value &&
                          createProjectController.isUpdateMode.value
                      ? false
                      : createProjectController.isAgentCreated.value == false &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  false
                          ? false
                          : (createProjectController.isAgentCreated.value ==
                                      true &&
                                  createProjectController.isUpdateMode.value ==
                                      false &&
                                  createProjectController.isSelectedBuilderProject
                                          .value ==
                                      true)
                              ? false
                              : true,
              isValidationAlways: createProjectController
                          .anyConstructionDone.value !=
                      ''
                  ? true
                  : false,
              hintText: 'Construction Status',
              isRequired:
                  createProjectController
                              .isUpdateMode.value ==
                          true
                      ? false
                      : true,
              items:
                  AppConstants.constructionDone.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"].toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createProjectController.anyConstructionDone.value != ''
                      ? createProjectController.anyConstructionDone.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.anyConstructionDone.value = value;
              }
              //: () {},
              )),
        ],
      ),
    );
  }

  Expanded buildBuiltUpArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Built Up Area', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Built Up Area',
              controller: createProjectController.builtUpAreaontroller,
              isRequired: true,
              label: 'Built Up Area')
        ],
      ),
    );
  }

  Expanded minBuiltUpArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Min Built Up Area', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Min Built Up Area',
              controller: createProjectController.minBuiltUpAreaontroller,
              isRequired: true,
              label: 'Min Built Up Area')
        ],
      ),
    );
  }

  Expanded maxBuiltUpArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Max Built Up Area', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Max Built Up Area',
              controller: createProjectController.maxBuiltUpAreaontroller,
              isRequired: true,
              label: 'Max Built Up Area')
        ],
      ),
    );
  }

  buildExpectedRentValue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Expected Rent Value', // Heading text
                style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Expected Rent Value',
            controller: createProjectController.rentController,
            isRequired: true,
            label: 'Expected Rent Value')
      ],
    );
  }

  Expanded buildPlotArea() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Plot Area', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Plot Area',
              controller: createProjectController.plotAreaController,
              isRequired: true,
              label: 'Plot Area')
        ],
      ),
    );
  }

  buildConfiguration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Configuration', style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            isEnable: createProjectController.isAgentCreated.value &&
                    createProjectController.isUpdateMode.value
                ? true
                : createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Configuration',
            controller: createProjectController.configurationController,
            isRequired: true,
            label: 'Configuration')
      ],
    );
  }

  Expanded buildSmallWidthConfiguration() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Configuration', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Configuration',
              controller: createProjectController.configurationController,
              isRequired: true,
              label: 'Configuration')
        ],
      ),
    );
  }

  Expanded buildFloorDetails() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Floor Details', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Floor Details',
              controller: createProjectController.floorDetailsController,
              isRequired: true,
              label: 'Floor Details')
        ],
      ),
    );
  }

  Expanded buildNumberOfFloors() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Total No. of Floors', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Total No. of Floors',
              controller: createProjectController.totalNoOfFloorsController,
              isRequired: true,
              label: 'Total No. of Floors')
        ],
      ),
    );
  }

  Expanded buildNumberOfTowers() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Total No. of Towers', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
              isEnable: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? true
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Total No. of Towers',
              controller: createProjectController.totalNoOfTowersController,
              isRequired: true,
              label: 'Total No. of Towers')
        ],
      ),
    );
  }

  Expanded buildFurnshingStatus() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Furnishing Status', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          // TextBoxWidget(
          //     isEnable: createProjectController.isAgentCreated.value &&
          //             createProjectController.isUpdateMode.value
          //         ? true
          //         : createProjectController.isAgentCreated.value == false &&
          //                 createProjectController.isUpdateMode.value == false &&
          //                 createProjectController
          //                         .isSelectedBuilderProject.value ==
          //                     false
          //             ? true
          //             : (createProjectController.isAgentCreated.value == true &&
          //                     createProjectController.isUpdateMode.value ==
          //                         false &&
          //                     createProjectController
          //                             .isSelectedBuilderProject.value ==
          //                         true)
          //                 ? true
          //                 : false,
          //     hintText: 'Furnishing status',
          //     controller: createProjectController.furnishingStatusController,
          //     isRequired: true,
          //     label: 'Furnishing status')

          Obx(() => DropdownFormFieldWidget(
              isReadOnly:
                  createProjectController.isAgentCreated.value &&
                          createProjectController.isUpdateMode.value
                      ? false
                      : createProjectController.isAgentCreated.value == false &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  false
                          ? false
                          : (createProjectController.isAgentCreated.value ==
                                      true &&
                                  createProjectController.isUpdateMode.value ==
                                      false &&
                                  createProjectController.isSelectedBuilderProject
                                          .value ==
                                      true)
                              ? false
                              : true,
              isValidationAlways: createProjectController
                          .anyConstructionDone.value !=
                      ''
                  ? true
                  : false,
              hintText: 'Furnishing Status',
              isRequired:
                  createProjectController
                              .isUpdateMode.value ==
                          true
                      ? false
                      : true,
              items:
                  AppConstants.furnishingStatus.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"].toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createProjectController.furnishingStatus.value != ''
                      ? createProjectController.furnishingStatus.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.furnishingStatus.value = value;
              }
              //: () {},
              )),
        ],
      ),
    );
  }

  buidProjectName() {
    print('isiiiiiiis ${createProjectController.isAgentCreated.value}');
    print('isiiiiiiis123 ${createProjectController.isUpdateMode.value}');
    print(
        'isiiiiiiis153 ${createProjectController.isSelectedBuilderProject.value}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Project Name', // Heading text
                style: Styles.labelStyles),
            Text('*', style: Styles.errorStyles)
          ],
        ),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        TextBoxWidget(
            isEnable: (createProjectController.isAgentCreated.value == true &&
                    createProjectController.isUpdateMode.value == true)
                ? true
                : (createProjectController.isAgentCreated.value == false &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            false)
                    ? true
                    : (createProjectController.isAgentCreated.value == true &&
                            createProjectController.isUpdateMode.value ==
                                false &&
                            createProjectController
                                    .isSelectedBuilderProject.value ==
                                true)
                        ? true
                        : false,
            hintText: 'Project Name',
            controller: createProjectController.projectNameController,
            isRequired: true,
            label: "Project Name")
      ],
    );
  }

  Expanded buidProjectFacing() {
    print('isiiiiiiis ${createProjectController.isAgentCreated.value}');
    print('isiiiiiiis123 ${createProjectController.isUpdateMode.value}');
    print(
        'isiiiiiiis153 ${createProjectController.isSelectedBuilderProject.value}');

    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Facing', // Heading text
                  style: Styles.labelStyles),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              isEnable: (createProjectController.isAgentCreated.value == true &&
                      createProjectController.isUpdateMode.value == true)
                  ? true
                  : (createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false)
                      ? true
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? true
                          : false,
              hintText: 'Facing',
              controller: createProjectController.facingController,
              isRequired: true,
              label: "Facing")
        ],
      ),
    );
  }

  Expanded buildProjectType() {
    print('........SelT ${createProjectController.selectedProjectType.value}');
    print(
        'test.123 ${createProjectController.selectedProjectType.value != ''}');
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Project Type', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width10),
          Obx(() => DropdownFormFieldWidget(
              isReadOnly:
                  createProjectController.isAgentCreated.value &&
                          createProjectController.isUpdateMode.value
                      ? false
                      : createProjectController
                                      .isAgentCreated.value ==
                                  false &&
                              createProjectController
                                      .isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  false
                          ? false
                          : (createProjectController
                                          .isAgentCreated.value ==
                                      true &&
                                  createProjectController
                                          .isUpdateMode.value ==
                                      false &&
                                  createProjectController
                                          .isSelectedBuilderProject.value ==
                                      true)
                              ? false
                              : true,
              isValidationAlways: createProjectController
                          .selectedProjectType.value !=
                      ''
                  ? true
                  : false,
              hintText: 'Project Type',
              isRequired: createProjectController.isUpdateMode.value == true
                  ? false
                  : true,
              items: AppConstants.projectTypes.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"].toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createProjectController.selectedProjectType.value != ''
                      ? createProjectController.selectedProjectType.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.selectedProjectType.value = value;
              }
              //: () {},
              )),
        ],
      ),
    );
  }

  Expanded buildPosessionStatus() {
    print('........SelT ${createProjectController.selectedProjectType.value}');
    print(
        'test.123 ${createProjectController.selectedProjectType.value != ''}');
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Construction Status', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width10),
          Obx(() => DropdownFormFieldWidget(
              isReadOnly: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? false
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? false
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? false
                          : true,
              isValidationAlways:
                  createProjectController.selectedPossesionSttus.value != ''
                      ? true
                      : false,
              hintText: 'Construction Status',
              isRequired: createProjectController.isUpdateMode.value == true
                  ? false
                  : true,
              items: AppConstants.possesionStatus.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"].toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createProjectController.selectedPossesionSttus.value != ''
                      ? createProjectController.selectedPossesionSttus.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.selectedPossesionSttus.value = value;
              }
              //: () {},
              )),
        ],
      ),
    );
  }

  Expanded buildTransactionType() {
    print(
        '........SelT ${createProjectController.selectedTransactionType.value}');
    print(
        'test.123 ${createProjectController.selectedTransactionType.value != ''}');
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Transaction Type', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width10),
          Obx(() => DropdownFormFieldWidget(
              isReadOnly: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? false
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? false
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? false
                          : true,
              isValidationAlways:
                  createProjectController.selectedTransactionType.value != ''
                      ? true
                      : false,
              hintText: 'Transaction Type',
              isRequired: createProjectController.isUpdateMode.value == true
                  ? false
                  : true,
              items:
                  AppConstants.transactionTypes.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"].toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createProjectController.selectedTransactionType.value != ''
                      ? createProjectController.selectedTransactionType.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.selectedTransactionType.value = value;
              }
              //: () {},
              )),
        ],
      ),
    );
  }

  Row buildBuilder() {
    return Row(
      children: [
        Text('Select Builder', style: Styles.labelStyles),
        SizedBox(
          width: ThemeConstants.width2,
        ),
        Text('*', style: Styles.errorStyles)
      ],
    );
  }

  Row buildSelectProjectLabel() {
    // print('leissm ${createProjectController.projectDetailsRes.length}');
    // print('leissm. ${createProjectController.projectDetailsRes.isEmpty}');
    return Row(
      children: [
        Text('Select project', style: Styles.labelStyles),
        SizedBox(
          width: ThemeConstants.width2,
        ),
        Text('*', style: Styles.errorStyles)
      ],
    );
  }

  buildSelectBuilder() {
    return TypeAheadField(
      controller: createProjectController.builderController,
      // hideKeyboardOnDrag: false,
      // hideWithKeyboard: false,
      // hideOnSelect: true,
      //  hideOnUnfocus: false,
      builder: (context, controller, focusNode) => TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        style: createProjectController.isAgentCreated.value &&
                createProjectController.isUpdateMode.value
            ? Styles.labelStyles
            : createProjectController.isAgentCreated.value == false &&
                    createProjectController.isUpdateMode.value == false &&
                    createProjectController.isSelectedBuilderProject.value ==
                        false
                ? Styles.labelStyles
                : (createProjectController.isAgentCreated.value == true &&
                        createProjectController.isUpdateMode.value == false &&
                        createProjectController
                                .isSelectedBuilderProject.value ==
                            true)
                    ? Styles.labelStyles
                    : Styles.greyLabelStyles1,
        autofocus: false,
        validator: (value) {
          if (createProjectController.builderController.text == '') {
            return 'Builder is required';
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? Colors.black
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? Colors.black
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? Colors.black
                          : ThemeConstants.greyColor,
            ),
            borderRadius: BorderRadius.circular(14.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: ThemeConstants.primaryColor),
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: ThemeConstants.whiteColor,
          hintText: "Select Builder",
          suffixIcon: createProjectController.builderId.value.isNotEmpty
              ? InkWell(
                  onTap: () {
                    createProjectController.builderId.value = '';
                    createProjectController.builderController.text = '';
                  },
                  child: Icon(
                    Icons.close,
                    size: 20,
                  ))
              : Icon(Icons.arrow_drop_down),
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
        title: Text(
          builder["registeredName"],
        ),
      ),
      onSelected: (v) {
        print("builderId: ${v["builderId"]}");

        createProjectController.builderId.value = v["builderId"];
        createProjectController.builderController.text = v["registeredName"];
        print(
            'isEmpty ... ${createProjectController.builderController.text.isEmpty}, ${createProjectController.builderController.text == ''}');
        createProjectController.getProjectsByBuilderId(v["builderId"]);
      },
      suggestionsCallback: suggestionsCallback,
      itemSeparatorBuilder: itemSeparatorBuilder,
    );
  }

  buildSelectProject() {
    return Obx(() => createProjectController.projects.isNotEmpty
        ? Column(
            children: [
              buildSelectProjectLabel(),
              SizedBox(
                height: ThemeConstants.height10,
              ),
              TypeAheadField(
                controller: createProjectController.projectController,
                builder: (context, controller, focusNode) => TextFormField(
                  controller: controller,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  focusNode: focusNode,
                  autofocus: true,
                  // validator: (value) {
                  //   if (createProjectController.projectController.text == '') {
                  //     return 'Project is required';
                  //   }
                  //   return null;
                  // },
                  decoration: InputDecoration(
                    suffixIcon: Obx(
                        () => createProjectController.projectId.value.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  createProjectController.projectId.value = '';
                                  createProjectController
                                      .projectController.text = ' ';
                                },
                                child: Icon(Icons.close, size: 20))
                            : Icon(Icons.arrow_drop_down)),
                    hintText: "Select Project",
                    hintStyle: Styles.hintStyles,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: ThemeConstants.primaryColor),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    filled: true,
                    fillColor: ThemeConstants.whiteColor,
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
                  title: Text(builder["projectName"]),
                ),
                onSelected: (v) {
                  print("on select called");
                  print("projectId: ${v["projectId"]}");
                  createProjectController.projectController.text =
                      v["projectName"];
                  createProjectController.projectId.value = v["projectId"];
                  createProjectController.getDetailsByProjectId(v["projectId"]);
                },
                suggestionsCallback: projectSuggestionsCallback,
                itemSeparatorBuilder: itemSeparatorBuilder,
              ),
            ],
          )
        : SizedBox.shrink());
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Divider(height: 1);

  Future<List<dynamic>> suggestionsCallback(String pattern) async {
    print('patternnnnnn123 $pattern');
    if (pattern.isEmpty) {
      print('patternnnnnn... empty');
      createProjectController.projects.clear();
      createProjectController.clearData();
      createProjectController.projectController.text = '';
      createProjectController.isAgentCreated.value = false;
      createProjectController.isSelectedBuilderProject.value = false;
    }
    createProjectController.isAgentCreated.value = false;
    createProjectController.isSelectedBuilderProject.value = false;
    createProjectController.projects.clear();
    createProjectController.clearData();
    createProjectController.projectController.text = '';
    print('next....');
    return Future.delayed(
      const Duration(milliseconds: 100),
      () => CommonService.instance.builders.where((b) {
        print('bbbbbbbbbbbb ${b["registeredName"]}');
        final nameLower = b["registeredName"].toLowerCase().split(' ').join('');
        final patternLower = pattern.toLowerCase().split(' ').join('');
        print('ccccccccc $patternLower');
        return nameLower.contains(patternLower);
      }).toList(),
    );
  }

  Future<List<dynamic>> projectSuggestionsCallback(String pattern) async =>
      Future.delayed(
        const Duration(seconds: 1),
        () => createProjectController.projects.where((b) {
          final nameLower = b["projectName"].toLowerCase().split(' ').join('');
          final patternLower = pattern.toLowerCase().split(' ').join('');
          return nameLower.contains(patternLower);
        }).toList(),
      );

  buildCountry() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Country",
                  style: Styles.labelStyles,
                ),
                Text(
                  "*",
                  style: Styles.errorStyles,
                )
              ],
            ),
            SizedBox(
              height: ThemeConstants.height8,
            ),
            DropdownFormFieldWidget(
              isReadOnly: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? false
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? false
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? false
                          : true,
              isValidationAlways:
                  createProjectController.selectedCountry.value != ''
                      ? true
                      : false,
              // isValidationAlways:
              //     createProjectController.isUpdateMode.value == true
              //         ? true
              //         : true,
              hintText: 'Country',
              isRequired: createProjectController.isUpdateMode.value == true
                  ? false
                  : true,
              items: createProjectController.countries
                  .map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item.cntId,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item.name.toString(),
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue: createProjectController.selectedCountry.value != ''
                  ? createProjectController.selectedCountry.value
                  : null,
              onChange: (value) {
                print("onChange : $value");
                createProjectController.selectedCountry.value =
                    value.toString();
                createProjectController.getStatesByCountryId(value.toString());
              },
            ),
          ],
        ));
  }

  buildStates() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "State",
                  style: Styles.labelStyles,
                ),
                Text(
                  "*",
                  style: Styles.errorStyles,
                )
              ],
            ),
            SizedBox(
              height: ThemeConstants.height8,
            ),
            DropdownFormFieldWidget(
              isReadOnly: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? false
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? false
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? false
                          : true,
              // isValidationAlways:
              //     createProjectController.isUpdateMode.value == true
              //         ? true
              //         : true,
              hintText: 'State',
              isRequired: createProjectController.isUpdateMode.value == true
                  ? false
                  : true,
              isValidationAlways:
                  createProjectController.selectedState.value != ''
                      ? true
                      : false,
              items: createProjectController.statesList
                  .map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item.sttId,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item.name!,
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue: createProjectController.selectedState.value != ''
                  ? createProjectController.selectedState.value
                  : null,
              onChange: (value) {
                print("states change: ${value}");
                createProjectController.selectedState.value = value;
                createProjectController.getCitiesByStateId(value);
              },
            ),
          ],
        ));
  }

  buildCities() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "City",
                  style: Styles.labelStyles,
                ),
                Text(
                  "*",
                  style: Styles.errorStyles,
                )
              ],
            ),
            SizedBox(
              height: ThemeConstants.height8,
            ),
            DropdownFormFieldWidget(
              isReadOnly: createProjectController.isAgentCreated.value &&
                      createProjectController.isUpdateMode.value
                  ? false
                  : createProjectController.isAgentCreated.value == false &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              false
                      ? false
                      : (createProjectController.isAgentCreated.value == true &&
                              createProjectController.isUpdateMode.value ==
                                  false &&
                              createProjectController
                                      .isSelectedBuilderProject.value ==
                                  true)
                          ? false
                          : true,
              isValidationAlways:
                  createProjectController.selectedCity.value != ''
                      ? true
                      : false,
              // isValidationAlways:
              //     createProjectController.isUpdateMode.value == true
              //         ? true
              //         : true,
              hintText: 'City',
              isRequired: createProjectController.isUpdateMode.value == true
                  ? false
                  : true,
              items:
                  createProjectController.cities.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item.citId,
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item.name!,
                        style:
                            createProjectController.isAgentCreated.value &&
                                    createProjectController.isUpdateMode.value
                                ? Styles.labelStyles
                                : createProjectController
                                                .isAgentCreated.value ==
                                            false &&
                                        createProjectController
                                                .isUpdateMode.value ==
                                            false &&
                                        createProjectController
                                                .isSelectedBuilderProject
                                                .value ==
                                            false
                                    ? Styles.labelStyles
                                    : (createProjectController
                                                    .isAgentCreated.value ==
                                                true &&
                                            createProjectController
                                                    .isUpdateMode.value ==
                                                false &&
                                            createProjectController
                                                    .isSelectedBuilderProject
                                                    .value ==
                                                true)
                                        ? Styles.labelStyles
                                        : Styles.greyLabelStyles1,
                      ),
                    ));
              }).toList(),
              selectedValue: createProjectController.selectedCity.value != ''
                  ? createProjectController.selectedCity.value
                  : null,
              onChange: (value) {
                print("city change: ${value}");
                createProjectController.selectedCity.value = value;
              },
            ),
          ],
        ));
  }

  buildPosessionDateField() {
    return Column(
      children: [
        Row(
          children: [
            Text('Possession Date', style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles),
          ],
        ),
        SizedBox(height: ThemeConstants.height4),
        DateTimeField(
          resetIcon: null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: createProjectController.isAgentCreated.value &&
                  createProjectController.isUpdateMode.value
              ? true
              : createProjectController.isAgentCreated.value == false &&
                      createProjectController.isUpdateMode.value == false &&
                      createProjectController.isSelectedBuilderProject.value ==
                          false
                  ? true
                  : (createProjectController.isAgentCreated.value == true &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              true)
                      ? true
                      : false,
          onChanged: (v) {
            print("posessionDate: $v");
            if (v != null) {
              createProjectController.posessionDate = v;
              createProjectController.possessionDateController.text =
                  DateFormat("MM/dd/yyyy").format(v);
            } else {
              createProjectController.possessionDateController.clear();
            }
          },
          style: Styles.inputStyle,
          decoration: InputDecoration(
            fillColor: ThemeConstants.whiteColor,
            filled: true,
            suffixIcon: Icon(Icons.calendar_today_sharp),
            hintText: "Posession Date",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.greyColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintStyle: Styles.hintStyles,
            contentPadding:
                EdgeInsets.only(left: ThemeConstants.width4, right: 9),
            isDense: true,
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.greyColor),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          format: DateFormat("MM/dd/yyyy"),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                locale: const Locale("en", "US"),
                initialEntryMode: DatePickerEntryMode.calendar,
                context: context,
                firstDate: DateTime(2000, 11, 11),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2050, 11, 11));
            if (date != null) {
              createProjectController.posessionDate =
                  date; // Ensure setting the selected date
              createProjectController.possessionDateController.text =
                  DateFormat("MM/dd/yyyy").format(date);
              return date;
            } else {
              return currentValue;
            }
          },
          controller: createProjectController.possessionDateController,
          validator: (value) {
            print('Validator called with value: $value');
            if (value == null) {
              print('Possession date is required');
              return 'Possession date is required';
            }
            return null;
          },
        )
      ],
    );
  }

  buildPosessionDateFieldWithoutValidation() {
    return Column(
      children: [
        Row(
          children: [
            Text('Possession Date', style: Styles.labelStyles),
            SizedBox(
              width: ThemeConstants.width2,
            ),
            Text('*', style: Styles.errorStyles),
          ],
        ),
        SizedBox(height: ThemeConstants.height4),
        DateTimeField(
          resetIcon: null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: createProjectController.isAgentCreated.value &&
                  createProjectController.isUpdateMode.value
              ? true
              : createProjectController.isAgentCreated.value == false &&
                      createProjectController.isUpdateMode.value == false &&
                      createProjectController.isSelectedBuilderProject.value ==
                          false
                  ? true
                  : (createProjectController.isAgentCreated.value == true &&
                          createProjectController.isUpdateMode.value == false &&
                          createProjectController
                                  .isSelectedBuilderProject.value ==
                              true)
                      ? true
                      : false,
          onChanged: (v) {
            print("posessionDate: $v");
            if (v != null) {
              createProjectController.posessionDate = v;
              createProjectController.possessionDateController.text =
                  DateFormat("MM/dd/yyyy").format(v);
            } else {
              createProjectController.possessionDateController.clear();
            }
          },
          style: Styles.inputStyle,
          decoration: InputDecoration(
            fillColor: ThemeConstants.whiteColor,
            filled: true,
            suffixIcon: Icon(Icons.calendar_today_sharp),
            hintText: "Posession Date",
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.greyColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.primaryColor),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            hintStyle: Styles.hintStyles,
            contentPadding:
                EdgeInsets.only(left: ThemeConstants.width4, right: 9),
            isDense: true,
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ThemeConstants.greyColor),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          format: DateFormat("MM/dd/yyyy"),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                locale: const Locale("en", "US"),
                initialEntryMode: DatePickerEntryMode.calendar,
                context: context,
                firstDate: DateTime(2000, 11, 11),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2050, 11, 11));
            if (date != null) {
              createProjectController.posessionDate =
                  date; // Ensure setting the selected date
              createProjectController.possessionDateController.text =
                  DateFormat("MM/dd/yyyy").format(date);
              return date;
            } else {
              return currentValue;
            }
          },
          controller: createProjectController.possessionDateController,
        )
      ],
    );
  }
}

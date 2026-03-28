import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/widgets/dropdown_formfield_widget.dart';
import 'package:brickbuddy/commons/widgets/mobile_number_widget.dart';
import 'package:brickbuddy/commons/widgets/rounded_filled_button.dart';
import 'package:brickbuddy/commons/widgets/text_box_widget.dart';
import 'package:brickbuddy/components/create_builder/create_builder_controller.dart';
import 'package:brickbuddy/components/projects/create_project_component.dart';
import 'package:brickbuddy/components/projects/create_project_controller.dart';
import 'package:brickbuddy/constants/app_constants.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/city.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:brickbuddy/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class CreateBuilderComponent extends StatelessWidget {
  CreateBuilderController createBuilderController =
      Get.put(CreateBuilderController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.delete<CreateProjectController>(force: true);
          Get.to(CreateProject());
          return false;
        },
        child: Scaffold(
            backgroundColor: Color.fromRGBO(246, 246, 246, 1),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: ThemeConstants.primaryColor,
              title: Text(
                'Builder Details',
                style: TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: ThemeConstants.whiteColor),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: WillPopScope(
              onWillPop: () async {
                Get.toNamed(Routes.projects);
                return false;
              },
              child: Obx(() => LoadingOverlay(
                    color: Colors.black54,
                    opacity: 1,
                    progressIndicator: const SpinKitCircle(
                      color: ThemeConstants.whiteColor,
                      size: 50.0,
                    ),
                    isLoading: createBuilderController.isLoading.value,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ThemeConstants.screenPadding),
                        child: Form(
                          //  autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: createBuilderController.builderFormkey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: ThemeConstants.height20,
                                ),
                                Row(
                                  children: [
                                    buidRegisteredName(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buidDisplayName()
                                  ],
                                ),
                                SizedBox(
                                  height: ThemeConstants.height10,
                                ),
                                buildRegisteredOfficeAddress(),
                                SizedBox(
                                  height: ThemeConstants.height20,
                                ),
                                Row(
                                  children: [
                                    buildOfficePrimaryContact(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildOfficeSecondaryContact(),
                                  ],
                                ),
                                SizedBox(
                                  height: ThemeConstants.height20,
                                ),
                                Row(
                                  children: [
                                    buildFounder(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildFounderFBUrl()
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.width10),
                                Row(
                                  children: [
                                    buildFounderTwitterUrl(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildFounderLinkedInUrl(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),
                                buildFounderInstagramUrl(),
                                SizedBox(height: ThemeConstants.height10),
                                Row(
                                  children: [
                                    buildFounderDetails(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildFounderContactInfo(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),
                                buildCompanyWebsite(),
                                SizedBox(height: ThemeConstants.height10),
                                buildRegistrationType(),
                                SizedBox(height: ThemeConstants.height10),
                                buildEstablishedYear(),
                                SizedBox(height: ThemeConstants.height10),
                                Row(
                                  children: [
                                    buildHeadOffice(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildBranchOffice()
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),
                                Row(
                                  children: [
                                    buildDealsInPropertyType(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),
                                Row(
                                  children: [
                                    buildCountry(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildStates()
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height10),
                                buildOperatingCities(),
                                SizedBox(height: ThemeConstants.height10),
                                buidBuilderOverview(),
                                SizedBox(height: ThemeConstants.height10),
                                Row(
                                  children: [
                                    buidExperience(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buidMissionAndValues(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height20),
                                buildReasonToChooseBuilder(),
                                SizedBox(height: ThemeConstants.height20),
                                buildSalesTeam(),
                                SizedBox(height: ThemeConstants.height20),
                                Row(
                                  children: [
                                    buildCompanyFbUrl(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildCompanyTwitterUrl(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height20),
                                Row(
                                  children: [
                                    buildCompanyLinkedInUrl(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildCompanyInstagramUrl(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height20),
                                Row(
                                  children: [
                                    buildAffiliation(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildReviews(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height20),
                                buildBuilderRegistrationNumber(),
                                SizedBox(height: ThemeConstants.height20),
                                Row(
                                  children: [
                                    buildOperationgHours(),
                                    SizedBox(
                                      width: ThemeConstants.width10,
                                    ),
                                    buildReraId(),
                                  ],
                                ),
                                SizedBox(height: ThemeConstants.height20),
                                RoundedFilledButtonWidget(
                                  buttonName: "Save",
                                  onPressed: () {
                                    if (createBuilderController
                                        .builderFormkey.currentState!
                                        .validate()) {
                                      createBuilderController.createBuilder();
                                    }
                                  },
                                ),
                                SizedBox(height: ThemeConstants.height20),
                              ]),
                        ),
                      ),
                    ),
                  )),
            )));
  }

  Expanded buildFounder() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Founder', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            hintText: 'Founder ',
            controller: createBuilderController.founderController,
            isRequired: false,
            label: "Founder",
          )
        ],
      ),
    );
  }

  Expanded buildFounderFBUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Founder Facebook Url', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            hintText: 'Founder Facebook Url ',
            controller: createBuilderController.founderFBUrlController,
            isRequired: false,
            label: "Founder Facebook Url",
          )
        ],
      ),
    );
  }

  Expanded buildFounderTwitterUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Founder Twitter Url', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            hintText: 'Founder Twitter Url ',
            controller: createBuilderController.founderTwitterUrl,
            isRequired: false,
            label: "Founder Twitter Url",
          )
        ],
      ),
    );
  }

  Expanded buildFounderLinkedInUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Founder LinkedIn Url', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            hintText: 'Founder LinkedIn Url ',
            controller: createBuilderController.founderLinkedInController,
            isRequired: false,
            label: "Founder LinkedIn Url",
          )
        ],
      ),
    );
  }

  buildFounderInstagramUrl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Founder Instagram Url', style: Styles.labelStyles),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
          hintText: 'Founder Instagram Url ',
          controller: createBuilderController.founderInstagramUrlController,
          isRequired: false,
          label: "Founder Instagram Url",
        )
      ],
    );
  }

  Expanded buildFounderDetails() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Founder Details Url', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          TextBoxWidget(
            hintText: 'Founder Details Url ',
            controller: createBuilderController.founderDetailsController,
            isRequired: false,
            label: "Founder Details Url",
          )
        ],
      ),
    );
  }

  buildRegisteredOfficeAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(' Registered Office Address', style: Styles.labelStyles),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            hintText: 'Registered Office Address',
            controller:
                createBuilderController.registeredOfficeAddressController,
            isRequired: false,
            label: "Registered Office Address")
      ],
    );
  }

  Expanded buildFounderContactInfo() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Founder Contact Info', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          MobileNumberWidget(
              controller: createBuilderController.founderContactInfoController,
              hintText: 'Founder Contact Info',
              isRequired: false)
        ],
      ),
    );
  }

  buildCompanyWebsite() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company Website', style: Styles.labelStyles),
        SizedBox(height: ThemeConstants.width8),
        TextBoxWidget(
            hintText: 'Company Website',
            controller: createBuilderController.companyWebsiteController,
            isRequired: false,
            label: 'Company Website')
      ],
    );
  }

  Expanded buildOfficePrimaryContact() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Office Primary Contact', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(height: ThemeConstants.width8),
          MobileNumberWidget(
            hintText: 'Office Primary Contact',
            controller: createBuilderController.officePrimaryContactController,
            isRequired: true,
          )
        ],
      ),
    );
  }

  Expanded buildOfficeSecondaryContact() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Office Secondary Contact', style: Styles.labelStyles),
          SizedBox(height: ThemeConstants.width8),
          MobileNumberWidget(
            hintText: 'Office Secondary Contact',
            controller:
                createBuilderController.officeSecondaryContactController,
            isRequired: false,
          )
        ],
      ),
    );
  }

  Expanded buidRegisteredName() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Registered Name', style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Registered Name',
              controller: createBuilderController.registeredNameController,
              isRequired: true,
              label: "Registered Name")
        ],
      ),
    );
  }

  Expanded buidDisplayName() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Display Name', // Heading text
                  style: Styles.labelStyles),
              SizedBox(
                width: ThemeConstants.width2,
              ),
              Text('*', style: Styles.errorStyles)
            ],
          ),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Display Name',
              controller: createBuilderController.displayNameController,
              isRequired: true,
              label: "Display Name")
        ],
      ),
    );
  }

  Expanded buildHeadOffice() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Head Office Address', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Head Office Address',
              controller: createBuilderController.headOfficeAddressController,
              isRequired: false,
              label: "Head Office Address")
        ],
      ),
    );
  }

  Expanded buildBranchOffice() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Branch Office Address', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Branch Office Address',
              controller: createBuilderController.branchOfficeAddressController,
              isRequired: false,
              label: "Branch Office Address")
        ],
      ),
    );
  }

  Expanded buidExperience() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Experience (in years)', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Experience',
              controller: createBuilderController.experienceController,
              isRequired: false,
              label: "Experience")
        ],
      ),
    );
  }

  buidBuilderOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Builder Overview', style: Styles.labelStyles),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        TextBoxWidget(
            hintText: 'Builder Overview',
            controller: createBuilderController.buiderOverviewController,
            isRequired: false,
            label: "Builder Overview")
      ],
    );
  }

  Expanded buidMissionAndValues() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mission And Values', // Heading text
              style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Mission And Values',
              controller: createBuilderController.missionAndValuesController,
              isRequired: false,
              label: "Mission And Values")
        ],
      ),
    );
  }

  buildReasonToChooseBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reason to Choose the Builder', style: Styles.labelStyles),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        TextBoxWidget(
            hintText: 'Reason to Choose the Builder',
            controller:
                createBuilderController.reasonToChooseTheBuilderController,
            isRequired: false,
            label: "Reason to Choose the Builder")
      ],
    );
  }

  buildSalesTeam() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sales Team (Name, Number & email)', // Heading text
            style: Styles.labelStyles),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        TextBoxWidget(
            hintText: 'Sales Team',
            controller: createBuilderController.saleTeamController,
            isRequired: false,
            label: "Sales Team")
      ],
    );
  }

  Expanded buildCompanyTwitterUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company Twitter Url', // Heading text
              style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Company Twitter Url',
              controller: createBuilderController.companyTwitterUrlController,
              isRequired: false,
              label: "Company Twitter Url")
        ],
      ),
    );
  }

  buildCompanyFbUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company Facebook Url', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Company Facebook Url',
              controller: createBuilderController.companyFacebookUrlController,
              isRequired: false,
              label: "Company Facebook Url")
        ],
      ),
    );
  }

  Expanded buildCompanyLinkedInUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company LinkedIn Url', // Heading text
              style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Company LinkedIn Url',
              controller: createBuilderController.companyLinkedInController,
              isRequired: false,
              label: "Company LinkedIn Url")
        ],
      ),
    );
  }

  Expanded buildCompanyInstagramUrl() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Company Instagram Url', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Company Instagram Url',
              controller: createBuilderController.companyInstagramController,
              isRequired: false,
              label: "Company Instagram Url")
        ],
      ),
    );
  }

  Expanded buildAffiliation() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Affiliations', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Affiliations',
              controller: createBuilderController.afiliationsControlleer,
              isRequired: false,
              label: "Affiliations")
        ],
      ),
    );
  }

  buildBuilderRegistrationNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Builder Registration Number', style: Styles.labelStyles),
        SizedBox(
          height: ThemeConstants.height10,
        ),
        TextBoxWidget(
            hintText: 'Builder Registration Number',
            controller: createBuilderController.builderRegistrationNumber,
            isRequired: false,
            label: "Builder Registration Number")
      ],
    );
  }

  Expanded buildReviews() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviews', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Reviews',
              controller: createBuilderController.reviewsController,
              isRequired: false,
              label: "Reviews")
        ],
      ),
    );
  }

  Expanded buildOperationgHours() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Operating Hours', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Operating Hours',
              controller: createBuilderController.operatingHoursController,
              isRequired: false,
              label: "Operating Hours")
        ],
      ),
    );
  }

  buildReraId() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rera Id', style: Styles.labelStyles),
          SizedBox(
            height: ThemeConstants.height10,
          ),
          TextBoxWidget(
              hintText: 'Rera Id',
              controller: createBuilderController.reraIdController,
              isRequired: false,
              label: "Rera Id")
        ],
      ),
    );
  }

  buildRegistrationType() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Company Registration Type",
              style: Styles.labelStyles,
            ),
            SizedBox(
              height: ThemeConstants.height8,
            ),
            DropdownFormFieldWidget(
              isValidationAlways: true,
              hintText: 'Company Registration Type',
              isRequired: false,
              items:
                  AppConstants.registrationTypes.map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"],
                        style: Styles.labelStyles,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createBuilderController.selectedRegistrationType.value != ''
                      ? createBuilderController.selectedRegistrationType.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createBuilderController.selectedRegistrationType.value =
                    value.toString();
              },
            ),
          ],
        ));
  }

  buildDealsInPropertyType() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Deal in Property Type",
            style: Styles.labelStyles,
          ),
          SizedBox(
            height: ThemeConstants.height8,
          ),
          DropdownFormFieldWidget(
            isValidationAlways: true,
            hintText: 'Deal in Property Type',
            isRequired: false,
            items: AppConstants.propertyTypes.map<DropdownMenuItem>((item) {
              return DropdownMenuItem(
                  value: item["value"],
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Text(
                      item["label"],
                      style: Styles.labelStyles,
                    ),
                  ));
            }).toList(),
            selectedValue: createBuilderController.selectedDealType.value != ''
                ? createBuilderController.selectedDealType.value
                : null,
            onChange: (value) {
              print("onChange : $value");
              createBuilderController.selectedDealType.value = value.toString();
            },
          ),
        ],
      ),
    );
  }

  buildOperatingCities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Operating Cities",
          style: Styles.labelStyles,
        ),
        SizedBox(
          height: ThemeConstants.height8,
        ),
        Obx(() => createBuilderController.cities.isNotEmpty
            ? MultiSelectDialogField(
                items: createBuilderController.cities
                    .map((f) => MultiSelectItem<City>(f, f.name!))
                    .toList(),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Please select cities";
                  }
                  return null;
                },
                title: Text("Select"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: ThemeConstants.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: ThemeConstants.greyColor,
                    width: 2,
                  ),
                ),
                buttonIcon: LineIcon(Icons.arrow_drop_down),
                buttonText: Text("Select", style: Styles.label1Styles),
                onConfirm: (results) {
                  print("results: $results");
                  createBuilderController.operatingCities.addAll(results);
                },
              )
            : SizedBox.shrink()),
      ],
    );
  }

  buildEstablishedYear() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Established Year",
              style: Styles.labelStyles,
            ),
            SizedBox(
              height: ThemeConstants.height8,
            ),
            DropdownFormFieldWidget(
              isValidationAlways: true,
              hintText: 'Established Year',
              isRequired: false,
              items: CommonService.instance.establishedYears
                  .map<DropdownMenuItem>((item) {
                return DropdownMenuItem(
                    value: item["value"],
                    child: Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        item["label"],
                        style: Styles.labelStyles,
                      ),
                    ));
              }).toList(),
              selectedValue:
                  createBuilderController.selectedEstablishedYear.value != ''
                      ? createBuilderController.selectedEstablishedYear.value
                      : null,
              onChange: (value) {
                print("onChange : $value");
                createBuilderController.selectedEstablishedYear.value =
                    value.toString();
              },
            ),
          ],
        ));
  }

  buildCountry() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Country",
            style: Styles.labelStyles,
          ),
          SizedBox(
            height: ThemeConstants.height8,
          ),
          DropdownFormFieldWidget(
            isValidationAlways: true,
            hintText: 'Country',
            isRequired: false,
            items:
                createBuilderController.countries.map<DropdownMenuItem>((item) {
              return DropdownMenuItem(
                  value: item.cntId,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Text(
                      item.name.toString(),
                      style: Styles.labelStyles,
                    ),
                  ));
            }).toList(),
            selectedValue: createBuilderController.selectedCountry.value != ''
                ? createBuilderController.selectedCountry.value
                : null,
            onChange: (value) {
              print("onChange : $value");
              createBuilderController.selectedCountry.value = value.toString();
              createBuilderController.getStatesByCountryId(value.toString());
            },
          ),
        ],
      ),
    );
  }

  buildStates() {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "State",
            style: Styles.labelStyles,
          ),
          SizedBox(
            height: ThemeConstants.height8,
          ),
          DropdownFormFieldWidget(
            isValidationAlways: true,
            hintText: 'State',
            isRequired: false,
            items: createBuilderController.statesList
                .map<DropdownMenuItem>((item) {
              return DropdownMenuItem(
                  value: item.sttId,
                  child: Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Text(item.name!, style: Styles.labelStyles),
                  ));
            }).toList(),
            selectedValue: createBuilderController.selectedState.value != ''
                ? createBuilderController.selectedState.value
                : null,
            onChange: (value) {
              print("states change: ${value}");
              createBuilderController.selectedState.value = value;
              createBuilderController.getCitiesByStateId(value);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/components/home/home_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/city.dart';
import 'package:brickbuddy/model/country.dart';
import 'package:brickbuddy/model/create_builder.dart';
import 'package:brickbuddy/model/state.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateBuilderController extends GetxController {
  RxBool isLoading = false.obs;
  final builderFormkey = GlobalKey<FormState>();

  TextEditingController registeredNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController registeredOfficeAddressController =
      TextEditingController();
  TextEditingController officePrimaryContactController =
      TextEditingController();
  TextEditingController officeSecondaryContactController =
      TextEditingController();

  TextEditingController founderController = TextEditingController();
  TextEditingController founderFBUrlController = TextEditingController();
  TextEditingController founderTwitterUrl = TextEditingController();
  TextEditingController founderLinkedInController = TextEditingController();
  TextEditingController founderInstagramUrlController = TextEditingController();
  TextEditingController founderDetailsController = TextEditingController();
  TextEditingController founderContactInfoController = TextEditingController();
  TextEditingController companyWebsiteController = TextEditingController();

  RxString selectedRegistrationType = "".obs;
  RxString selectedEstablishedYear = "".obs;
  RxString selectedDealType = "".obs;
  List<City> operatingCities = <City>[].obs;

  TextEditingController headOfficeAddressController = TextEditingController();
  TextEditingController branchOfficeAddressController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

  TextEditingController buiderOverviewController = TextEditingController();
  TextEditingController missionAndValuesController = TextEditingController();
  TextEditingController reasonToChooseTheBuilderController =
      TextEditingController();
  TextEditingController saleTeamController = TextEditingController();

  TextEditingController companyFacebookUrlController = TextEditingController();

  TextEditingController companyTwitterUrlController = TextEditingController();

  TextEditingController companyLinkedInController = TextEditingController();

  TextEditingController companyInstagramController = TextEditingController();

  TextEditingController afiliationsControlleer = TextEditingController();

  TextEditingController builderRegistrationNumber = TextEditingController();

  TextEditingController reviewsController = TextEditingController();
  TextEditingController operatingHoursController = TextEditingController();
  TextEditingController reraIdController = TextEditingController();

  RxList<Country> countries = <Country>[].obs;
  RxString selectedCountry = "".obs;
  RxString selectedState = "".obs;
  RxList<ProjectState> statesList = <ProjectState>[].obs;

  ProjectsService projectsService = Get.find();

  RxList<City> cities = <City>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getCountries();
    super.onInit();
  }

  getCountries() {
    countries.clear();
    projectsService.getCountries().then((coutriesRes) {
      print("getCountries res: $coutriesRes");
      coutriesRes["data"].forEach((c) {
        if (c["status"] == 1) {
          Country country = Country();
          country.cntId = c["cntId"];
          country.dateCreated = c["dateCreated"];
          country.name = c["name"];
          country.status = c["status"];
          countries.add(country);
        }
      });
      print("countries length: ${countries.length}");
    }).catchError((error) {
      print("Error while fetching getCountries: $error");
    });
  }

  createBuilder() {
    isLoading.value = true;
    CreateBuilder createBuilder = CreateBuilder();
    BuilderDetails builderDetails = BuilderDetails();
    builderDetails.registeredName = registeredNameController.text;
    builderDetails.displayName = displayNameController.text;
    builderDetails.ofcPrimaryContactNo = officePrimaryContactController.text;

    builderDetails.registeredOfcAddress =
        registeredOfficeAddressController.text;
    builderDetails.ofcSecondaryContactNo =
        officeSecondaryContactController.text;
    builderDetails.founder = founderController.text;
    builderDetails.founderFbUrl = founderFBUrlController.text;
    builderDetails.founderTwitterUrl = founderTwitterUrl.text;
    builderDetails.founderLinkedinUrl = founderLinkedInController.text;
    builderDetails.founderIgUrl = founderInstagramUrlController.text;
    builderDetails.founderDetails = founderDetailsController.text;
    builderDetails.founderContactInfo = founderContactInfoController.text;
    builderDetails.companyWebsite = companyWebsiteController.text;
    builderDetails.companyRegistrationType = selectedRegistrationType.value;
    builderDetails.establishedYear = selectedEstablishedYear.value;
    builderDetails.headOfcAddress = headOfficeAddressController.text;
    builderDetails.branchOfcAddress = branchOfficeAddressController.text;
    builderDetails.propertyTypeDeals = selectedDealType.value;
    builderDetails.country = selectedCountry.value;
    builderDetails.state = selectedState.value;
    List<String> selectedCities = [];
    print("operatingCities cities: ${operatingCities}");

    for (var c in operatingCities) {
      selectedCities.add(c.citId!);
    }

    print("selected cities: ${selectedCities}");

    builderDetails.operatingCities = [];
    builderDetails.operatingCities!.addAll(selectedCities);

    print("Operating Cities: ${builderDetails.operatingCities}");

    builderDetails.experience = experienceController.text;
    builderDetails.builderOverview = buiderOverviewController.text;
    builderDetails.missionAndValues = missionAndValuesController.text;
    builderDetails.reasonToChoose = reasonToChooseTheBuilderController.text;
    builderDetails.salesTeam = saleTeamController.text;
    builderDetails.companyFbUrl = companyFacebookUrlController.text;
    builderDetails.companyTwitterUrl = companyTwitterUrlController.text;
    builderDetails.companyLinkedinUrl = companyLinkedInController.text;
    builderDetails.companyIgUrl = companyInstagramController.text;
    builderDetails.affiliations = afiliationsControlleer.text;

    ///builderDetails.review =
    builderDetails.builderRegistrationNo = builderRegistrationNumber.text;
    builderDetails.operatingHours = operatingHoursController.text;
    builderDetails.reraId = reraIdController.text;

    createBuilder.builderDetails = builderDetails;

    print("create Builde tojson: ${createBuilder.toJson()}");

    projectsService.createBuilder(createBuilder).then((res) {
      isLoading.value = false;
      print("createBuilder res: $res");
      Get.rawSnackbar(
          message: res["message"],
          backgroundColor: ThemeConstants.successColor);
      CommonService.instance.selectedIndex.value = 0;
      Get.delete<HomeController>();
      Get.toNamed(Routes.homeScreen);
    }).catchError((err) {
      isLoading.value = false;
      Get.rawSnackbar(message: "Something went wrong");
      print("createBuilder err: $err");
    });
  }

  getStatesByCountryId(countryId) {
    statesList.clear();
    selectedState.value = '';
    projectsService.getStatesByCountryId(countryId).then((statesRes) {
      print("states res: $statesRes");
      statesRes["data"].forEach((s) {
        ProjectState state = ProjectState();
        state.name = s['name'];
        state.sttId = s["sttId"];
        statesList.add(state);
      });
    }).catchError((error) {
      print("Error while fetching getStatesByCountryId: $error");
    });
  }

  getCitiesByStateId(stateId) {
    cities.clear();
    projectsService
        .getCitiesByStateId(selectedCountry.value, stateId)
        .then((citiesRes) {
      print("citiesRes res: $citiesRes");
      citiesRes["data"].forEach((city) {
        City c = City();
        c.citId = city["citId"];
        c.name = city["name"];
        cities.add(c);
      });
    }).catchError((error) {
      print("Error while fetching getCitiesByStateId: $error");
    });
  }
}

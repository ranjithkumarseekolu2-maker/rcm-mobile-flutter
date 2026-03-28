import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:brickbuddy/commons/services/common_service.dart';
import 'package:brickbuddy/commons/services/projects_service.dart';
import 'package:brickbuddy/commons/utils/date_util.dart';
import 'package:brickbuddy/commons/utils/http_util.dart';
import 'package:brickbuddy/commons/widgets/cupertino_dialog_widget.dart';
import 'package:brickbuddy/components/project_documents/project_documents_controller.dart';
import 'package:brickbuddy/components/projects/projects_controller.dart';
import 'package:brickbuddy/constants/theme_constants.dart';
import 'package:brickbuddy/model/city.dart';
import 'package:brickbuddy/model/country.dart';
import 'package:brickbuddy/model/createProject.dart';
import 'package:brickbuddy/model/place.dart';
import 'package:brickbuddy/model/place_search.dart';
import 'package:brickbuddy/model/state.dart';
import 'package:brickbuddy/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "AIzaSyBLDp2eDCSwnHoC1Hei4h9Zb_qRgEC_Gjc";

class CreateProjectController extends GetxController {
  RxBool isDetailsLoading = false.obs;
  ProjectsService projectService = Get.find();
  RxList<dynamic> builders = <dynamic>[].obs;
  RxList<dynamic> projects = <dynamic>[].obs;

  TextEditingController builderController = TextEditingController();
  TextEditingController projectController = TextEditingController();

  TextEditingController projectNameController = TextEditingController();
  TextEditingController facingController = TextEditingController();
  TextEditingController plotAreaController = TextEditingController();
  TextEditingController carpetAreaController = TextEditingController();
  TextEditingController plotPriceController = TextEditingController();
  TextEditingController floorDetailsController = TextEditingController();
  TextEditingController totalProjectAreaController = TextEditingController();
  TextEditingController totalNoOfUnitsController = TextEditingController();
  TextEditingController builtUpAreaontroller = TextEditingController();
  TextEditingController minBuiltUpAreaontroller = TextEditingController();
  TextEditingController maxBuiltUpAreaontroller = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController aboutProjectController = TextEditingController();
  TextEditingController aboutLocationController = TextEditingController();
  TextEditingController locationAdvantageController = TextEditingController();
  TextEditingController totalNoOfTowersController = TextEditingController();
  TextEditingController configurationController = TextEditingController();
  TextEditingController dimensionsController = TextEditingController();
  TextEditingController possessionDateController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController pocController = TextEditingController();
  TextEditingController mobileNmberController = TextEditingController();
  TextEditingController propertyAgeController = TextEditingController();
  TextEditingController boundaryWallPresentController = TextEditingController();
  TextEditingController noOfOpenSidesController = TextEditingController();
  TextEditingController widthOffacingRoadController = TextEditingController();
  TextEditingController floorsAllowedForConstructionController =
      TextEditingController();
  TextEditingController cornerPlotController = TextEditingController();
  TextEditingController furnishingStatusController = TextEditingController();
  TextEditingController rentController = TextEditingController();
  TextEditingController totalNoOfFloorsController = TextEditingController();

  final Completer<GoogleMapController> mapController = Completer();
  var showAdditionalInfo = false.obs;
  RxList<Marker> myMarker = <Marker>[].obs;
  RxDouble latitude = 00.0000.obs;
  RxDouble longitude = 00.0000.obs;
  RxList<PlaceSearch> searchResults = <PlaceSearch>[].obs;
  RxString address = 'fetching current location..'.obs;
  TextEditingController searchtermController = TextEditingController();

  RxList<Country> countries = <Country>[].obs;
  RxList<ProjectState> statesList = <ProjectState>[].obs;
  RxList<City> cities = <City>[].obs;

  RxList<Amenities> allAmenitiesList = <Amenities>[].obs;
  RxList<Amenities> allSpecalitiesList = <Amenities>[].obs;

  RxList<Feature> amenityFeatureList = <Feature>[].obs;
  RxList<Feature> specalityFeatureList = <Feature>[].obs;

  RxList<dynamic> specalitiesList = <dynamic>[].obs;

  RxString selectedCountry = ''.obs;
  RxString selectedState = ''.obs;
  RxString selectedCity = ''.obs;

  RxString selectedAmenity = ''.obs;
  Rx<Feature> selectedAmenityFeature = Feature().obs;

  RxString selectedSpecificationName = ''.obs;
  Rx<Feature> selectedSpecificationFeature = Feature().obs;

  RxList<String> landMarksList = <String>[].obs;
  RxList<RegulatoryAspects> regulatoryAspectsList = <RegulatoryAspects>[].obs;

  RxList<Amenities> amenitiesList = <Amenities>[].obs;
  RxList<Specifications> specificationsList = <Specifications>[].obs;

  TextEditingController landMarkNameController = TextEditingController();
  TextEditingController regulatoryNameController = TextEditingController();
  TextEditingController regulatoryIdController = TextEditingController();

  Amenities amenity = Amenities();
  Specifications specification = Specifications();

  RxString projectId = ''.obs;
  RxString builderId = ''.obs;
  String marketingAgencyId = '';
  String agentId = '';
  var projectDetailsRes;
  DateTime posessionDate = DateTime.now();
  RxBool isSelectedBuilderProject = false.obs;
  final projectFormKey = GlobalKey<FormState>();

  RxList<BuilderData> builderDataList = <BuilderData>[].obs;

  RxString selectedProjectType = ''.obs;
  RxString selectedPossesionSttus = ''.obs;
  RxString selectedTransactionType = ''.obs;
  RxString anyConstructionDone = ''.obs;
  RxString boundaryWallPresent = ''.obs;

  RxString furnishingStatus = ''.obs;

  final regulatoryFormKey = GlobalKey<FormState>();
  final amenitiesFormKey = GlobalKey<FormState>();
  final specificationsFormKey = GlobalKey<FormState>();
  final landMarkFormKey = GlobalKey<FormState>();

  RxBool isUpdateMode = false.obs;
  RxBool isAgentCreated = false.obs;
  RxString projectID = "".obs;
  RxBool isCreateNewProj = false.obs;

  @override
  void onInit() {
    super.onInit();
    builders.clear();
    builders.addAll(CommonService.instance.builders);
    print('builders.... $builders');

    getCountries();
    getAllAmenities();
    if (Get.arguments != null) {
      print("projectId edit mode: ${Get.arguments["projectId"]}");
      isUpdateMode.value = true;

      projectID.value = Get.arguments["projectId"];
      getDetailsByProjectId(Get.arguments["projectId"]);
    } else {
      isCreateNewProj.value = true;
      isAgentCreated.value = false;
      // isUpdateMode.value = false;
    }
  }

  getProjectsByBuilderId(builderId) {
    projectService.getProjectsByBuilderId(builderId).then((buildersRes) {
      print("projects res: $buildersRes");
      buildersRes["data"]["projects"].forEach((element) {
        if (element['status'] == 1) {
          projects.add(element);
        }
      });
      //   projects.addAll(buildersRes["data"]["projects"]);
    }).catchError((error) {
      print("Error while fetching getProjectsByBuilderId: $error");
    });
  }

  getDetailsByProjectId(projectId) {
    isDetailsLoading.value = true;
    clearData();
    projectService.getDetailsByProjectId(projectId).then((detailsRes) {
      print("getDetailsByProjectId res: $detailsRes");
      print('poc12456 ${detailsRes["data"]["furnishingStatus"]}');
      builderId.value = detailsRes["data"]["builderId"];
      print('poc0010 ${CommonService.instance.mobileNumber.value}');
      print("getDetailsByProjectId res123: ${detailsRes["data"]["createdBy"]}");
      print(
          "getDetailsByProjectId res123: ${CommonService.instance.agentId.value}");
      isSelectedBuilderProject.value = true;
      print(
          "isSelectedBuilderProject res123: ${isSelectedBuilderProject.value}");
      if (isUpdateMode.value == true) {
        bindBuilder(detailsRes["data"]["builderId"]);
      }
      if (detailsRes["data"]['createdBy'] ==
          CommonService.instance.agentId.value) {
        isAgentCreated.value = true;
        print('value123 ${isAgentCreated.value}');
      }
      // print('sssss');
      print('dddddd0123 ${detailsRes["data"]["projectType"]}');
      // print('kkkkk ${detailsRes["data"]["marketingAgencyId"]}');
      agentId = detailsRes["data"]["agentId"] != null
          ? detailsRes["data"]["agentId"]
          : '';
      marketingAgencyId = detailsRes["data"]["marketingAgencyId"] != null
          ? detailsRes["data"]["marketingAgencyId"]
          : '';
      print('dddddd ${detailsRes["data"]["boundaryWallPresent"]}');
      projectDetailsRes = detailsRes["data"];
      plotAreaController.text = detailsRes["data"]["totalPlotArea"] ?? '';
      plotPriceController.text = detailsRes["data"]["plotPrice"] ?? '';
      boundaryWallPresent.value =
          detailsRes["data"]["boundaryWallPresent"] ?? '';
      boundaryWallPresentController.text =
          detailsRes["data"]["boundaryWallPresent"] ?? '';
      rentController.text = detailsRes["data"]["expectedRentValue"] ?? '';
      dimensionsController.text = detailsRes["data"]["dimensions"] ?? '';

      noOfOpenSidesController.text = detailsRes["data"]["noOfOpenSides"] ?? '';
      floorsAllowedForConstructionController.text =
          detailsRes["data"]["floorsAllowedForConstruction"] ?? '';
      widthOffacingRoadController.text =
          detailsRes["data"]["facingRoadWidth"] ?? '';
      carpetAreaController.text = detailsRes["data"]["carpetArea"] ?? '';
      totalNoOfFloorsController.text =
          detailsRes["data"]["totNoOfFloors"] ?? '';
      propertyAgeController.text = detailsRes["data"]["propertyAge"] ?? '';
      floorDetailsController.text = detailsRes["data"]["floorDetails"] ?? '';
      furnishingStatus.value = detailsRes["data"]["furnishingStatus"] ?? '';
      furnishingStatusController.text =
          detailsRes["data"]["furnishingStatus"] ?? '';
      anyConstructionDone.value =
          detailsRes["data"]["anyConstructionDone"] ?? '';
      selectedTransactionType.value =
          detailsRes["data"]["transactionType"] ?? '';
      facingController.text = detailsRes["data"]["facing"] ?? '';
      selectedPossesionSttus.value =
          detailsRes["data"]["constructionStatus"] ?? '';

      projectNameController.text = detailsRes["data"]["projectName"] ?? '';
      aboutProjectController.text = detailsRes["data"]["aboutProject"] ?? '';
      aboutLocationController.text = detailsRes['data']['aboutLocation'] ?? '';
      selectedProjectType.value = detailsRes["data"]["projectType"] ?? '';
      totalProjectAreaController.text =
          detailsRes["data"]["totalProjectArea"] ?? '';
      totalNoOfUnitsController.text = detailsRes["data"]["totNoOfUnits"] ?? '';
      builtUpAreaontroller.text = detailsRes["data"]["builtUpArea"] ?? '';
      minPriceController.text = detailsRes["data"]["minPrice"] ?? '';
      maxPriceController.text = detailsRes["data"]["maxPrice"] ?? '';

      selectedCountry.value = detailsRes["data"]["country"] ?? '';
      totalNoOfTowersController.text =
          detailsRes["data"]["totNoOfTowers"] ?? '';
      configurationController.text = detailsRes["data"]["configuration"] ?? '';
      print('qqqqqqq');
      if (detailsRes["data"]["state"] != '') {
        bindState(detailsRes["data"]["state"], detailsRes["data"]["city"]);
      }
      locationAdvantageController.text =
          detailsRes["data"]["locationAdvantage"];
      latitude.value = detailsRes["data"]["location"][0];
      longitude.value = detailsRes["data"]["location"][1];
      searchtermController.text = detailsRes["data"]["address"];
      print('agentId01... ${CommonService.instance.agentId.value}');
      print(
          'agentId12... ${detailsRes["data"]["createdBy"]},${detailsRes["data"]["pointOfContact"]}');
      // if (CommonService.instance.agentId.value !=
      //         detailsRes["data"]["createdBy"] &&
      //     CommonService.instance.agentId.value !=
      //         detailsRes["data"]["projectId"]) {
      //   pocController.text = detailsRes["data"]["pointOfContact"];
      // } else {
      print('poc12345 ${CommonService.instance.mobileNumber.value}');
      print('poc5678 ${detailsRes["data"]["pointOfContact"]}');
      // if (CommonService.instance.mobileNumber.value !=
      //     detailsRes["data"]["pointOfContact"]) {
      if (isUpdateMode.value == true) {
        pocController.text = detailsRes["data"]["pointOfContact"];
      } else {
        pocController.text = CommonService.instance.mobileNumber.value;
      }
      //} //detailsRes["data"]["pointOfContact"];
      gstController.text = detailsRes["data"]["gstApplicable"];
      if (detailsRes["data"]["landmark"] != null) {
        detailsRes["data"]["landmark"].forEach((l) {
          landMarksList.add(l);
        });
        landMarksList.removeWhere((element) => element.isEmpty);
      }
      print(
          'pdddd......... ${DateTimeUtils.formatDate(detailsRes["data"]["possessionDate"])}');
      print('ppppppp');
      if (detailsRes["data"]["regulatoryAspects"] != null) {
        detailsRes["data"]["regulatoryAspects"].forEach((r) {
          RegulatoryAspects regulatoryAspects = RegulatoryAspects();
          regulatoryAspects.name = r["name"];
          if (regulatoryAspects.name != null) {
            showAdditionalInfo.value = true;
          }
          regulatoryAspects.value = r["value"];
          regulatoryAspectsList.add(regulatoryAspects);
        });
      }
      if (detailsRes["data"]["specifications"] != null) {
        detailsRes["data"]["specifications"].forEach((s) {
          Specifications specifications = Specifications();
          specifications.name = s["name"];
          if (specifications.name != null) {
            showAdditionalInfo.value = true;
          }
          specifications.type = "Specification";
          specifications.amenitySpecificationId = s["amenitySpecificationId"];
          specifications.features = [];
          s['features'].forEach((ft) {
            Feature f = Feature();
            f.logo = ft['logo'];
            f.name = ft['name'];
            specifications.features!.add(f);
          });
          specificationsList.add(specifications);
        });
      }
      print('Specific... $specalitiesList');
      if (detailsRes["data"]["amenities"] != null) {
        detailsRes["data"]["amenities"].forEach((s) {
          Amenities amenity = Amenities();
          amenity.name = s['name'].toString();
          if (amenity.name != null) {
            showAdditionalInfo.value = true;
          }
          amenity.amenitySpecificationId =
              s['amenitySpecificationId'].toString();
          amenity.type = s['type'].toString();
          amenity.features = [];
          s['features'].forEach((ft) {
            Feature f = Feature();
            f.logo = ft['logo'];
            f.name = ft['name'];
            amenity.features!.add(f);
          });
          amenitiesList.add(amenity);
        });

        print("amenitiesList length: ${amenitiesList.length}");
        print("amenitiesList 123: ${jsonEncode(amenitiesList)}");
      }
      possessionDateController.text =
          DateTimeUtils.formatDate(detailsRes["data"]["possessionDate"]);
      posessionDate = DateTime.parse(detailsRes["data"]["possessionDate"]);

      if (detailsRes["data"]["builderData"] != null) {
        detailsRes["data"]["builderData"].forEach((s) {
          builderDataList.add(BuilderData.fromJson(s));
        });
      }
      updateMapCameraPosition(latitude.value, longitude.value);
      print('poss0101 ${possessionDateController.text},${posessionDate}');
      isDetailsLoading.value = false;
    }).catchError((error) {
      isDetailsLoading.value = false;
      print("22Error while fetching getDetailsByProjectId: $error");
    });
  }

  bindBuilder(builderId) {
    print("builder list: $builderDataList");

    builders.forEach((b) {
      if (b["builderId"] == builderId) {
        builderController.text = b["registeredName"];
      }
    });
  }

  clearData() {
    projectNameController.text = '';
    selectedProjectType.value = '';
    totalProjectAreaController.text = '';
    aboutLocationController.text = '';
    totalNoOfUnitsController.text = '';
    facingController.text = '';
    builtUpAreaontroller.text = '';
    minPriceController.text = '';
    maxPriceController.text = '';
    locationAdvantageController.text = '';
    searchtermController.text = '';
    pocController.text = '';

    gstController.text = '';
    landMarksList.clear();
    regulatoryAspectsList.clear();
    specificationsList.clear();
    amenitiesList.clear();
    selectedCountry.value = '';
    selectedState.value = '';
    selectedCity.value = '';
    anyConstructionDone.value = '';
    aboutProjectController.text = '';
    totalNoOfTowersController.text = '';
    configurationController.text = '';
    possessionDateController.text = '';
    selectedTransactionType.value = '';
    selectedPossesionSttus.value = '';
    propertyAgeController.text = '';
    cornerPlotController.text = '';
    carpetAreaController.text = '';
    rentController.text = '';
    plotAreaController.text = '';
    dimensionsController.text = '';
    boundaryWallPresentController.text = '';
    boundaryWallPresent.value = '';
    noOfOpenSidesController.text = '';
    plotPriceController.text = '';
    widthOffacingRoadController.text = '';
    totalNoOfFloorsController.text = '';
    floorDetailsController.text = '';
    furnishingStatusController.text = '';
    furnishingStatus.value = '';
  }

  updateMapCameraPosition(double lat, double lng) async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 18)));
    updateMarkerPosition(LatLng(lat, lng));
    getAddressFromLatLng(lat, lng);
  }

  void updateMarkerPosition(LatLng position) {
    myMarker.clear();
    myMarker.value = [];
    myMarker.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        draggable: true,
        onDragEnd: ((newPosition) {
          print(newPosition.latitude);
          print(newPosition.longitude);
          latitude.value = newPosition.latitude;
          longitude.value = newPosition.longitude;
          getAddressFromLatLng(newPosition.latitude, newPosition.longitude);
        })));
  }

  getAddressFromLatLng(double lat, double lng) async {
    print("getAddressFromLatLng called");
    print("lat: $lat");
    String _host = 'https://maps.google.com/maps/api/geocode/json';
    final url =
        '$_host?key=AIzaSyBLDp2eDCSwnHoC1Hei4h9Zb_qRgEC_Gjc&language=en&latlng=$lat,$lng';

    print("latlng: $lat - $lng");
    if (lat != null && lng != null) {
      var response = await HttpUtils.getInstance().get(url);
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.toString());
        print('data address: $data');
        address.value = data['results'][0]['formatted_address'];
      } else
        return null;
    } else
      return null;
  }

  setSelectedLocation(String placeId) async {
    var sLocation = await getPlace(placeId);
    print("sLocation$sLocation");
    print(sLocation.geometry.location.lat);
    print(sLocation.geometry.location.lng);
    latitude.value = sLocation.geometry.location.lat;
    longitude.value = sLocation.geometry.location.lng;
    print(sLocation.name);
    print(sLocation.vicinity);
    searchResults.clear();
    searchResults.value = [];
    updateMapCameraPosition(
        sLocation.geometry.location.lat, sLocation.geometry.location.lng);
  }

  searchPlaces(String searchTerm) async {
    print('response$searchTerm');
    searchResults.value = await getAutocomplete(searchTerm);
  }

  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:IN&key=$kGoogleApiKey';
    var response = await HttpUtils.getInstance().get(url);
    print('response$response');
    var json = jsonDecode(response.toString());
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$kGoogleApiKey';
    var response = await HttpUtils.getInstance().get(url);
    var json = jsonDecode(response.toString());
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  handleTap(LatLng tappedPoint) {
    updateMapCameraPosition(tappedPoint.latitude, tappedPoint.longitude);
  }

  getCountries() {
    countries.clear();
    projectService.getCountries().then((coutriesRes) {
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

  bindState(stateId, cityId) {
    selectedState.value = '';
    selectedCity.value = '';
    statesList.clear();
    cities.clear();
    projectService
        .getStatesByCountryId(selectedCountry.value)
        .then((statesRes) {
      print("states res: $statesRes");
      statesRes["data"].forEach((s) {
        ProjectState state = ProjectState();
        state.name = s['name'];
        state.sttId = s["sttId"];
        statesList.add(state);
      });
      selectedState.value = stateId;
      if (cityId != '') {
        bindCity(cityId);
      }
    }).catchError((error) {
      print("Error while fetching getStatesByCountryId: $error");
    });
  }

  bindCity(cityId) {
    cities.clear();
    selectedCity.value = '';
    projectService
        .getCitiesByStateId(selectedCountry.value, selectedState.value)
        .then((citiesRes) {
      print("citiesRes res: $citiesRes");
      citiesRes["data"].forEach((city) {
        City c = City();
        c.citId = city["citId"];
        c.name = city["name"];
        cities.add(c);
      });

      print("cities: ${cities.toJson()}");
      selectedCity.value = cityId;
    }).catchError((error) {
      print("Error while fetching getCitiesByStateId: $error");
    });
  }

  getStatesByCountryId(countryId) {
    statesList.clear();
    cities.clear();
    selectedState.value = '';
    selectedCity.value = '';
    projectService.getStatesByCountryId(countryId).then((statesRes) {
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
    selectedCity.value = '';
    projectService
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

  getAllAmenities() {
    projectService.getAllAmenities().then((amenityRes) {
      print("amenityRes res: $amenityRes");
      amenityRes["data"].forEach((a) {
        if (a['type'] == "Amenity") {
          Amenities amenities = Amenities();
          amenities.name = a['name'];
          amenities.type = a['type'];
          amenities.amenitySpecificationId = a['amenitySpecificationId'];
          amenities.features = [];
          a['features'].forEach((ft) {
            Feature f = Feature();
            f.logo = ft['logo'];
            f.name = ft['name'];
            amenities.features!.add(f);
          });
          allAmenitiesList.add(amenities);
        } else {
          Amenities amenities = Amenities();
          amenities.name = a['name'];
          amenities.type = a['type'];
          amenities.amenitySpecificationId = a['amenitySpecificationId'];
          amenities.features = [];
          a['features'].forEach((ft) {
            Feature f = Feature();
            f.logo = ft['logo'];
            f.name = ft['name'];
            amenities.features!.add(f);
          });
          allSpecalitiesList.add(amenities);
        }
      });
    }).catchError((error) {
      print("Error while fetching getAllAmenities: $error");
    });
  }

  addLandMark() {
    landMarksList.add(landMarkNameController.text);
    Get.back();
    landMarkNameController.text = '';
  }

  addRegulatoryAspects(r) {
    regulatoryAspectsList.add(r);
    Get.back();
    regulatoryNameController.text = '';
    regulatoryIdController.text = '';
  }

  addAmenity(Amenities a) {
    print('amamamLi ${a.toJson()}');
    amenitiesList.add(a);
    print('amamamList ${amenitiesList.toJson()}');
    Future.delayed(
        const Duration(seconds: 2),
        () => allAmenitiesList.removeWhere(
            (am) => am.amenitySpecificationId == a.amenitySpecificationId));

    amenityFeatureList.clear();
  }

  addAmenities() {
    amenitiesList.forEach((element) {
      print('ele00 ${jsonEncode(element.amenitySpecificationId)}');
      allAmenitiesList.removeWhere(
          (am) => am.amenitySpecificationId == element.amenitySpecificationId);
    });

    amenityFeatureList.clear();
    print('len11 ${allAmenitiesList.length}');
    //  allAmenitiesList.clear();
  }

  addSpecificationsEditMode() {
    print('specificationL ${jsonEncode(specalitiesList)}');
    print('specificationL ${jsonEncode(allSpecalitiesList)}');
    print('specificationL ${allSpecalitiesList.length}');

    specificationsList.forEach((element) {
      print('ele00 ${jsonEncode(element.amenitySpecificationId)}');
      allSpecalitiesList.removeWhere(
          (am) => am.amenitySpecificationId == element.amenitySpecificationId);
    });
    print('specificationL ${allSpecalitiesList.length}');
    specalityFeatureList.clear();
    //  print('len11 ${allAmenitiesList.length}');
    //  allAmenitiesList.clear();
  }

  addSpecification(s) {
    specificationsList.add(s);

    Future.delayed(
        const Duration(seconds: 2),
        () => allSpecalitiesList.removeWhere(
            (am) => am.amenitySpecificationId == s.amenitySpecificationId));
    specalityFeatureList.clear();
  }

  save() {
    print('sssssss ${selectedState.value}');
    print('skkk ${plotAreaController.text}');
    print('sssssss ${selectedState.value.isEmpty}');
    print('sssssss ${jsonEncode(regulatoryAspectsList.length)}');

    if (projectFormKey.currentState!.validate()
        //&&
        // amenitiesList.isNotEmpty &&
        // specificationsList.isNotEmpty
        ) {
// if (posessionDate == null) {
//       Get.rawSnackbar(message: "Possession date is required");
//       return;
//     }
      if (selectedPossesionSttus.value == "Under Construction") {
        if (possessionDateController.text.isEmpty) {
          Get.rawSnackbar(
            message: 'Possession Date is Required',
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          );
          return; // Stop the form submission
        }
      }
      if (selectedState.value.isNotEmpty && selectedCity.value.isNotEmpty) {
        isDetailsLoading.value = true;

        ProjectDetails projectDetails = ProjectDetails();
        
        projectDetails.aboutBuilder = builderController.text;
        projectDetails.carpetArea = carpetAreaController.text;
        projectDetails.totalPlotArea = plotAreaController.text;
        projectDetails.plotPrice = plotPriceController.text;
        projectDetails.constructionStatus = selectedPossesionSttus.value;
        projectDetails.floorDetails = floorDetailsController.text;
        projectDetails.facing = facingController.text;
        projectDetails.transactionType = selectedTransactionType.value;
        projectDetails.totNoOfTowers = totalNoOfTowersController.text;
        projectDetails.propertyAge = propertyAgeController.text;
        projectDetails.boundaryWallPresent = boundaryWallPresent.value;
        projectDetails.anyConstructionDone = anyConstructionDone.value;
        projectDetails.dimensions = dimensionsController.text;
        projectDetails.expectedRentValue = rentController.text;
        projectDetails.facingRoadWidth = widthOffacingRoadController.text;
        projectDetails.floorsAllowedForConstruction =
            floorsAllowedForConstructionController.text;
        projectDetails.furnishingStatus = furnishingStatus.value;
        projectDetails.noOfOpenSides = noOfOpenSidesController.text;
        projectDetails.aboutProject = aboutProjectController.text;
        projectDetails.projectId = projectId.value;
        projectDetails.projectName = projectNameController.text;
        projectDetails.builderId = builderId.value;
        projectDetails.builderContactDetails = projectDetailsRes != null
            ? projectDetailsRes['builderContactDetails']
            : '';
        projectDetails.marketingAgencyId = marketingAgencyId;
        projectDetails.agentId = agentId;
        projectDetails.location = [latitude.value, longitude.value];
        projectDetails.address = searchtermController.text;
        projectDetails.projectType = selectedProjectType.value;
        projectDetails.totalProjectArea = totalProjectAreaController.text;
        projectDetails.configurationType = '';
        projectDetails.totNoOfUnits = totalNoOfUnitsController.text;
        projectDetails.builtUpArea = builtUpAreaontroller.text;
        projectDetails.minBuiltUpArea = minBuiltUpAreaontroller.text;
        projectDetails.maxBuiltUpArea = maxBuiltUpAreaontroller.text;
        projectDetails.minPrice = minPriceController.text;
        projectDetails.maxPrice = maxPriceController.text;
        projectDetails.possessionDate = posessionDate.toIso8601String();
        projectDetails.totNoOfFloors = totalNoOfFloorsController.text;
        projectDetails.aboutLocation = aboutLocationController.text;
        projectDetails.locationAdvantage = locationAdvantageController.text;
        projectDetails.gstApplicable = gstController.text;
        projectDetails.otherProjects = [];
        projectDetails.projectsNearby = '';
        projectDetails.ratingsAndReviews = '';
        projectDetails.reviewAbtProject = '';
        projectDetails.pointOfContact = pocController.text;
        print('pppopop ${projectDetails.pointOfContact}');
        projectDetails.country = selectedCountry.value;
        projectDetails.state = selectedState.value;
        projectDetails.city = selectedCity.value;
        projectDetails.logo = "";
        projectDetails.createdBy =
            projectDetailsRes != null ? projectDetailsRes["createdBy"] : "";
        projectDetails.createdAt =
            projectDetailsRes != null ? projectDetailsRes["createdAt"] : "";
        projectDetails.updatedBy =
            projectDetailsRes != null ? projectDetailsRes["updatedBy"] : "";
        projectDetails.updatedAt = DateTime.now().toString();
        projectDetails.status =
            projectDetailsRes != null ? projectDetailsRes["status"] : 1;
        projectDetails.builderData = [];
        projectDetails.builderData?.addAll(builderDataList);
        projectDetails.amenities = [];
        projectDetails.amenities!.addAll(amenitiesList);
        projectDetails.landmark = [];
        projectDetails.landmark?.addAll(landMarksList);
        projectDetails.specifications = [];
        projectDetails.specifications?.addAll(specificationsList);
        projectDetails.regulatoryAspects = [];
        projectDetails.regulatoryAspects!.addAll(regulatoryAspectsList);
        projectDetails.configuration = configurationController.text;
        // print(
        //     'pocController.text${pocController.text},${aboutProjectController.text},${projectDetails.pointOfContact}');
        print('pppopop123 ${projectDetails.pointOfContact}');
        print("project obj: ${jsonEncode(projectDetails)}");

        Project project = Project();
        project.projectDetails = projectDetails;
        if (isUpdateMode.value == false) {
          createProject(project);
        } else {
          updateProject(project);
        }
      } else {
        if (selectedState.value.isEmpty && selectedCity.value.isEmpty) {
          Get.rawSnackbar(message: "Please Select State and City");
        } else if (selectedState.value.isEmpty) {
          Get.rawSnackbar(message: "Please Select state");
        } else {
          Get.rawSnackbar(message: "Please select city");
        }
      }
    } else {
      Get.rawSnackbar(message: "Please Fill All Required Details");
    }
  }

  createProject(project) {
    projectService.createProject(project).then((res) {
      isDetailsLoading.value = false;

      print("createProject res: $res");
      if (res["status"] == 200) {
        if (res['type'] == "warning") {
          Get.rawSnackbar(
              message: res["message"], backgroundColor: Colors.amber);
        } else {
          return Get.dialog(AppCupertinoDialog(
            title: "Project Created Successfully",
            subTitle:
                "Would You Like to Add Project Documents to This  ${projectNameController.text} Project?",
            onAccepted: () {
              Get.delete<ProjectDocumentsController>(force: true);
              Get.toNamed(Routes.projectDocuments,
                  arguments: {"projectId": res['data'][0]['projectId']});
            },
            onCanceled: () {
              print("OnCancelled called");
              Get.delete<ProjectsController>(force: true);
              Get.toNamed(Routes.projects);
            },
            isOkBtn: false,
            cancelText: "Skip",
            acceptText: "Continue",
          ));
        }
      } else {
        Get.rawSnackbar(message: res['msg']);
      }
    }).catchError((err) {
      isDetailsLoading.value = false;

      print("createProject err: ${err['message']}");
      Get.rawSnackbar(message: err["message"].toString());
    });
  }

  updateProject(project) {
    projectService.updateProject(projectID.value, project).then((res) {
      isDetailsLoading.value = false;

      print("updateProject res: $res");
      if (res["status"] == 200) {
        if (res['type'] == "warning") {
          Get.rawSnackbar(
              message: res["message"], backgroundColor: Colors.amber);
        } else {
          Get.dialog(AppCupertinoDialog(
            title: "Project Updated Successfully",
            subTitle:
                "Would You Like to Add Project Documents to This  ${projectNameController.text} Project?",
            onAccepted: () {
              Get.delete<ProjectDocumentsController>();
              Get.toNamed(Routes.projectDocuments,
                  arguments: {"projectId": res['data'][0]['projectId']});
            },
            onCanceled: () {
              Get.delete<ProjectsController>(force: true);
              Get.toNamed(Routes.projects);
            },
            isOkBtn: false,
            cancelText: "Skip",
            acceptText: "Continue",
          ));
          Get.rawSnackbar(
              message: res["message"],
              backgroundColor: ThemeConstants.successColor);
        }
      } else {
        print('...........why....');
        Get.rawSnackbar(message: 'Something Went Wrong');
      }
    }).catchError((err) {
      isDetailsLoading.value = false;

      print("updateProject err err: ${err['message']}");
      Get.rawSnackbar(message: err["message"].toString());
    });
  }
}

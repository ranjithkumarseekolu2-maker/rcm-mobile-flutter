class Project {
  ProjectDetails? projectDetails;

  Project({this.projectDetails});

  Project.fromJson(Map<String, dynamic> json) {
    projectDetails = json['projectDetails'] != null
        ? new ProjectDetails.fromJson(json['projectDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.projectDetails != null) {
      data['projectDetails'] = this.projectDetails!.toJson();
    }
    return data;
  }
}

class ProjectDetails {
  String? totalPlotArea;
  String? projectId;
  String? projectName;
  String? builderId;
  String? marketingAgencyId;
  List<double>? location;
  String? address;
  String? projectType;
  String? totalProjectArea;
  String? configurationType;
  String? totNoOfUnits;
  String? totNoOfTowers;
  String? configuration;
  String? builtUpArea;
  String? minPrice;
  String? maxPrice;
  String? possessionDate;
  List<Amenities>? amenities;
  List<Specifications>? specifications;
  String? aboutProject;
  String? aboutLocation;
  String? locationAdvantage;
  String? gstApplicable;
  List<String>? landmark;
  List<RegulatoryAspects>? regulatoryAspects;
  List<dynamic>? projectImages;
  String? aboutBuilder;
  List<dynamic>? otherProjects;
  String? projectsNearby;
  String? builderContactDetails;
  String? ratingsAndReviews;
  String? reviewAbtProject;
  String? pointOfContact;
  String? country;
  String? state;
  String? city;
  String? logo;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  int? status;
  String? agentId;
  String? minBuiltUpArea;
  String? maxBuiltUpArea;
  List<BuilderData>? builderData;
  String? transactionType;
  String? facing;
  String? constructionStatus;
  String? plotPrice;
  String? floorDetails;
  String? carpetArea;
  String? totNoOfFloors;

  String? propertyAge;
  String? dimensions;
  String? boundaryWallPresent;
  String? noOfOpenSides;
  String? furnishingStatus;
  String? expectedRentValue;
  String? facingRoadWidth;
  String? anyConstructionDone;
  String? floorsAllowedForConstruction;

  ProjectDetails(
      {this.totalPlotArea,
      this.projectId,
      this.projectName,
      this.builderId,
      this.marketingAgencyId,
      this.location,
      this.address,
      this.projectType,
      this.totalProjectArea,
      this.configurationType,
      this.totNoOfUnits,
      this.totNoOfTowers,
      this.configuration,
      this.builtUpArea,
      this.minBuiltUpArea,
      this.maxBuiltUpArea,
      this.minPrice,
      this.maxPrice,
      this.possessionDate,
      this.amenities,
      this.specifications,
      this.aboutProject,
      this.aboutLocation,
      this.locationAdvantage,
      this.gstApplicable,
      this.landmark,
      this.regulatoryAspects,
      this.projectImages,
      this.aboutBuilder,
      this.otherProjects,
      this.projectsNearby,
      this.builderContactDetails,
      this.ratingsAndReviews,
      this.reviewAbtProject,
      this.pointOfContact,
      this.country,
      this.state,
      this.city,
      this.logo,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt,
      this.status,
      this.agentId,
      this.builderData,
      this.carpetArea,
      this.facing,
      this.floorDetails,
      this.plotPrice,
      this.constructionStatus,
      this.transactionType,
      this.totNoOfFloors,
      this.propertyAge,
      this.boundaryWallPresent,
      this.anyConstructionDone,
      this.dimensions,
      this.expectedRentValue,
      this.facingRoadWidth,
      this.floorsAllowedForConstruction,
      this.furnishingStatus,
      this.noOfOpenSides});

  ProjectDetails.fromJson(Map<String, dynamic> json) {
    totalPlotArea = json['totalPlotArea'];
    projectId = json['projectId'];
    projectName = json['projectName'];
    builderId = json['builderId'];
    marketingAgencyId = json['marketingAgencyId'];
    location = json['location'].cast<double>();
    address = json['address'];
    projectType = json['projectType'];
    totalProjectArea = json['totalProjectArea'];
    configurationType = json['configurationType'];
    totNoOfUnits = json['totNoOfUnits'];
    configuration = json['configuration'];
    totNoOfTowers = json['totNoOfTowers'];
    builtUpArea = json['builtUpArea'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    minBuiltUpArea = json['minBuiltUpArea'];
    maxBuiltUpArea = json['maxBuiltUpArea'];
    
    possessionDate = json['possessionDate'];
    if (json['amenities'] != null) {
      amenities = <Amenities>[];
      json['amenities'].forEach((v) {
        amenities!.add(new Amenities.fromJson(v));
      });
    }
    if (json['specifications'] != null) {
      specifications = <Specifications>[];
      json['specifications'].forEach((v) {
        specifications!.add(new Specifications.fromJson(v));
      });
    }
    aboutProject = json['aboutProject'];
    aboutLocation = json['aboutLocation'];
    locationAdvantage = json['locationAdvantage'];
    gstApplicable = json['gstApplicable'];
    landmark = json['landmark'].cast<String>();
    if (json['regulatoryAspects'] != null) {
      regulatoryAspects = <RegulatoryAspects>[];
      json['regulatoryAspects'].forEach((v) {
        regulatoryAspects!.add(new RegulatoryAspects.fromJson(v));
      });
    }
    if (json['projectImages'] != null) {
      projectImages = [];
      json['projectImages'].forEach((v) {
        projectImages!.add(v);
      });
    }
    aboutBuilder = json['aboutBuilder'];
    if (json['otherProjects'] != null) {
      otherProjects = [];
      json['otherProjects'].forEach((v) {
        otherProjects!.add((v));
      });
    }
    projectsNearby = json['projectsNearby'];
    builderContactDetails = json['builderContactDetails'];
    ratingsAndReviews = json['ratingsAndReviews'];
    reviewAbtProject = json['reviewAbtProject'];
    pointOfContact = json['pointOfContact'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    logo = json['logo'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    carpetArea = json['carpetArea'];

    plotPrice = json['plotPrice'];
    constructionStatus = json['constructionStatus'];
    facing = json['facing'];
    floorDetails = json['floorDetails'];
    transactionType = json['transactionType'];
    totNoOfFloors = json['totNoOfFloors'];

    this.propertyAge = json['propertyAge'];
    this.boundaryWallPresent = json['boundaryWallPresent'];
    this.anyConstructionDone = json['anyConstructionDone'];
    this.dimensions = json['dimensions'];
    this.expectedRentValue = json['expectedRentValue'];
    this.facingRoadWidth = json['facingRoadWidth'];
    this.floorsAllowedForConstruction = json['floorsAllowedForConstruction'];
    this.furnishingStatus = json['furnishingStatus'];
    this.noOfOpenSides = json['noOfOpenSides'];

    agentId = json['agentId'];
    if (json['builderData'] != null) {
      builderData = <BuilderData>[];
      json['builderData'].forEach((v) {
        builderData!.add(new BuilderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalPlotArea'] = this.totalPlotArea;
    data['projectId'] = this.projectId;
    data['projectName'] = this.projectName;
    data['builderId'] = this.builderId;
    data['marketingAgencyId'] = this.marketingAgencyId;
    data['location'] = this.location;
    data['address'] = this.address;
    data['projectType'] = this.projectType;
    data['totalProjectArea'] = this.totalProjectArea;
    data['configurationType'] = this.configurationType;
    data['totNoOfUnits'] = this.totNoOfUnits;
    data["configuration"] = this.configuration;
    data["totNoOfTowers"] = this.totNoOfTowers;
    data['builtUpArea'] = this.builtUpArea;
 data['minBuiltUpArea'] = this.minBuiltUpArea;
  data['maxBuiltUpArea'] = this.maxBuiltUpArea;
    
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['possessionDate'] = this.possessionDate;
    if (this.amenities != null) {
      data['amenities'] = this.amenities!.map((v) => v.toJson()).toList();
    }
    if (this.specifications != null) {
      data['specifications'] =
          this.specifications!.map((v) => v.toJson()).toList();
    }
    data['aboutProject'] = this.aboutProject;
    data['aboutLocation'] = this.aboutLocation;
    data['locationAdvantage'] = this.locationAdvantage;
    data['gstApplicable'] = this.gstApplicable;
    data['landmark'] = this.landmark;
    if (this.regulatoryAspects != null) {
      data['regulatoryAspects'] =
          this.regulatoryAspects!.map((v) => v.toJson()).toList();
    }
    if (this.projectImages != null) {
      data['projectImages'] = projectImages!.map((v) => v?.toJson()).toList();
    }
    data['aboutBuilder'] = this.aboutBuilder;
    if (this.otherProjects != null) {
      data['otherProjects'] =
          this.otherProjects!.map((v) => v.toJson()).toList();
    }
    data['projectsNearby'] = this.projectsNearby;
    data['builderContactDetails'] = this.builderContactDetails;
    data['ratingsAndReviews'] = this.ratingsAndReviews;
    data['reviewAbtProject'] = this.reviewAbtProject;
    data['pointOfContact'] = this.pointOfContact;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['logo'] = this.logo;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedBy'] = this.updatedBy;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;

    data['plotPrice'] = this.plotPrice;
    data['transactionType'] = this.transactionType;
    data['carpetArea'] = this.carpetArea;
    data['facing'] = this.facing;
    data['floorDetails'] = this.floorDetails;
    data['constructionStatus'] = this.constructionStatus;
    data['agentId'] = this.agentId;
    data['totNoOfFloors'] = this.totNoOfFloors;

    data['propertyAge'] = this.propertyAge;
    data['boundaryWallPresent'] = this.boundaryWallPresent;
    data['anyConstructionDone'] = this.anyConstructionDone;
    data['dimensions'] = this.dimensions;
    data['expectedRentValue'] = this.expectedRentValue;
    data['facingRoadWidth'] = this.facingRoadWidth;
    data['floorsAllowedForConstruction'] = this.floorsAllowedForConstruction;
    data['furnishingStatus'] = this.furnishingStatus;
    data['noOfOpenSides'] = this.noOfOpenSides;
    if (this.builderData != null) {
      data['builderData'] = this.builderData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Amenities {
  String? name;
  String? type;
  List<Feature>? features;
  String? amenitySpecificationId;

  Amenities({this.name, this.type, this.features, this.amenitySpecificationId});

  Amenities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    if (json['features'] != null) {
      features = <Feature>[];
      json['features'].forEach((v) {
        features!.add(new Feature.fromJson(v));
      });
    }
    amenitySpecificationId = json['amenitySpecificationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['amenitySpecificationId'] = this.amenitySpecificationId;
    return data;
  }
}

class Specifications {
  String? name;
  String? type;
  List<Feature>? features;
  String? amenitySpecificationId;

  Specifications(
      {this.name, this.type, this.features, this.amenitySpecificationId});

  Specifications.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    if (json['features'] != null) {
      features = <Feature>[];
      json['features'].forEach((v) {
        features!.add(new Feature.fromJson(v));
      });
    }
    amenitySpecificationId = json['amenitySpecificationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['amenitySpecificationId'] = this.amenitySpecificationId;
    return data;
  }
}

class Feature {
  String? logo;
  String? name;

  Feature({this.logo, this.name});

  Feature.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logo'] = this.logo;
    data['name'] = this.name;
    return data;
  }
}

class RegulatoryAspects {
  String? name;
  String? value;

  RegulatoryAspects({this.name, this.value});

  RegulatoryAspects.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class BuilderData {
  String? builderId;
  String? registeredName;
  String? displayName;
  String? registeredOfcAddress;
  String? ofcPrimaryContactNo;
  String? ofcSecondaryContactNo;
  String? founder;
  String? founderFbUrl;
  String? founderTwitterUrl;
  String? founderLinkedinUrl;
  String? founderIgUrl;
  String? founderDetails;
  String? founderContactInfo;
  String? companyWebsite;
  String? companyRegistrationType;
  String? establishedYear;
  String? headOfcAddress;
  String? branchOfcAddress;
  String? propertyTypeDeals;
  String? operatingCities;
  String? experience;
  String? priceTrends;
  String? builderOverview;
  String? missionAndValues;
  String? reasonToChoose;
  String? salesTeam;
  String? companyFbUrl;
  String? companyTwitterUrl;
  String? companyLinkedinUrl;
  String? companyIgUrl;
  String? directions;
  String? affeliations;
  String? builderRegistrationNo;
  String? reviews;
  String? operatingHours;
  String? reraId;
  String? paymentModes;
  String? createdBy;
  String? createdAt;
  String? updatedBy;
  String? updatedAt;
  int? status;
  int? isVerified;
  String? pan;
  String? rera;
  String? roc;
  String? description;
  String? otp;
  int? isDefault;

  BuilderData(
      {this.builderId,
      this.registeredName,
      this.displayName,
      this.registeredOfcAddress,
      this.ofcPrimaryContactNo,
      this.ofcSecondaryContactNo,
      this.founder,
      this.founderFbUrl,
      this.founderTwitterUrl,
      this.founderLinkedinUrl,
      this.founderIgUrl,
      this.founderDetails,
      this.founderContactInfo,
      this.companyWebsite,
      this.companyRegistrationType,
      this.establishedYear,
      this.headOfcAddress,
      this.branchOfcAddress,
      this.propertyTypeDeals,
      this.operatingCities,
      this.experience,
      this.priceTrends,
      this.builderOverview,
      this.missionAndValues,
      this.reasonToChoose,
      this.salesTeam,
      this.companyFbUrl,
      this.companyTwitterUrl,
      this.companyLinkedinUrl,
      this.companyIgUrl,
      this.directions,
      this.affeliations,
      this.builderRegistrationNo,
      this.reviews,
      this.operatingHours,
      this.reraId,
      this.paymentModes,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt,
      this.status,
      this.isVerified,
      this.pan,
      this.rera,
      this.roc,
      this.description,
      this.otp,
      this.isDefault});

  BuilderData.fromJson(Map<String, dynamic> json) {
    builderId = json['builderId'];
    registeredName = json['registeredName'];
    displayName = json['displayName'];
    registeredOfcAddress = json['registeredOfcAddress'];
    ofcPrimaryContactNo = json['ofcPrimaryContactNo'];
    ofcSecondaryContactNo = json['ofcSecondaryContactNo'];
    founder = json['founder'];
    founderFbUrl = json['founderFbUrl'];
    founderTwitterUrl = json['founderTwitterUrl'];
    founderLinkedinUrl = json['founderLinkedinUrl'];
    founderIgUrl = json['founderIgUrl'];
    founderDetails = json['founderDetails'];
    founderContactInfo = json['founderContactInfo'];
    companyWebsite = json['companyWebsite'];
    companyRegistrationType = json['companyRegistrationType'];
    establishedYear = json['establishedYear'];
    headOfcAddress = json['headOfcAddress'];
    branchOfcAddress = json['branchOfcAddress'];
    propertyTypeDeals = json['propertyTypeDeals'];
    operatingCities = json['operatingCities'];
    experience = json['experience'];
    priceTrends = json['priceTrends'];
    builderOverview = json['builderOverview'];
    missionAndValues = json['missionAndValues'];
    reasonToChoose = json['reasonToChoose'];
    salesTeam = json['salesTeam'];
    companyFbUrl = json['companyFbUrl'];
    companyTwitterUrl = json['companyTwitterUrl'];
    companyLinkedinUrl = json['companyLinkedinUrl'];
    companyIgUrl = json['companyIgUrl'];
    directions = json['directions'];
    affeliations = json['affeliations'];
    builderRegistrationNo = json['builderRegistrationNo'];
    reviews = json['reviews'];
    operatingHours = json['operatingHours'];
    reraId = json['reraId'];
    paymentModes = json['paymentModes'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'];
    status = json['status'];
    isVerified = json['isVerified'];
    pan = json['pan'];
    rera = json['rera'];
    roc = json['roc'];
    description = json['description'];
    otp = json['otp'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['builderId'] = this.builderId;
    data['registeredName'] = this.registeredName;
    data['displayName'] = this.displayName;
    data['registeredOfcAddress'] = this.registeredOfcAddress;
    data['ofcPrimaryContactNo'] = this.ofcPrimaryContactNo;
    data['ofcSecondaryContactNo'] = this.ofcSecondaryContactNo;
    data['founder'] = this.founder;
    data['founderFbUrl'] = this.founderFbUrl;
    data['founderTwitterUrl'] = this.founderTwitterUrl;
    data['founderLinkedinUrl'] = this.founderLinkedinUrl;
    data['founderIgUrl'] = this.founderIgUrl;
    data['founderDetails'] = this.founderDetails;
    data['founderContactInfo'] = this.founderContactInfo;
    data['companyWebsite'] = this.companyWebsite;
    data['companyRegistrationType'] = this.companyRegistrationType;
    data['establishedYear'] = this.establishedYear;
    data['headOfcAddress'] = this.headOfcAddress;
    data['branchOfcAddress'] = this.branchOfcAddress;
    data['propertyTypeDeals'] = this.propertyTypeDeals;
    data['operatingCities'] = this.operatingCities;
    data['experience'] = this.experience;
    data['priceTrends'] = this.priceTrends;
    data['builderOverview'] = this.builderOverview;
    data['missionAndValues'] = this.missionAndValues;
    data['reasonToChoose'] = this.reasonToChoose;
    data['salesTeam'] = this.salesTeam;
    data['companyFbUrl'] = this.companyFbUrl;
    data['companyTwitterUrl'] = this.companyTwitterUrl;
    data['companyLinkedinUrl'] = this.companyLinkedinUrl;
    data['companyIgUrl'] = this.companyIgUrl;
    data['directions'] = this.directions;
    data['affeliations'] = this.affeliations;
    data['builderRegistrationNo'] = this.builderRegistrationNo;
    data['reviews'] = this.reviews;
    data['operatingHours'] = this.operatingHours;
    data['reraId'] = this.reraId;
    data['paymentModes'] = this.paymentModes;
    data['createdBy'] = this.createdBy;
    data['createdAt'] = this.createdAt;
    data['updatedBy'] = this.updatedBy;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    data['isVerified'] = this.isVerified;
    data['pan'] = this.pan;
    data['rera'] = this.rera;
    data['roc'] = this.roc;
    data['description'] = this.description;
    data['otp'] = this.otp;
    data['isDefault'] = this.isDefault;
    return data;
  }
}

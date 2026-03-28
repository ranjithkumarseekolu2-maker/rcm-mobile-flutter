class Builder {
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
  int? establishedYear;
  String? headOfcAddress;
  String? branchOfcAddress;
  List<String>? propertyTypeDeals;
  String? operatingCities;
  int? experience;
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

 

  Builder(
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

  Builder.fromJson(Map<String, dynamic> json) {
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
    propertyTypeDeals = json['propertyTypeDeals'] != null && json['propertyTypeDeals'] != "" ? json['propertyTypeDeals'].cast<String>() : null ;
    operatingCities = json['operatingCities'] != null && json['operatingCities'] != "" ? json['operatingCities'].cast<String>() :null ;
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
    data['affeliations'] = affeliations;
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

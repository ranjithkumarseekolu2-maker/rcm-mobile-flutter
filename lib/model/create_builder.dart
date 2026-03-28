class CreateBuilder {
  BuilderDetails? builderDetails;

  CreateBuilder({this.builderDetails});

  CreateBuilder.fromJson(Map<String, dynamic> json) {
    builderDetails = json['builderDetails'] != null
        ? new BuilderDetails.fromJson(json['builderDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.builderDetails != null) {
      data['builderDetails'] = this.builderDetails!.toJson();
    }
    return data;
  }
}

class BuilderDetails {
  Null? builderId;
  String? firstName;
  String? lastName;
  String? emailId;
  String? mobileNumber;
  String? password;
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
  List<String>? operatingCities;
  String? experience;
  String? builderOverview;
  String? missionAndValues;
  String? reasonToChoose;
  String? salesTeam;
  String? companyFbUrl;
  String? companyTwitterUrl;
  String? companyLinkedinUrl;
  String? companyIgUrl;
  String? affiliations;
  String? builderRegistrationNo;
  String? operatingHours;
  String? reraId;
  String? state;
  String? country;

  BuilderDetails(
      {this.builderId,
      this.firstName,
      this.lastName,
      this.emailId,
      this.mobileNumber,
      this.password,
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
      this.builderOverview,
      this.missionAndValues,
      this.reasonToChoose,
      this.salesTeam,
      this.companyFbUrl,
      this.companyTwitterUrl,
      this.companyLinkedinUrl,
      this.companyIgUrl,
      this.affiliations,
      this.builderRegistrationNo,
      this.operatingHours,
      this.reraId,
      this.state,
      this.country});

  BuilderDetails.fromJson(Map<String, dynamic> json) {
    builderId = json['builderId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailId = json['emailId'];
    mobileNumber = json['mobileNumber'];
    password = json['password'];
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
    operatingCities = json['operatingCities'].cast<String>();
    experience = json['experience'];
    builderOverview = json['builderOverview'];
    missionAndValues = json['missionAndValues'];
    reasonToChoose = json['reasonToChoose'];
    salesTeam = json['salesTeam'];
    companyFbUrl = json['companyFbUrl'];
    companyTwitterUrl = json['companyTwitterUrl'];
    companyLinkedinUrl = json['companyLinkedinUrl'];
    companyIgUrl = json['companyIgUrl'];
    affiliations = json['affiliations'];
    builderRegistrationNo = json['builderRegistrationNo'];
    operatingHours = json['operatingHours'];
    reraId = json['reraId'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['builderId'] = this.builderId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['emailId'] = this.emailId;
    data['mobileNumber'] = this.mobileNumber;
    data['password'] = this.password;
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
    data['builderOverview'] = this.builderOverview;
    data['missionAndValues'] = this.missionAndValues;
    data['reasonToChoose'] = this.reasonToChoose;
    data['salesTeam'] = this.salesTeam;
    data['companyFbUrl'] = this.companyFbUrl;
    data['companyTwitterUrl'] = this.companyTwitterUrl;
    data['companyLinkedinUrl'] = this.companyLinkedinUrl;
    data['companyIgUrl'] = this.companyIgUrl;
    data['affiliations'] = this.affiliations;
    data['builderRegistrationNo'] = this.builderRegistrationNo;
    data['operatingHours'] = this.operatingHours;
    data['reraId'] = this.reraId;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}

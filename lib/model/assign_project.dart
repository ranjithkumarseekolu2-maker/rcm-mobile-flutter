class AssignProject {
  JobMappingDetails? jobMappingDetails;

  AssignProject({this.jobMappingDetails});

  AssignProject.fromJson(Map<String, dynamic> json) {
    jobMappingDetails = json['jobMappingDetails'] != null
        ? new JobMappingDetails.fromJson(json['jobMappingDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jobMappingDetails != null) {
      data['jobMappingDetails'] = this.jobMappingDetails!.toJson();
    }
    return data;
  }
}

class JobMappingDetails {
  List<String>? contactIds;
  String? projectId;
  String? agentId;
  String? builderId;

  JobMappingDetails(
      {this.contactIds, this.projectId, this.agentId, this.builderId});

  JobMappingDetails.fromJson(Map<String, dynamic> json) {
    contactIds = json['contactIds'].cast<String>();
    projectId = json['projectId'];
    agentId = json['agentId'];
    builderId = json['builderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactIds'] = this.contactIds;
    data['projectId'] = this.projectId;
    data['agentId'] = this.agentId;
    data['builderId'] = this.builderId;
    return data;
  }
}

class BuddyNotification {
  String? notificationId;
  String? builderId;
  String? marketingAgencyId;
  String? projectId;
  String? notificationText;
  String? type;
  int? status;
  String? createdAt;

  BuddyNotification(
      {this.notificationId,
      this.builderId,
      this.marketingAgencyId,
      this.projectId,
      this.notificationText,
      this.type,
      this.status,
      this.createdAt});

  BuddyNotification.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    builderId = json['builderId'];
    marketingAgencyId = json['marketingAgencyId'];
    projectId = json['projectId'];
    notificationText = json['notificationText'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  get startDate => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationId'] = this.notificationId;
    data['builderId'] = this.builderId;
    data['marketingAgencyId'] = this.marketingAgencyId;
    data['projectId'] = this.projectId;
    data['notificationText'] = this.notificationText;
    data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }

  // Helper method to convert `createdAt` to DateTime
  DateTime get createdAtDateTime => DateTime.parse(createdAt!);
}

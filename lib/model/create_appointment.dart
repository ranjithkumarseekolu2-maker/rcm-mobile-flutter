class CreateAppointment {
  String? agentId;
  String? userId;
  String? title;
  String? description;
  String? startDateTime;
  String? endDateTime;
  String? location;
  String? userName;

  CreateAppointment(
      {this.agentId,
      this.userId,
      this.title,
      this.description,
      this.startDateTime,
      this.endDateTime,
      this.location,
      this.userName
      });

  CreateAppointment.fromJson(Map<String, dynamic> json) {
    agentId = json['agentId'];
    userId = json['userId'];
    title = json['title'];
    description = json['description'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    location = json['location'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentId'] = this.agentId;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['location'] = this.location;
    data['userName'] = this.userName;
    return data;
  }
}

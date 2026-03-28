class UpdateAppointment {
  int? id;
  String? title;
  String? description;
  String? startDateTime;
  String? endDateTime;
  String? location;
  String? status;

  UpdateAppointment(
      {this.id,
      this.title,
      this.description,
      this.startDateTime,
      this.endDateTime,
      this.location,
      this.status});

  UpdateAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    location = json['location'];
    status = json['status'];
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['location'] = this.location;
    data['status'] = this.status;
    return data;
  }
}

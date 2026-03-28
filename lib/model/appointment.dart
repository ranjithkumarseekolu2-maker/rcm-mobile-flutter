class Appointment {
  int? appointmentId;
  String? agentId;
  String? userId;
  String? userName;
  String? title;
  String? description;
  String? startDateTime;
  String? endDateTime;
  String? location;
  String? status;
  Contacts? contact;

  Appointment({
    this.appointmentId,
    this.agentId,
    this.userId,
    this.userName,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.location,
    this.status,
    this.contact,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    agentId = json['agentId'];
    userId = json['userId'];
    userName = json['userName'];
    title = json['title'];
    description = json['description'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    location = json['location'];
    status = json['status'];
    contact = json['contact'] != null ? Contacts.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appointmentId'] = this.appointmentId;
    data['agentId'] = this.agentId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['title'] = this.title;
    data['description'] = this.description;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    data['location'] = this.location;
    data['status'] = this.status;
    data['contact'] = this.contact?.toJson();

    return data;
  }

  DateTime get startDate => DateTime.parse(startDateTime!);
}

class Contacts {
  final String conId;
  final String primaryNumber;

  Contacts({
    required this.conId,
    required this.primaryNumber,
  });

  factory Contacts.fromJson(Map<String, dynamic> json) {
    return Contacts(
      conId: json['CON_ID'] as String,
      primaryNumber: json['PRIMARY_NUMBER'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CON_ID': conId,
      'PRIMARY_NUMBER': primaryNumber,
    };
  }
}

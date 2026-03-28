class ReferBuddy {
  String? projectUrl;
  String? projectId;
  List<Contacts>? contacts;

  ReferBuddy({this.projectUrl, this.projectId, this.contacts});

  ReferBuddy.fromJson(Map<String, dynamic> json) {
    projectUrl = json['projectUrl'];
    projectId = json['projectId'];
    if (json['contacts'] != null) {
      contacts = <Contacts>[];
      json['contacts'].forEach((v) {
        contacts!.add(new Contacts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['projectUrl'] = this.projectUrl;
    data['projectId'] = this.projectId;
    if (this.contacts != null) {
      data['contacts'] = this.contacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Contacts {
  String? conId;
  String? mobileNumber;
  int? status;

  Contacts({this.conId, this.mobileNumber, this.status});

  Contacts.fromJson(Map<String, dynamic> json) {
    conId = json['conId'];
    mobileNumber = json['mobileNumber'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conId'] = this.conId;
    data['mobileNumber'] = this.mobileNumber;
    data['status'] = this.status;
    return data;
  }
}

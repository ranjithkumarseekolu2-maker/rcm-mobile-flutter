class Country {
  String? cntId;
  String? name;
  int? status;
  String? dateCreated;

  Country({this.cntId, this.name, this.status, this.dateCreated});

  Country.fromJson(Map<String, dynamic> json) {
    cntId = json['cntId'];
    name = json['name'];
    status = json['status'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cntId'] = this.cntId;
    data['name'] = this.name;
    data['status'] = this.status;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}

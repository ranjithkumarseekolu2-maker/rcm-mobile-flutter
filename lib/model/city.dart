 class City {
  String? citId;
  String? name;

  City({this.citId, this.name});

  City.fromJson(Map<String, dynamic> json) {
    citId = json['citId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['citId'] = this.citId;
    data['name'] = this.name;
    return data;
  }
}

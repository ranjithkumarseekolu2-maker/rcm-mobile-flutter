class ProjectState {
  String? sttId;
  String? name;

  ProjectState({this.sttId, this.name});

  ProjectState.fromJson(Map<String, dynamic> json) {
    sttId = json['sttId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sttId'] = this.sttId;
    data['name'] = this.name;
    return data;
  }
}

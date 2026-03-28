class UpdateFile {
  FileDetails? fileDetails;

  UpdateFile({this.fileDetails});

  UpdateFile.fromJson(Map<String, dynamic> json) {
    fileDetails = json['fileDetails'] != null
        ? new FileDetails.fromJson(json['fileDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fileDetails != null) {
      data['fileDetails'] = this.fileDetails!.toJson();
    }
    return data;
  }
}

class FileDetails {
  String? title;
  String? description;
  List<String>? category;
  String? fileId;

  FileDetails({this.title, this.description, this.category, this.fileId});

  FileDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    category = json['category'].cast<String>();
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['category'] = this.category;
    data['fileId'] = this.fileId;
    return data;
  }
}

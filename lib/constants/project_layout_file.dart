import 'dart:io';

class ProjectLayoutFile {
  String? category;
  String? description;
  String? fileId;
  String? fileType;
  String? name;
  String? size;
  int? status;
  String? title;
  String? type;
  String? url;
  File? file;
  String? path;

  ProjectLayoutFile(
      {this.category,
      this.description,
      this.fileId,
      this.fileType,
      this.name,
      this.size,
      this.status,
      this.title,
      this.type,
      this.url,
      this.file,
      this.path
      });

  ProjectLayoutFile.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    description = json['description'];
    fileId = json['fileId'];
    fileType = json['fileType'];
    name = json['name'];
    size = json['size'];
    status = json['status'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
    file = json['file'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['description'] = this.description;
    data['fileId'] = this.fileId;
    data['fileType'] = this.fileType;
    data['name'] = this.name;
    data['size'] = this.size;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    data['url'] = this.url;
    data['file'] = this.file;
    data['path'] = this.path;
    return data;
  }
}

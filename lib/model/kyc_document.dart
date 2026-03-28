class KYCDocument {
  String? fILEID;
  String? nAME;
  String? sIZE;
  String? tYPE;
  String? uRL;
  String? fILETYPE;
  int? sTATUS;
  String? path;

  KYCDocument(
      {this.fILEID,
      this.nAME,
      this.sIZE,
      this.tYPE,
      this.uRL,
      this.fILETYPE,
      this.sTATUS,
      this.path
      });

  KYCDocument.fromJson(Map<String, dynamic> json) {
    fILEID = json['FILE_ID'];
    nAME = json['NAME'];
    sIZE = json['SIZE'];
    tYPE = json['TYPE'];
    uRL = json['URL'];
    fILETYPE = json['FILE_TYPE'];
    sTATUS = json['STATUS'];
    path = json["path"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FILE_ID'] = this.fILEID;
    data['NAME'] = this.nAME;
    data['SIZE'] = this.sIZE;
    data['TYPE'] = this.tYPE;
    data['URL'] = this.uRL;
    data['FILE_TYPE'] = this.fILETYPE;
    data['STATUS'] = this.sTATUS;
    data['path'] = this.path;
    return data;
  }
}

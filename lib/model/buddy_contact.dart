class BuddyContact {
  String? cONID;
  String? fIRSTNAME;
  int? pRIMARYNUMBER;
  String? lASTNAME;
  String? eMAIL;

  BuddyContact(
      {this.cONID,
      this.fIRSTNAME,
      this.pRIMARYNUMBER,
      this.lASTNAME,
      this.eMAIL});

  BuddyContact.fromJson(Map<String, dynamic> json) {
    cONID = json['CON_ID'];
    fIRSTNAME = json['FIRST_NAME'];
    pRIMARYNUMBER = json['PRIMARY_NUMBER'];
    lASTNAME = json['LAST_NAME'];
    eMAIL = json['EMAIL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CON_ID'] = this.cONID;
    data['FIRST_NAME'] = this.fIRSTNAME;
    data['PRIMARY_NUMBER'] = this.pRIMARYNUMBER;
    data['LAST_NAME'] = this.lASTNAME;
    data['EMAIL'] = this.eMAIL;
    return data;
  }
}

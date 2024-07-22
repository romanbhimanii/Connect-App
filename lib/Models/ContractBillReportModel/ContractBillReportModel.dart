class ContractBillReportModel {
  String? status;
  String? message;
  List<Data>? data;

  ContractBillReportModel({this.status, this.message, this.data});

  ContractBillReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? generateDate;
  String? clientId;
  String? clientName;
  String? path;
  String? docfilename;
  String? doctype;

  Data(
      {this.generateDate,
        this.clientId,
        this.clientName,
        this.path,
        this.docfilename,
        this.doctype});

  Data.fromJson(Map<String, dynamic> json) {
    generateDate = json['generate_date'];
    clientId = json['client_id'];
    clientName = json['client_name'];
    path = json['path'];
    docfilename = json['docfilename'];
    doctype = json['doctype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['generate_date'] = generateDate;
    data['client_id'] = clientId;
    data['client_name'] = clientName;
    data['path'] = path;
    data['docfilename'] = docfilename;
    data['doctype'] = doctype;
    return data;
  }
}

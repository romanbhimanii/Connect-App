class PayOutModel {
  String? status;
  String? message;
  List<Data>? data;

  PayOutModel({this.status, this.message, this.data});

  PayOutModel.fromJson(Map<String, dynamic> json) {
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
  String? uCC;
  String? entryDate;
  String? bankAccNo;
  String? amount;

  Data({this.uCC, this.entryDate, this.bankAccNo, this.amount});

  Data.fromJson(Map<String, dynamic> json) {
    uCC = json['UCC'].toString();
    entryDate = json['EntryDate'].toString();
    bankAccNo = json['BankAccNo'].toString();
    amount = json['Amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UCC'] = uCC;
    data['EntryDate'] = entryDate;
    data['BankAccNo'] = bankAccNo;
    data['Amount'] = amount;
    return data;
  }
}

class TotalBalanceModel {
  String status;
  String message;
  Data data;

  TotalBalanceModel({required this.status, required this.message, required this.data});

  factory TotalBalanceModel.fromJson(Map<String, dynamic> json) {
    return TotalBalanceModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Data {
  Ledger ledger;
  Margin margin;
  String holding;

  Data({required this.ledger, required this.margin, required this.holding});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      ledger: Ledger.fromJson(json['ledger'] as Map<String, dynamic>),
      margin: Margin.fromJson(json['margin'] as Map<String, dynamic>),
      holding: json['holding'] as String,
    );
  }
}

class Ledger {
  String other;
  String group1;
  String group2;

  Ledger({required this.other, required this.group1, required this.group2});

  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      other: json['other'].toString(),
      group1: json['group1'].toString(),
      group2: json['group2'].toString(),
    );
  }
}

class Margin {
  String bseCash;
  String nseCash;
  String nseFno;
  String mcx;

  Margin({required this.bseCash, required this.nseCash, required this.nseFno, required this.mcx});

  factory Margin.fromJson(Map<String, dynamic> json) {
    return Margin(
      bseCash: json['BSE_CASH'].toString(),
      nseCash: json['NSE_CASH'].toString(),
      nseFno: json['NSE_FNO'].toString(),
      mcx: json['MCX'].toString(),
    );
  }
}

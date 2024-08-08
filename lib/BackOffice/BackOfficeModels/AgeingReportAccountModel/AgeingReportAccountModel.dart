// ageing_report_model.dart

class AgeingReport {
  final String status;
  final String message;
  final List<ClientData> data;

  AgeingReport({required this.status, required this.message, required this.data});

  factory AgeingReport.fromJson(Map<String, dynamic> json) {
    return AgeingReport(
      status: json['status'],
      message: json['message'],
      data: List<ClientData>.from(json['data'].map((item) => ClientData.fromJson(item))),
    );
  }
}

class ClientData {
  final String cocd;
  final String clientname;
  final String clientId;
  final String amount;
  final String amt2;
  final String amt7;
  final String amt5;
  final String amt9;
  final String amt11;
  final String amt7Alt;

  ClientData({
    required this.cocd,
    required this.clientname,
    required this.clientId,
    required this.amount,
    required this.amt2,
    required this.amt5,
    required this.amt7,
    required this.amt9,
    required this.amt11,
    required this.amt7Alt,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      cocd: json['cocd'].toString(),
      clientname: json['clientname'].toString(),
      clientId: json['client_id'].toString(),
      amount: json['amount'].toString(),
      amt2: json['amt_2'].toString(),
      amt5: json['amt_5'].toString(),
      amt7: json['amt_7'].toString(),
      amt9: json['amt_9'].toString(),
      amt11: json['amt_11'].toString(),
      amt7Alt: json['amt7'].toString(),
    );
  }
}

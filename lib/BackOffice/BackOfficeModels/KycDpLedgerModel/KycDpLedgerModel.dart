class DpLedgerReport {
  final String status;
  final String message;
  final List<DpLedgerData> data;

  DpLedgerReport({required this.status, required this.message, required this.data});

  factory DpLedgerReport.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<DpLedgerData> dataItems = dataList.map((i) => DpLedgerData.fromJson(i)).toList();

    return DpLedgerReport(
      status: json['status'],
      message: json['message'],
      data: dataItems,
    );
  }
}

class DpLedgerData {
  String date;
  String voucher;
  String voucherno;
  String code;
  String narration;
  String chqno;
  String receiveDate;
  String drAmt;
  String crAmt;
  String balance;
  String srNo;

  DpLedgerData({
    required this.date,
    required this.voucher,
    required this.voucherno,
    required this.code,
    required this.narration,
    required this.chqno,
    required this.receiveDate,
    required this.drAmt,
    required this.crAmt,
    required this.balance,
    required this.srNo,
  });

  factory DpLedgerData.fromJson(Map<String, dynamic> json) {
    return DpLedgerData(
      date: json['date'].toString(),
      voucher: json['voucher'].toString(),
      voucherno: json['voucherno'].toString(),
      code: json['code'].toString(),
      narration: json['narration'].toString(),
      chqno: json['chqno'].toString(),
      receiveDate: json['receive_date'].toString(),
      drAmt: json['dr_amt'].toString(),
      crAmt: json['cr_amt'].toString(),
      balance: json['balance'].toString(),
      srNo: json['sr_no'].toString(),
    );
  }
}

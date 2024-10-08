class LedgerReport {
  final String status;
  final String message;
  final List<ReportData> data;

  LedgerReport({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LedgerReport.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ReportData> dataList = list.map((i) => ReportData.fromJson(i)).toList();

    return LedgerReport(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class ReportData {
  final String billDate;
  final String voucherDate;
  final String voucherNo;
  final String cocd;
  final String narration;
  final String chqNo;
  final String drAmt;
  final String crAmt;
  final String balance;

  ReportData({
    required this.billDate,
    required this.voucherDate,
    required this.voucherNo,
    required this.cocd,
    required this.narration,
    required this.chqNo,
    required this.drAmt,
    required this.crAmt,
    required this.balance,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      billDate: json['bill_date'].toString(),
      voucherDate: json['voucherdate'].toString(),
      voucherNo: json['voucherno'].toString(),
      cocd: json['cocd'].toString(),
      narration: json['narration'].toString(),
      chqNo: json['chqno'].toString(),
      drAmt: json['dr_amt'].toString(),
      crAmt: json['cr_amt'].toString(),
      balance: json['balance'].toString(),
    );
  }
}

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
  final double drAmt;
  final double crAmt;
  final double balance;

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
      billDate: json['bill_date'],
      voucherDate: json['voucherdate'],
      voucherNo: json['voucherno'],
      cocd: json['cocd'],
      narration: json['narration'],
      chqNo: json['chqno'].toString(),
      drAmt: json['dr_amt'],
      crAmt: json['cr_amt'],
      balance: json['balance'],
    );
  }
}

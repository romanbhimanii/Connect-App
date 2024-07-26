class FundPayinResponse {
  final String status;
  final String message;
  final List<FundPayinData> data;

  FundPayinResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FundPayinResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<FundPayinData> dataList = list.map((i) => FundPayinData.fromJson(i)).toList();

    return FundPayinResponse(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class FundPayinData {
  final String clientCode;
  final String segment;
  final String txnAmt;
  final String accountNo;
  final String txnDate;

  FundPayinData({
    required this.clientCode,
    required this.segment,
    required this.txnAmt,
    required this.accountNo,
    required this.txnDate,
  });

  factory FundPayinData.fromJson(Map<String, dynamic> json) {
    return FundPayinData(
      clientCode: json['client_code'].toString(),
      segment: json['segment'].toString(),
      txnAmt: json['txn_amt'].toString(),
      accountNo: json['account_no'].toString(),
      txnDate: json['txn_date'].toString(),
    );
  }
}
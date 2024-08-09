class GlobalSummaryBrokerageResponse {
  String status;
  String message;
  List<BrokerageData> data;

  GlobalSummaryBrokerageResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GlobalSummaryBrokerageResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<BrokerageData> dataItems = dataList.map((i) => BrokerageData.fromJson(i)).toList();

    return GlobalSummaryBrokerageResponse(
      status: json['status'],
      message: json['message'],
      data: dataItems,
    );
  }
}

class BrokerageData {
  String branchCodeName;
  String companyCode;
  String clientId;
  String clientName;
  String netBrk;
  String clientBrokerage;
  String remeshireBrokerage;

  BrokerageData({
    required this.branchCodeName,
    required this.companyCode,
    required this.clientId,
    required this.clientName,
    required this.netBrk,
    required this.clientBrokerage,
    required this.remeshireBrokerage,
  });

  factory BrokerageData.fromJson(Map<String, dynamic> json) {
    return BrokerageData(
      branchCodeName: json['branchcodename'].toString(),
      companyCode: json['company_code'].toString(),
      clientId: json['client_id'].toString(),
      clientName: json['client_name'].toString(),
      netBrk: json['net_brk'].toString(),
      clientBrokerage: json['client_brokerage'].toString(),
      remeshireBrokerage: json['remeshire_brokerage'].toString(),
    );
  }
}

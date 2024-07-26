class PositionReportResponse {
  String status;
  String message;
  PositionReportData? data;
  TotalData? totalData;

  PositionReportResponse({
    required this.status,
    required this.message,
    this.data,
    this.totalData,
  });

  factory PositionReportResponse.fromJson(Map<String, dynamic> json) {
    return PositionReportResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? PositionReportData.fromJson(json['data']['data']) : null,
      totalData: json['data'] != null ? TotalData.fromJson(json['data']['data']['total']) : null,
    );
  }
}

class PositionReportData {
  List<PositionData> dfFilter;

  PositionReportData({required this.dfFilter});

  factory PositionReportData.fromJson(Map<String, dynamic> json) {
    var list = json['df_filter'] as List;
    List<PositionData> dfFilterList = list.map((i) => PositionData.fromJson(i)).toList();

    return PositionReportData(
      dfFilter: dfFilterList,
    );
  }
}

class PositionData {
  String description;
  String position;
  String osqty;
  String osrate;
  String closingPrice;
  String amount;

  PositionData({
    required this.description,
    required this.position,
    required this.osqty,
    required this.osrate,
    required this.closingPrice,
    required this.amount,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) {
    return PositionData(
      description: json['description'].toString(),
      position: json['position'].toString(),
      osqty: json['osqty'].toString(),
      osrate: json['osrate'].toString(),
      closingPrice: json['closing_price'].toString(),
      amount: json['amount'].toString(),
    );
  }
}

class TotalData {
  String osqty;
  String amount;

  TotalData({required this.osqty, required this.amount});

  factory TotalData.fromJson(Map<String, dynamic> json) {
    return TotalData(
      osqty: json['osqty'].toString(),
      amount: json['amount'].toString(),
    );
  }
}
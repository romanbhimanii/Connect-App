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
  double osqty;
  double osrate;
  double closingPrice;
  double amount;

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
      description: json['description'],
      position: json['position'],
      osqty: json['osqty'].toDouble(),
      osrate: json['osrate'].toDouble(),
      closingPrice: json['closing_price'].toDouble(),
      amount: json['amount'].toDouble(),
    );
  }
}

class TotalData {
  double osqty;
  double amount;

  TotalData({required this.osqty, required this.amount});

  factory TotalData.fromJson(Map<String, dynamic> json) {
    return TotalData(
      osqty: json['osqty'].toDouble(),
      amount: json['amount'].toDouble(),
    );
  }
}
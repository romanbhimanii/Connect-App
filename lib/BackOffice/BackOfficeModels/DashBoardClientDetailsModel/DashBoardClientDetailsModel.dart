import 'dart:convert';

class ClientDetail {
  final String clientId;
  final String boName;
  final String boPanNo;
  final String accOpenDate;
  final String tradeStatus;

  ClientDetail({
    required this.clientId,
    required this.boName,
    required this.boPanNo,
    required this.accOpenDate,
    required this.tradeStatus,
  });

  factory ClientDetail.fromJson(Map<String, dynamic> json) {
    return ClientDetail(
      clientId: json['client_id'].toString(),
      boName: json['bo_name'].toString(),
      boPanNo: json['bo_pan_no'].toString(),
      accOpenDate: json['acc_open_date'].toString(),
      tradeStatus: json['trade_status'].toString(),
    );
  }
}

class ApiResponse {
  final String status;
  final String message;
  final List<ClientDetail> data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(String source) {
    final json = jsonDecode(source);
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((e) => ClientDetail.fromJson(e)).toList(),
    );
  }
}

import 'dart:convert';

class ClientBidReport {
  final String symbol;
  final String applicationNo;
  final String clientCode;
  final String clientName;
  final String status;
  final String reason;
  final String category;
  final String? mandateStatus;
  final String clientBenId;
  final String timestamp;
  final String upi;
  final String bidAmount;
  final String bidQty;
  final String bidReferenceNo;
  final double price;

  ClientBidReport({
    required this.symbol,
    required this.applicationNo,
    required this.clientCode,
    required this.clientName,
    required this.status,
    required this.reason,
    required this.category,
    this.mandateStatus,
    required this.clientBenId,
    required this.timestamp,
    required this.upi,
    required this.bidAmount,
    required this.bidQty,
    required this.bidReferenceNo,
    required this.price,
  });

  factory ClientBidReport.fromJson(Map<String, dynamic> json) {
    return ClientBidReport(
      symbol: json['symbol'],
      applicationNo: json['application_no'],
      clientCode: json['client_code'],
      clientName: json['client_name'],
      status: json['status'],
      reason: json['reason'],
      category: json['category'],
      mandateStatus: json['mandate_status'],
      clientBenId: json['clientbenid'],
      timestamp: json['timestamp'],
      upi: json['upi'],
      bidAmount: json['bid_amount'],
      bidQty: json['bid_qty'],
      bidReferenceNo: json['bid_refrence_no'],
      price: json['price'],
    );
  }
}

class ClientBidReportResponse {
  final String status;
  final String message;
  final List<ClientBidReport> data;

  ClientBidReportResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ClientBidReportResponse.fromJson(String str) {
    final jsonData = json.decode(str);
    return ClientBidReportResponse(
      status: jsonData['status'],
      message: jsonData['message'],
      data: List<ClientBidReport>.from(
        jsonData['data'].map((x) => ClientBidReport.fromJson(x)),
      ),
    );
  }
}

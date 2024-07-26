class HoldingDataResponse {
  final String status;
  final String message;
  final List<Holding> data;

  HoldingDataResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HoldingDataResponse.fromJson(Map<String, dynamic> json) {
    return HoldingDataResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Holding.fromJson(item))
          .toList(),
    );
  }
}

class Holding {
  final String scripName;
  final String isin;
  final String freeQty;
  final String pledgeQty;
  final String colQty;
  final String net;
  final String scripValue;
  final String amount;

  Holding({
    required this.scripName,
    required this.isin,
    required this.freeQty,
    required this.pledgeQty,
    required this.colQty,
    required this.net,
    required this.scripValue,
    required this.amount,
  });

  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      scripName: json['scrip_name'].toString(),
      isin: json['isin'].toString(),
      freeQty: json['freeqty'].toString(),
      pledgeQty: json['pledgeqty'].toString(),
      colQty: json['colqty'].toString(),
      net: json['net'].toString(),
      scripValue: json['scrip_value'].toString(),
      amount: json['amount'].toString(),
    );
  }
}

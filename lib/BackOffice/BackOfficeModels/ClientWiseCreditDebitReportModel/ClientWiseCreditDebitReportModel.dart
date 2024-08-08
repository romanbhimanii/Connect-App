class ClientWiseDrCr {
  final String clientName;
  final String clientId;
  final String ledger;
  final String virtualDr;

  ClientWiseDrCr({
    required this.clientName,
    required this.clientId,
    required this.ledger,
    required this.virtualDr,
  });

  factory ClientWiseDrCr.fromJson(Map<String, dynamic> json) {
    return ClientWiseDrCr(
      clientName: json['client_name'].toString(),
      clientId: json['client_id'].toString(),
      ledger: json['ledger'].toString(),
      virtualDr: json['virtualdr'].toString(),
    );
  }
}

class ApiResponse1 {
  final String status;
  final String message;
  final List<ClientWiseDrCr> data;

  ApiResponse1({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse1.fromJson(Map<String, dynamic> json) {
    return ApiResponse1(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((i) => ClientWiseDrCr.fromJson(i))
          .toList(),
    );
  }
}

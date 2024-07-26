class DetailedFileResponse {
  final String status;
  final String message;
  final ClientData data;

  DetailedFileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DetailedFileResponse.fromJson(Map<String, dynamic> json) {
    return DetailedFileResponse(
      status: json['status'],
      message: json['message'],
      data: ClientData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ClientData {
  final String clientName;
  final String clientDpCode;
  final String resiAddress;
  final String uccStatus;
  final String panNo;

  ClientData({
    required this.clientName,
    required this.clientDpCode,
    required this.resiAddress,
    required this.uccStatus,
    required this.panNo,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      clientName: json['client_name'],
      clientDpCode: json['client_dp_code'],
      resiAddress: json['resi_address'],
      uccStatus: json['ucc_status'],
      panNo: json['pan_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_name': clientName,
      'client_dp_code': clientDpCode,
      'resi_address': resiAddress,
      'ucc_status': uccStatus,
      'pan_no': panNo,
    };
  }
}

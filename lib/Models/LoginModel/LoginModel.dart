class LoginResponse {
  final String status;
  final int message;
  final Data data;

  LoginResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      data: Data.fromJson(json['data']),
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

class Data {
  final String token;
  final String username;
  final String clientCode;

  Data({
    required this.token,
    required this.username,
    required this.clientCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      token: json['token'],
      username: json['username'],
      clientCode: json['client_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'client_code': clientCode,
    };
  }
}

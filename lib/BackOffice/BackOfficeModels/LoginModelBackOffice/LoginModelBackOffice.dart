class LoginModelBackOffice {
  String? status;
  String? message;
  Data? data;

  LoginModelBackOffice({this.status, this.message, this.data});

  LoginModelBackOffice.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  String? branchCode;
  String? userType;

  Data({this.token, this.branchCode, this.userType});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    branchCode = json['branch_code'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['branch_code'] = branchCode;
    data['user_type'] = userType;
    return data;
  }
}

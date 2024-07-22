class BankDetailsResponse {
  final String status;
  final String message;
  final BankDetails data;

  BankDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BankDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: BankDetails.fromJson(json['data']['bank_details']),
    );
  }
}

class BankDetails {
  final Map<String, String> bankName;
  final Map<String, String> bankAccountNumber;
  final Map<String, String> ifscCode;
  final Map<String, String> micrCode;
  final Map<String, String> bankAccountType;
  final Map<String, String> defaultAccount;

  BankDetails({
    required this.bankName,
    required this.bankAccountNumber,
    required this.ifscCode,
    required this.micrCode,
    required this.bankAccountType,
    required this.defaultAccount,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      bankName: Map<String, String>.from(json['bank_name']),
      bankAccountNumber: Map<String, String>.from(json['bank_acno']),
      ifscCode: Map<String, String>.from(json['ifsc_code_act']),
      micrCode: Map<String, String>.from(json['micr_code']),
      bankAccountType: Map<String, String>.from(json['bank_acctype']),
      defaultAccount: Map<String, String>.from(json['default_ac']),
    );
  }
}

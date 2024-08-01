class TradingDetailsResponse {
  String status;
  String message;
  List<TradingDetail> data;

  TradingDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TradingDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TradingDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: List<TradingDetail>.from(
          json['data'].map((x) => TradingDetail.fromJson(x))),
    );
  }
}

class TradingDetail {
  String companyCode;
  String micrCode;
  String bankAcno;
  String bankName;
  String clientDpCode;
  String dpId;
  String dpName;
  String remeshireGroup;
  String remeshireName;
  String clientId;
  String clientName;
  String clResiAdd1;
  String clResiAdd2;
  String clResiAdd3;
  String mobileNo;
  String clientIdMail;
  String panNo;

  TradingDetail({
    required this.companyCode,
    required this.micrCode,
    required this.bankAcno,
    required this.bankName,
    required this.clientDpCode,
    required this.dpId,
    required this.dpName,
    required this.remeshireGroup,
    required this.remeshireName,
    required this.clientId,
    required this.clientName,
    required this.clResiAdd1,
    required this.clResiAdd2,
    required this.clResiAdd3,
    required this.mobileNo,
    required this.clientIdMail,
    required this.panNo,
  });

  factory TradingDetail.fromJson(Map<String, dynamic> json) {
    return TradingDetail(
      companyCode: json['company_code'].toString(),
      micrCode: json['micr_code'].toString(),
      bankAcno: json['bank_acno'].toString(),
      bankName: json['bank_name'].toString(),
      clientDpCode: json['client_dp_code'].toString(),
      dpId: json['dp_id'].toString(),
      dpName: json['dp_name'].toString(),
      remeshireGroup: json['remeshire_group'].toString(),
      remeshireName: json['remeshire_name'].toString(),
      clientId: json['client_id'].toString(),
      clientName: json['client_name'].toString(),
      clResiAdd1: json['cl_resi_add1'].toString(),
      clResiAdd2: json['cl_resi_add2'].toString(),
      clResiAdd3: json['cl_resi_add3'].toString(),
      mobileNo: json['mobile_no'].toString(),
      clientIdMail: json['client_id_mail'].toString(),
      panNo: json['pan_no'].toString(),
    );
  }
}

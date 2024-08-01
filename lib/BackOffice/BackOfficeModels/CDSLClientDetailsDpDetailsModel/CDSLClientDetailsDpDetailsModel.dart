// dp_details_model.dart

class DPDetails {
  final String branchCode;
  final String tradingClientId;
  final String boId;
  final String firstHoldName;
  final String itpaNo;
  final String accStat;
  final String boSubStat;
  final String accOpenDate;
  final String boDob;
  final String boAdd1;
  final String boAdd2;
  final String boAdd3;
  final String boAddCity;
  final String boAddState;
  final String boAddCountry;
  final String boAddPin;
  final String mobileNum;
  final String emailId;
  final String bankName;
  final String bankAccNo;
  final String micrCode;
  final String secondHoldName;
  final String? panNo2;
  final String thirdHoldName;
  final String? panNo3;
  final String poaName;
  final String poaEnabled;
  final String? nominName;
  final String riskCategory;
  final String? guardianPanNo;

  DPDetails({
    required this.branchCode,
    required this.tradingClientId,
    required this.boId,
    required this.firstHoldName,
    required this.itpaNo,
    required this.accStat,
    required this.boSubStat,
    required this.accOpenDate,
    required this.boDob,
    required this.boAdd1,
    required this.boAdd2,
    required this.boAdd3,
    required this.boAddCity,
    required this.boAddState,
    required this.boAddCountry,
    required this.boAddPin,
    required this.mobileNum,
    required this.emailId,
    required this.bankName,
    required this.bankAccNo,
    required this.micrCode,
    required this.secondHoldName,
    this.panNo2,
    required this.thirdHoldName,
    this.panNo3,
    required this.poaName,
    required this.poaEnabled,
    this.nominName,
    required this.riskCategory,
    this.guardianPanNo,
  });

  factory DPDetails.fromJson(Map<String, dynamic> json) {
    return DPDetails(
      branchCode: json['BRANCH_CODE'].toString(),
      tradingClientId: json['TRADING_CLIENT_ID'].toString(),
      boId: json['BO_ID'].toString(),
      firstHoldName: json['FIRST_HOLD_NAME'].toString(),
      itpaNo: json['ITPA_NO'].toString(),
      accStat: json['ACC_STAT'].toString(),
      boSubStat: json['BO_SUB_STAT'].toString(),
      accOpenDate: json['ACC_OPEN_DAT'].toString(),
      boDob: json['BO_DOB'].toString(),
      boAdd1: json['BO_ADD1'].toString(),
      boAdd2: json['BO_ADD2'].toString(),
      boAdd3: json['BO_ADD3'].toString(),
      boAddCity: json['BO_ADD_CITY'].toString(),
      boAddState: json['BO_ADD_STATE'].toString(),
      boAddCountry: json['BO_ADD_COUNTRY'].toString(),
      boAddPin: json['BO_ADD_PIN'].toString(),
      mobileNum: json['MOBILE_NUM'].toString(),
      emailId: json['EMAIL_ID'].toString(),
      bankName: json['BANK_NAM'].toString(),
      bankAccNo: json['BANK_ACC_NO'].toString(),
      micrCode: json['MICR_CODE'].toString(),
      secondHoldName: json['SECOND_HOLD_NAM'].toString(),
      panNo2: json['PAN_NO_2'].toString(),
      thirdHoldName: json['THIRD_HOLD_NAM'].toString(),
      panNo3: json['PAN_NO_3'].toString(),
      poaName: json['POA_NAME'].toString(),
      poaEnabled: json['POA_ENABLED'].toString(),
      nominName: json['NOMIN_NAM'].toString(),
      riskCategory: json['Risk_catg'].toString(),
      guardianPanNo: json['Guardian_PANNO'].toString(),
    );
  }
}

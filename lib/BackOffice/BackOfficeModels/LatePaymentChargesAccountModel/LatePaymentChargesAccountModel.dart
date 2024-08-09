class LatePaymentCharges {
  String status;
  String message;
  List<ChargeData> data;

  LatePaymentCharges({required this.status, required this.message, required this.data});

  factory LatePaymentCharges.fromJson(Map<String, dynamic> json) {
    return LatePaymentCharges(
      status: json['status'],
      message: json['message'],
      data: List<ChargeData>.from(json['data'].map((x) => ChargeData.fromJson(x))),
    );
  }
}

class ChargeData {
  String grp;
  String othD;
  String totalCollateralE;
  String totalMargin;
  String pickMargin;
  String applicableMargin;
  String marginShort;
  String drInterest;
  String minCashMargin;
  String fundsDrInterest;
  String marginShortDrInterest;
  String tradeDate;
  String totalInterest;
  String posted;
  String fromDate;
  String toDate;
  String postLogic;
  String marginInterestPer;
  String addInterest;
  String fixIntAmt;
  String intAmountRange;
  String cocd;
  String clientId;
  String fundsDr;
  String fundsCr;
  String secB1;
  String secApplicable;
  String fdC;

  ChargeData({
    required this.grp,
    required this.othD,
    required this.totalCollateralE,
    required this.totalMargin,
    required this.pickMargin,
    required this.applicableMargin,
    required this.marginShort,
    required this.drInterest,
    required this.minCashMargin,
    required this.fundsDrInterest,
    required this.marginShortDrInterest,
    required this.tradeDate,
    required this.totalInterest,
    required this.posted,
    required this.fromDate,
    required this.toDate,
    required this.postLogic,
    required this.marginInterestPer,
    required this.addInterest,
    required this.fixIntAmt,
    required this.intAmountRange,
    required this.cocd,
    required this.clientId,
    required this.fundsDr,
    required this.fundsCr,
    required this.secB1,
    required this.secApplicable,
    required this.fdC,
  });

  factory ChargeData.fromJson(Map<String, dynamic> json) {
    return ChargeData(
      grp: json['grp'].toString(),
      othD: json['oth_d'].toString(),
      totalCollateralE: json['total_collatral_e'].toString(),
      totalMargin: json['total_margin'].toString(),
      pickMargin: json['pick_margin'].toString(),
      applicableMargin: json['applicable_margin'].toString(),
      marginShort: json['margin_short'].toString(),
      drInterest: json['dr_interest'].toString(),
      minCashMargin: json['min_cash_margin'].toString(),
      fundsDrInterest: json['funds_dr_interest'].toString(),
      marginShortDrInterest: json['marginshort_dr_interest'].toString(),
      tradeDate: json['tradedate'].toString(),
      totalInterest: json['total_interest'].toString(),
      posted: json['posted'].toString(),
      fromDate: json['from_date'].toString(),
      toDate: json['to_date'].toString(),
      postLogic: json['postlogic'].toString(),
      marginInterestPer: json['margin_interest_per'].toString(),
      addInterest: json['add_interest'].toString(),
      fixIntAmt: json['fix_int_amt'].toString(),
      intAmountRange: json['int_amount_range'].toString(),
      cocd: json['cocd'].toString(),
      clientId: json['client_id'].toString(),
      fundsDr: json['funds_dr'].toString(),
      fundsCr: json['funds_cr'].toString(),
      secB1: json['sec_b1'].toString(),
      secApplicable: json['sec_applicable'].toString(),
      fdC: json['fd_c'].toString(),
    );
  }
}

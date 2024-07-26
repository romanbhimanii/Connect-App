class GlobalDetailsResponse {
  String status;
  String message;
  List<CompanyData> data;
  GrandTotal grandTotal;

  GlobalDetailsResponse({required this.status, required this.message, required this.data, required this.grandTotal});

  factory GlobalDetailsResponse.fromJson(Map<String, dynamic> json) {
    List<CompanyData> dataList = [];
    GrandTotal? grandTotal;

    for (var entry in json['data']) {
      if (entry.containsKey('Grand_Total')) {
        grandTotal = GrandTotal.fromJson(entry['Grand_Total']);
      } else {
        dataList.add(CompanyData.fromJson(entry));
      }
    }

    return GlobalDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: dataList,
      grandTotal: grandTotal!,
    );
  }
}

class CompanyData {
  Map<String, List<ReportDetails>> companyDetails;
  Total total;

  CompanyData({required this.companyDetails, required this.total});

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    Map<String, List<ReportDetails>> details = {};
    json.forEach((key, value) {
      if (key != "Total") {
        List<ReportDetails> reportDetailsList = (value as List).map((i) => ReportDetails.fromJson(i)).toList();
        details[key] = reportDetailsList;
      }
    });

    return CompanyData(
      companyDetails: details,
      total: Total.fromJson(json['Total']),
    );
  }
}

class ReportDetails {
  String scripSymbol;
  String companyCode;
  String tradeDate;
  String narration;
  String bqty;
  String brate;
  String sqty;
  String srate;
  String netqty;
  String nrate;
  String netamt;

  ReportDetails({
    required this.scripSymbol,
    required this.companyCode,
    required this.tradeDate,
    required this.narration,
    required this.bqty,
    required this.brate,
    required this.sqty,
    required this.srate,
    required this.netqty,
    required this.nrate,
    required this.netamt,
  });

  factory ReportDetails.fromJson(Map<String, dynamic> json) {
    return ReportDetails(
      scripSymbol: json['scrip_symbol'].toString(),
      companyCode: json['company_code'].toString(),
      tradeDate: json['trade_date'].toString(),
      narration: json['narration'].toString(),
      bqty: json['bqty'].toString(),
      brate: json['brate'].toString(),
      sqty: json['sqty'].toString(),
      srate: json['srate'].toString(),
      netqty: json['netqty'].toString(),
      nrate: json['nrate'].toString(),
      netamt: json['netamt'].toString(),
    );
  }
}

class Total {
  String totalBqty;
  String totalSqty;
  String totalNetqty;
  String totalNetamt;

  Total({required this.totalBqty, required this.totalSqty, required this.totalNetqty, required this.totalNetamt});

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(
      totalBqty: json['total_bqty'].toString(),
      totalSqty: json['total_sqty'].toString(),
      totalNetqty: json['total_netqty'].toString(),
      totalNetamt: json['total_netamt'].toString(),
    );
  }
}

class GrandTotal {
  String scripSymbol;
  String totalBqty;
  String totalSqty;
  String totalNetqty;
  String totalNetamt;

  GrandTotal({required this.scripSymbol, required this.totalBqty, required this.totalSqty, required this.totalNetqty, required this.totalNetamt});

  factory GrandTotal.fromJson(Map<String, dynamic> json) {
    return GrandTotal(
      scripSymbol: json['scrip_symbol'].toString(),
      totalBqty: json['total_bqty'].toString(),
      totalSqty: json['total_sqty'].toString(),
      totalNetqty: json['total_netqty'].toString(),
      totalNetamt: json['total_netamt'].toString(),
    );
  }
}

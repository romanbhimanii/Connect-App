class HoldingModel {
  String scripName;
  String isin;
  String freeQty;
  String pledgeQty;
  String colQty;
  String net;
  String inShort;
  String outShort;
  String scripValue;
  String amount;
  String lockinQty;
  String netTotal;

  HoldingModel({
    required this.scripName,
    required this.isin,
    required this.freeQty,
    required this.pledgeQty,
    required this.colQty,
    required this.net,
    required this.inShort,
    required this.outShort,
    required this.scripValue,
    required this.amount,
    required this.lockinQty,
    required this.netTotal,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) {
    return HoldingModel(
      scripName: json['scrip_name'],
      isin: json['isin'],
      freeQty: json['freeqty'].toString(),
      pledgeQty: json['pledgeqty'].toString(),
      colQty: json['colqty'].toString(),
      net: json['net'].toString(),
      inShort: json['inshort'].toString(),
      outShort: json['outshort'].toString(),
      scripValue: json['scrip_value'].toString(),
      amount: json['amount'].toString(),
      lockinQty: json['lockinqty'].toString(),
      netTotal: json['net_total'].toString(),
    );
  }
}

class TotalsModel {
  String freeQty;
  String pledgeQty;
  String colQty;
  String net;
  String inShort;
  String outShort;
  String amount;
  String lockinQty;

  TotalsModel({
    required this.freeQty,
    required this.pledgeQty,
    required this.colQty,
    required this.net,
    required this.inShort,
    required this.outShort,
    required this.amount,
    required this.lockinQty,
  });

  factory TotalsModel.fromJson(Map<String, dynamic> json) {
    return TotalsModel(
      freeQty: json['freeqty'].toString(),
      pledgeQty: json['pledgeqty'].toString(),
      colQty: json['colqty'].toString(),
      net: json['net'].toString(),
      inShort: json['inshort'].toString(),
      outShort: json['outshort'].toString(),
      amount: json['amount'].toString(),
      lockinQty: json['lockinqty'].toString(),
    );
  }
}

class ReportResponse {
  String status;
  String message;
  List<HoldingModel> filteredHoldingList;
  List<TotalsModel> totalsList;

  ReportResponse({
    required this.status,
    required this.message,
    required this.filteredHoldingList,
    required this.totalsList,
  });

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    var filteredList = json['data']['filtered_df'] as List;
    var totalsList = json['data']['totals_df'] as List;

    List<HoldingModel> holdings = filteredList.map((item) => HoldingModel.fromJson(item)).toList();
    List<TotalsModel> totals = totalsList.map((item) => TotalsModel.fromJson(item)).toList();

    return ReportResponse(
      status: json['status'],
      message: json['message'],
      filteredHoldingList: holdings,
      totalsList: totals,
    );
  }
}


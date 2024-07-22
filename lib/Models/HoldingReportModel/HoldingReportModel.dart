class HoldingReportModel {
  String? status;
  String? message;
  Data? data;

  HoldingReportModel({this.status, this.message, this.data});

  factory HoldingReportModel.fromJson(Map<String, dynamic> json) {
    return HoldingReportModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  List<FilteredDf>? filteredDf;
  List<TotalsDf>? totalsDf;

  Data({this.filteredDf, this.totalsDf});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      filteredDf: (json['filtered_df'] as List<dynamic>?)
          ?.map((e) => FilteredDf.fromJson(e))
          .toList(),
      totalsDf: (json['totals_df'] as List<dynamic>?)
          ?.map((e) => TotalsDf.fromJson(e))
          .toList(),
    );
  }
}

class FilteredDf {
  String? scripName;
  String? isin;
  String? freeqty;
  String? pledgeqty;
  String? colqty;
  String? net;
  String? inshort;
  String? outshort;
  String? scripValue;
  String? amount;
  String? lockinqty;
  String? netTotal;

  FilteredDf({
    this.scripName,
    this.isin,
    this.freeqty,
    this.pledgeqty,
    this.colqty,
    this.net,
    this.inshort,
    this.outshort,
    this.scripValue,
    this.amount,
    this.lockinqty,
    this.netTotal,
  });

  factory FilteredDf.fromJson(Map<String, dynamic> json) {
    return FilteredDf(
      scripName: json['scrip_name'].toString(),
      isin: json['isin'].toString(),
      freeqty: json['freeqty']?.toString(),
      pledgeqty: json['pledgeqty'].toString(),
      colqty: json['colqty'].toString(),
      net: json['net'].toString(),
      inshort: json['inshort'].toString(),
      outshort: json['outshort'].toString(),
      scripValue: json['scrip_value']?.toString(),
      amount: json['amount']?.toString(),
      lockinqty: json['lockinqty']?.toString(),
      netTotal: json['net_total']?.toString(),
    );
  }
}

class TotalsDf {
  String? freeqty;
  String? pledgeqty;
  String? colqty;
  String? net;
  String? inshort;
  String? outshort;
  String? amount;
  String? lockinqty;

  TotalsDf({
    this.freeqty,
    this.pledgeqty,
    this.colqty,
    this.net,
    this.inshort,
    this.outshort,
    this.amount,
    this.lockinqty,
  });

  factory TotalsDf.fromJson(Map<String, dynamic> json) {
    return TotalsDf(
      freeqty: json['freeqty']?.toString(),
      pledgeqty: json['pledgeqty']?.toString(),
      colqty: json['colqty']?.toString(),
      net: json['net']?.toString(),
      inshort: json['inshort']?.toString(),
      outshort: json['outshort']?.toString(),
      amount: json['amount']?.toString(),
      lockinqty: json['lockinqty']?.toString(),
    );
  }
}
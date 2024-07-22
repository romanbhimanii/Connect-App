class GlobalSummary {
  String? status;
  String? message;
  Data? data;

  GlobalSummary({this.status, this.message, this.data});

  GlobalSummary.fromJson(Map<String, dynamic> json) {
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
  List<FilteredDf>? filteredDf;
  List<TotalsDf>? totalsDf;

  Data({this.filteredDf, this.totalsDf});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['filtered_df'] != null) {
      filteredDf = <FilteredDf>[];
      json['filtered_df'].forEach((v) {
        filteredDf!.add(FilteredDf.fromJson(v));
      });
    }
    if (json['totals_df'] != null) {
      totalsDf = <TotalsDf>[];
      json['totals_df'].forEach((v) {
        totalsDf!.add(TotalsDf.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (filteredDf != null) {
      data['filtered_df'] = filteredDf!.map((v) => v.toJson()).toList();
    }
    if (totalsDf != null) {
      data['totals_df'] = totalsDf!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilteredDf {
  String? scripSymbol;
  int? tradingQuantity;
  double? tradingAmount;
  int? buyQuantity;
  double? buyRate;
  int? saleQuantity;
  double? saleRate;
  int? netQuantity;
  double? netRate;
  int? netAmount;
  double? closingPrice;
  int? notProfit;
  String? fullScripSymbol;
  String? scripSymbol1;
  String? companyCode;

  FilteredDf(
      {this.scripSymbol,
        this.tradingQuantity,
        this.tradingAmount,
        this.buyQuantity,
        this.buyRate,
        this.saleQuantity,
        this.saleRate,
        this.netQuantity,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.notProfit,
        this.fullScripSymbol,
        this.scripSymbol1,
        this.companyCode});

  FilteredDf.fromJson(Map<String, dynamic> json) {
    scripSymbol = json['scrip_symbol'];
    tradingQuantity = json['trading_quantity'];
    tradingAmount = json['trading_amount'];
    buyQuantity = json['buy_quantity'];
    buyRate = json['buy_rate'];
    saleQuantity = json['sale_quantity'];
    saleRate = json['sale_rate'];
    netQuantity = json['net_quantity'];
    netRate = json['net_rate'];
    netAmount = json['net_amount'];
    closingPrice = json['closing_price'];
    notProfit = json['not_profit'];
    fullScripSymbol = json['full_scrip_symbol'];
    scripSymbol1 = json['scrip_symbol1'];
    companyCode = json['company_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scrip_symbol'] = scripSymbol;
    data['trading_quantity'] = tradingQuantity;
    data['trading_amount'] = tradingAmount;
    data['buy_quantity'] = buyQuantity;
    data['buy_rate'] = buyRate;
    data['sale_quantity'] = saleQuantity;
    data['sale_rate'] = saleRate;
    data['net_quantity'] = netQuantity;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['not_profit'] = notProfit;
    data['full_scrip_symbol'] = fullScripSymbol;
    data['scrip_symbol1'] = scripSymbol1;
    data['company_code'] = companyCode;
    return data;
  }
}

class TotalsDf {
  int? tradingQuantity;
  int? buyQuantity;
  int? saleQuantity;
  int? netQuantity;
  int? netAmount;
  int? notProfit;

  TotalsDf(
      {this.tradingQuantity,
        this.buyQuantity,
        this.saleQuantity,
        this.netQuantity,
        this.netAmount,
        this.notProfit});

  TotalsDf.fromJson(Map<String, dynamic> json) {
    tradingQuantity = json['trading_quantity'];
    buyQuantity = json['buy_quantity'];
    saleQuantity = json['sale_quantity'];
    netQuantity = json['net_quantity'];
    netAmount = json['net_amount'];
    notProfit = json['not_profit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trading_quantity'] = tradingQuantity;
    data['buy_quantity'] = buyQuantity;
    data['sale_quantity'] = saleQuantity;
    data['net_quantity'] = netQuantity;
    data['net_amount'] = netAmount;
    data['not_profit'] = notProfit;
    return data;
  }
}
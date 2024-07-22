class IncomeTaxReport {
  String? status;
  String? message;
  Data? data;

  IncomeTaxReport({this.status, this.message, this.data});

  IncomeTaxReport.fromJson(Map<String, dynamic> json) {
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
  List<ASSETS>? aSSETS;
  List<EXPENSES>? eXPENSES;
  List<LONGTERM>? lONGTERM;
  List<OPASSETS>? oPASSETS;
  List<OPSHORTTERM>? oPSHORTTERM;
  List<SHORTTERM>? sHORTTERM;
  List<TRADING>? tRADING;
  List<GrandTotal>? grandTotal;

  Data(
      {this.aSSETS,
        this.eXPENSES,
        this.lONGTERM,
        this.oPASSETS,
        this.oPSHORTTERM,
        this.sHORTTERM,
        this.tRADING,
        this.grandTotal});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['ASSETS'] != null) {
      aSSETS = <ASSETS>[];
      json['ASSETS'].forEach((v) {
        aSSETS!.add(ASSETS.fromJson(v));
      });
    }
    if (json['EXPENSES'] != null) {
      eXPENSES = <EXPENSES>[];
      json['EXPENSES'].forEach((v) {
        eXPENSES!.add(EXPENSES.fromJson(v));
      });
    }
    if (json['LONGTERM'] != null) {
      lONGTERM = <LONGTERM>[];
      json['LONGTERM'].forEach((v) {
        lONGTERM!.add(LONGTERM.fromJson(v));
      });
    }
    if (json['OP_ASSETS'] != null) {
      oPASSETS = <OPASSETS>[];
      json['OP_ASSETS'].forEach((v) {
        oPASSETS!.add(OPASSETS.fromJson(v));
      });
    }
    if (json['OP_SHORTTERM'] != null) {
      oPSHORTTERM = <OPSHORTTERM>[];
      json['OP_SHORTTERM'].forEach((v) {
        oPSHORTTERM!.add(OPSHORTTERM.fromJson(v));
      });
    }
    if (json['SHORTTERM'] != null) {
      sHORTTERM = <SHORTTERM>[];
      json['SHORTTERM'].forEach((v) {
        sHORTTERM!.add(SHORTTERM.fromJson(v));
      });
    }
    if (json['TRADING'] != null) {
      tRADING = <TRADING>[];
      json['TRADING'].forEach((v) {
        tRADING!.add(TRADING.fromJson(v));
      });
    }
    if (json['Grand Total'] != null) {
      grandTotal = <GrandTotal>[];
      json['Grand Total'].forEach((v) {
        grandTotal!.add(GrandTotal.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (aSSETS != null) {
      data['ASSETS'] = aSSETS!.map((v) => v.toJson()).toList();
    }
    if (eXPENSES != null) {
      data['EXPENSES'] = eXPENSES!.map((v) => v.toJson()).toList();
    }
    if (lONGTERM != null) {
      data['LONGTERM'] = lONGTERM!.map((v) => v.toJson()).toList();
    }
    if (oPASSETS != null) {
      data['OP_ASSETS'] = oPASSETS!.map((v) => v.toJson()).toList();
    }
    if (oPSHORTTERM != null) {
      data['OP_SHORTTERM'] = oPSHORTTERM!.map((v) => v.toJson()).toList();
    }
    if (sHORTTERM != null) {
      data['SHORTTERM'] = sHORTTERM!.map((v) => v.toJson()).toList();
    }
    if (tRADING != null) {
      data['TRADING'] = tRADING!.map((v) => v.toJson()).toList();
    }
    if (grandTotal != null) {
      data['Grand Total'] = grandTotal!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ASSETS {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  ASSETS(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  ASSETS.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class EXPENSES {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  EXPENSES(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  EXPENSES.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class LONGTERM {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  LONGTERM(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  LONGTERM.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class OPSHORTTERM {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  OPSHORTTERM(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  OPSHORTTERM.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class OPASSETS {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  OPASSETS(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  OPASSETS.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class SHORTTERM {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  SHORTTERM(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  SHORTTERM.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class TRADING {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  TRADING(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  TRADING.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}

class GrandTotal {
  String? trType;
  String? scripName;
  String? netQty;
  String? netRate;
  String? netAmount;
  String? closingPrice;
  String? plAmt;
  String? buyQty;
  String? buyRate;
  String? buyAmt;
  String? saleQty;
  String? saleRate;
  String? saleAmt;
  String? shortTerm;
  String? longTerm;
  String? speculation;
  String? currAmount;

  GrandTotal(
      {this.trType,
        this.scripName,
        this.netQty,
        this.netRate,
        this.netAmount,
        this.closingPrice,
        this.plAmt,
        this.buyQty,
        this.buyRate,
        this.buyAmt,
        this.saleQty,
        this.saleRate,
        this.saleAmt,
        this.shortTerm,
        this.longTerm,
        this.speculation,
        this.currAmount});

  GrandTotal.fromJson(Map<String, dynamic> json) {
    trType = json['tr_type'];
    scripName = json['scrip_name'];
    netQty = json['net_qty'].toString();
    netRate = json['net_rate'].toString();
    netAmount = json['net_amount'].toString();
    closingPrice = json['closing_price'].toString();
    plAmt = json['pl_amt'].toString();
    buyQty = json['buy_qty'].toString();
    buyRate = json['buy_rate'].toString();
    buyAmt = json['buy_amt'].toString();
    saleQty = json['sale_qty'].toString();
    saleRate = json['sale_rate'].toString();
    saleAmt = json['sale_amt'].toString();
    shortTerm = json['short_term'].toString();
    longTerm = json['long_term'].toString();
    speculation = json['speculation'].toString();
    currAmount = json['curr_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tr_type'] = trType;
    data['scrip_name'] = scripName;
    data['net_qty'] = netQty;
    data['net_rate'] = netRate;
    data['net_amount'] = netAmount;
    data['closing_price'] = closingPrice;
    data['pl_amt'] = plAmt;
    data['buy_qty'] = buyQty;
    data['buy_rate'] = buyRate;
    data['buy_amt'] = buyAmt;
    data['sale_qty'] = saleQty;
    data['sale_rate'] = saleRate;
    data['sale_amt'] = saleAmt;
    data['short_term'] = shortTerm;
    data['long_term'] = longTerm;
    data['speculation'] = speculation;
    data['curr_amount'] = currAmount;
    return data;
  }
}
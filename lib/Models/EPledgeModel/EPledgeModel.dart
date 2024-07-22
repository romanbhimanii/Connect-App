class EPledgeModel {
  String? status;
  String? message;
  Data? data;

  EPledgeModel({this.status, this.message, this.data});

  EPledgeModel.fromJson(Map<String, dynamic> json) {
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
  List<EPledgeFilteredDf>? filteredDf;
  Total? total;

  Data({this.filteredDf, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['filtered_df'] != null) {
      filteredDf = <EPledgeFilteredDf>[];
      json['filtered_df'].forEach((v) {
        filteredDf!.add(EPledgeFilteredDf.fromJson(v));
      });
    }
    total = json['total'] != null ? Total.fromJson(json['total']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (filteredDf != null) {
      data['filtered_df'] = filteredDf!.map((v) => v.toJson()).toList();
    }
    if (total != null) {
      data['total'] = total!.toJson();
    }
    return data;
  }
}

class EPledgeFilteredDf {
  String? scripName;
  String? isin;
  String? freeqty;
  String? pledgeqty;
  String? colqty;
  String? net;
  String? scripValue;
  String? amount;
  String? price;
  String? haircutPercentage;

  EPledgeFilteredDf(
      {this.scripName,
        this.isin,
        this.freeqty,
        this.pledgeqty,
        this.colqty,
        this.net,
        this.scripValue,
        this.amount,
        this.price,
        this.haircutPercentage});

  EPledgeFilteredDf.fromJson(Map<String, dynamic> json) {
    scripName = json['scrip_name'].toString();
    isin = json['isin'].toString();
    freeqty = json['freeqty'].toString();
    pledgeqty = json['pledgeqty'].toString();
    colqty = json['colqty'].toString();
    net = json['net'].toString();
    scripValue = json['scrip_value'].toString();
    amount = json['amount'].toString();
    price = json['price'].toString();
    haircutPercentage = json['haircut_percentage'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scrip_name'] = scripName;
    data['isin'] = isin;
    data['freeqty'] = freeqty;
    data['pledgeqty'] = pledgeqty;
    data['colqty'] = colqty;
    data['net'] = net;
    data['scrip_value'] = scripValue;
    data['amount'] = amount;
    data['price'] = price;
    data['haircut_percentage'] = haircutPercentage;
    return data;
  }
}

class Total {
  String? freeqty;
  String? colqty;
  String? net;
  String? pledgeqty;
  String? amount;

  Total({this.freeqty, this.colqty, this.net, this.pledgeqty, this.amount});

  Total.fromJson(Map<String, dynamic> json) {
    freeqty = json['freeqty'].toString();
    colqty = json['colqty'].toString();
    net = json['net'].toString();
    pledgeqty = json['pledgeqty'].toString();
    amount = json['amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['freeqty'] = freeqty;
    data['colqty'] = colqty;
    data['net'] = net;
    data['pledgeqty'] = pledgeqty;
    data['amount'] = amount;
    return data;
  }
}

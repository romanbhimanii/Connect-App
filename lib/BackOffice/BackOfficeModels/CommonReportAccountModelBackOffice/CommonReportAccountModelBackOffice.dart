class RiskReport {
  final String status;
  final String message;
  final List<ClientData> data;

  RiskReport({required this.status, required this.message, required this.data});

  factory RiskReport.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ClientData> dataList = list.map((i) => ClientData.fromJson(i)).toList();

    return RiskReport(
      status: json['status'],
      message: json['message'],
      data: dataList,
    );
  }
}

class ClientData {
  final String clientId;
  final String clientName;
  final String ledger;
  final String margin;
  final String soh;
  final String benificiaryStock;
  final String collateral;
  final String inshort;
  final String outshort;
  final String grossledger;
  final String netstock;
  final String netledger;
  final String freestocksoh;
  final String netrisk;
  final String lastTradeDate;
  final String lastReceipt;
  final String lastPayment;

  ClientData({
    required this.clientId,
    required this.clientName,
    required this.ledger,
    required this.margin,
    required this.soh,
    required this.benificiaryStock,
    required this.collateral,
    required this.inshort,
    required this.outshort,
    required this.grossledger,
    required this.netstock,
    required this.netledger,
    required this.freestocksoh,
    required this.netrisk,
    required this.lastTradeDate,
    required this.lastReceipt,
    required this.lastPayment,
  });

  factory ClientData.fromJson(Map<String, dynamic> json) {
    return ClientData(
      clientId: json['client_id'].toString(),
      clientName: json['client_name'].toString(),
      ledger: json['ledger'].toString(),
      margin: json['margin'].toString(),
      soh: json['soh'].toString(),
      benificiaryStock: json['benificiary_stock'].toString(),
      collateral: json['collateral'].toString(),
      inshort: json['inshort'].toString(),
      outshort: json['outshort'].toString(),
      grossledger: json['grossledger'].toString(),
      netstock: json['netstock'].toString(),
      netledger: json['netledger'].toString(),
      freestocksoh: json['freestocksoh'].toString(),
      netrisk: json['netrisk'].toString(),
      lastTradeDate: json['last_trade_date'].toString(),
      lastReceipt: json['last_receipt'].toString(),
      lastPayment: json['last_payment'].toString(),
    );
  }
}

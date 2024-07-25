import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/HoldingReportModel/HoldingReportModel.dart';
import 'package:flutter/cupertino.dart';

class HoldingReportProvider with ChangeNotifier{
  final ApiServices _apiService = ApiServices();
  HoldingReportModel? futureHoldingReport;

  HoldingReportModel? get holdingReport => futureHoldingReport;

  Future<HoldingReportModel?> fetchHoldingReport({
    String? date,
    String? token,
    String? clientCode,
}) async {
    if (futureHoldingReport == null) {
      futureHoldingReport = await _apiService.fetchHoldingsReport(
        date: date,
        token: token,
        clientCode: clientCode
      );
      notifyListeners();
    }
    return futureHoldingReport;
  }

  Future<HoldingReportModel?> refreshData(
      {
        String? date,
        String? token,
        String? clientCode,
      }
      ) async {
    futureHoldingReport = null;
    await fetchHoldingReport(
      clientCode: clientCode,
      token: token,
      date: date
    );
    return null;
  }
}
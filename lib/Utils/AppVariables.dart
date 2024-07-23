import 'package:connect/Models/HoldingReportModel/HoldingReportModel.dart';
import 'package:connect/Models/LedgerReportModel/LedgerReportModel.dart';

class Appvariables{

  static String token = '';
  static String clientCode = "";
  static String year = "";

  static Future<HoldingReportModel>? futureHoldingReport;
  static Future<LedgerReport>? ledgerReport;
}
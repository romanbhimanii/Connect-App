import 'package:connect/ConnectApp/Models/ContractBillReportModel/ContractBillReportModel.dart';
import 'package:connect/ConnectApp/Models/GlobalDetailsModel/GlobalDetailsModel.dart';
import 'package:connect/ConnectApp/Models/GlobalSummaryReportModel/GlobalSummaryReportModel.dart';
import 'package:connect/ConnectApp/Models/HoldingReportModel/HoldingReportModel.dart';
import 'package:connect/ConnectApp/Models/IncomeTaxReportModel/IncomeTaxReportModel.dart';
import 'package:connect/ConnectApp/Models/LedgerReportModel/LedgerReportModel.dart';
import 'package:connect/ConnectApp/Models/PositionReportModel/PositionReportModel.dart';

class Appvariables{

  static String token = '';
  static String clientCode = "";
  static String year = "";

  static Future<HoldingReportModel>? futureHoldingReport;
  static Future<LedgerReport>? ledgerReport;
  static Future<PositionReportResponse>? positionReport;
  static Future<GlobalSummary>? globalSummary;
  static Future<GlobalDetailsResponse>? globalDetails;
  static Future<IncomeTaxReport?>? futureIncomeTaxReport;
  static Future<ContractBillReportModel?>? contractBill;
}
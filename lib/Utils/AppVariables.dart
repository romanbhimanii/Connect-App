import 'package:connect/Models/ContractBillReportModel/ContractBillReportModel.dart';
import 'package:connect/Models/GlobalDetailsModel/GlobalDetailsModel.dart';
import 'package:connect/Models/GlobalSummaryReportModel/GlobalSummaryReportModel.dart';
import 'package:connect/Models/HoldingReportModel/HoldingReportModel.dart';
import 'package:connect/Models/IncomeTaxReportModel/IncomeTaxReportModel.dart';
import 'package:connect/Models/LedgerReportModel/LedgerReportModel.dart';
import 'package:connect/Models/PositionReportModel/PositionReportModel.dart';

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
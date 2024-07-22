import 'package:connect/Screens/ReportScreens/ContractBillReportScreen/ContractBillReportScreen.dart';
import 'package:connect/Screens/ReportScreens/GlobalDetailReportScreen/GlobalDetailsReportScreen.dart';
import 'package:connect/Screens/ReportScreens/GlobalSummaryReportScreen/GlobalSummaryReportScreen.dart';
import 'package:connect/Screens/ReportScreens/HoldingReportScreen/HoldingReportScreen.dart';
import 'package:connect/Screens/ReportScreens/IncomeTaxReportScreen/IncomeTaxReportScreen.dart';
import 'package:connect/Screens/ReportScreens/LedgerReportScreen/LedgerReportScreen.dart';
import 'package:connect/Screens/ReportScreens/PositionReportScreen/PositionReportScreen.dart';
import 'package:connect/Screens/ReportScreens/ProfitAndLossReportScreen/ProfitAndLossReportScreen.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  List<String> reportName = [
    "Holdings",
    "Ledger",
    "Positions",
    "Global Summary",
    "Global Details",
    "Profit & Loss",
    "Income Tax",
    "Contract Bill"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF292D32))),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFF292D32),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        title: Utils.text(
          text: "Reports",
          color: const Color(0xFF00A9FF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView.builder(
        itemCount: 8,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(08.0),
          child: InkWell(
            onTap: () {
              if(index == 0){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HoldingReportScreen();
                },));
              }else if(index == 1){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LedgerReportScreen();
                },));
              }else if(index == 2){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PositionReportScreen();
                },));
              }else if(index == 3){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Globalsummaryreportscreen();
                },));
              }else if(index == 4){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Globaldetailsreportscreen();
                },));
              }else if(index == 5){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Profitandlossreportscreen();
                },));
              }else if(index == 6){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Incometaxreportscreen();
                },));
              }else if(index == 7){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Contractbillreportscreen();
                },));
              }
            },
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF2F2F7),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Utils.text(
                      text: reportName[index],
                      color: const Color(0xFF4A5568),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },),
    );
  }
}

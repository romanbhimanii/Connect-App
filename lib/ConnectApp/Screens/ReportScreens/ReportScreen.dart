
import 'package:connect/ConnectApp/Screens/ReportScreens/ContractBillReportScreen/ContractBillReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/GlobalDetailReportScreen/GlobalDetailsReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/GlobalSummaryReportScreen/GlobalSummaryReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/HoldingReportScreen/HoldingReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/IncomeTaxReportScreen/IncomeTaxReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/LedgerReportScreen/LedgerReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/PositionReportScreen/PositionReportScreen.dart';
import 'package:connect/ConnectApp/Screens/ReportScreens/ProfitAndLossReportScreen/ProfitAndLossReportScreen.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
                onTap: () {
                  Get.to(const SettingsScreen());
                },
                child: SvgPicture.asset(
                  "assets/icons/DeSelectSettingIcon.svg",
                  height: 27,
                  width: 27,
                )),
          )
        ],
        backgroundColor: Colors.white,
        title: Utils.text(
          text: "Reports",
          color: const Color(0xFF00A9FF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: GridView.builder(
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
                    color: const Color(0xFFEAF9FF),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Utils.text(
                            text: reportName[index],
                            color: const Color(0xFF4A5568),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.center
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
          );
        },),
      ),
    );
  }
}

import 'package:connect/BackOffice/BackOfficeScreens/KycScreenBackOffice/CDSlClientDetailsScreen/CDSLClientDetailsScreen.dart';
import 'package:connect/BackOffice/BackOfficeScreens/KycScreenBackOffice/KycDpLedgerScreen/KycDpLedgerScreen.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KycScreenBackOffice extends StatefulWidget {
  const KycScreenBackOffice({super.key});

  @override
  State<KycScreenBackOffice> createState() => _KycScreenBackOfficeState();
}

class _KycScreenBackOfficeState extends State<KycScreenBackOffice> with SingleTickerProviderStateMixin{

  List<String> reportName = [
    "Client Details",
    "Client Holding",
    "DP Ledger",
    "Physical KYC",
    "Nomination"
  ];

  List<String> icons = [
    "assets/ReportsIcon/holdingsIcon.svg",
    "assets/ReportsIcon/ledgerIcon.svg",
    "assets/ReportsIcon/positionIcon.svg",
    "assets/ReportsIcon/globalSummaryIcon.svg",
    "assets/ReportsIcon/globalDetailsIcon.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Utils.text(
            text: "Kyc",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
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
        iconTheme: const IconThemeData(color: kBlackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: GridView.builder(
          itemCount: 5,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            mainAxisExtent: 130
          ),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(05.0),
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const CDSLClientDetailsScreen();
                      },
                    ));
                  } else if (index == 1) {

                  } else if (index == 2) {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const KycDpLedgerScreen();
                      },
                    ));
                  } else if (index == 3) {

                  } else if (index == 4) {

                  } else if (index == 5) {

                  } else if (index == 6) {

                  } else if (index == 7) {

                  }
                },
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAF9FF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          icons[index],
                          height: 30,
                          width: 30,
                          color: const Color(0xFF4A5568),
                        ),
                        const SizedBox(
                          height: 05,
                        ),
                        Padding(
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
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

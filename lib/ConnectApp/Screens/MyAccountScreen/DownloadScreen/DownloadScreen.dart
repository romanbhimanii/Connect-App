

import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Downloadscreen extends StatefulWidget {
  const Downloadscreen({super.key});

  @override
  State<Downloadscreen> createState() => _DownloadscreenState();
}

class _DownloadscreenState extends State<Downloadscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  int? year;
  List<String> title = [
    "Client Details",
    "Holdings",
    "Global Summary",
    "Income Tax",
    "Global Details",
    "Ledger",
  ];
  List<String> icons = [
    "assets/icons/ProfileIconAccount.svg",
    "assets/icons/BankDetailsIconAccount.svg",
    "assets/icons/DpDetailsIconAccount.svg",
    "assets/icons/NomineeDetailsIconAccount.svg",
    "assets/icons/GlobalSummaryIcon.svg",
    "assets/icons/payInIcon.svg"
  ];

  List<bool> isDownloading = List.filled(6, false);

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    loadYear();
  }

  void loadYear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now();
    String reportYear = prefs.getString('year') ?? "${time.year}";
    year = int.parse(reportYear);
  }

  Future<void> handleDownload(int index) async {
    setState(() {
      isDownloading[index] = true;
    });
    try {
      if (index == 0) {
        await ApiServices().downloadClientDetails(token: Appvariables.token, context: context);
      } else if (index == 1) {
        await ApiServices().downloadHoldingReport(token: Appvariables.token, context: context);
      } else if (index == 2) {
        await ApiServices().downloadGlobalSummary(token: Appvariables.token, context: context);
      } else if (index == 3) {
        await ApiServices().downloadIncomeTax(token: Appvariables.token, context: context);
      } else if (index == 4) {
        await ApiServices().downloadGlobalDetails(token: Appvariables.token, context: context);
      } else if (index == 5) {
        await ApiServices().downloadLedger(token: Appvariables.token, context: context, year: year);
      }
    } finally {
      setState(() {
        isDownloading[index] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 13,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Utils.text(
                    text: "Reports",
                    color: const Color(0xFF0F3F62),
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 05,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 6,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 05.0),
                    child: InkWell(
                      onTap: () => handleDownload(index),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFEAF9FF)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              SvgPicture.asset(icons[index], height: 25, width: 25),
                              const SizedBox(
                                width: 13,
                              ),
                              Utils.text(
                                  text: title[index],
                                  color: const Color(0xFF0F3F62),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              isDownloading[index]
                                  ?  Lottie.asset('assets/lottie/loading.json',height: 30,width: 30)
                                  : SvgPicture.asset("assets/icons/DocumentDownload.svg")
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Utils.text(
                text: "Disclaimer: The P&L report/Holdings/Positions data is prepared based on the trades and information available with us, at the time of report generation. Arham share private limited does not make any warranty, express or implied, or assume any legal/consequential liability, or responsibility for the authenticity, and completeness of the data presented in this report/data. Kindly double check your P&L report/Holdings/Positions data, verify it with the Tradebook, Contract Notes and the Funds Statement which are available with you at all times.",
                color: kBlackColor,
                fontSize: 9,
                textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

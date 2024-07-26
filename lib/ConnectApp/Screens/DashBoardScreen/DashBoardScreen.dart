// ignore_for_file: avoid_unnecessary_containers


import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/TotalBalanceModel/TotalbalanceModel.dart';
import 'package:connect/ConnectApp/Screens/DpProcessScreen/DpProcessScreen.dart';
import 'package:connect/ConnectApp/Screens/IPOScreens/ViewAllIpoScreen.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  final ApiServices _apiService = ApiServices();
  Future<TotalBalanceModel>? holdingReport;
  String equity = "";
  DateTime now = DateTime.now();
  String year = "";
  final List<String> items = [
    '2024-2025',
    '2023-2024',
    '2022-2023',
    '2021-2022',
    '2020-2021',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    year = "${now.year}";
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    loadData();
  }

  void loadData() async {
    holdingReport = _apiService.fetchTotalBalanceData(token: Appvariables.token, year: year);
    ApiServices().loadYear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Utils.text(
            text: "Dashboard",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/DashBoardBanner.png"),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utils.text(
                            text: "Total Balance",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          Utils.text(
                            text: "Total Portfolio",
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utils.text(
                            text: "Equity:",
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          Utils.text(
                            text: "Holdings:",
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          equity != ""
                              ? Utils.text(
                                  text: "Rs. $equity",
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )
                              : Center(
                                  child: Lottie.asset(
                                      'assets/lottie/loading.json',
                                      height: 35,
                                      width: 35),
                                ),
                          fetchHoldingReport(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.text(
                                text: "Commodities:",
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              Utils.text(
                                text: "Rs. 0",
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Color(0xFFFFFBFB),
                                ),
                                iconSize: 25,
                              ),
                              hint: Appvariables.year != "" ? Utils.text(
                                text: Appvariables.year,
                                color: const Color(0xFFFFFBFB),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ) : Center(
                                  child: Lottie.asset('assets/lottie/loading.json',
                                      height: 35, width: 35)),
                              items: items
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Utils.text(
                                                text: item,
                                                color: selectedValue == item
                                                    ? const Color(0xFFFFFBFB)
                                                    : const Color(0xFF4A5568),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ))
                                  .toList(),
                              style: GoogleFonts.inter(
                                color: const Color(0xFFFFFBFB),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              value: selectedValue,
                              onChanged: (String? value) async {
                                selectedValue = value;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (selectedValue == "2024-2025") {
                                  DateTime now = DateTime.now();
                                  year = "${now.year}";
                                  await prefs.setString('year', year);
                                } else if (selectedValue == "2023-2024") {
                                  year = "2024";
                                  await prefs.setString('year', year);
                                } else if (selectedValue == "2022-2023") {
                                  year = "2023";
                                  await prefs.setString('year', year);
                                } else if (selectedValue == "2021-2022") {
                                  year = "2022";
                                  await prefs.setString('year', year);
                                } else if (selectedValue == "2020-2021") {
                                  year = "2021";
                                  await prefs.setString('year', year);
                                }
                                ApiServices().loadYear();
                                setState(() {});
                              },
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFFEAF9FF))),
                              buttonStyleData: ButtonStyleData(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 08),
                                height: 40,
                                width: 140,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFFFFBFB)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Utils.text(
                text: "Apply for IPO and be the first in newly listed stocks",
                color: const Color(0xFF001533),
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Viewalliposcreen(
                            name: "open IPO",
                          );
                        },
                      ));
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 170,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF89CFF3).withOpacity(0.2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/OpenIPO.svg",
                            height: 100,
                            width: 100,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.text(
                              text: "Open IPO",
                              color: const Color(0xFF4A5568),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.text(
                              text: "Apply Now",
                              color: const Color(0xFF4A5568),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Viewalliposcreen(
                              name: "Upcoming IPO",
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 170,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF89CFF3).withOpacity(0.2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/UpComingIPO.svg",
                            height: 100,
                            width: 100,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.text(
                              text: "Upcoming IPO",
                              color: const Color(0xFF4A5568),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Utils.text(
                              text: "Apply Now",
                              color: const Color(0xFF4A5568),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Dpprocessscreen();
                      },
                    ),
                  );
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF89CFF3).withOpacity(0.20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Center(
                          child: Utils.text(
                            text: "DP Process",
                            color: const Color(0xFF4A5568),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        SvgPicture.asset("assets/icons/DpProcess.svg"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget fetchHoldingReport() {
    return FutureBuilder<TotalBalanceModel>(
      future: holdingReport,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset('assets/lottie/loading.json',
                  height: 35, width: 35));
        } else if (snapshot.hasError) {
          return Center(
              child: Utils.text(
            text: 'Error',
            color: Colors.white,
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          if (equity == "") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                equity = data.ledger.group1.toString();
              });
            });
          }
          return Utils.text(
              text: "Rs. ${data.holding}",
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold);
        } else {
          return Center(
            child: Utils.text(
              text: 'No data available',
              color: kBlackColor,
              fontSize: 15,
            ),
          );
        }
      },
    );
  }
}

// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/ClientWiseBidReport/ClientWiseBidReport.dart';
import 'package:connect/Models/IpoModels/IpoModel.dart';
import 'package:connect/Models/LoginModel/LoginModel.dart';
import 'package:connect/Models/TotalBalanceModel/TotalbalanceModel.dart';
import 'package:connect/Screens/DashBoardScreen/viewFullBidDetailsScreen.dart';
import 'package:connect/Screens/DpProcessScreen/DpProcessScreen.dart';
import 'package:connect/Screens/IPOScreens/ViewAllIpoScreen.dart';
import 'package:connect/Screens/ReportScreens/ReportScreen.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
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

class _DashBoardScreenState extends State<DashBoardScreen>
    with SingleTickerProviderStateMixin {
  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;

  LoginResponse? loginResponse;
  final ApiServices _apiService = ApiServices();
  Future<ClientBidReportResponse>? futureClientBidReport;
  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;
  Future<TotalBalanceModel>? holdingReport;
  String equity = "";
  DateTime now = DateTime.now();
  String datePickedValue = "";
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
    _tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void loadData() async {
    holdingReport = _apiService.fetchTotalBalanceData(
        token: Appvariables.token, year: year);
    upcomingIPO = _apiService.fetchUpcomingIpoDetails();
    openIPO = _apiService.fetchOpenIpoDetails();
    futureClientBidReport =
        _apiService.fetchClientBidReports(token: Appvariables.token);
    String date = ApiServices().loadYear().toString();
    debugPrint(date.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            print(Appvariables.token);
          },
          child: Utils.text(
              text: "Dashboard",
              color: const Color(0xFF00A9FF),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          dividerHeight: 0.0,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          automaticIndicatorColorAdjustment: true,
          controller: _tabController,
          labelPadding: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.all(0),
          indicatorPadding: const EdgeInsets.all(05),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFF0066F6),
              width: 1,
            ),
          ),
          labelStyle:
              GoogleFonts.poppins(color: const Color(0xFF0066F6), fontSize: 15),
          unselectedLabelStyle:
              GoogleFonts.poppins(color: kBlackColor, fontSize: 15),
          indicatorColor: kBlackColor,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'IPO'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Bid Details'),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        iconTheme: const IconThemeData(color: kBlackColor),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
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
                          image:
                              AssetImage("assets/images/DashBoardBanner.png"),
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
                              Utils.text(
                                text: "Rs. $equity",
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              fetchHoldingReport(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 08,
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
                                  hint: Utils.text(
                                    text: Appvariables.year,
                                    color: const Color(0xFFFFFBFB),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  items: items
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
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
                                  buttonStyleData: ButtonStyleData(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 08),
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
                        const SizedBox(
                          height: 02,
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
                    text:
                        "Apply for IPO and be the first in newly listed stocks",
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Utils.text(
                                  text: "Open IPO",
                                  color: const Color(0xFF4A5568),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Utils.text(
                                  text: "Upcoming IPO",
                                  color: const Color(0xFF4A5568),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
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
                            return const ReportScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 70,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF89CFF3).withOpacity(0.20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/Download.svg"),
                            const SizedBox(
                              width: 10,
                            ),
                            Utils.text(
                              text: "Download Reports",
                              color: const Color(0xFF4A5568),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Utils.text(
                //           text: "Open IPO",
                //           color: kBlackColor,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w700),
                //       GestureDetector(
                //         onTap: () {
                //           Get.to(const Viewalliposcreen(),
                //               arguments: ({
                //                 "name": "open IPO",
                //               }));
                //         },
                //         child: Utils.text(
                //           text: "View All",
                //           color: kBlackColor,
                //           fontSize: 12,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: SizedBox(
                //     child: Column(
                //       children: [
                //         openIPOsList(),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Utils.text(
                //           text: "upcoming IPO",
                //           color: kBlackColor,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w700),
                //       GestureDetector(
                //         onTap: () {
                //           Get.to(const Viewalliposcreen(),
                //               arguments: ({
                //                 "name": "Upcoming IPO",
                //               }));
                //         },
                //         child: Utils.text(
                //           text: "View All",
                //           color: kBlackColor,
                //           fontSize: 12,
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //   child: Container(
                //     child: Column(
                //       children: [
                //         upcomingIPOs(),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        fetchClientWiseBidReport(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fetchClientWiseBidReport() {
    return FutureBuilder<ClientBidReportResponse>(
      future: futureClientBidReport,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset('assets/lottie/loading.json',
                  height: 100, width: 100));
        } else if (snapshot.hasError) {
          return Center(
            child: Utils.text(text: '${snapshot.error}', color: kBlackColor),
          );
        } else if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: snapshot.data?.data.length ?? 0,
            itemBuilder: (context, index) {
              final report = snapshot.data!.data[index];
              return InkWell(
                onTap: () {
                  Get.to(const viewFullBidDetailsScreen(),
                      arguments: ({"data": report}));
                },
                child: Container(
                  child: Card(
                    color: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.grey.shade800
                                                      .withOpacity(0.1),
                                                ),
                                              ),
                                              child: Center(
                                                child: Utils.text(
                                                  text: "${index + 1}",
                                                  color: kBlackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 180,
                                      child: Utils.text(
                                          text:
                                              "Application No. ${report.applicationNo}",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: kBlackColor),
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: 180,
                                      child: RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: 'Bid Amount ',
                                          style: GoogleFonts.poppins(
                                            color: kBlackColor,
                                            fontSize: 10,
                                          ),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: report.bidAmount,
                                              style: GoogleFonts.poppins(
                                                color: kBlackColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    RichText(
                                      textAlign: TextAlign.start,
                                      text: TextSpan(
                                        text: 'Date ',
                                        style: GoogleFonts.poppins(
                                          color: kBlackColor,
                                          fontSize: 10,
                                        ),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: report.timestamp,
                                            style: GoogleFonts.poppins(
                                              color: kBlackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromRGBO(27, 82, 52, 1.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Center(
                                      child: Utils.text(
                                        text: "View",
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Utils.text(
              text: 'No data found', color: kBlackColor, fontSize: 15);
        }
      },
    );
  }

  Widget fetchHoldingReport() {
    return FutureBuilder<TotalBalanceModel>(
      future: holdingReport,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset('assets/lottie/loading.json',
                  height: 40, width: 40));
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

// Widget openIPOsList() {
//   return FutureBuilder<IpoDetailsResponse>(
//     future: openIPO,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(
//             child: CircularProgressIndicator(
//           color: Color.fromRGBO(27, 82, 52, 1.0),
//         ));
//       } else if (snapshot.hasError) {
//         return Center(
//             child: Utils.text(
//           text: 'Error: ${snapshot.error}',
//           color: kBlackColor,
//         ));
//       } else if (snapshot.hasData) {
//         final data = snapshot.data!.data;
//         return ListView.builder(
//           shrinkWrap: true,
//           itemCount: data.length > 3 ? 3 : data.length,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(0),
//           itemBuilder: (context, index) {
//             final ipo = data[index];
//
//             return InkWell(
//               onTap: () {
//                 Get.to(const IPODetailsScreen(),
//                     arguments: ({
//                       'name': "open IPO",
//                       'data': ipo,
//                     }));
//               },
//               child: Container(
//                 child: Card(
//                   color: Colors.white,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10.0, vertical: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             height: 35,
//                                             width: 35,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               border: Border.all(
//                                                 color: Colors.grey.shade800
//                                                     .withOpacity(0.1),
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Utils.text(
//                                                 text: "${index + 1}",
//                                                 color: kBlackColor,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             width: 180,
//                                             child: Utils.text(
//                                               text: ipo.name,
//                                               color: kBlackColor,
//                                               fontSize: 13,
//                                               fontWeight: FontWeight.w600,
//                                               textAlign: TextAlign.start,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 5),
//                                           RichText(
//                                             textAlign: TextAlign.start,
//                                             text: TextSpan(
//                                               text: 'Bid Start Date ',
//                                               style: GoogleFonts.poppins(
//                                                 color: kBlackColor,
//                                                 fontSize: 10,
//                                               ),
//                                               children: <InlineSpan>[
//                                                 TextSpan(
//                                                   text: ipo.biddingStartDate,
//                                                   style: GoogleFonts.poppins(
//                                                     color: kBlackColor,
//                                                     fontWeight:
//                                                         FontWeight.w500,
//                                                     fontSize: 10,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 5),
//                                           RichText(
//                                             textAlign: TextAlign.start,
//                                             text: TextSpan(
//                                               text: 'Bid End Date ',
//                                               style: GoogleFonts.poppins(
//                                                 color: kBlackColor,
//                                                 fontSize: 10,
//                                               ),
//                                               children: <InlineSpan>[
//                                                 TextSpan(
//                                                   text: ipo.biddingEndDate,
//                                                   style: GoogleFonts.poppins(
//                                                     color: kBlackColor,
//                                                     fontWeight:
//                                                         FontWeight.w500,
//                                                     fontSize: 10,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           const SizedBox(height: 5),
//                                           Container(
//                                             height: 15,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               color: Colors
//                                                   .deepPurpleAccent.shade700
//                                                   .withOpacity(0.1),
//                                             ),
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       horizontal: 5.0),
//                                               child: Utils.text(
//                                                 text: ipo.ipoType,
//                                                 color: Colors.deepPurple,
//                                                 fontSize: 9,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               const Spacer(),
//                               Container(
//                                 height: 30,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color:
//                                       const Color.fromRGBO(27, 82, 52, 1.0),
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0),
//                                   child: Center(
//                                     child: Utils.text(
//                                       text: "Apply",
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 12,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       } else {
//         return Center(
//             child: Utils.text(
//                 text: 'No data available', color: kBlackColor, fontSize: 15));
//       }
//     },
//   );
// }
//
// Widget upcomingIPOs() {
//   return FutureBuilder<IpoDetailsResponse>(
//     future: upcomingIPO,
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return const Center(
//             child: CircularProgressIndicator(
//           color: Color.fromRGBO(27, 82, 52, 1.0),
//         ));
//       } else if (snapshot.hasError) {
//         return Center(
//             child: Utils.text(
//           text: 'Error: ${snapshot.error}',
//           color: kBlackColor,
//         ));
//       } else if (snapshot.hasData) {
//         final data = snapshot.data!.data;
//         return data.isNotEmpty
//             ? ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: data.length > 3 ? 3 : data.length,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(0),
//                 itemBuilder: (context, index) {
//                   final ipo = data[index];
//                   return InkWell(
//                     onTap: () {
//                       Get.to(const IPODetailsScreen(),
//                           arguments: ({'name': "upcoming IPO", 'data': ipo}));
//                     },
//                     child: Container(
//                       child: Card(
//                         color: Colors.white,
//                         child: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10.0, vertical: 10),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Container(
//                                                   height: 35,
//                                                   width: 35,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius
//                                                               .circular(10),
//                                                       border: Border.all(
//                                                           color: Colors
//                                                               .grey.shade800
//                                                               .withOpacity(
//                                                                   0.1))),
//                                                   child: Center(
//                                                     child: Utils.text(
//                                                       text: "${index + 1}",
//                                                       color: kBlackColor,
//                                                       fontSize: 14,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Utils.text(
//                                                     text: ipo.name,
//                                                     color: kBlackColor,
//                                                     fontSize: 13,
//                                                     fontWeight:
//                                                         FontWeight.w600),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 RichText(
//                                                   textAlign: TextAlign.start,
//                                                   text: TextSpan(
//                                                     text: 'Bid Start Date ',
//                                                     style:
//                                                         GoogleFonts.poppins(
//                                                       color: kBlackColor,
//                                                       fontSize: 10,
//                                                     ),
//                                                     children: <InlineSpan>[
//                                                       TextSpan(
//                                                         text: ipo
//                                                             .biddingStartDate,
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                           color: kBlackColor,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           fontSize: 10,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 const SizedBox(height: 5),
//                                                 RichText(
//                                                   textAlign: TextAlign.start,
//                                                   text: TextSpan(
//                                                     text: 'Bid End Date ',
//                                                     style:
//                                                         GoogleFonts.poppins(
//                                                       color: kBlackColor,
//                                                       fontSize: 10,
//                                                     ),
//                                                     children: <InlineSpan>[
//                                                       TextSpan(
//                                                         text: ipo
//                                                             .biddingEndDate,
//                                                         style:
//                                                             GoogleFonts.inter(
//                                                           color: kBlackColor,
//                                                           fontWeight:
//                                                               FontWeight.w500,
//                                                           fontSize: 10,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 5,
//                                                 ),
//                                                 Container(
//                                                   height: 15,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius
//                                                               .circular(05),
//                                                       color: Colors
//                                                           .deepPurpleAccent
//                                                           .shade700
//                                                           .withOpacity(0.1)),
//                                                   child: Padding(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 5.0),
//                                                     child: Utils.text(
//                                                         text: ipo.ipoType,
//                                                         color:
//                                                             Colors.deepPurple,
//                                                         fontSize: 09),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : Column(
//                 children: [
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   Center(
//                     child: Utils.text(
//                         text: "No Data Found!",
//                         color: kBlackColor,
//                         fontSize: 15),
//                   ),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                 ],
//               );
//       } else {
//         return Center(
//             child: Utils.text(
//                 text: 'No data available', color: kBlackColor, fontSize: 15));
//       }
//     },
//   );
// }
}

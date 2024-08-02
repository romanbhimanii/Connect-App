// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/DashBoardDetailsModelBackOffice/DashBoardDetailsModelBackOffice.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoardScreenBackOffice extends StatefulWidget {
  const DashBoardScreenBackOffice({super.key});

  @override
  State<DashBoardScreenBackOffice> createState() =>
      _DashBoardScreenBackOfficeState();
}

class _DashBoardScreenBackOfficeState extends State<DashBoardScreenBackOffice> {
  int touchedIndex = -1;
  final ConnectivityService connectivityService = ConnectivityService();
  Future<DashboardResponse>? dashBoardDetailsResponse;
  final BackOfficeApiService _apiService = BackOfficeApiService();
  DateTime now = DateTime.now();
  String year = "";
  String formattedDate = "";
  String percentageOfAccountOpening = "";
  String rejectionOfAccountOpening = "";
  String nonTradedClient = "";
  String tradedClient = "";
  String numberOfClients = "";
  Future<String>? annualYear;
  final List<String> items = [
    '2024-2025',
    '2023-2024',
    '2022-2023',
    '2021-2022',
    '2020-2021',
  ];
  List<String> images = [
    "assets/BackOffice/Icons/modificationOptionProcessIcon.svg",
    "assets/BackOffice/Icons/noOfClientsIcon.svg",
    "assets/BackOffice/Icons/accountOpeningIcon.svg",
  ];
  List<String> percentage = ["100%", "26", "0%"];
  List<String> titles = [
    "Account Opening Process",
    "Total Clients",
    "Modification Online Process"
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('MMMM - yyyy').format(now);
    year = "${now.year}";
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    annualYear = BackOfficeApiService().loadYear();
    loadData();
  }

  void loadData() async {
    dashBoardDetailsResponse = _apiService.fetchDashboardData(
        token: Appvariablesbackoffice.token ?? "");
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
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16.0),
                _buildProcessCards(),
                const SizedBox(height: 16.0),
                _buildClientOverviewChart(),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage("assets/images/DashBoardBanner.png"),
              fit: BoxFit.fill)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Utils.text(
                    text: "My Brokerage",
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                      hint: !annualYear.isNull
                          ? Utils.text(
                              text: Appvariablesbackoffice.year,
                              color: const Color(0xFFFFFBFB),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )
                          : Center(
                              child: Lottie.asset('assets/lottie/loading.json',
                                  height: 35, width: 35)),
                      selectedItemBuilder: (_) {
                        return items
                            .map(
                              (e) => Container(
                                alignment: Alignment.center,
                                child: Utils.text(
                                    text: e,
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                            .toList();
                      },
                      items: items.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Utils.text(
                              text: value,
                              color: const Color(0xFF4A5568),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        );
                      }).toList(),
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFFBFB),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      value: selectedValue,
                      onChanged: (String? value) async {
                        selectedValue = value;
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        if (selectedValue == "2024-2025") {
                          DateTime now = DateTime.now();
                          year = "${now.year}";
                          await prefs.setString('backOfficeYear', year);
                        } else if (selectedValue == "2023-2024") {
                          year = "2024";
                          await prefs.setString('backOfficeYear', year);
                        } else if (selectedValue == "2022-2023") {
                          year = "2023";
                          await prefs.setString('backOfficeYear', year);
                        } else if (selectedValue == "2021-2022") {
                          year = "2022";
                          await prefs.setString('backOfficeYear', year);
                        } else if (selectedValue == "2020-2021") {
                          year = "2021";
                          await prefs.setString('backOfficeYear', year);
                        }
                        BackOfficeApiService().loadYear();
                        setState(() {});
                      },
                      dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFEAF9FF))),
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 08),
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFFFFBFB)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
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
                    text: formattedDate,
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  Utils.text(
                    text: "Prev Month",
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 02,
            ),
            fetchDashBoardDetailsData(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessCards() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.45,
        initialPage: 0,
        enableInfiniteScroll: true,
        disableCenter: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
      items: [0, 1, 2].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 08),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: i == 0
                        ? const Color(0xFFF3898B).withOpacity(0.2)
                        : i == 1
                            ? const Color(0xFF89CFF3).withOpacity(0.2)
                            : const Color(0xFFF3BA89).withOpacity(0.21)),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      images[i],
                      height: 80,
                      width: 80,
                    ),
                    const Spacer(),
                    Utils.text(
                        text: i == 0
                            ? percentageOfAccountOpening
                            : i == 1
                                ? numberOfClients
                                : rejectionOfAccountOpening,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A5568)),
                    const SizedBox(height: 8.0),
                    Utils.text(
                        text: titles[i],
                        fontSize: 12,
                        color: const Color(0xFF4A5568),
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildClientOverviewChart() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFF89CFF3).withOpacity(0.20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Utils.text(
                text: "Client Overview",
                color: const Color(0xFF4A5568),
                fontSize: 18,
                fontWeight: FontWeight.bold),
            const SizedBox(height: 16.0),
            Row(
              children: [
                SizedBox(
                  height: 170,
                  width: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Utils.text(
                              text: numberOfClients,
                              color: const Color(0xFF4A5568),
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                          Utils.text(
                              text: "Total Clients",
                              color: const Color(0xFF4A5568),
                              fontSize: 12),
                        ],
                      ),
                      PieChart(
                        PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            sectionsSpace: 04,
                            sections: [
                              PieChartSectionData(
                                value: numberOfClients == "" ? 25 : double.parse(numberOfClients),
                                gradient: LinearGradient(colors: [
                                  const Color(0xFFF3898B).withOpacity(0.0),
                                  const Color(0xFFF3898B).withOpacity(1.0),
                                  const Color(0xFFF3898B).withOpacity(1.0),
                                ]),
                                title: '',
                                radius: 35,
                                titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: tradedClient == "" ? 25 : double.parse(tradedClient),
                                gradient: LinearGradient(colors: [
                                  const Color(0xFF00A9FF).withOpacity(1.0),
                                  const Color(0xFF89CFF3).withOpacity(1.0),
                                ]),
                                title: '',
                                radius: 35,
                                titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              PieChartSectionData(
                                value: nonTradedClient == "" ? 25 : double.parse(nonTradedClient),
                                title: '',
                                gradient: LinearGradient(colors: [
                                  const Color(0xFFF3BA89).withOpacity(0.0),
                                  const Color(0xFFF3BA89).withOpacity(1.0),
                                  const Color(0xFFF3BA89).withOpacity(1.0),
                                ]),
                                radius: 35,
                                titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                            ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF3898B),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(06),
                        child: Utils.text(
                            text: "TOTAL CLIENT",
                            color: Colors.white,
                            fontSize: 11),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF00A9FF),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(06),
                        child: Utils.text(
                            text: "TRADED CLIENT",
                            color: Colors.white,
                            fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF3BA89),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(06),
                        child: Utils.text(
                            text: "NON-TRADED CLIENT",
                            color: Colors.white,
                            fontSize: 11),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(08),
                              color: const Color(0xFFF3898B)),
                          child: Padding(
                            padding: const EdgeInsets.all(08),
                            child: Utils.text(
                                text: numberOfClients,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(08),
                              color: const Color(0xFFF3BA89)),
                          child: Padding(
                            padding: const EdgeInsets.all(08),
                            child: Utils.text(
                                text: nonTradedClient,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(08),
                              color: const Color(0xFF00A9FF)),
                          child: Padding(
                            padding: const EdgeInsets.all(08),
                            child: Utils.text(
                                text: tradedClient,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget fetchDashBoardDetailsData() {
    return FutureBuilder<DashboardResponse>(
      future: dashBoardDetailsResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset('assets/lottie/loading.json',
                  height: 35, width: 35));
        } else if (snapshot.hasError) {
          return Center(
              child: Utils.text(
            text: '',
            color: Colors.white,
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          if (percentageOfAccountOpening == "" &&
              rejectionOfAccountOpening == "" &&
              numberOfClients == "" &&
              nonTradedClient == "" &&
              tradedClient == "") {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                percentageOfAccountOpening = data.completedPr.toString();
                rejectionOfAccountOpening = data.rejection.toString();
                numberOfClients = data.noOfClient.toString();
                nonTradedClient = data.nonTradedClient.toString();
                tradedClient = data.tradedClient.toString();
              });
            });
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utils.text(
                    text: "₹ ${data.currentMonthBrokerage}",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                Utils.text(
                    text: "₹ ${data.previousMonthBrokerage}",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ],
            ),
          );
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

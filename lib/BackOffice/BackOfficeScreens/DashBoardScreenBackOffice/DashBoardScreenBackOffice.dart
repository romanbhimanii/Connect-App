import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/DashBoardDetailsModelBackOffice/DashBoardDetailsModelBackOffice.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  State<DashBoardScreenBackOffice> createState() => _DashBoardScreenBackOfficeState();
}

class _DashBoardScreenBackOfficeState extends State<DashBoardScreenBackOffice> {

  final ConnectivityService connectivityService = ConnectivityService();
  Future<DashboardResponse>? dashBoardDetailsResponse;
  final BackOfficeApiService _apiService = BackOfficeApiService();
  DateTime now = DateTime.now();
  String year = "";
  Future<String>? annualYear;
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
    annualYear = BackOfficeApiService().loadYear();
    loadData();
  }

  void loadData() async {
    dashBoardDetailsResponse = _apiService.fetchDashboardData(token: Appvariablesbackoffice.token ?? "");
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM - yyyy').format(now);
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 05),
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
                              hint: !annualYear.isNull ? Utils.text(
                                text: Appvariablesbackoffice.year,
                                color: const Color(0xFFFFFBFB),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ) : Center(
                                  child: Lottie.asset('assets/lottie/loading.json',
                                      height: 35, width: 35)),
                              selectedItemBuilder: (_) {
                                return items
                                    .map((e) => Container(
                                  alignment: Alignment.center,
                                  child: Utils.text(
                                      text: e,
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),)
                                    .toList();
                              },
                              items: items.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Utils.text(
                                      text: value,
                                      color: const Color(0xFF4A5568),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                  ),
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
                                BackOfficeApiService().loadYear();
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
            ),
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Utils.text(
                    text: "₹ ${data.currentMonthBrokerage}",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
                Utils.text(
                    text: "₹ ${data.previousMonthBrokerage}",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
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

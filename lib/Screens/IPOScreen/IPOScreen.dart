import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/IpoModels/IpoModel.dart';
import 'package:connect/Screens/IPOScreens/IPODetailsScreen.dart';
import 'package:connect/SettingsScreen/SettingsScreen.dart';
import 'package:connect/Utils/AppDrawer.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IPOScreen extends StatefulWidget {
  const IPOScreen({super.key});

  @override
  State<IPOScreen> createState() => _IPOScreenState();
}

class _IPOScreenState extends State<IPOScreen>  with SingleTickerProviderStateMixin{

  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;

  final ApiServices _apiService = ApiServices();
  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
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

  void loadData() {
    upcomingIPO = _apiService.fetchUpcomingIpoDetails();
    openIPO = _apiService.fetchOpenIpoDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Utils.text(
          text: "IPO",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
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
              color: const Color(0xFF00A9FF),
              width: 1,
            ),
          ),
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF00A9FF), fontSize: 15),
          unselectedLabelStyle: GoogleFonts.poppins(color: kBlackColor, fontSize: 15),
          indicatorColor: kBlackColor,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Open Ipo'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Upcoming Ipo'),
            ),
          ],
        ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SizedBox(
                    child: Column(
                      children: [
                        openIPOsList(),
                      ],
                    ),
                  ),
                ),
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
                  child: Column(
                    children: [
                      upcomingIPOs(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget openIPOsList() {
    return FutureBuilder<IpoDetailsResponse>(
      future: openIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
        } else if (snapshot.hasError) {
          return Center(child: Utils.text(
            text: 'Error: ${snapshot.error}',
            color: Colors.black,
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return IPODetailsScreen(name: "open IPO",data: ipo,);
                      },));
                    },
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          color:  const Color(0xFFEAF9FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Utils.text(
                                                text: ipo.name,
                                                color: const Color(0xFF4A5568),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Lot Size ',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.lotSize,
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF001533),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'IPO Type ',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.ipoType,
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF001533),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Bid Start Date ',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingStartDate,
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF001533),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFF2970E8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Center(
                                        child: Utils.text(
                                          text: "Apply Now",
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
                  );
                },
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ) : Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(child: Utils.text(
                  text: "No Data Found!",
                  color: Colors.black,
                  fontSize: 15
              ),),
              const SizedBox(
                height: 50,
              ),
            ],
          );
        } else {
          return Center(child: Utils.text(
              text: 'No data available',
              color: Colors.black,
              fontSize: 15
          ));
        }
      },
    );
  }

  Widget upcomingIPOs() {
    return FutureBuilder<IpoDetailsResponse>(
      future: upcomingIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
        } else if (snapshot.hasError) {
          return Center(child: Utils.text(
            text: 'Error: ${snapshot.error}',
            color: Colors.black,
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return IPODetailsScreen(name: "upcoming IPO",data: ipo,);
                      },));
                    },
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            color:  const Color(0xFFEAF9FF),
                            borderRadius: BorderRadius.circular(10)),
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
                                              Utils.text(
                                                text: ipo.name,
                                                color: kBlackColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Lot Size ',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.lotSize,
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF001533),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'IPO Type ',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.ipoType,
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF001533),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Bid Start Date ',
                                                  style: GoogleFonts.poppins(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingStartDate,
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF001533),
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ) :
          Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(child: Utils.text(
                  text: "No Data Found!",
                  color: Colors.black,
                  fontSize: 15
              ),),
              const SizedBox(
                height: 50,
              ),
            ],
          );
        } else {
          return Center(child: Utils.text(
              text: 'No data available',
              color: Colors.black,
              fontSize: 15
          ));
        }
      },
    );
  }

}

import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/ClientWiseBidReport/ClientWiseBidReport.dart';
import 'package:connect/ConnectApp/Models/IpoModels/IpoModel.dart';
import 'package:connect/ConnectApp/Screens/DashBoardScreen/viewFullBidDetailsScreen.dart';
import 'package:connect/ConnectApp/Screens/IPOScreens/IPODetailsScreen.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class BackOfficeIpoScreen extends StatefulWidget {
  const BackOfficeIpoScreen({super.key});

  @override
  State<BackOfficeIpoScreen> createState() => _BackOfficeIpoScreenState();
}

class _BackOfficeIpoScreenState extends State<BackOfficeIpoScreen> with SingleTickerProviderStateMixin{

  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;
  final ApiServices _apiService = ApiServices();
  Future<ClientBidReportResponse>? futureClientBidReport;
  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;
  List<IpoDetails> upcomingFilteredData = [];
  List<IpoDetails> openFilteredData = [];
  List<IpoDetails> upcomingOriginalData = [];
  List<IpoDetails> openOriginalData = [];
  String selectedColumn = 'Ipo Type';
  String selectedOperator = 'equals';
  String filterValue = '';

  final List<String> columns = ['ID', 'Ipo Type'];
  final List<String> operators = ['contains', 'equals', 'starts with', 'ends with', 'is empty', 'is not empty', 'is any of'];

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener((){
      setState(() {});
    });
    fetchIpoData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> fetchIpoData() async {
    upcomingIPO = _apiService.fetchUpcomingIpoDetails(source: "ap");
    upcomingIPO?.then((response) {
      setState(() {
        upcomingFilteredData = response.data;
        upcomingOriginalData = response.data;
      });
    });
    openIPO = _apiService.fetchOpenIpoDetails(source: "ap");
    openIPO?.then((response) {
      setState(() {
        openFilteredData = response.data;
        openOriginalData = response.data;
      });
    });
  }

  void applyOpenIpoFilter() {
    setState(() {
      openFilteredData = openOriginalData.where((item) {
        int index = openOriginalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'ID':
            return applyOperator(index.toString());
          case 'Ipo Type':
            return applyOperator(item.ipoType);
          default:
            return false;
        }
      }).toList();
    });
  }

  void applyUpcomingIpoFilter() {
    setState(() {
      upcomingFilteredData = upcomingOriginalData.where((item) {
        int index = upcomingOriginalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'ID':
            return applyOperator(index.toString());
          case 'Ipo Type':
            return applyOperator(item.ipoType);
          default:
            return false;
        }
      }).toList();
    });
  }

  bool applyOperator(String value) {
    switch (selectedOperator) {
      case 'contains':
        return value.contains(filterValue);
      case 'equals':
        return value == filterValue;
      case 'starts with':
        return value.startsWith(filterValue);
      case 'ends with':
        return value.endsWith(filterValue);
      case 'is empty':
        return value.isEmpty;
      case 'is not empty':
        return value.isNotEmpty;
      case 'is any of':
        List<String> values = filterValue.split(',');
        return values.contains(value);
      default:
        return false;
    }
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
          fontWeight: FontWeight.bold,
        ),
        actions: _tabController?.index == 2
            ? [
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
          ),
        ]
            : [
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
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: kBlackColor),
            color: Colors.white,
            onSelected: (String result) async {
              if (result == "Filters") {
                Get.bottomSheet(
                  backgroundColor: Colors.white,
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 07,
                            ),
                            Row(
                              children: [
                                Utils.text(
                                  text: "Filters",
                                  color: kBlackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      fetchIpoData();
                                      Get.back();
                                    });
                                  },
                                  child: Utils.text(
                                    text: "Reset",
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  filterValue = value;
                                });
                              },
                              decoration: const InputDecoration(
                                fillColor: Colors.transparent,
                                labelText: 'Enter Ipo Type',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                _tabController?.index == 0 ? applyOpenIpoFilter() : applyUpcomingIpoFilter();
                                Get.back();
                              },
                              child: Utils.gradientButton(
                                message: "Apply Filter",
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Filters',
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Utils.text(
                      text: "Filters",
                      color: Colors.black,
                      fontSize: 15,
                    )
                  ],
                ),
              ),
            ],
          ),
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
          labelStyle: GoogleFonts.inter(color: const Color(0xFF00A9FF), fontSize: 15),
          unselectedLabelStyle: GoogleFonts.inter(color: kBlackColor, fontSize: 15),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Bid Details'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
              onRefresh: fetchIpoData,
              child: SingleChildScrollView(child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: openIPOsList(),
                  ),
                ],
              ))),
          RefreshIndicator(
              onRefresh: fetchIpoData,
              child: SingleChildScrollView(child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: upcomingIPOs(),
                  ),
                ],
              ))),
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
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                  child: Lottie.asset('assets/lottie/loading.json',
                      height: 100, width: 100)),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Utils.noDataFound(),
            ],
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
                                        style: GoogleFonts.inter(
                                          color: kBlackColor,
                                          fontSize: 10,
                                        ),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: report.bidAmount,
                                            style: GoogleFonts.inter(
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
                                      style: GoogleFonts.inter(
                                        color: kBlackColor,
                                        fontSize: 10,
                                      ),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: report.timestamp,
                                          style: GoogleFonts.inter(
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
                                  Colors.black,
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
              );
            },
          );
        } else {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        }
      },
    );
  }

  Widget openIPOsList() {
    return FutureBuilder<IpoDetailsResponse>(
      future: openIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                  child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return openFilteredData.isNotEmpty ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: openFilteredData.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = openFilteredData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 05.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return IPODetailsScreen(name: "open IPO",data: ipo,);
                        },),);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:  const Color(0xFFEAF9FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.text(
                                text: ipo.name,
                                color: const Color(0xFF001533),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              ),
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
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Lot Size : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.lotSize,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'IPO Type : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.ipoType,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Bid Start Date : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingStartDate,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
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
                height: 150,
              ),
            ],
          ) : Utils.noDataFound();
        } else {
          return Utils.noDataFound();
        }
      },
    );
  }

  Widget upcomingIPOs() {
    return FutureBuilder<IpoDetailsResponse>(
      future: upcomingIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                  child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return upcomingFilteredData.isNotEmpty ?  Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: upcomingFilteredData.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = upcomingFilteredData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 05.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return IPODetailsScreen(name: "upcoming IPO",data: ipo,);
                        },));
                      },
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
                                              SizedBox(
                                                width: 280,
                                                child: Utils.text(
                                                    text: ipo.name,
                                                    color: const Color(0xFF001533),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    textAlign: TextAlign.start,
                                                    textOverFlow: TextOverflow.ellipsis
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Lot Size : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.lotSize,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'IPO Type : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.ipoType,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Bid Start Date : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingStartDate,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
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
                height: 150,
              ),
            ],
          ) : Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        }
      },
    );
  }
}

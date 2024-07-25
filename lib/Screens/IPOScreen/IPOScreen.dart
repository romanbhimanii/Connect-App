import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/ClientWiseBidReport/ClientWiseBidReport.dart';
import 'package:connect/Screens/DashBoardScreen/viewFullBidDetailsScreen.dart';
import 'package:connect/Screens/IPOScreen/IpoProvider.dart';
import 'package:connect/Screens/IPOScreens/IPODetailsScreen.dart';
import 'package:connect/SettingsScreen/SettingsScreen.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class IPOScreen extends StatefulWidget {
  const IPOScreen({super.key});

  @override
  State<IPOScreen> createState() => _IPOScreenState();
}

class _IPOScreenState extends State<IPOScreen>  with SingleTickerProviderStateMixin{

  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;
  Future<ClientBidReportResponse>? futureClientBidReport;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _tabController = TabController(length: 3, vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void loadData() {
    final ipoProvider = Provider.of<IpoProvider>(context, listen: false);
    ipoProvider.fetchUpcomingIpoDetails();
    ipoProvider.fetchOpenIpoDetails();
    futureClientBidReport = ApiServices().fetchClientBidReports(token: Appvariables.token);
  }

  Future<void> refreshData() async {
    final ipoProvider = Provider.of<IpoProvider>(context, listen: false);
    await ipoProvider.refreshData();
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
              onRefresh: refreshData,
              child: SingleChildScrollView(child: Column(
                children: [
                  _buildIpoList(context, isUpcoming: false),
                ],
              ))),
          RefreshIndicator(
              onRefresh: refreshData,
              child: SingleChildScrollView(child: Column(
                children: [
                  _buildIpoList(context, isUpcoming: true),
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
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //         child: SizedBox(
          //           child: Column(
          //             children: [
          //               openIPOsList(),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SingleChildScrollView(
          //   child: Column(
          //     children: [
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //         child: Column(
          //           children: [
          //             upcomingIPOs(),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
              Center(
                child: Utils.text(text: 'No Data Found!', color: kBlackColor),
              ),
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
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                child: Utils.text(
                    text: 'No data found', color: kBlackColor, fontSize: 15),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildIpoList(BuildContext context, {required bool isUpcoming}) {
    return Consumer<IpoProvider>(
      builder: (context, ipoProvider, child) {
        final ipoData = isUpcoming ? ipoProvider.upcomingIpoDetails : ipoProvider.openIpoDetails;
        if (ipoData == null) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                child: Lottie.asset('assets/lottie/loading.json', height: 100, width: 100),
              ),
            ],
          );
        } else if (ipoData.data.isEmpty) {
          return Center(child: Utils.text(text: "No Data Found!", color: Colors.black, fontSize: 15));
        }
        return ipoData.data.isNotEmpty ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: ipoData.data.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = ipoData.data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return IPODetailsScreen(name: isUpcoming ? "upcoming IPO" : "open IPO",data: ipo,);
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
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Visibility(
                                    visible: !isUpcoming,
                                    child: Container(
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
          ),
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
      },
    );
  }

  // Widget openIPOsList() {
  //   return FutureBuilder<IpoDetailsResponse>(
  //     future: openIPO,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(
  //             child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
  //       } else if (snapshot.hasError) {
  //         return Center(child: Utils.text(
  //           text: 'Error: ${snapshot.error}',
  //           color: Colors.black,
  //         ));
  //       } else if (snapshot.hasData) {
  //         final data = snapshot.data!.data;
  //         return data.isNotEmpty ? Column(
  //           children: [
  //             ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: data.length,
  //               physics: const NeverScrollableScrollPhysics(),
  //               padding: const EdgeInsets.all(0),
  //               itemBuilder: (context, index) {
  //                 final ipo = data[index];
  //                 return InkWell(
  //                   onTap: () {
  //                     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                       return IPODetailsScreen(name: "open IPO",data: ipo,);
  //                     },));
  //                   },
  //                   child: Card(
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                         color:  const Color(0xFFEAF9FF),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
  //                         child: Column(
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.end,
  //                               children: [
  //                                 Column(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Column(
  //                                           mainAxisAlignment: MainAxisAlignment.start,
  //                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                           children: [
  //                                             Utils.text(
  //                                               text: ipo.name,
  //                                               color: const Color(0xFF4A5568),
  //                                               fontSize: 14,
  //                                               fontWeight: FontWeight.w600,
  //                                               textAlign: TextAlign.start,
  //                                             ),
  //                                             const SizedBox(height: 5),
  //                                             RichText(
  //                                               textAlign: TextAlign.start,
  //                                               text: TextSpan(
  //                                                 text: 'Lot Size ',
  //                                                 style: GoogleFonts.poppins(
  //                                                     color: const Color(0xFF4A5568),
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w600
  //                                                 ),
  //                                                 children: <InlineSpan>[
  //                                                   TextSpan(
  //                                                     text: ipo.lotSize,
  //                                                     style: GoogleFonts.poppins(
  //                                                       color: const Color(0xFF001533),
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             const SizedBox(height: 5),
  //                                             RichText(
  //                                               textAlign: TextAlign.start,
  //                                               text: TextSpan(
  //                                                 text: 'IPO Type ',
  //                                                 style: GoogleFonts.poppins(
  //                                                     color: const Color(0xFF4A5568),
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w600
  //                                                 ),
  //                                                 children: <InlineSpan>[
  //                                                   TextSpan(
  //                                                     text: ipo.ipoType,
  //                                                     style: GoogleFonts.poppins(
  //                                                       color: const Color(0xFF001533),
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             const SizedBox(height: 5),
  //                                             RichText(
  //                                               textAlign: TextAlign.start,
  //                                               text: TextSpan(
  //                                                 text: 'Bid Start Date ',
  //                                                 style: GoogleFonts.poppins(
  //                                                     color: const Color(0xFF4A5568),
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w600
  //                                                 ),
  //                                                 children: <InlineSpan>[
  //                                                   TextSpan(
  //                                                     text: ipo.biddingStartDate,
  //                                                     style: GoogleFonts.poppins(
  //                                                       color: const Color(0xFF001533),
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const Spacer(),
  //                                 Container(
  //                                   height: 30,
  //                                   decoration: BoxDecoration(
  //                                     borderRadius: BorderRadius.circular(10),
  //                                     color: const Color(0xFF2970E8),
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                                     child: Center(
  //                                       child: Utils.text(
  //                                         text: "Apply Now",
  //                                         color: Colors.white,
  //                                         fontWeight: FontWeight.w500,
  //                                         fontSize: 12,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             const SizedBox(
  //               height: 100,
  //             ),
  //           ],
  //         ) : Column(
  //           children: [
  //             const SizedBox(
  //               height: 50,
  //             ),
  //             Center(child: Utils.text(
  //                 text: "No Data Found!",
  //                 color: Colors.black,
  //                 fontSize: 15
  //             ),),
  //             const SizedBox(
  //               height: 50,
  //             ),
  //           ],
  //         );
  //       } else {
  //         return Center(child: Utils.text(
  //             text: 'No data available',
  //             color: Colors.black,
  //             fontSize: 15
  //         ));
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
  //         return Center(
  //             child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
  //       } else if (snapshot.hasError) {
  //         return Center(child: Utils.text(
  //           text: 'Error: ${snapshot.error}',
  //           color: Colors.black,
  //         ));
  //       } else if (snapshot.hasData) {
  //         final data = snapshot.data!.data;
  //         return data.isNotEmpty ? Column(
  //           children: [
  //             ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: data.length,
  //               physics: const NeverScrollableScrollPhysics(),
  //               padding: const EdgeInsets.all(0),
  //               itemBuilder: (context, index) {
  //                 final ipo = data[index];
  //                 return InkWell(
  //                   onTap: () {
  //                     Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                       return IPODetailsScreen(name: "upcoming IPO",data: ipo,);
  //                     },));
  //                   },
  //                   child: Card(
  //                     color: Colors.white,
  //                     child: Container(
  //                       decoration: BoxDecoration(
  //                           color:  const Color(0xFFEAF9FF),
  //                           borderRadius: BorderRadius.circular(10)),
  //                       child: Padding(
  //                         padding: const EdgeInsets.symmetric(
  //                             horizontal: 10.0, vertical: 10),
  //                         child: Column(
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               children: [
  //                                 Column(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   crossAxisAlignment: CrossAxisAlignment.start,
  //                                   children: [
  //                                     Row(
  //                                       children: [
  //                                         Column(
  //                                           mainAxisAlignment:
  //                                           MainAxisAlignment.start,
  //                                           crossAxisAlignment:
  //                                           CrossAxisAlignment.start,
  //                                           children: [
  //                                             Utils.text(
  //                                               text: ipo.name,
  //                                               color: kBlackColor,
  //                                               fontSize: 13,
  //                                               fontWeight: FontWeight.w600,
  //                                               textAlign: TextAlign.start,
  //                                             ),
  //                                             const SizedBox(height: 5),
  //                                             RichText(
  //                                               textAlign: TextAlign.start,
  //                                               text: TextSpan(
  //                                                 text: 'Lot Size ',
  //                                                 style: GoogleFonts.poppins(
  //                                                     color: const Color(0xFF4A5568),
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w600
  //                                                 ),
  //                                                 children: <InlineSpan>[
  //                                                   TextSpan(
  //                                                     text: ipo.lotSize,
  //                                                     style: GoogleFonts.poppins(
  //                                                       color: const Color(0xFF001533),
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             const SizedBox(height: 5),
  //                                             RichText(
  //                                               textAlign: TextAlign.start,
  //                                               text: TextSpan(
  //                                                 text: 'IPO Type ',
  //                                                 style: GoogleFonts.poppins(
  //                                                     color: const Color(0xFF4A5568),
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w600
  //                                                 ),
  //                                                 children: <InlineSpan>[
  //                                                   TextSpan(
  //                                                     text: ipo.ipoType,
  //                                                     style: GoogleFonts.poppins(
  //                                                       color: const Color(0xFF001533),
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                             const SizedBox(height: 5),
  //                                             RichText(
  //                                               textAlign: TextAlign.start,
  //                                               text: TextSpan(
  //                                                 text: 'Bid Start Date ',
  //                                                 style: GoogleFonts.poppins(
  //                                                     color: const Color(0xFF4A5568),
  //                                                     fontSize: 14,
  //                                                     fontWeight: FontWeight.w600
  //                                                 ),
  //                                                 children: <InlineSpan>[
  //                                                   TextSpan(
  //                                                     text: ipo.biddingStartDate,
  //                                                     style: GoogleFonts.poppins(
  //                                                       color: const Color(0xFF001533),
  //                                                       fontSize: 13,
  //                                                     ),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             const SizedBox(
  //               height: 100,
  //             ),
  //           ],
  //         ) :
  //         Column(
  //           children: [
  //             const SizedBox(
  //               height: 50,
  //             ),
  //             Center(child: Utils.text(
  //                 text: "No Data Found!",
  //                 color: Colors.black,
  //                 fontSize: 15
  //             ),),
  //             const SizedBox(
  //               height: 50,
  //             ),
  //           ],
  //         );
  //       } else {
  //         return Center(child: Utils.text(
  //             text: 'No data available',
  //             color: Colors.black,
  //             fontSize: 15
  //         ));
  //       }
  //     },
  //   );
  // }
}

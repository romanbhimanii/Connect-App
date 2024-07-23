// ignore_for_file: must_be_immutable

import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/IpoModels/IpoModel.dart';
import 'package:connect/Screens/IPOScreens/IPODetailsScreen.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Viewalliposcreen extends StatefulWidget {
  String? name;
  Viewalliposcreen({super.key,required this.name});

  @override
  State<Viewalliposcreen> createState() => _ViewalliposcreenState();
}

class _ViewalliposcreenState extends State<Viewalliposcreen> {

  final ConnectivityService connectivityService = ConnectivityService();
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
    upcomingIPO = _apiService.fetchUpcomingIpoDetails();
    openIPO = _apiService.fetchOpenIpoDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF292D32))
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: widget.name == "open IPO" ? "Open Ipo" : "Upcoming Ipo",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.name == "open IPO" ? openIPOsList() : upcomingIPOs(),
              ],
            ),
          ),
        ),
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
            color: kBlackColor
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final ipo = data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IPODetailsScreen(name: widget.name,data: ipo,);
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
          ) : Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
              ),
              Center(child: Utils.text(
                  text: "No Data Found!",
                  color: kBlackColor,
                  fontSize: 15
              ),)
            ],
          );
        } else {
          return Center(child: Utils.text(
            text: 'No data available',
            color: kBlackColor,
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
            color: kBlackColor
          ));
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return data.isNotEmpty ?  ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final ipo = data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IPODetailsScreen(name: widget.name,data: ipo,);
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
          ) : Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
              ),
              Center(child: Utils.text(
                  text: "No Data Found!",
                  color: kBlackColor,
                  fontSize: 15
              ),),
            ],
          );
        } else {
          return Center(child: Utils.text(
            text: 'No data available',
            color: kBlackColor
          ));
        }
      },
    );
  }

}

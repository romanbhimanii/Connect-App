import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/BankDetailsModel/BankDetailsModel.dart';
import 'package:connect/Screens/MyAccountScreen/DownloadScreen/DownloadScreen.dart';
import 'package:connect/Screens/MyAccountScreen/FundScreen/FundScreen.dart';
import 'package:connect/Screens/MyAccountScreen/ProfileScreen/ProfileScreen.dart';
import 'package:connect/Screens/MyAccountScreen/SegmentAdditionScreen/SegmentAdditionScreen.dart';
import 'package:connect/Screens/MyAccountScreen/eMandateScreen/eMandateScreen.dart';
import 'package:connect/Utils/AppDrawer.dart';
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

class Myaccountscreen extends StatefulWidget {
  const Myaccountscreen({super.key});

  @override
  State<Myaccountscreen> createState() => _MyaccountscreenState();
}

class _MyaccountscreenState extends State<Myaccountscreen>
    with SingleTickerProviderStateMixin {
  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;
  Future<BankDetailsResponse>? futureBankDetails;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _tabController = TabController(length: 5, vsync: this);
    futureBankDetails = ApiServices().fetchBankDetails(token: Appvariables.token);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: "My Account",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        elevation: 0.0,
        bottom: TabBar(
          dividerHeight: 0.0,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          automaticIndicatorColorAdjustment: true,
          controller: _tabController,
          labelPadding: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.all(0),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFF0066F6),
              width: 1,
            ),
          ),
          labelStyle: GoogleFonts.poppins(color: const Color(0xFF0066F6), fontSize: 15),
          unselectedLabelStyle: GoogleFonts.poppins(color: kBlackColor, fontSize: 15),
          indicatorColor: kBlackColor,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tab(text: 'Profile'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tab(text: 'Segment Addition'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tab(text: 'Fund'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tab(text: 'e-Mandate'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Tab(text: 'Download'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProfileScreen(),
          SegmentAdditionScreen(),
          Fundscreen(),
          eMandateScreen(),
          Downloadscreen(),
        ],
      ),
    );
  }

  Widget fetchBankDetails() {
    return FutureBuilder<BankDetailsResponse>(
      future: futureBankDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
        } else if (snapshot.hasError) {
          return Center(
              child: Utils.text(
                  text: 'Error: ${snapshot.error}', color: kBlackColor));
        } else if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: snapshot.data!.data.bankName.length,
            itemBuilder: (context, index) {
              final bankName = snapshot.data!.data.bankName['$index']!;
              final bankAccountNumber =
                  snapshot.data!.data.bankAccountNumber['$index']!;
              final ifscCode = snapshot.data!.data.ifscCode['$index']!;
              final micrCode = snapshot.data!.data.micrCode['$index']!;
              final bankAccountType =
                  snapshot.data!.data.bankAccountType['$index']!;
              final defaultAccount =
                  snapshot.data!.data.defaultAccount['$index']!;
              return ListTile(
                title: Utils.text(text: bankName, color: kBlackColor),
                subtitle: Utils.text(
                    text:
                        'Account No: $bankAccountNumber\nIFSC: $ifscCode\nMICR: $micrCode\nType: $bankAccountType\nDefault: $defaultAccount',
                    color: kBlackColor),
              );
            },
          );
        } else {
          return Center(
              child: Utils.text(text: 'No data available', color: kBlackColor));
        }
      },
    );
  }
}

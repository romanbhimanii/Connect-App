
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/IncomeTaxReportModel/IncomeTaxReportModel.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Incometaxreportscreen extends StatefulWidget {
  const Incometaxreportscreen({super.key});

  @override
  State<Incometaxreportscreen> createState() => _IncometaxreportscreenState();
}

class _IncometaxreportscreenState extends State<Incometaxreportscreen> with SingleTickerProviderStateMixin{

  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;
  List<bool>? isShow;
  List<bool>? isShow1;
  List<bool>? isShow2;
  List<bool>? isShow3;
  List<bool>? isShow4;
  List<bool>? isShow5;
  List<bool>? isShow6;
  List<bool>? isShow7;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _tabController = TabController(length: 8, vsync: this);
    fetchIncomeTaxReport();
  }

  Future<void> fetchIncomeTaxReport() async {
    if(Appvariables.futureIncomeTaxReport.isNull || Appvariables.futureIncomeTaxReport == null){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime time = DateTime.now();
      String year = prefs.getString('year') ?? "${time.year}";
      setState(() {
        Appvariables.futureIncomeTaxReport = ApiServices().getIncomeTaxReport(token: Appvariables.token,financialYear: year);
      });
      Appvariables.futureIncomeTaxReport?.then((data) {
        if(mounted){
          setState(() {
            isShow = List<bool>.filled((data?.data?.aSSETS?.length ?? 0), false);
            isShow1 = List<bool>.filled((data?.data?.eXPENSES?.length ?? 0), false);
            isShow2 = List<bool>.filled((data?.data?.lONGTERM?.length ?? 0), false);
            isShow3 = List<bool>.filled((data?.data?.oPASSETS?.length ?? 0), false);
            isShow4 = List<bool>.filled((data?.data?.oPSHORTTERM?.length ?? 0), false);
            isShow5 = List<bool>.filled((data?.data?.sHORTTERM?.length ?? 0), false);
            isShow6 = List<bool>.filled((data?.data?.tRADING?.length ?? 0),false);
            isShow7 = List<bool>.filled((data?.data?.grandTotal?.length ?? 0), false);
          });
        }
      });
    }
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
        leadingWidth: 50,
        centerTitle: true,
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
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        title: Utils.text(
          text: "Income Tax Report",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
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
              color: const Color(0xFF00A9FF),
              width: 1,
            ),
          ),
          labelStyle:
          GoogleFonts.inter(color: const Color(0xFF00A9FF), fontSize: 15),
          unselectedLabelStyle:
          GoogleFonts.inter(color: kBlackColor, fontSize: 15),
          indicatorColor: kBlackColor,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Assets'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Expenses'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Long Term'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Op Assets'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Op Short Term'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Short Term'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Trading'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Grand Total'),
            ),
          ],
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.aSSETS?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (report.data?.aSSETS?.length ?? 0),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.aSSETS?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow?[index] = !(isShow?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                            text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                            color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                            fontSize: 12,
                                                            textOverFlow: TextOverflow.ellipsis,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ) :
                            Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.eXPENSES?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (report.data?.eXPENSES?.length ?? 0),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.eXPENSES?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow1?[index] = !(isShow1?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow1?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ) : Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.lONGTERM?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (report.data?.lONGTERM?.length ?? 0),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.lONGTERM?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow2?[index] = !(isShow2?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow1?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ) : Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.oPASSETS?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (report.data?.oPASSETS?.length ?? 0),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.oPASSETS?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow3?[index] = !(isShow3?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow3?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ) : Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.oPSHORTTERM?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (report.data?.oPSHORTTERM?.length ?? 0),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.oPSHORTTERM?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow4?[index] = !(isShow4?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow1?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ) : Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.sHORTTERM?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (report.data?.sHORTTERM?.length ?? 0),
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.sHORTTERM?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow5?[index] = !(isShow5?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow1?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ) : Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                          }
                          else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }
                          else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.tRADING?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: report.data?.tRADING?.length ?? 0,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.tRADING?[index];
                                    return assetsReport.isNull ? Utils.noDataFound()
                                     : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow6?[index] = !(isShow6?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: assetsReport?.netAmount ?? "N/A",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt ?? "N/A",
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow6?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ) : Utils.noDataFound();
                          }
                          else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        RefreshIndicator(
          onRefresh: () {
            setState(() {
              Appvariables.futureIncomeTaxReport = null;
            });
            return fetchIncomeTaxReport();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      FutureBuilder<IncomeTaxReport?>(
                        future: Appvariables.futureIncomeTaxReport,
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
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.hasData) {
                            final report = snapshot.data!;
                            return report.data?.grandTotal?.isNotEmpty ?? false ? Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: report.data?.grandTotal?.length,
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    final assetsReport = report.data?.grandTotal?[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            isShow7?[index] = !(isShow7?[index] ?? false);
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: const Color(0xFFEAF9FF),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: 220,
                                                      child: Utils.text(
                                                        text: assetsReport?.scripName ?? "N/A",
                                                        color: const Color(0xFF37474F),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12,
                                                        textOverFlow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Column(
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Amt",
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                          fontSize: 10,
                                                        ),
                                                        Utils.text(
                                                          text: "${assetsReport?.netAmount}" == "" ? "N/A" : "${assetsReport?.netAmount}",
                                                          color: (assetsReport?.netAmount?.startsWith('-') ?? false) ? Colors.red : Colors.green,
                                                          fontSize: 12,
                                                          textOverFlow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Net Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.netRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Buy Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.buyAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleQty,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleRate,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Utils.text(
                                                          text: "Sale Amt",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        ),
                                                        Utils.text(
                                                            text: assetsReport?.saleAmt,
                                                            color: Colors.black,
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (isShow1?[index] ?? false),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(05.0),
                                                          child: Column(
                                                            children: [
                                                              Divider(
                                                                color: Colors.grey.shade800.withOpacity(0.2),
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Visibility(
                                                                visible: assetsReport?.scripName != "",
                                                                child: Row(
                                                                  children: [
                                                                    Utils.text(
                                                                      text: (assetsReport?.scripName?.length ?? 0) > 10 ? "${assetsReport?.scripName?.substring(0,10)}..." : assetsReport?.scripName,
                                                                      color: Colors.black,
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w600,
                                                                      textAlign: TextAlign.start,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 05,
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: () {
                                                                          showDialog(
                                                                            context: context, builder: (context) {
                                                                            return AlertDialog(
                                                                              contentPadding: const EdgeInsets.all(10),
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Utils.text(
                                                                                    text: assetsReport?.scripName,
                                                                                    color: Colors.black,
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    textAlign: TextAlign.start,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },);
                                                                        },
                                                                        child: const Icon(Icons.info,color: Colors.grey,size: 20,)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double.infinity,
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(05),
                                                                  border: Border.all(color: Colors.grey.shade800.withOpacity(0.2)),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Net Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.netQty == "" ? "N/A" : assetsReport?.netQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.netRate == "" ? "N/A" : assetsReport?.netRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Buy Rate",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: assetsReport?.buyQty == "" ? "N/A" : assetsReport?.buyQty,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: assetsReport?.buyRate == "" ? "N/A" : assetsReport?.buyRate,
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 15,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Buy Amt",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "Sale Qty",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.buyAmt}" == "" ? "N/A" : "${assetsReport?.buyAmt}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          Utils.text(
                                                                            text: "${assetsReport?.saleQty}" == "" ? "N/A" : "${assetsReport?.saleQty}",
                                                                            color: kBlackColor87,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "Net Amount",
                                                                            color: kBlackColor87,
                                                                            fontSize: 11,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          Utils.text(
                                                                            text: "${assetsReport?.netAmount}",
                                                                            color: "${assetsReport?.netAmount}".startsWith("N/A") ? Colors.red : Colors.green,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
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
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 100,
                                )
                              ],
                            ) : Utils.noDataFound();
                          } else {
                            return Utils.noDataFound();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

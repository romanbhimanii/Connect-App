import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsDpDetailsModel/CDSLClientDetailsDpDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsTradingDetailsModel/CDSLClientDetailsTradingDetailsModel.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CDSLClientDetailsScreen extends StatefulWidget {
  const CDSLClientDetailsScreen({super.key});

  @override
  State<CDSLClientDetailsScreen> createState() => _CDSLClientDetailsScreenState();
}

class _CDSLClientDetailsScreenState extends State<CDSLClientDetailsScreen> with SingleTickerProviderStateMixin{

  TabController? _tabController;
  Future<List<DPDetails>>? futureDPDetails;
  Future<TradingDetailsResponse>? futureTradingDetails;
  final TextEditingController clientCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchDpDetails();
  }

  Future<void> fetchDpDetails() async {
    futureDPDetails = BackOfficeApiService().fetchDPDetails(token: Appvariablesbackoffice.token);
  }

  Future<void> fetchTradingDetails() async {
    if(clientCodeController.text != ""){
      futureTradingDetails = BackOfficeApiService().fetchTradingDetails(clientCode: clientCodeController.text,token: Appvariablesbackoffice.token);
    }
    setState(() {});
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
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Utils.text(
          text: "Client Details",
          color: const Color(0xFF00A9FF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
              child: Tab(text: 'DP Details'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Trading Details'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
              onRefresh: fetchDpDetails,
              child: SingleChildScrollView(child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: fetchDpDetailsWidget(),
                  ),
                ],
              ))),
          RefreshIndicator(
              onRefresh: fetchDpDetails,
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: clientCodeController,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        onEditingComplete: () {
                          fetchTradingDetails();
                        },
                        style: GoogleFonts.inter(
                          color: kBlackColor,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: "Enter Client Code",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Colors.blueGrey.shade600.withOpacity(0.15),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                          fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                        ),
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter Client Code";
                          }
                          return null;
                        },
                      ),
                      Visibility(
                        visible: clientCodeController.text != "",
                        child: fetchTradingDetailsWidget(),
                      ),
                    ],
                  ),
                  ))),
        ],
      ),
    );
  }

  Widget fetchDpDetailsWidget() {
    return FutureBuilder<List<DPDetails>>(
      future: futureDPDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          final dpDetails = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: dpDetails.length,
            itemBuilder: (context, index) {
              final dpDetail = dpDetails[index];
              return ListTile(
                title: Text(dpDetail.firstHoldName),
                subtitle: Text(dpDetail.boId),
              );
            },
          );
        }
      },
    );
  }

  Widget fetchTradingDetailsWidget() {
    return FutureBuilder<TradingDetailsResponse>(
      future: futureTradingDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final tradingDetails = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: tradingDetails.data.length,
            itemBuilder: (context, index) {
              final detail = tradingDetails.data[index];
              return ListTile(
                title: Text(detail.clientName),
                subtitle: Text(detail.companyCode),
              );
            },
          );
        } else {
          return const Center(child: Text('No data found'));
        }
      },
    );
  }
}

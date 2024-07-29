
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/EPledgeModel/EPledgeModel.dart';
import 'package:connect/ConnectApp/Models/EddpiDpProcessModel/EddpiDpProcessModel.dart';
import 'package:connect/ConnectApp/Models/StockVerificationDpProcessModel/StockVerificationDpProcessModel.dart';
import 'package:connect/ConnectApp/Screens/DpProcessScreen/EPledgeDetailsScreen.dart';
import 'package:connect/ConnectApp/Screens/DpProcessScreen/StockVerificationDetailsScreen.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Dpprocessscreen extends StatefulWidget {
  const Dpprocessscreen({super.key});

  @override
  State<Dpprocessscreen> createState() => _DpprocessscreenState();
}

class _DpprocessscreenState extends State<Dpprocessscreen>
    with SingleTickerProviderStateMixin {
  final ConnectivityService connectivityService = ConnectivityService();
  TabController? _tabController;
  String? selectedExchange;
  String? selectedTradeType;
  String datePickedValue = "";
  Future<EPledgeModel?>? ePledgeModel;
  Future<HoldingDataResponse?>? stockVerificationData;
  DetailedFileResponse? detailedFileResponse;
  DateTime now = DateTime.now();
  final List<String> items = ["Normal"];
  final List<String> tradeType = ["Post Trade"];

  @override
  void initState() {
    super.initState();
    datePickedValue = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _tabController = TabController(length: 3, vsync: this);
    ePledgeModel = ApiServices().ePledgeDpProcess(token: Appvariables.token);
    ApiServices()
        .fetchEddpiDpProcessUserData(Appvariables.clientCode)
        .then((response) {
      setState(() {
        detailedFileResponse = response;
      });
    });
    fetchData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    stockVerificationData = ApiServices().fetchStockVerificationDpProcessData();
  }

  Future<void> _showDateTimePicker() async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00A9FF),
              onPrimary: Colors.black,
              onSurface: Color(0xFF313131),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF313131),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (datePicked != null) {
      setState(() {
        datePickedValue = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      });
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: "Dp Process",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
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
                border: Border.all(
                  color: const Color(0xFF292D32),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFF292D32),
                  size: 18,
                ),
              ),
            ),
          ),
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
            color: Colors.white,
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
              child: Tab(text: 'Stock Verification'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'E-Pledge'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'EDDPI'),
            ),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down_rounded,color: Color(0xFF91919F),size: 40,),
                    iconSize: 25,
                  ),
                  hint: Utils.text(
                    text: "EDS Type",
                    color: const Color(0xFF91919F),
                    fontSize: 16,),
                  items: items
                      .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Utils.text(
                        text: item,
                        color: const Color(0xFF4A5568),
                        fontSize: 15,),
                    ),
                  ))
                      .toList(),
                  value: selectedExchange,
                  onChanged: (String? value) {
                    setState(() {
                      selectedExchange = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 04),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF1F1FA)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  iconStyleData: const IconStyleData(
                    icon: Icon(Icons.keyboard_arrow_down_rounded,color: Color(0xFF91919F),size: 40,),
                    iconSize: 25,
                  ),
                  hint: Utils.text(
                    text: "Trade Type",
                    color: const Color(0xFF91919F),
                    fontSize: 16,),
                  items: tradeType
                      .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Utils.text(
                        text: item,
                        color: const Color(0xFF4A5568),
                        fontSize: 15,),
                    ),
                  ))
                      .toList(),
                  value: selectedTradeType,
                  onChanged: (String? value) {
                    setState(() {
                      selectedTradeType = value;
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: const EdgeInsets.symmetric(horizontal: 04),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF1F1FA)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                onTap: () async{
                  await _showDateTimePicker();
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFF1F1FA)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 05.0),
                    child: Row(
                      children: [
                        Utils.text(
                          text: datePickedValue,
                          color: const Color(0xFF91919F),
                          fontSize: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<HoldingDataResponse?>(
                future: stockVerificationData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Lottie.asset('assets/lottie/loading.json',
                            height: 100, width: 100));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/icons/NoDataFound.svg",height: 100,width: 100,),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Utils.text(
                              text: "No data Found!",
                              color: kBlackColor,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  else if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data != null && data.data.isNotEmpty) {
                      return ListView.builder(
                        itemCount: data.data.length,
                        itemBuilder: (context, index) {
                          final response = data.data[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 05),
                            child: InkWell(
                              onTap: () {
                                Get.to(const StockVerificationDetailsScreen(),
                                    arguments: ({'data': response}));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAF9FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Column(
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
                                                text: "Name",
                                                color: const Color(0xFF4A5568)
                                                    .withOpacity(0.70),
                                                fontSize: 10,
                                              ),
                                              SizedBox(
                                                width: 220,
                                                child: Utils.text(
                                                  text: response.scripName,
                                                  color: const Color(0xFF0F3F62),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  textOverFlow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Utils.text(
                                                text: "Amount",
                                                color: const Color(0xFF4A5568)
                                                    .withOpacity(0.70),
                                                fontSize: 10,
                                              ),
                                              Utils.text(
                                                text: response.amount,
                                                color: const Color(0xFF0F3F62),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                textOverFlow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Utils.text(
                                                text: "ISIN",
                                                color: const Color(0xFF4A5568)
                                                    .withOpacity(0.70),
                                                fontSize: 10,
                                              ),
                                              Utils.text(
                                                text: response.isin,
                                                color: const Color(0xFF0F3F62),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                textOverFlow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Utils.text(
                                                text: "Net",
                                                color: const Color(0xFF4A5568)
                                                    .withOpacity(0.70),
                                                fontSize: 10,
                                              ),
                                              Utils.text(
                                                text: response.net,
                                                color: const Color(0xFF0F3F62),
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                textOverFlow: TextOverflow.ellipsis,
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
                      );
                    } else {
                      return Utils.noDataFound();
                    }
                  }
                  else {
                    return Utils.noDataFound();
                  }
                },
              ),
            ),
          ],
        ),
        FutureBuilder<EPledgeModel?>(
          future: ePledgeModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Lottie.asset('assets/lottie/loading.json',
                      height: 100, width: 100));
            } else {
              if (snapshot.hasError) {
                return Utils.noDataFound();
              } else if (!snapshot.hasData || snapshot.data!.data == null) {
                return Utils.noDataFound();
              } else {
                final data = snapshot.data!;
                return ListView.builder(
                  itemCount: data.data!.filteredDf!.length,
                  itemBuilder: (context, index) {
                    final response = data.data!.filteredDf?[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 05),
                      child: InkWell(
                        onTap: () {
                          Get.to(const Epledgedetailsscreen(),
                              arguments: ({'data': response}));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF9FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10),
                            child: Column(
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
                                          text: "Name",
                                          color: const Color(0xFF4A5568)
                                              .withOpacity(0.70),
                                          fontSize: 10,
                                        ),
                                        SizedBox(
                                          width: 220,
                                          child: Utils.text(
                                            text: response?.scripName,
                                            color: const Color(0xFF0F3F62),
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            textOverFlow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Utils.text(
                                          text: "Amount",
                                          color: const Color(0xFF4A5568)
                                              .withOpacity(0.70),
                                          fontSize: 10,
                                        ),
                                        Utils.text(
                                          text: response?.amount,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          textOverFlow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Utils.text(
                                          text: "ISIN",
                                          color: const Color(0xFF4A5568)
                                              .withOpacity(0.70),
                                          fontSize: 10,
                                        ),
                                        Utils.text(
                                          text: response?.isin,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          textOverFlow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Utils.text(
                                          text: "Net",
                                          color: const Color(0xFF4A5568)
                                              .withOpacity(0.70),
                                          fontSize: 10,
                                        ),
                                        Utils.text(
                                          text: response?.net,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          textOverFlow: TextOverflow.ellipsis,
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
                );
              }
            }
          },
        ),
        detailedFileResponse != null
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color(0xFFEAF9FF),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                          text: "BOID",
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF777777),
                                          fontSize: 12),
                                      Utils.text(
                                          text: detailedFileResponse?.data.clientDpCode,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 14),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: const Color(0xFF2970E8).withOpacity(0.05),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                          text: "BO Name",
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF777777),
                                          fontSize: 12),
                                      Utils.text(
                                          text: detailedFileResponse?.data.clientName,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 14),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: const Color(0xFF2970E8).withOpacity(0.05),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                          text: "Date",
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF777777),
                                          fontSize: 12),
                                      Utils.text(
                                          text: "${now.day}-${now.month}-${now.year}",
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 14),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: const Color(0xFF2970E8).withOpacity(0.05),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                          text: "BO Address",
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF777777),
                                          fontSize: 12),
                                      Utils.text(
                                          text: detailedFileResponse?.data.resiAddress,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 14),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: const Color(0xFF2970E8).withOpacity(0.05),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                          text: "DDPI Status",
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF777777),
                                          fontSize: 12),
                                      Utils.text(
                                          text: detailedFileResponse?.data.uccStatus,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F3F62),
                                          fontSize: 14),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: const Color(0xFF2970E8).withOpacity(0.05),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Utils.noDataFound())
      ]),
    );
  }
}

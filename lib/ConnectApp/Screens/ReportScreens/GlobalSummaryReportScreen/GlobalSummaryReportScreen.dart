import 'dart:io';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/GlobalSummaryReportModel/GlobalSummaryReportModel.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Globalsummaryreportscreen extends StatefulWidget {
  const Globalsummaryreportscreen({super.key});

  @override
  State<Globalsummaryreportscreen> createState() =>
      _GlobalsummaryreportscreenState();
}

class _GlobalsummaryreportscreenState extends State<Globalsummaryreportscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  DateTime dateTime = DateTime.now();
  List<bool>? isShow;
  TotalsDf? totalsDf;
  final List<String> items = [
    'All',
    'Equity',
    'Derivatives',
    'Currency',
  ];
  final List<String> items1 = [
    'Yes',
    'No',
  ];
  String? selectedValue;
  String? selectedValue1;
  String datePickedValue = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    datePickedValue =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _fetchGlobalSummaryReport();
  }

  Future<void> _fetchGlobalSummaryReport() async {
    if(Appvariables.globalSummary.isNull || Appvariables.globalSummary == null){
      Appvariables.globalSummary = ApiServices().fetchGlobalSummary(
        toDate: datePickedValue,
        token: Appvariables.token,
        openBalance: selectedValue1 ?? "y",
      );
      Appvariables.globalSummary?.then((data) {
        if(mounted){
          setState(() {
            isShow = List<bool>.filled((data.data!.filteredDf?.length ?? 0), false);
            isLoading = false;
          });
        }
      });
    }
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
      datePickedValue = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      setState(() {
        Appvariables.globalSummary = null;
        isLoading = true;
        _fetchGlobalSummaryReport();
      });
    }
  }

  Future<void> exportToCSV(List<FilteredDf>? data) async {
    List<List<dynamic>> rows = [];
    rows.add([
      "Sr No",
      "Exchange",
      "Scrip Symbol",
      "Scrip Name",
      "Trade Qty",
      "Trade Amt",
      "Buy Qty",
      "Buy Rate",
      "Sale Qty",
      "Sale Rate",
      "Net Qty",
      "Net Rate",
      "Closing Price",
      "National P/L",
      "Net Amt"
    ]);

    for (int i = 0; i < data!.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.companyCode,
        item.scripSymbol,
        item.scripSymbol1,
        item.tradingQuantity,
        item.tradingAmount,
        item.buyQuantity,
        item.buyRate,
        item.saleQuantity,
        item.saleRate,
        item.netQuantity,
        item.netRate,
        item.closingPrice,
        item.fullScripSymbol,
        item.netAmount,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime time = DateTime.now();
      String year = prefs.getString('year') ?? "${time.year}";
      String reportYear = '';
      if (year == "") {
        reportYear = "${time.year}";
      } else if (year == "2024") {
        reportYear = "2024";
      } else if (year == "2023") {
        reportYear = "2023";
      } else if (year == "2022") {
        reportYear = "2022";
      } else if (year == "2021") {
        reportYear = "2021";
      }

      String path =
          "${directory?.path}/Global Summary Report Of$reportYear.csv";
      File file = File(path);

      await file.writeAsString(csv);
      OpenFile.open(path);
      Utils.toast(msg: "Exported to $path");
    } else {
      Utils.toast(msg: "Permission denied");
    }
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
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: "Global Summary",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 08.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Color(0xFF00A9FF),
                        ),
                        iconSize: 25,
                      ),
                      hint: Utils.text(
                          text: "Exchange Code",
                          color: const Color(0xFF00A9FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                      items: items
                          .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Utils.text(
                                    text: item,
                                    color: const Color(0xFF00A9FF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                          Appvariables.globalSummary = null;
                          isLoading = true;
                          _fetchGlobalSummaryReport();
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 40,
                        width: 140,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00A9FF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      await _showDateTimePicker();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF00A9FF)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 08),
                        child: Center(
                          child: Utils.text(
                              text: datePickedValue,
                              color: const Color(0xFF00A9FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      iconStyleData: const IconStyleData(
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Color(0xFF00A9FF),
                        ),
                        iconSize: 25,
                      ),
                      hint: Utils.text(
                          text: "Open Balance",
                          color: const Color(0xFF00A9FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                      items: items1
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Utils.text(
                                  text: item,
                                  color: const Color(0xFF00A9FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                          .toList(),
                      value: selectedValue1,
                      onChanged: (String? value) {
                        setState(
                          () {
                            selectedValue1 = value;
                            Appvariables.globalSummary = null;
                            isLoading = true;
                            _fetchGlobalSummaryReport();
                          },
                        );
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        width: 95,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF00A9FF),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: SvgPicture.asset("assets/icons/DownloadIcon.svg"),
                  color: Colors.white,
                  onSelected: (String result) async {
                    if (result == 'PDF') {
                      Utils.showLoadingDialogue(context);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      DateTime time = DateTime.now();
                      String year = prefs.getString('year') ?? "${time.year}";
                      String reportYear = '';
                      if (year == "") {
                        reportYear = "${time.year}";
                      } else if (year == "2024") {
                        reportYear = "2024";
                      } else if (year == "2023") {
                        reportYear = "2023";
                      } else if (year == "2022") {
                        reportYear = "2022";
                      } else if (year == "2021") {
                        reportYear = "2021";
                      }
                      // ApiServices().downloadReportDocuments(
                      //     token: Appvariables.token,
                      //     type: "ledger",
                      //     downloadType: "PDF",
                      //     year: reportYear,
                      //     context: context
                      // );
                    } else if (result == "Excel") {
                      if (await Appvariables.globalSummary != null) {
                        Appvariables.globalSummary?.then((response) {
                          if (response.data?.filteredDf != null) {
                            exportToCSV(response.data?.filteredDf);
                          }
                        });
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    // PopupMenuItem<String>(
                    //   value: 'PDF',
                    //   child: Row(
                    //     children: [
                    //       const Icon(
                    //         Icons.download,
                    //         color: Color.fromRGBO(27, 82, 52, 1.0),
                    //       ),
                    //       const SizedBox(
                    //         width: 8,
                    //       ),
                    //       Utils.text(
                    //         text: "PDF",
                    //         color: const Color.fromRGBO(27, 82, 52, 1.0),
                    //         fontSize: 15,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    PopupMenuItem<String>(
                      value: 'Excel',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.download,
                            color: Color.fromRGBO(27, 82, 52, 1.0),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Utils.text(
                            text: "Excel",
                            color: const Color.fromRGBO(27, 82, 52, 1.0),
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            isLoading = true;
            Appvariables.globalSummary = null;
          });
          return _fetchGlobalSummaryReport();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children: [
                        FutureBuilder<GlobalSummary?>(
                          future: Appvariables.globalSummary,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 250,
                                  ),
                                  Center(child: Lottie.asset('assets/lottie/loading.json', height: 100, width: 100)),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Utils.text(
                                      text: 'Error: ${snapshot.error}',
                                      color: Colors.black));
                            } else if (snapshot.hasData) {
                              final data = snapshot.data;
                              if (snapshot.data?.data?.totalsDf?.last.netAmount !=
                                      totalsDf?.netAmount ||
                                  totalsDf.isNull) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {
                                    totalsDf = snapshot.data?.data?.totalsDf?.last;
                                  });
                                });
                              }
                              return data == null
                                  ? Utils.noDataFound()
                                  : Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: data.data?.filteredDf?.length,
                                          physics: const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.all(0),
                                          itemBuilder: (context, index) {
                                            final globalSummaryReport =
                                                data.data?.filteredDf?[index];
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0, vertical: 05),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isShow?[index] =
                                                        !(isShow?[index] ?? false);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color: const Color(0xFFEAF9FF),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10.0, vertical: 10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 220,
                                                              child: Utils.text(
                                                                text: globalSummaryReport
                                                                    ?.scripSymbol1,
                                                                color: const Color(
                                                                    0xFF37474F),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                                textOverFlow:
                                                                    TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Column(
                                                              children: [
                                                                Utils.text(
                                                                  text: "Amount ",
                                                                  color: const Color(
                                                                          0xFF4A5568)
                                                                      .withOpacity(0.70),
                                                                  fontSize: 10,
                                                                ),
                                                                Utils.text(
                                                                  text: "${globalSummaryReport?.netAmount}" ==
                                                                          ""
                                                                      ? "-"
                                                                      : "${globalSummaryReport?.netAmount}",
                                                                  color:
                                                                      const Color(0xFF37474F),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight.w600,
                                                                  textOverFlow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Trade Qty",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.tradingQuantity}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Trade Amt",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.tradingAmount}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Buy Qty",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.buyQuantity}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Buy Rate",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.buyRate}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            // Utils.text(
                                                            //   text: "Scrip Name: ",
                                                            //   color: Colors.black,
                                                            //   fontSize: 12,
                                                            //   fontWeight: FontWeight.bold,
                                                            // ),
                                                            // Utils.text(
                                                            //   text: (globalSummaryReport
                                                            //                   ?.scripSymbol1
                                                            //                   ?.length ??
                                                            //               0) >
                                                            //           10
                                                            //       ? "${globalSummaryReport?.scripSymbol1?.substring(0, 10)}..."
                                                            //       : globalSummaryReport
                                                            //           ?.scripSymbol1,
                                                            //   color: Colors.black,
                                                            //   fontSize: 12,
                                                            //   textOverFlow: TextOverflow.ellipsis,
                                                            // ),
                                                            // const Spacer(),
                                                            // Utils.text(
                                                            //   text: "Net Profit : ",
                                                            //   color: Colors.black,
                                                            //   fontSize: 12,
                                                            //   fontWeight: FontWeight.bold,
                                                            // ),
                                                            // Utils.text(
                                                            //   text: "${globalSummaryReport?.notProfit}" ==
                                                            //           ""
                                                            //       ? "-"
                                                            //       : "${globalSummaryReport?.notProfit?.toStringAsFixed(2)}",
                                                            //   color:
                                                            //       "${globalSummaryReport?.notProfit}"
                                                            //               .startsWith("-")
                                                            //           ? Colors.red
                                                            //           : Colors.green,
                                                            //   fontSize: 12,
                                                            //   textOverFlow: TextOverflow.ellipsis,
                                                            // ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Sale Qty",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.saleQuantity}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Sale Rate",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.saleRate}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Net Qty",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.netQuantity}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Net Rate",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.netRate}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Closing Price",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.closingPrice}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Utils.text(
                                                                    text: "National P/L",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.fullScripSymbol}",
                                                                    color: Colors.black,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment.end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment.end,
                                                              children: [
                                                                Utils.text(
                                                                    text: "Net Amt",
                                                                    fontSize: 10,
                                                                    color: const Color(
                                                                        0xFF4A5568)),
                                                                Utils.text(
                                                                    text:
                                                                        "${globalSummaryReport?.netAmount}",
                                                                    color:
                                                                        "${globalSummaryReport?.netAmount}"
                                                                                .startsWith(
                                                                                    "-")
                                                                            ? Colors.red
                                                                            : Colors
                                                                                .green,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight.w600),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              (isShow?[index] ?? false),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                width: double.infinity,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(05.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Divider(
                                                                        color: Colors
                                                                            .grey.shade800
                                                                            .withOpacity(
                                                                                0.2),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 05,
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            globalSummaryReport
                                                                                    ?.scripSymbol1 !=
                                                                                "",
                                                                        child: Row(
                                                                          children: [
                                                                            Utils.text(
                                                                              text: (globalSummaryReport?.scripSymbol1?.length ??
                                                                                          0) >
                                                                                      10
                                                                                  ? "${globalSummaryReport?.scripSymbol1?.substring(0, 10)}..."
                                                                                  : globalSummaryReport
                                                                                      ?.scripSymbol1,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .w600,
                                                                              textAlign:
                                                                                  TextAlign
                                                                                      .start,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 05,
                                                                            ),
                                                                            GestureDetector(
                                                                                onTap:
                                                                                    () {
                                                                                  showDialog(
                                                                                    context:
                                                                                        context,
                                                                                    builder:
                                                                                        (context) {
                                                                                      return AlertDialog(
                                                                                        contentPadding: const EdgeInsets.all(10),
                                                                                        content: Column(
                                                                                          mainAxisSize: MainAxisSize.min,
                                                                                          children: [
                                                                                            Utils.text(
                                                                                              text: globalSummaryReport?.scripSymbol1,
                                                                                              color: Colors.black,
                                                                                              fontSize: 16,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              textAlign: TextAlign.start,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  );
                                                                                },
                                                                                child:
                                                                                    const Icon(
                                                                                  Icons
                                                                                      .info,
                                                                                  color: Colors
                                                                                      .grey,
                                                                                  size:
                                                                                      20,
                                                                                )),
                                                                            const Spacer(),
                                                                            Visibility(
                                                                              visible:
                                                                                  globalSummaryReport?.companyCode !=
                                                                                      "",
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height:
                                                                                        15,
                                                                                    decoration:
                                                                                        BoxDecoration(
                                                                                      borderRadius:
                                                                                          BorderRadius.circular(05),
                                                                                      color:
                                                                                          Colors.deepPurpleAccent.shade700.withOpacity(0.1),
                                                                                    ),
                                                                                    child:
                                                                                        Padding(
                                                                                      padding:
                                                                                          const EdgeInsets.symmetric(horizontal: 5.0),
                                                                                      child:
                                                                                          Utils.text(
                                                                                        text: globalSummaryReport?.companyCode,
                                                                                        color: Colors.deepPurple,
                                                                                        fontSize: 09,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width:
                                                                                        7,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height: 10,
                                                                      ),
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius
                                                                                  .circular(
                                                                                      05),
                                                                          border: Border.all(
                                                                              color: Colors
                                                                                  .grey
                                                                                  .shade800
                                                                                  .withOpacity(
                                                                                      0.2)),
                                                                        ),
                                                                        child: Padding(
                                                                          padding:
                                                                              const EdgeInsets
                                                                                  .all(
                                                                                  10.0),
                                                                          child: Column(
                                                                            children: [
                                                                              const SizedBox(
                                                                                height:
                                                                                    10,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Trade Qty",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Trade Amt",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.tradingQuantity}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.tradingQuantity}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.tradingAmount}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.tradingAmount}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    15,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Buy Qty",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Buy Rate",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.buyQuantity}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.buyQuantity}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.buyRate}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.buyRate}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    15,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Sale Qty",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Sale Rate",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.saleQuantity}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.saleQuantity}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.saleRate}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.saleRate}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    15,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Net Qty",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Net Rate",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.netQuantity}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.netQuantity}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.netRate}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.netRate}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    15,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Net Amt",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "Closing Price",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .spaceBetween,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.netAmount}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.netAmount}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                  Utils
                                                                                      .text(
                                                                                    text: "${globalSummaryReport?.closingPrice}" == ""
                                                                                        ? "-"
                                                                                        : "${globalSummaryReport?.closingPrice}",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .center,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "National P/L",
                                                                                    color:
                                                                                        Colors.black87,
                                                                                    fontSize:
                                                                                        11,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(
                                                                                height:
                                                                                    05,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment
                                                                                        .center,
                                                                                children: [
                                                                                  Utils
                                                                                      .text(
                                                                                    text:
                                                                                        "${globalSummaryReport?.fullScripSymbol}",
                                                                                    color: "${globalSummaryReport?.fullScripSymbol}".startsWith("-")
                                                                                        ? Colors.red
                                                                                        : Colors.green,
                                                                                    fontSize:
                                                                                        13,
                                                                                    fontWeight:
                                                                                        FontWeight.w600,
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
                                        height: 150,
                                      ),
                                    ],
                                  );
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
            Visibility(
              visible: !totalsDf.isNull && isLoading == false,
              child: Positioned(
                bottom: 70,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Utils.text(
                          text: "Total",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF4A5568),
                        ),
                        Utils.text(
                          text: "${totalsDf?.netAmount}",
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: const Color(0xFF4A5568),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

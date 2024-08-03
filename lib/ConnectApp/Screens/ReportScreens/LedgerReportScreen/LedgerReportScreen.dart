// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/LedgerReportModel/LedgerReportModel.dart';
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

class LedgerReportScreen extends StatefulWidget {
  const LedgerReportScreen({super.key});

  @override
  State<LedgerReportScreen> createState() => _LedgerReportScreenState();
}

class _LedgerReportScreenState extends State<LedgerReportScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  List<bool>? isShow;
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String fromDate = "";
  String toDate = "";
  String year = "";
  String selectedColumn = 'Sr No';
  String selectedOperator = 'contains';
  String filterValue = '';
  final List<String> columns = ['Sr No', 'Bill Date', 'Voucher Date', 'Voucher No', 'COCD', 'Narration', 'Dr Amount', 'Cr Amount', 'Balance'];
  final List<String> operators = ['contains', 'equals', 'starts with', 'ends with', 'is empty', 'is not empty', 'is any of'];
  List<ReportData> filteredData = [];
  List<ReportData> originalData = [];
  ReportData? totalData;

  final List<String> items = [
    'All',
    'Group 1',
    'Group 2',
  ];

  final List<String> margin = [
    'No',
    'Yes',
  ];
  String? selectedValue;
  String? selectedValueOfMargin;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    datePickedValue = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    year = "${dateTime.year}";
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    _fetchLedgerReport();
  }

  void applyFilter() {
    setState(() {
      filteredData = originalData.where((item) {
        int index = originalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'Sr No':
            return applyOperator(index.toString());
          case 'Bill Date':
            return applyOperator(item.billDate);
          case 'Voucher Date':
            return applyOperator(item.voucherDate);
          case 'Voucher No':
            return applyOperator(item.voucherNo);
          case 'COCD':
            return applyOperator(item.cocd);
          case 'Narration':
            return applyOperator(item.narration);
          case 'Dr Amount':
            return applyOperator(item.drAmt.toString());
          case 'Cr Amount':
            return applyOperator(item.crAmt.toString());
          case 'Balance':
            return applyOperator(item.balance.toString());
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

  Future<void> _fetchLedgerReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now();
    String year = prefs.getString('year') ?? "${time.year}";
    if(fromDate == ""){
      if(year == ""){
        fromDate = "${time.year}-${time.month.toString().padLeft(2,'0')}-${time.day.toString().padLeft(2,'0')}";
      }else if(year == "2024"){
        fromDate = "2024-04-01";
      }else if(year == "2023"){
        fromDate = "2023-04-01";
      }else if(year == "2022"){
        fromDate = "2022-04-01";
      }else if(year == "2021"){
        fromDate = "2021-04-01";
      }
    }if(toDate == ""){
      toDate = "${time.year}-${time.month.toString().padLeft(2,'0')}-${time.day.toString().padLeft(2,'0')}";
    }

    if(Appvariables.ledgerReport.isNull || Appvariables.ledgerReport == null){
      Appvariables.ledgerReport = ApiServices().fetchLedgerReport(
        clientCode: Appvariables.clientCode,
        token: Appvariables.token,
        fromDate: fromDate,
        toDate: toDate,
        margin: selectedValueOfMargin ?? "Y",
      );
    }

    Appvariables.ledgerReport?.then((data) {
      if(mounted){
        setState(() {
          isShow = List<bool>.filled(data.data.length, false);
          filteredData = data.data;
          originalData = data.data;
          isLoading = false;
        });
      }
    });
  }

  Future<void> _showDateTimePicker(String? type) async {
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

      if(type == "fromDate"){
        fromDate = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      }else if(type == "toDate"){
        toDate = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      }
      setState(() {
        Appvariables.ledgerReport = null;
        isLoading = true;
        _fetchLedgerReport();
      });
    }
  }

  Future<void> exportToCSV(List<ReportData> data) async {
    List<List<dynamic>> rows = [];
    rows.add(["Sr No", "Bill Date", "Voucher Date", "Voucher No", "COCD", "Narration", "Dr Amount", "Cr Amount", "Balance"]);

    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.billDate,
        item.voucherDate,
        item.voucherNo,
        item.cocd,
        item.narration,
        item.drAmt,
        item.crAmt,
        item.balance,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus = await Permission.manageExternalStorage.request().isGranted;
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
      if(year == ""){
        reportYear = "${time.year}";
      }
      else if(year == "2024"){
        reportYear = "2024";
      }else if(year == "2023"){
        reportYear = "2023";
      }else if(year == "2022"){
        reportYear = "2022";
      }else if(year == "2021"){
        reportYear = "2021";
      }

      String path = "${directory?.path}/ledgerReportOf$reportYear.csv";
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
                  border: Border.all(color: const Color(0xFF292D32),),
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        title: Utils.text(text: "Ledger Report", color: const Color(0xFF00A9FF), fontSize: 20,fontWeight: FontWeight.bold),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 08.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down_rounded,color: Color(0xFF00A9FF),),
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
                          if(selectedValue == "2024-2025"){
                            DateTime now = DateTime.now();
                            datePickedValue = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                            year = "${now.year}";
                          }else if(selectedValue == "2023-2024"){
                            datePickedValue = "2024-03-31";
                            year = "2024";
                          }else if(selectedValue == "2022-2023"){
                            datePickedValue = "2023-03-31";
                            year = "2023";
                          }else if(selectedValue == "2021-2022"){
                            datePickedValue = "2022-03-31";
                            year = "2022";
                          }else if(selectedValue == "2020-2021"){
                            datePickedValue = "2021-03-31";
                            year = "2021";
                          }
                          setState(() {
                            Appvariables.ledgerReport = null;
                            isLoading = true;
                            _fetchLedgerReport();
                          });
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 04),
                        height: 40,
                        width: 130,
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
                      await _showDateTimePicker("fromDate");
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
                              text: fromDate == "" ? "From Date" : fromDate,
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
                  InkWell(
                    onTap: () async {
                      await _showDateTimePicker("toDate");
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
                              text: toDate == "" ? "To Date" : toDate,
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
                        icon: Icon(Icons.arrow_drop_down_rounded,color: Color(0xFF00A9FF),),
                        iconSize: 25,
                      ),
                      hint: Utils.text(
                          text: "Margin",
                          color: const Color(0xFF00A9FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                      items: margin
                          .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Utils.text(
                            text: item,
                            color: const Color(0xFF00A9FF),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ))
                          .toList(),
                      value: selectedValueOfMargin,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValueOfMargin = value;
                          Appvariables.ledgerReport = null;
                          isLoading = true;
                          _fetchLedgerReport();
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 08),
                        height: 40,
                        width: 85,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF00A9FF)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     Utils.showLoadingDialogue(context);
                  //     ApiServices().downloadReportDocuments(
                  //         token: Appvariables.token,
                  //         type: "holding",
                  //         downloadType: "PDF",
                  //         year: year,
                  //         context: context
                  //     );
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: const Color(0xFF0066F6)),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 10.0, vertical: 08),
                  //       child: Center(
                  //         child: Utils.text(
                  //             text: "Margin",
                  //             color: const Color(0xFF0066F6),
                  //             fontSize: 12,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      DateTime time = DateTime.now();
                      String year = prefs.getString('year') ?? "${time.year}";
                      String reportYear = '';
                      if(year == ""){
                        reportYear = "${time.year}";
                      }
                      else if(year == "2024"){
                        reportYear = "2024";
                      }else if(year == "2023"){
                        reportYear = "2023";
                      }else if(year == "2022"){
                        reportYear = "2022";
                      }else if(year == "2021"){
                        reportYear = "2021";
                      }
                      ApiServices().downloadReportDocuments(
                          token: Appvariables.token,
                          type: "ledger",
                          downloadType: "PDF",
                          year: reportYear,
                          context: context
                      );
                    } else if (result == "Excel") {
                      if (await Appvariables.ledgerReport != null) {
                        Appvariables.ledgerReport?.then((response) {
                          if (response.data.isNotEmpty) {
                            exportToCSV(response.data);
                          }
                        });
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'PDF',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Utils.text(
                            text: "PDF",
                            color: Colors.black,
                            fontSize: 15,
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Excel',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Utils.text(
                            text: "Excel",
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                    onTap: () {
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
                                      TextButton(onPressed: () {
                                        setState(() {
                                          Appvariables.ledgerReport = null;
                                          isLoading = true;
                                          _fetchLedgerReport();
                                          Get.back();
                                        });
                                      }, child: Utils.text(
                                        text: "Reset",
                                        color: kBlackColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: selectedColumn,
                                          padding: const EdgeInsets.all(0),
                                          onChanged: (value) {
                                            setState(() {
                                              selectedColumn = value!;
                                            });
                                          },
                                          items: columns.map((column) {
                                            return DropdownMenuItem(
                                              value: column,
                                              child: Utils.text(
                                                  text: column,
                                                  color: kBlackColor
                                              ),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            fillColor: Colors.transparent,
                                            labelText: 'Columns',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: DropdownButtonFormField<String>(
                                          value: selectedOperator,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedOperator = value!;
                                            });
                                          },
                                          items: operators.map((operator) {
                                            return DropdownMenuItem(
                                              value: operator,
                                              child: Utils.text(
                                                  text: operator,
                                                  color: kBlackColor
                                              ),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            fillColor: Colors.transparent,
                                            labelText: 'Operator',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        filterValue = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      fillColor: Colors.transparent,
                                      labelText: 'Filter Value',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: () {
                                      applyFilter();
                                      Get.back();
                                    },
                                    child: Utils.gradientButton(
                                      message: "Apply Filter"
                                    ),
                                  )
                                  // ElevatedButton(
                                  //   style: ElevatedButton.styleFrom(
                                  //     backgroundColor: Colors.black,
                                  //   ),
                                  //   onPressed: () {
                                  //     applyFilter();
                                  //     Get.back();
                                  //   },
                                  //   child: Utils.text(
                                  //       text: 'Apply Filter',
                                  //       color: Colors.white
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: SvgPicture.asset("assets/icons/filterIcon.svg")),
              ],
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            Appvariables.ledgerReport = null;
            isLoading = true;
          });
          return _fetchLedgerReport();
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
                        FutureBuilder<LedgerReport>(
                          future: Appvariables.ledgerReport,
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
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 200,
                                  ),
                                  Utils.noDataFound(),
                                ],
                              );
                            }
                            else if (snapshot.hasData) {
                              if(totalData.isNull || totalData != snapshot.data!.data.last){
                                WidgetsBinding.instance.addPostFrameCallback((_){
                                  setState(() {
                                    totalData = snapshot.data!.data.last;
                                  });
                                });
                              }
                              return filteredData.isNotEmpty ? Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredData.length,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      final ledgerReport = filteredData[index];
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
                                                        width: 180,
                                                        child: Utils.text(
                                                            text: ledgerReport.narration == ""
                                                                ? "-"
                                                                : ledgerReport.narration,
                                                            color: const Color(0xFF37474F),
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w700,
                                                            textOverFlow: TextOverflow.ellipsis
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Column(
                                                        children: [
                                                          Utils.text(
                                                            text: "Balance",
                                                            color: const Color(0xFF4A5568).withOpacity(0.70),
                                                            fontSize: 10,
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.balance == ""
                                                                  ? "-"
                                                                  : ledgerReport.balance,
                                                              color: ledgerReport.balance.startsWith("-") ? const Color(0xFFFF2E2E) : const Color(0xFF61A735),
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
                                                              text: "Bill Date",
                                                              fontSize: 10,
                                                              color: const Color(0xFF4A5568)
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.billDate == "" ? "-" : ledgerReport.billDate,
                                                              color: Colors.black,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Utils.text(
                                                              text: "Voucher Date",
                                                              fontSize: 10,
                                                              color: const Color(0xFF4A5568)
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.voucherDate == "" ? "-" : ledgerReport.voucherDate,
                                                              color: Colors.black,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Utils.text(
                                                              text: "Voucher No",
                                                              fontSize: 10,
                                                              color: const Color(0xFF4A5568)
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.voucherNo,
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
                                                              text: "COCD",
                                                              fontSize: 10,
                                                              color: const Color(0xFF4A5568)
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.cocd,
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
                                                              text: "Dr Amount",
                                                              fontSize: 10,
                                                              color: const Color(0xFF4A5568)
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.drAmt,
                                                              color: Colors.black,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Utils.text(
                                                              text: "Cr Amount",
                                                              fontSize: 10,
                                                              color: const Color(0xFF4A5568)
                                                          ),
                                                          Utils.text(
                                                              text: ledgerReport.crAmt,
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
                                                                  visible: ledgerReport.narration != "",
                                                                  child: Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: 160,
                                                                        child: Utils.text(
                                                                            text: ledgerReport.narration,
                                                                            color: kBlackColor,
                                                                            fontSize: 16,
                                                                            fontWeight: FontWeight.w600,
                                                                            textAlign: TextAlign.start,
                                                                            textOverFlow: TextOverflow.ellipsis
                                                                        ),
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
                                                                                      text: ledgerReport.narration,
                                                                                      color: kBlackColor,
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
                                                                      const Spacer(),
                                                                      Visibility(
                                                                        visible: ledgerReport.cocd != "",
                                                                        child: Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 15,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(05),
                                                                                color: Colors.deepPurpleAccent.shade700.withOpacity(0.1),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                                child: Utils.text(
                                                                                  text: ledgerReport.cocd,
                                                                                  color: Colors.deepPurple,
                                                                                  fontSize: 09,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 7,
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
                                                                              text: "Bill Date",
                                                                              color: kBlackColor87,
                                                                              fontSize: 11,
                                                                            ),
                                                                            Utils.text(
                                                                              text: "Voucher Date",
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
                                                                              text: ledgerReport.billDate == "" ? "-" : ledgerReport.billDate,
                                                                              color: kBlackColor87,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                            Utils.text(
                                                                              text: ledgerReport.voucherDate == "" ? "-" : ledgerReport.voucherDate,
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
                                                                              text: "Voucher No",
                                                                              color: kBlackColor87,
                                                                              fontSize: 11,
                                                                            ),
                                                                            Utils.text(
                                                                              text: "COCD",
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
                                                                              text: ledgerReport.voucherNo == "" ? "-" : ledgerReport.voucherNo,
                                                                              color: kBlackColor87,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                            Utils.text(
                                                                              text: ledgerReport.cocd == "" ? "-" : ledgerReport.cocd,
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
                                                                              text: "DR Amount",
                                                                              color: kBlackColor87,
                                                                              fontSize: 11,
                                                                            ),
                                                                            Utils.text(
                                                                              text: "CR Amount",
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
                                                                              text: ledgerReport.drAmt == "" ? "-" : ledgerReport.drAmt,
                                                                              color: kBlackColor87,
                                                                              fontSize: 13,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                            Utils.text(
                                                                              text: ledgerReport.crAmt == "" ? "-" : ledgerReport.crAmt,
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
                                                                              text: "Balance",
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
                                                                              text: ledgerReport.balance,
                                                                              color: ledgerReport.balance.startsWith("-") ? Colors.red : Colors.green,
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
                            }
                            else {
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !totalData.isNull && isLoading == false,
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
                          text: "${totalData?.drAmt}",
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

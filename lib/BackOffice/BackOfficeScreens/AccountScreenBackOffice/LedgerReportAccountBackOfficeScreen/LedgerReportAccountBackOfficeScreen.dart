import 'dart:io';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/LedgerReportModel/LedgerReportModel.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LedgerReportAccountBackOfficeScreen extends StatefulWidget {
  const LedgerReportAccountBackOfficeScreen({super.key});

  @override
  State<LedgerReportAccountBackOfficeScreen> createState() => _LedgerReportAccountBackOfficeScreenState();
}

class _LedgerReportAccountBackOfficeScreenState extends State<LedgerReportAccountBackOfficeScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController clientCodeController = TextEditingController();
  Future<LedgerReport>? ledgerReport;
  bool isOpenClientDetails = false;
  String selectedColumn = 'Group 1';
  String selectedMargin = 'No';
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String fromDate = "";
  String toDate = "";
  String year = "";
  List<bool>? isShow;
  ReportData? totalData;
  List<ReportData> filteredData = [];
  final List<String> companyCodeList = [
    'Group 1',
    'Group 2',
  ];

  final List<String> margin = [
    'Yes',
    'No',
  ];

  @override
  void initState() {
    super.initState();
    datePickedValue =
    "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    year = "${dateTime.year}";
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
  }

  Future<void> _fetchLedgerReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now();
    String year = prefs.getString('backOfficeYear') ?? "${time.year}";
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

    if(ledgerReport.isNull || ledgerReport == null){
      ledgerReport = ApiServices().fetchLedgerReport(
        clientCode: clientCodeController.text,
        token: Appvariablesbackoffice.token,
        fromDate: fromDate,
        toDate: toDate,
        margin: selectedMargin == "Yes" ? "Y" : "N",
        source: "ap"
      );
    }

    ledgerReport?.then((data) {
      if(mounted){
        setState(() {
          isShow = List<bool>.filled(data.data.length, false);
          filteredData = data.data;
        });
      }
    });
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
      datePickedValue =
      "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";

      if (type == "fromDate") {
        fromDate =
        "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      } else if (type == "toDate") {
        toDate =
        "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      }
      setState(() {
        // futureDpLedgerReport = null;
        // _fetchLedgerReport();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
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
                  border: Border.all(color: const Color(0xFF292D32))),
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
        title: Utils.text(
            text: "Ledger",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: kBlackColor),
            color: Colors.white,
            onSelected: (String result) async {
              if (result == "Export") {
                showMenu(
                  context: context,
                  color: Colors.white,
                  position: const RelativeRect.fromLTRB(100, 0, 0, 0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'CSV',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.table_chart,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Utils.text(
                            text: "CSV",
                            color: Colors.black,
                            fontSize: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ).then((value) async {
                  if (value == 'CSV') {
                    if (await ledgerReport != null) {
                      ledgerReport?.then((response) {
                        if (response.data.isNotEmpty) {
                          exportToCSV(response.data);
                        }
                      });
                    }else{
                      Utils.toast(msg: "Please Search Any Client Details!");
                    }
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Export',
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
                      text: "Export",
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      isOpenClientDetails = !isOpenClientDetails;
                    });
                  },
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFE4E4E4).withOpacity(0.3),
                      border: Border.all(
                        color: Colors.blueGrey.shade600.withOpacity(0.15),
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        children: [
                          Utils.text(
                              text: 'Enter Details',
                              fontSize: 12,
                              color: const Color(0xFF91919F)),
                          const Spacer(),
                          Icon(
                            isOpenClientDetails
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xFF91919F),
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: TextFormField(
                    controller: clientCodeController,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
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
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Client Code";
                      }
                      return null;
                    },
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    readOnly: true,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "AA",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                    ),
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: InkWell(
                    onTap: () async {
                      await _showDateTimePicker("fromDate");
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E4E4).withOpacity(0.3),
                        border: Border.all(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Row(
                          children: [
                            Utils.text(
                              text: fromDate == "" ? "From" : fromDate,
                              color: const Color(0xFF91919F),
                              fontSize: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 10,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: InkWell(
                    onTap: () async {
                      await _showDateTimePicker("toDate");
                    },
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE4E4E4).withOpacity(0.3),
                        border: Border.all(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Row(
                          children: [
                            Utils.text(
                              text: toDate == "" ? "To" : toDate,
                              color: const Color(0xFF91919F),
                              fontSize: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 300,
                    value: selectedColumn,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedColumn = value!;
                      });
                    },
                    items: companyCodeList.map((column) {
                      return DropdownMenuItem(
                        value: column,
                        child: Utils.text(
                          text: column,
                          color: kBlackColor,
                          textOverFlow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                      labelText: 'Company Code',
                      labelStyle: GoogleFonts.inter(
                        color: const Color(0xFF91919F),
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(10),
                    dropdownColor: Colors.white,
                    menuMaxHeight: 300,
                    value: selectedMargin,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedMargin = value!;
                      });
                    },
                    items: margin.map((column) {
                      return DropdownMenuItem(
                        value: column,
                        child: Utils.text(
                          text: column,
                          color: kBlackColor,
                          textOverFlow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                      labelText: 'Margin',
                      labelStyle: GoogleFonts.inter(
                        color: const Color(0xFF91919F),
                        fontSize: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFE4E4E4).withOpacity(0.3),
                            border: Border.all(
                              color: Colors.blueGrey.shade600.withOpacity(0.15),
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                              child: Utils.text(
                                text: "Clear",
                                color: const Color(0xFF91919F),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          clientCodeController.clear();
                          fromDate = "";
                          toDate = "";
                          setState(() {});
                        },
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isOpenClientDetails = !isOpenClientDetails;
                            });
                            _fetchLedgerReport();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF007FEB),
                                Color(0xFF00A9FF),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                              child: Utils.text(
                                text: "Submit",
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: !isOpenClientDetails,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: !isOpenClientDetails,
                  child: FutureBuilder<LedgerReport>(
                    future: ledgerReport,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 250,
                            ),
                            Center(
                                child: Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
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
                                  padding: const EdgeInsets.symmetric(vertical: 05),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

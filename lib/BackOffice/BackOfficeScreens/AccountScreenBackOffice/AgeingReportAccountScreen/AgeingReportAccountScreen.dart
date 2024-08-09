import 'dart:io';

import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/AgeingReportAccountModel/AgeingReportAccountModel.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
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

class AgeingReportAccountScreen extends StatefulWidget {
  const AgeingReportAccountScreen({super.key});

  @override
  State<AgeingReportAccountScreen> createState() =>
      _AgeingReportAccountScreenState();
}

class _AgeingReportAccountScreenState extends State<AgeingReportAccountScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  final _formKey = GlobalKey<FormState>();
  Future<AgeingReport?>? futureAgeingReport;
  final TextEditingController clientCodeController = TextEditingController();
  final TextEditingController day1 = TextEditingController();
  final TextEditingController day2 = TextEditingController();
  final TextEditingController day3 = TextEditingController();
  final TextEditingController day4 = TextEditingController();
  final TextEditingController day5 = TextEditingController();
  bool isOpenClientDetails = false;
  String datePickedValue = "";
  String selectedColumn = "2024";
  String selectedCompanyCode = "Group 1";
  DateTime dateTime = DateTime.now();

  final List<String> companyCodeList = [
    'Group 1',
    'Group 2',
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchAgeingReport() async {
    DateTime time = DateTime.now();
    if(datePickedValue == ""){
      datePickedValue = "${time.year}-${time.month.toString().padLeft(2,'0')}-${time.day.toString().padLeft(2,'0')}";
    }

    futureAgeingReport = BackOfficeApiService().fetchAgeingReport(
        authToken: Appvariablesbackoffice.token,
        branchCode: "AA",
        clientCode: clientCodeController.text,
        companyCode: selectedCompanyCode.removeAllWhitespace,
        day1: int.parse(day1.text),
      day2: int.parse(day2.text),
      day3: int.parse(day3.text),
      day4: int.parse(day4.text),
      day5: int.parse(day5.text),
      startYear: int.parse(selectedColumn),
      voucherDate: datePickedValue
    );
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
      datePickedValue =
          "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";

      setState(() {
        // futureDpLedgerReport = null;
        // _fetchLedgerReport();
      });
    }
  }

  Future<void> exportToCSV(List<ClientData> data) async {
    List<List<dynamic>> rows = [];
    rows.add(["Sr No", "COCD", "Client Name", "Client Id", "Amount", "Amt 2", "Amt 5", "Amt 7", "Amt 9", "Amt 11", "Amt 7"]);

    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.cocd,
        item.clientname,
        item.clientId,
        item.amount,
        item.amt2,
        item.amt5,
        item.amt7,
        item.amt9,
        item.amt11,
        item.amt7Alt,
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
      String year = prefs.getString('backOfficeYear') ?? "${time.year}";
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

      String path = "${directory?.path}/Global Brokerage Summary$reportYear.csv";
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
    List<String> yearList = [
      dateTime.year.toString(),
      "2023",
      "2022",
      "2021",
      "2020",
      "2019",
      "2018",
      "2017",
      "2016",
      "2015",
    ];
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
            text: "Ageing",
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
                    if (await futureAgeingReport != null) {
                      futureAgeingReport?.then((response) {
                        if (response != null || response!.data.isNotEmpty) {
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
                    items: yearList.map((column) {
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
                      labelText: '',
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
                  child: InkWell(
                    onTap: () async {
                      await _showDateTimePicker();
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
                              text: datePickedValue == ""
                                  ? "Voucher Date"
                                  : datePickedValue,
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
                    value: selectedCompanyCode,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedCompanyCode = value!;
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
                      labelText: '',
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
                  child: TextFormField(
                    controller: clientCodeController,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
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
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: isOpenClientDetails,
                  child: TextFormField(
                    controller: day1,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Day 1",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    controller: day2,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Day 2",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    controller: day3,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Day 3",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    controller: day4,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Day 4",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
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
                  child: TextFormField(
                    controller: day5,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    onEditingComplete: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: "Day 5",
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                          datePickedValue = "";
                          setState(() {});
                        },
                      ),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isOpenClientDetails = !isOpenClientDetails;
                            });
                            fetchAgeingReport();
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
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
                    visible: isOpenClientDetails,
                    child: const SizedBox(
                      height: 200,
                    )),
                Visibility(
                  visible: !isOpenClientDetails,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: !isOpenClientDetails && clientCodeController.text != "",
                  child: FutureBuilder<AgeingReport?>(
                    future: futureAgeingReport,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 200,
                            ),
                            Center(
                                child: Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
                          ],
                        );
                      } else {
                        if (snapshot.hasError) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 150,
                              ),
                              Center(child: Utils.noDataFound()),
                            ],
                          );
                        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 150,
                              ),
                              Center(child: Utils.noDataFound()),
                            ],
                          );
                        } else {
                          final data = snapshot.data!;
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.data.length,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  final commonReport = data.data[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 05),
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
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Utils.text(
                                                      text: "Client Name",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.clientname == "" ? "N/A" : commonReport.clientname,
                                                      color: kBlackColor,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      textOverFlow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Utils.text(
                                                      text: "Client Id",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.clientId == "" ? "N/A" : commonReport.clientId,
                                                      color: kBlackColor,
                                                      fontSize: 12,
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
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Utils.text(
                                                      text: "COCD",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.cocd == "" ? "N/A" : commonReport.cocd,
                                                      color: kBlackColor,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      textOverFlow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Utils.text(
                                                      text: "Amount",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.amount == "" ? "N/A" : commonReport.amount,
                                                      color: kBlackColor,
                                                      fontSize: 12,
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
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 150,
                              )
                            ],
                          );
                        }
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

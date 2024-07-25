// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/GlobalDetailsModel/GlobalDetailsModel.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
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

class Globaldetailsreportscreen extends StatefulWidget {
  const Globaldetailsreportscreen({super.key});

  @override
  State<Globaldetailsreportscreen> createState() => _GlobaldetailsreportscreenState();
}

class _GlobaldetailsreportscreenState extends State<Globaldetailsreportscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  List<bool>? isShow;
  DateTime dateTime = DateTime.now();
  String fromDate = "";
  String toDate = "";
  String year = "";
  String datePickedValue = "";
  dynamic companyDetails;
  dynamic companyKeys;
  GrandTotal? totalData;
  List<ReportDetails>? reportDetails;
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
    fetchGlobalDetailsReport();
  }

  Future<void> fetchGlobalDetailsReport() async {
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
    if(Appvariables.globalDetails.isNull || Appvariables.globalDetails == null){
      Appvariables.globalDetails = ApiServices().fetchGlobalDetails(
          authToken: Appvariables.token,
          toDate: toDate,
          fromDate: fromDate,
          year: int.parse(year)
      );
      Appvariables.globalDetails?.then((data) {
        isShow = List<bool>.filled(data.data.length ?? 0, false);
        if(mounted){
          setState(() {
            isLoading = false;
          });
        }
      });
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
      datePickedValue = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";

      if(type == "fromDate"){
        fromDate = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      }else if(type == "toDate"){
        toDate = "${datePicked.year}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.day.toString().padLeft(2, '0')}";
      }
      setState(() {
        isLoading = true;
        Appvariables.globalDetails = null;
        fetchGlobalDetailsReport();
      });
    }
  }

  Future<void> exportToCSV(List<ReportDetails>? data, List<Total>? total) async {
    List<List<dynamic>> rows = [];
    rows.add(["Sr No", "Scrip Symbol", "Trade Date", "Narration", "Bought Quantity", "Bought Rate", "Sold Quantity", "Sold Rate", "Net Quantity", "Net Rate", "Net Amount"]);

    for (int i = 0; i < data!.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.scripSymbol,
        item.tradeDate,
        item.narration,
        item.bqty,
        item.brate,
        item.sqty,
        item.srate,
        item.netqty,
        item.nrate,
        item.netamt,
      ]);
      if(total != null && i < total.length){
        var item = total[i];
        rows.add([
          "Total",
          item.totalBqty,
          item.totalSqty,
          item.totalNetqty,
          item.totalNetamt
        ]);
      }
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

      String path = "${directory?.path}/Global Details Report Of $reportYear.csv";
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
            text: "Global Details",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 08.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
              ],
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
                    if (result == "Excel") {
                      if (await Appvariables.globalDetails != null) {
                        Appvariables.globalDetails?.then((response) {
                          if (response.data.isNotEmpty) {
                            List<Map<String, dynamic>> allCompanyDetails = [];
                            List<Total> total = [];
                            for (int i = 0; i < response.data.length; i++) {
                              allCompanyDetails.add(response.data[i].companyDetails);
                              total.add(response.data[i].total);
                            }

                            List<String> companyKeys = [];
                            List<ReportDetails> reportDetails = [];

                            for (var companyDetails in allCompanyDetails) {
                              companyKeys = companyDetails.keys.toList();
                              for (var companyKey in companyKeys) {
                                reportDetails.addAll(companyDetails[companyKey]);
                              }
                            }
                            exportToCSV(reportDetails,total);
                          }
                        });
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            isLoading = true;
            Appvariables.globalDetails = null;
          });
          return fetchGlobalDetailsReport();
        },
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<GlobalDetailsResponse?>(
                    future: Appvariables.globalDetails,
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
                        return Center(child: Utils.text(
                            text: 'Error: ${snapshot.error}',
                            color: Colors.black,
                        ));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Utils.text(
                          text: 'No data available',
                          color: Colors.black,
                        ));
                      }
                      else {
                        final data = snapshot.data!;
                        if(totalData.isNull){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            setState(() {
                              totalData = snapshot.data?.grandTotal;
                            });
                          });
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.data.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            final companyDetails = data.data[index].companyDetails;
                            final companyKeys = companyDetails.keys.toList();

                            return Column(
                              children: companyKeys.expand((companyKey) {
                                return companyDetails[companyKey]!.map((report) {

                                  // reportDetails = companyDetails[companyKey]?.toList();
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
                                                      text: report.narration,
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
                                                        text: "Balance",
                                                        color: const Color(0xFF4A5568).withOpacity(0.70),
                                                        fontSize: 10,
                                                      ),
                                                      Utils.text(
                                                        text: report.netamt,
                                                        color: report.netamt.startsWith("-") ? Colors.red : Colors.green,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
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
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Utils.text(
                                                          text: "Bought Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568)
                                                      ),
                                                      Utils.text(
                                                          text: report.bqty == "" ? "-" : report.bqty,
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
                                                          text: "Bought Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568)
                                                      ),
                                                      Utils.text(
                                                          text: report.brate == "" ? "-" : report.brate,
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
                                                          text: "Sold Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568)
                                                      ),
                                                      Utils.text(
                                                          text: report.sqty == "" ? "-" : report.sqty,
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
                                                          text: "Sold Rate",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568)
                                                      ),
                                                      Utils.text(
                                                          text: report.srate == "" ? "-" : report.srate,
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
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Utils.text(
                                                          text: "Net Qty",
                                                          fontSize: 10,
                                                          color: const Color(0xFF4A5568)
                                                      ),
                                                      Utils.text(
                                                          text: report.netqty == "" ? "-" : report.netqty,
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
                                                          color: const Color(0xFF4A5568)
                                                      ),
                                                      Utils.text(
                                                          text: report.nrate == "" ? "-" : report.nrate,
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
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Column(
                                                          children: [
                                                            Divider(
                                                              color: Colors.grey.shade800.withOpacity(0.2),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Visibility(
                                                              visible: report.narration != "",
                                                              child: Row(
                                                                children: [
                                                                  Utils.text(
                                                                    text: report.narration.length > 10 ? "${report.narration.substring(0,10)}..." : report.narration,
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w600,
                                                                    textAlign: TextAlign.start,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (context) {
                                                                          return AlertDialog(
                                                                            contentPadding: const EdgeInsets.all(10),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Utils.text(
                                                                                  text: report.narration,
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
                                                                    child: const Icon(Icons.info, color: Colors.grey, size: 20),
                                                                  ),
                                                                  const Spacer(),
                                                                  Visibility(
                                                                    visible: report.companyCode != "",
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          height: 15,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            color: Colors.deepPurpleAccent.shade700.withOpacity(0.1),
                                                                          ),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                            child: Utils.text(
                                                                              text: report.companyCode,
                                                                              color: Colors.deepPurple,
                                                                              fontSize: 9,
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
                                                                borderRadius: BorderRadius.circular(5),
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
                                                                          text: "Bought Qty",
                                                                          color: kBlackColor87,
                                                                          fontSize: 11,
                                                                        ),
                                                                        Utils.text(
                                                                          text: "Bought Rate",
                                                                          color: kBlackColor87,
                                                                          fontSize: 11,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Utils.text(
                                                                          text: report.bqty == "" ? "-" : report.bqty,
                                                                          color: kBlackColor87,
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                        Utils.text(
                                                                          text: report.brate == "" ? "-" : report.brate,
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
                                                                          text: "Sold Qty",
                                                                          color: kBlackColor87,
                                                                          fontSize: 11,
                                                                        ),
                                                                        Utils.text(
                                                                          text: "Sold Rate",
                                                                          color: kBlackColor87,
                                                                          fontSize: 11,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Utils.text(
                                                                          text: report.sqty == "" ? "-" : report.sqty,
                                                                          color: kBlackColor87,
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                        Utils.text(
                                                                          text: report.srate == "" ? "-" : report.srate,
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
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Utils.text(
                                                                          text: report.netqty == "" ? "-" : report.netqty,
                                                                          color: kBlackColor87,
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                        Utils.text(
                                                                          text: report.nrate == "" ? "-" : report.nrate,
                                                                          color: kBlackColor87,
                                                                          fontSize: 13,
                                                                          fontWeight: FontWeight.w600,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 5,
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
                                                                      height: 5,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Utils.text(
                                                                          text: report.netamt,
                                                                          color: report.netamt.startsWith("-") ? Colors.red : Colors.green,
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
                                }).toList();
                              }).toList(),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
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
                          text: "${totalData?.totalNetamt}",
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

import 'dart:io';

import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/ClientWiseCreditDebitReportModel/ClientWiseCreditDebitReportModel.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientWiseDebitCreditReportScreen extends StatefulWidget {
  const ClientWiseDebitCreditReportScreen({super.key});

  @override
  State<ClientWiseDebitCreditReportScreen> createState() => _ClientWiseDebitCreditReportScreenState();
}

class _ClientWiseDebitCreditReportScreenState extends State<ClientWiseDebitCreditReportScreen> {

  final _formKey = GlobalKey<FormState>();
  Future<ApiResponse1?>? futureClientWiseCrDrReport;
  final TextEditingController clientCodeController = TextEditingController();
  bool isOpenClientDetails = false;
  String selectedColumn = 'Equity+Der+Currency+MFSS+SLBM+NBFC';

  final List<String> companyCodeList = [
    'Equity',
    'Derivative',
    'Currency',
    'Commodity',
    'Equity+Derivative',
    'Equity+Derivative+Currency+MFSS+SLBM',
    'Equity+Derivative+Currency+Commodity',
    'Equity+Der+Currency+MFSS+SLBM+NBFC',
    'Equity+Der+Currency+Commodity+MFSS+SLBM+NBFC',
    'MFSS',
    'SLBM',
    'Equity+Derivative+MFSS+SLBM',
    'Equity+Der+Currency+Commodity+MFSS+SLBM+NBFC+NSE_COM+BSE_COM',
    'Equity+Derivative+Currency+MFSS+SLBM+NSE_COM+BSE_COM(default)',
  ];

  Future<void> fetchClientWiseDebitCreditReport() async {
    futureClientWiseCrDrReport = BackOfficeApiService().fetchClientWiseDrCr(
        companyCode: '10',
        clientCode: clientCodeController.text,
        authToken: Appvariablesbackoffice.token,
      branchCode: "AA"
    );
  }

  Future<void> exportToCSV(List<ClientWiseDrCr> data) async {
    List<List<dynamic>> rows = [];
    rows.add(["Sr No", "Client Id", "Client Name", "Ledger", "Virtual DR"]);

    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.clientId,
        item.clientName,
        item.ledger,
        item.virtualDr,
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

      String path = "${directory?.path}/Client Wise Dr Cr Report Of$reportYear.csv";
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
            text: "Client Wise Debit Credit",
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ).then((value) async {
                  if (value == 'CSV') {
                    if (await futureClientWiseCrDrReport != null) {
                      futureClientWiseCrDrReport?.then((response) {
                        if (response!.data.isNotEmpty) {
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
                        setState(() {});
                      },
                    ),
                    InkWell(
                      onTap: () {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            isOpenClientDetails = !isOpenClientDetails;
                          });
                          fetchClientWiseDebitCreditReport();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color(0xFF007FEB),
                            Color(0xFF00A9FF),
                          ],),
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
                visible: !isOpenClientDetails && clientCodeController.text != "",
                child: FutureBuilder<ApiResponse1?>(
                  future: futureClientWiseCrDrReport,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 200,
                          ),
                          Center(
                              child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
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
                                                    text: commonReport.clientName == "" ? "N/A" : commonReport.clientName,
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
                                                    text: "Ledger",
                                                    color: const Color(0xFF4A5568).withOpacity(0.7),
                                                    fontSize: 10,
                                                  ),
                                                  Utils.text(
                                                    text: commonReport.ledger == "" ? "N/A" : commonReport.ledger,
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
                                                    text: "Virtual Dr",
                                                    color: const Color(0xFF4A5568).withOpacity(0.7),
                                                    fontSize: 10,
                                                  ),
                                                  Utils.text(
                                                    text: commonReport.virtualDr == "" ? "N/A" : commonReport.virtualDr,
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
    );
  }
}

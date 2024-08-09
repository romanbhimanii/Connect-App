import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/LatePaymentChargesAccountModel/LatePaymentChargesAccountModel.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LatePaymentChargeScreen extends StatefulWidget {
  const LatePaymentChargeScreen({super.key});

  @override
  State<LatePaymentChargeScreen> createState() => _LatePaymentChargeScreenState();
}

class _LatePaymentChargeScreenState extends State<LatePaymentChargeScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  final _formKey = GlobalKey<FormState>();
  Future<LatePaymentCharges>? futureCharges;
  final TextEditingController clientCodeController = TextEditingController();
  bool isOpenClientDetails = false;
  String selectedColumn = 'All';
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String fromDate = "";
  String toDate = "";
  String year = "";
  final List<String> companyCodeList = [
    'All',
    'Interest Charge Client',
    'Debit But Interest Not Charge Client',
  ];

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

  Future<void> fetchLatePayment() async {
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

    futureCharges = BackOfficeApiService().fetchLatePaymentCharges(
        token: Appvariablesbackoffice.token,
        clientCode: clientCodeController.text,
        fromDate: fromDate,
        toDate: toDate,
      clientFilter: selectedColumn == "All" ? 0 : selectedColumn == "Interest Charge Client" ? 1 : 2,
    );
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
            text: "Late Payment Charges",
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
                    // if (await futureRiskReport != null) {
                    //   futureRiskReport?.then((response) {
                    //     if (response != null || response!.data.isNotEmpty) {
                    //       exportCommonReportToCsv(response.data);
                    //     }
                    //   });
                    // }else{
                    //   Utils.toast(msg: "Please Search Any Client Details!");
                    // }
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
                            fetchLatePayment();
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
                  visible: !isOpenClientDetails && clientCodeController.text != "",
                  child: FutureBuilder<LatePaymentCharges?>(
                    future: futureCharges,
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
                                                const Spacer(),
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
                                                      text: "Funds DR",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.fundsDr == "" ? "N/A" : commonReport.fundsDr,
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
                                                      text: "Funds CR",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.fundsCr == "" ? "N/A" : commonReport.fundsCr,
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
                                                      text: "To Date",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.toDate == "" ? "N/A" : commonReport.toDate,
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
                                                      text: "From Date",
                                                      color: const Color(0xFF4A5568).withOpacity(0.7),
                                                      fontSize: 10,
                                                    ),
                                                    Utils.text(
                                                      text: commonReport.fromDate == "" ? "N/A" : commonReport.fromDate,
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

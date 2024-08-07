import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalBrokerageSummaryAccountBackOfficeScreen extends StatefulWidget {
  const GlobalBrokerageSummaryAccountBackOfficeScreen({super.key});

  @override
  State<GlobalBrokerageSummaryAccountBackOfficeScreen> createState() =>
      _GlobalBrokerageSummaryAccountBackOfficeScreenState();
}

class _GlobalBrokerageSummaryAccountBackOfficeScreenState
    extends State<GlobalBrokerageSummaryAccountBackOfficeScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController clientCodeController = TextEditingController();
  bool isOpenClientDetails = false;
  String selectedColumn = 'Group 1';
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String fromDate = "";
  String toDate = "";
  String year = "";

  final List<String> companyCodeList = [
    'Group 1',
    'Group 2',
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
            text: "Global Brokerage Summary",
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
                  controller: clientCodeController,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter Branch Code";
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
                          // fetchCommonReportData();
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
            ],
          ),
        ),
      ),
    );
  }
}

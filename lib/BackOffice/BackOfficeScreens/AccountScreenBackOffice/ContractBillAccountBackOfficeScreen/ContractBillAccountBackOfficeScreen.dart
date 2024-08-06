import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Models/ContractBillReportModel/ContractBillReportModel.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContractBillAccountBackOfficeScreen extends StatefulWidget {
  const ContractBillAccountBackOfficeScreen({super.key});

  @override
  State<ContractBillAccountBackOfficeScreen> createState() => _ContractBillAccountBackOfficeScreenState();
}

class _ContractBillAccountBackOfficeScreenState extends State<ContractBillAccountBackOfficeScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  final _formKey = GlobalKey<FormState>();
  Future<ContractBillReportModel?>? contractBill;
  bool isOpenClientDetails = false;
  final TextEditingController clientCodeController = TextEditingController();
  final SingleValueDropDownController _cnt = SingleValueDropDownController();
  DropDownValueModel? companyCode;
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String fromDate = "";
  String toDate = "";
  String year = "";
  List<bool>? isShow;

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

  Future<void> fetchContractBillReport() async {
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
    setState(() {
      contractBill = BackOfficeApiService().fetchContractBillsBackOffice(
        fromDate: fromDate,
        toDate: toDate,
        source: "ap",
        authToken: Appvariablesbackoffice.token,
        clientCode: clientCodeController.text,
        companyCode: companyCode?.value
      );
    });
    contractBill?.then((data) {
      setState(() {
        isShow = List<bool>.filled((data?.data?.length ?? 0), false);
      });
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
            text: "Common Contract Bill",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
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
                      // _fetchLedgerReport();
                    },
                    style: GoogleFonts.inter(
                      color: kBlackColor,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: "Enter Client Code",
                      hintStyle: GoogleFonts.inter(
                          fontSize: 12, color: const Color(0xFF91919F)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                  child: DropDownTextField(
                    controller: _cnt,
                    clearOption: false,
                    enableSearch: false,
                    dropdownRadius: 10,
                    padding: const EdgeInsets.all(0),
                    textFieldDecoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelStyle: GoogleFonts.inter(
                      color: kBlackColor,
                      ),
                      hintText: "Select Company Code",
                      hintStyle: GoogleFonts.inter(
                          fontSize: 12, color: const Color(0xFF91919F)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 1.0,
                        ),
                      ),
                      fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                    ),
                    clearIconProperty: IconProperty(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Select Company Code";
                      } else {
                        return null;
                      }
                    },
                    dropDownItemCount: 3,
                    dropDownList: const [
                      DropDownValueModel(name: 'ALL', value: "ALL"),
                      DropDownValueModel(name: 'GRP 1', value: "GRP 1"),
                      DropDownValueModel(name: 'MCX', value: "MCX"),
                    ],
                    onChanged: (val) {
                      if(val != ""){
                        companyCode = val;
                      }
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
                          _cnt.clearDropDown();
                          setState(() {});
                        },
                      ),
                      InkWell(
                        onTap: () {
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              isOpenClientDetails = !isOpenClientDetails;
                            });
                            fetchContractBillReport();
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
                  visible: isOpenClientDetails,
                  child: const SizedBox(
                    height: 15,
                  ),
                ),
                Visibility(
                  visible: !isOpenClientDetails && clientCodeController.text != "" && companyCode?.value != "",
                  child: FutureBuilder<ContractBillReportModel?>(
                    future: contractBill,
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
                        } else if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
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
                                itemCount: data.data?.length,
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(0),
                                itemBuilder: (context, index) {
                                  final ledgerReport = data.data?[index];
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
                                          color: Color(0xFFEAF9FF),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Utils.text(
                                                    text: "Generate Date : ",
                                                    color: kBlackColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Utils.text(
                                                    text: ledgerReport?.generateDate == "" ? "-" : ledgerReport?.generateDate,
                                                    color: kBlackColor,
                                                    fontSize: 12,
                                                    textOverFlow: TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Utils.text(
                                                    text: "Client Id : ",
                                                    color: kBlackColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Utils.text(
                                                    text: "${ledgerReport?.clientId}" == "" ? "-" : "${ledgerReport?.clientId}",
                                                    color: kBlackColor,
                                                    fontSize: 12,
                                                    textOverFlow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Utils.text(
                                                    text: "Client Name : ",
                                                    color: kBlackColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Utils.text(
                                                    text: (ledgerReport?.clientName?.length ?? 0) > 10
                                                        ? "${ledgerReport?.clientName?.substring(0, 10)}..."
                                                        : ledgerReport?.clientName,
                                                    color: kBlackColor,
                                                    fontSize: 12,
                                                    textOverFlow: TextOverflow.ellipsis,
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
                                                              visible: ledgerReport?.docfilename != "",
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap:(){
                                                                      // Utils.showLoadingDialogue(context);
                                                                      // ApiServices().downloadPDF(
                                                                      //   pdfFileName: ledgerReport?.docfilename,
                                                                      //   pdfUrl: ledgerReport?.path,
                                                                      //   context: context,
                                                                      // );
                                                                    },
                                                                    child: Container(
                                                                      height: 25,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(05),
                                                                        color: Colors.deepPurpleAccent.shade700.withOpacity(0.1),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                        child: Center(
                                                                          child: Utils.text(
                                                                            text: ledgerReport?.docfilename?.toString() ?? 'N/A',
                                                                            color: Colors.deepPurple,
                                                                            fontSize: 14,
                                                                          ),
                                                                        ),
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

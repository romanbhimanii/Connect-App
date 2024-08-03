import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/KycDpLedgerModel/KycDpLedgerModel.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KycDpLedgerScreen extends StatefulWidget {
  const KycDpLedgerScreen({super.key});

  @override
  State<KycDpLedgerScreen> createState() => _KycDpLedgerScreenState();
}

class _KycDpLedgerScreenState extends State<KycDpLedgerScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  List<bool>? isShow;
  final TextEditingController clientCodeController = TextEditingController();
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String fromDate = "";
  String toDate = "";
  String year = "";
  List<DpLedgerData> dpLedgerFilteredData = [];
  List<DpLedgerData> dpLedgerOriginalData = [];
  bool isOpenClientDetails = false;

  @override
  void initState() {
    super.initState();
    datePickedValue = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    fromDate = "2024-04-01";
    toDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
    year = "${dateTime.year}";
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
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

    if(Appvariablesbackoffice.futureDpLedgerReport.isNull || Appvariablesbackoffice.futureDpLedgerReport == null){
      Appvariablesbackoffice.futureDpLedgerReport = BackOfficeApiService().fetchDpLedgerReport(
        token: Appvariablesbackoffice.token ?? "",
        clientCode: clientCodeController.text,
        toDate: toDate,
        fromDate: fromDate
      );
    }

    Appvariablesbackoffice.futureDpLedgerReport?.then((data) {
      if(mounted){
        setState(() {
          isShow = List<bool>.filled(data.data.length, false);
          dpLedgerFilteredData = data.data;
          dpLedgerOriginalData = data.data;
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
        Appvariablesbackoffice.futureDpLedgerReport = null;
        _fetchLedgerReport();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  border: Border.all(color: const Color(0xFF292D32))
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        title: Utils.text(
            text: "DP Ledger",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        // bottom: PreferredSize(
        //   preferredSize: const Size(double.infinity, 40),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 08.0),
        //     child: SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       child: Row(
        //         children: [
        //           const SizedBox(
        //             width: 10,
        //           ),
        //           InkWell(
        //             onTap: () async {
        //               await _showDateTimePicker("fromDate");
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 border: Border.all(color: const Color(0xFF00A9FF)),
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     horizontal: 10.0, vertical: 08),
        //                 child: Center(
        //                   child: Utils.text(
        //                       text: fromDate == "" ? "From Date" : fromDate,
        //                       color: const Color(0xFF00A9FF),
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ),
        //             ),
        //           ),
        //           const SizedBox(
        //             width: 10,
        //           ),
        //           InkWell(
        //             onTap: () async {
        //               await _showDateTimePicker("toDate");
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                 border: Border.all(color: const Color(0xFF00A9FF)),
        //                 borderRadius: BorderRadius.circular(10),
        //               ),
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     horizontal: 10.0, vertical: 08),
        //                 child: Center(
        //                   child: Utils.text(
        //                       text: toDate == "" ? "To Date" : toDate,
        //                       color: const Color(0xFF00A9FF),
        //                       fontSize: 12,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            Appvariablesbackoffice.futureDpLedgerReport = null;
          });
          return _fetchLedgerReport();
        },
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          color: const Color(0xFF91919F)
                      ),
                      const Spacer(),
                      Icon(isOpenClientDetails ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,color: Color(0xFF91919F),size: 25,),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isOpenClientDetails,
              child: const SizedBox(
              height: 10,
            ),),
            Visibility(
              visible: isOpenClientDetails,
              child: TextFormField(
              controller: clientCodeController,
              textInputAction: TextInputAction.next,
              cursorColor: Colors.black,
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
                _fetchLedgerReport();
                setState(() {
                  isOpenClientDetails = !isOpenClientDetails;
                });
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
                    fontSize: 12,
                    color: const Color(0xFF91919F)
                ),
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
            ),),
            Visibility(
              visible: isOpenClientDetails,
              child: const SizedBox(
                height: 10,
              ),),
            Visibility(
              visible: isOpenClientDetails,
              child: InkWell(
                onTap: () async{
                  await _showDateTimePicker("fromDate");
                  setState(() {
                    isOpenClientDetails = !isOpenClientDetails;
                  });
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
                          text: fromDate,
                          color: const Color(0xFF91919F),
                          fontSize: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),),
            Visibility(
              visible: isOpenClientDetails,
              child: const SizedBox(
                height: 10,
              ),),
            Visibility(
              visible: isOpenClientDetails,
              child: InkWell(
                onTap: () async{
                  await _showDateTimePicker("toDate");
                  setState(() {
                    isOpenClientDetails = !isOpenClientDetails;
                  });
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
                          text: toDate,
                          color: const Color(0xFF91919F),
                          fontSize: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),),
            Visibility(
              visible: dpLedgerFilteredData.isNotEmpty,
              child: Expanded(child: FutureBuilder<DpLedgerReport>(
              future: Appvariablesbackoffice.futureDpLedgerReport,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      Center(
                        child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100),),
                    ],
                  );
                }
                else if (snapshot.hasData) {
                  return dpLedgerFilteredData.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: dpLedgerFilteredData.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      final ledgerReport = dpLedgerFilteredData[index];
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
                                              text: "Date",
                                              fontSize: 10,
                                              color: const Color(0xFF4A5568)
                                          ),
                                          Utils.text(
                                              text: ledgerReport.date == "" ? "-" : ledgerReport.date,
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
                                              text: "Receive Date",
                                              fontSize: 10,
                                              color: const Color(0xFF4A5568)
                                          ),
                                          Utils.text(
                                              text: ledgerReport.receiveDate == "" ? "-" : ledgerReport.receiveDate,
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
                                              text: ledgerReport.voucherno,
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
                                              text: "Code",
                                              fontSize: 10,
                                              color: const Color(0xFF4A5568)
                                          ),
                                          Utils.text(
                                              text: ledgerReport.code,
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
                                              text: "Debit Amount",
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
                                              text: "Credit Amount",
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
                                                                backgroundColor: Colors.white,
                                                                shape: OutlineInputBorder(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    borderSide: const BorderSide(
                                                                      color: Colors.white,
                                                                    )
                                                                ),
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
                                                        visible: ledgerReport.code != "",
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
                                                                  text: ledgerReport.code,
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
                                                              text: "Date",
                                                              color: kBlackColor87,
                                                              fontSize: 11,
                                                            ),
                                                            Utils.text(
                                                              text: "Receive Date",
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
                                                              text: ledgerReport.date == "" ? "-" : ledgerReport.date,
                                                              color: kBlackColor87,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            Utils.text(
                                                              text: ledgerReport.receiveDate == "" ? "-" : ledgerReport.receiveDate,
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
                                                              text: "Voucher",
                                                              color: kBlackColor87,
                                                              fontSize: 11,
                                                            ),
                                                            Utils.text(
                                                              text: "Voucher No",
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
                                                              text: ledgerReport.voucher == "" ? "-" : ledgerReport.voucher,
                                                              color: kBlackColor87,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            Utils.text(
                                                              text: ledgerReport.voucherno == "" ? "-" : ledgerReport.voucherno,
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
                                                              text: "Code",
                                                              color: kBlackColor87,
                                                              fontSize: 11,
                                                            ),
                                                            Utils.text(
                                                              text: "Cheque No",
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
                                                              text: ledgerReport.code == "" ? "N/A" : ledgerReport.code,
                                                              color: kBlackColor87,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            Utils.text(
                                                              text: ledgerReport.chqno == "" ? "N/A" : ledgerReport.chqno,
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
                                                              text: "Debit Amount",
                                                              color: kBlackColor87,
                                                              fontSize: 11,
                                                            ),
                                                            Utils.text(
                                                              text: "Credit Amount",
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
                  ) : Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      Utils.noDataFound(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      Utils.noDataFound(),
                    ],
                  );
                } else{
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
            ),),)
          ],
        ),),
      ),
    );
  }
}

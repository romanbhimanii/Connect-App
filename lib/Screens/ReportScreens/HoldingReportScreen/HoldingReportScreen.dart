import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/HoldingReportModel/HoldingReportModel.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class HoldingReportScreen extends StatefulWidget {
  const HoldingReportScreen({super.key});

  @override
  State<HoldingReportScreen> createState() => _HoldingReportScreenState();
}

class _HoldingReportScreenState extends State<HoldingReportScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  Future<HoldingReportModel>? futureReport;
  List<TotalsDf>? totalsDF;
  List<bool>? isShow;
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";
  String year = "";
  final List<String> items = [
    '2024-2025',
    '2023-2024',
    '2022-2023',
    '2021-2022',
    '2020-2021',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    datePickedValue = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    year = "${dateTime.year}";
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchHoldingReport();
  }

  Future<void> fetchHoldingReport() async {
    setState(() {
      futureReport = ApiServices().fetchHoldingsReport(
          date: datePickedValue,
          token: Appvariables.token,
          clientCode: Appvariables.clientCode);
    });
    futureReport?.then((data) {
      setState(() {
        isShow = List<bool>.filled(data.data!.filteredDf!.length, false);
      });
    });
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
      fetchHoldingReport();
      print("${datePicked.year}-${datePicked.month}-${datePicked.day}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
          text: 'Report Holding',
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 08.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down_rounded,color: Color(0xFF0066F6),),
                      iconSize: 25,
                    ),
                    hint: Utils.text(
                        text: "2024-2025",
                        color: const Color(0xFF0066F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Utils.text(
                                  text: item,
                                  color: const Color(0xFF0066F6),
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
                        print(datePickedValue);
                        fetchHoldingReport();
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 40,
                      width: 140,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0066F6)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await _showDateTimePicker();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF0066F6)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 08),
                      child: Center(
                        child: Utils.text(
                            text: datePickedValue,
                            color: const Color(0xFF0066F6),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Utils.showLoadingDialogue(context);
                    ApiServices().downloadReportDocuments(
                        token: Appvariables.token,
                        type: "holding",
                        downloadType: "PDF",
                        year: year,
                        context: context
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF0066F6)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 08),
                      child: Center(
                        child: Utils.text(
                            text: "Download",
                            color: const Color(0xFF0066F6),
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
      ),
      body: RefreshIndicator(
        onRefresh: fetchHoldingReport,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<HoldingReportModel>(
                    future: futureReport,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Utils.text(
                          text: 'Error: ${snapshot.error}',
                          color: Colors.black,
                        ));
                      }
                      else if (snapshot.hasData) {
                        final report = snapshot.data!;
                        totalsDF = snapshot.data?.data?.totalsDf;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {});
                        });
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: report.data!.filteredDf!.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            final data = report.data!.filteredDf![index];
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
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 180,
                                              child: Utils.text(
                                                text: "${data.scripName}" == ""
                                                    ? "-"
                                                    : "${data.scripName}",
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
                                                  text: "Amount",
                                                  color: const Color(0xFF4A5568).withOpacity(0.70),
                                                  fontSize: 10,
                                                ),
                                                Utils.text(
                                                  text: "${data.amount}" == ""
                                                      ? "-"
                                                      : "${data.amount}",
                                                  color: const Color(0xFF37474F),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600
                                                ),
                                              ],
                                            )
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
                                                  text: "ISIN",
                                                  fontSize: 10,
                                                  color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.isin,
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
                                                    text: "Col Qty",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.colqty,
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
                                                    text: "Lock In",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.lockinqty,
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
                                                    text: "Closing Price",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.scripValue,
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
                                                    text: "Net Total",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.netTotal,
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
                                                    text: "In Short",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.inshort,
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
                                                    text: "Out Short",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.outshort,
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
                                                    text: "Free Qty",
                                                    fontSize: 10,
                                                    color: const Color(0xFF4A5568)
                                                ),
                                                Utils.text(
                                                    text: data.freeqty,
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Utils.text(
                                        //       text: "ISIN",
                                        //       color: Color(0xFF4A5568),
                                        //       fontSize: 10,
                                        //     ),
                                        //     Utils.text(
                                        //       text: data.isin,
                                        //       color: Colors.black,
                                        //       fontSize: 10,
                                        //       fontWeight: FontWeight.w600
                                        //     ),
                                        //     const Spacer(),
                                        //     Utils.text(
                                        //       text: "Amount : ",
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //     Utils.text(
                                        //       text: "${data.amount}" == ""
                                        //           ? "-"
                                        //           : "${data.amount}",
                                        //       color:
                                        //           "${data.amount}".startsWith("-")
                                        //               ? Colors.red
                                        //               : Colors.green,
                                        //       fontSize: 12,
                                        //       textOverFlow: TextOverflow.ellipsis,
                                        //     ),
                                        //   ],
                                        // ),
                                        Visibility(
                                          visible: (isShow?[index] ?? false),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(05.0),
                                                  child: Column(
                                                    children: [
                                                      Divider(
                                                        color: Colors
                                                            .grey.shade800
                                                            .withOpacity(0.2),
                                                      ),
                                                      const SizedBox(
                                                        height: 05,
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            data.scripName != "",
                                                        child: Row(
                                                          children: [
                                                            Utils.text(
                                                              text: (data.scripName
                                                                              ?.length ??
                                                                          0) >
                                                                      10
                                                                  ? "${data.scripName?.substring(0, 10)}..."
                                                                  : data
                                                                      .scripName,
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              textAlign:
                                                                  TextAlign.start,
                                                            ),
                                                            const SizedBox(
                                                              width: 05,
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        contentPadding:
                                                                            const EdgeInsets
                                                                                .all(
                                                                                10),
                                                                        content:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Utils
                                                                                .text(
                                                                              text:
                                                                                  data.scripName,
                                                                              color:
                                                                                  Colors.black,
                                                                              fontSize:
                                                                                  16,
                                                                              fontWeight:
                                                                                  FontWeight.w600,
                                                                              textAlign:
                                                                                  TextAlign.start,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  );
                                                                },
                                                                child: const Icon(
                                                                  Icons.info,
                                                                  color:
                                                                      Colors.grey,
                                                                  size: 20,
                                                                )),
                                                            const Spacer(),
                                                            Visibility(
                                                              visible:
                                                                  data.isin != "",
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    height: 15,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              05),
                                                                      color: Colors
                                                                          .deepPurpleAccent
                                                                          .shade700
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                      child: Utils
                                                                          .text(
                                                                        text: data
                                                                            .isin,
                                                                        color: Colors
                                                                            .deepPurple,
                                                                        fontSize:
                                                                            09,
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
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(05),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .grey.shade800
                                                                  .withOpacity(
                                                                      0.2)),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Utils.text(
                                                                    text:
                                                                        "Pledge Qty",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                  Utils.text(
                                                                    text:
                                                                        "Free Qty",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Utils.text(
                                                                    text: "${data.pledgeqty}" ==
                                                                            ""
                                                                        ? "-"
                                                                        : "${data.pledgeqty}",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "${data.freeqty}" ==
                                                                            ""
                                                                        ? "-"
                                                                        : "${data.freeqty}",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Utils.text(
                                                                    text:
                                                                        "COL Qty",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                  Utils.text(
                                                                    text:
                                                                        "Net Total",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Utils.text(
                                                                    text: "${data.colqty}" ==
                                                                            ""
                                                                        ? "-"
                                                                        : "${data.colqty}",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "${data.netTotal}" ==
                                                                            ""
                                                                        ? "-"
                                                                        : "${data.netTotal}",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Utils.text(
                                                                    text:
                                                                        "Out Short",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                  Utils.text(
                                                                    text:
                                                                        "In Short",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Utils.text(
                                                                    text: "${data.inshort}" ==
                                                                            ""
                                                                        ? "-"
                                                                        : "${data.inshort}",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "${data.outshort}" ==
                                                                            ""
                                                                        ? "-"
                                                                        : "${data.outshort}",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Utils.text(
                                                                    text:
                                                                        "Amount",
                                                                    color:
                                                                        kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 05,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Utils.text(
                                                                    text:
                                                                        "${data.amount}",
                                                                    color: "${data.amount}"
                                                                            .startsWith(
                                                                                "-")
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                    fontSize: 13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
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
                        );
                        // return ListView.builder(
                        //   itemCount: report.data!.filteredDf!.length,
                        //   itemBuilder: (context, index) {
                        //     final data = report.data!.filteredDf![index];
                        //     return Padding(
                        //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        //       child: Card(
                        //          color: Colors.white,
                        //         child: Container(
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(10),
                        //           ),
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 horizontal: 10.0, vertical: 10),
                        //             child: Column(
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment: MainAxisAlignment.start,
                        //                   children: [
                        //                     Column(
                        //                       mainAxisAlignment: MainAxisAlignment.start,
                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                        //                       children: [
                        //                         Row(
                        //                           children: [
                        //                             Column(
                        //                               mainAxisAlignment:
                        //                               MainAxisAlignment.start,
                        //                               crossAxisAlignment:
                        //                               CrossAxisAlignment.start,
                        //                               children: [
                        //                                 Container(
                        //                                   height: 35,
                        //                                   width: 35,
                        //                                   decoration: BoxDecoration(
                        //                                     borderRadius:
                        //                                     BorderRadius.circular(10),
                        //                                     border: Border.all(
                        //                                       color: Colors.grey.shade800
                        //                                           .withOpacity(0.1),
                        //                                     ),
                        //                                   ),
                        //                                   child: Center(
                        //                                     child: Utils.text(
                        //                                       text: "${index + 1}",
                        //                                       color: Colors.black,
                        //                                       fontSize: 14,
                        //                                       fontWeight: FontWeight.bold,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             const SizedBox(
                        //                               width: 10,
                        //                             ),
                        //                             Column(
                        //                               mainAxisAlignment: MainAxisAlignment.start,
                        //                               crossAxisAlignment: CrossAxisAlignment.start,
                        //                               children: [
                        //                                 Row(
                        //                                   children: [
                        //                                     Utils.text(
                        //                                       text: "ISIN : ",
                        //                                       color: Colors.black,
                        //                                       fontSize: 10,
                        //                                       fontWeight: FontWeight.bold,
                        //                                     ),
                        //                                     Utils.text(
                        //                                       text: data.isin,
                        //                                       color: Colors.black,
                        //                                       fontSize: 10,
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                                 Row(
                        //                                   children: [
                        //                                     Utils.text(
                        //                                       text: "Script Name : ",
                        //                                       color: Colors.black,
                        //                                       fontSize: 10,
                        //                                       fontWeight: FontWeight.bold,
                        //                                     ),
                        //                                     Utils.text(
                        //                                       text: data.scripName,
                        //                                       color: Colors.black,
                        //                                       fontSize: 10,
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "Free Qty : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.freeqty}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "Col Qty : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.colqty}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "In Short : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.inshort}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "Out Short : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.outshort}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "Lockin : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.lockinqty}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "Net Total : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.netTotal}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 // Row(
                        //                                 //   children: [
                        //                                 //     Utils.text(
                        //                                 //       text: "Closing Price : ",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //     Utils.text(
                        //                                 //       text: "${data.scripValue}",
                        //                                 //       color: Colors.black,
                        //                                 //       fontSize: 10,
                        //                                 //     ),
                        //                                 //   ],
                        //                                 // ),
                        //                                 Row(
                        //                                   children: [
                        //                                     Utils.text(
                        //                                       text: "Amount : ",
                        //                                       color: Colors.black,
                        //                                       fontSize: 10,
                        //                                       fontWeight: FontWeight.bold,
                        //                                     ),
                        //                                     Utils.text(
                        //                                       text: "${data.amount}",
                        //                                       color: Colors.black,
                        //                                       fontSize: 10,
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       // child: Card(
                        //       //   color: Colors.white,
                        //       //   child: Padding(
                        //       //     padding: const EdgeInsets.all(10.0),
                        //       //     child: Column(
                        //       //       children: [
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "SR NO : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${index + 1}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "ISIN : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: data.isin,
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Script Name : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: data.scripName,
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Free Qty : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.freeqty}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Col Qty : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.colqty}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "In Short : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.inshort}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Out Short : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.outshort}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Out Short : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.outshort}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Lockin : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.lockinqty}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Net Total : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.netTotal}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Closing Price : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.scripValue}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //         Row(
                        //       //           children: [
                        //       //             Utils.text(
                        //       //               text: "Amount : ",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //             Utils.text(
                        //       //               text: "${data.amount}",
                        //       //               color: Colors.black,
                        //       //               fontSize: 10,
                        //       //             ),
                        //       //           ],
                        //       //         ),
                        //       //       ],
                        //       //     ),
                        //       //   ),
                        //       // ),
                        //     );
                        // },);
                      } else {
                        return const Center(child: Text('No data found'));
                      }
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: totalsDF != null && totalsDF!.isNotEmpty,
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
                          text: "${totalsDF?[0].amount}",
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

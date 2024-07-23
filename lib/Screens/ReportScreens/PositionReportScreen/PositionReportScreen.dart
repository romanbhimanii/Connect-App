// ignore_for_file: unrelated_type_equality_checks

import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/PositionReportModel/PositionReportModel.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class PositionReportScreen extends StatefulWidget {
  const PositionReportScreen({super.key});

  @override
  State<PositionReportScreen> createState() => _PositionReportScreenState();
}

class _PositionReportScreenState extends State<PositionReportScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  Future<PositionReportResponse>? positionReport;
  TotalData? totalData;
  List<bool>? isShow;
  DateTime dateTime = DateTime.now();
  String datePickedValue = "";

  @override
  void initState() {
    super.initState();
    datePickedValue = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchPositionReport();
  }

  Future<void> fetchPositionReport() async {
    setState(() {
      positionReport = ApiServices().fetchPositionReport(
        token: Appvariables.token,
        date: datePickedValue,
      );
    });
    positionReport?.then((data) {
      setState(() {
        isShow = List<bool>.filled(data.data!.dfFilter.length, false);
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

      fetchPositionReport();
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
                  border: Border.all(color: const Color(0xFF292D32))
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        scrolledUnderElevation: 0.0,
        title: Utils.text(
            text: "Open Position",           color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 32),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 08.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      await _showDateTimePicker();
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
                              text: "All",
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
                      await _showDateTimePicker();
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
                              text: "NSE FNO",
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
                      await _showDateTimePicker();
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
                              text: "CD NSE",
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
                      await _showDateTimePicker();
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
                              text: "MCX",
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
                      await _showDateTimePicker();
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
                              text: datePickedValue,
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchPositionReport,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: FutureBuilder<PositionReportResponse>(
                    future: positionReport,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!;
                        if(totalData?.amount != snapshot.data?.totalData || totalData.isNull){
                          WidgetsBinding.instance.addPostFrameCallback((_){
                            setState(() {
                              totalData = snapshot.data?.totalData;
                            });
                          });
                        }
                        return data.data!.dfFilter.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.data!.dfFilter.length,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 100),
                          itemBuilder: (context, index) {
                            final dfFilter = data.data!.dfFilter[index];
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
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 35,
                                                          width: 35,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(10),
                                                            color: dfFilter.position == "BUY" ? const Color(0xFF77FFB0).withOpacity(0.30) : const Color(0xFFFF7777).withOpacity(0.20),
                                                          ),
                                                          child: Center(
                                                            child: Utils.text(
                                                              text: dfFilter.position == "BUY" ? "B" : "S",
                                                              color: dfFilter.position == "BUY" ? const Color(0xFF61A735) : const Color(0xFFFF2E2E),
                                                              fontSize: 14,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(
                                                          width: 260,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Utils.text(
                                                                  text: dfFilter.description.length > 20 ? "${dfFilter.description.substring(0,20)}..." : dfFilter.description,
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 12,
                                                                  textOverFlow: TextOverflow.ellipsis
                                                              ),
                                                              Utils.text(
                                                                  text: dfFilter.amount,
                                                                  fontSize: 12,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: "${dfFilter.amount}".startsWith("-") ? const Color(0xFFFF2E2E) : const Color(0xFF008710)
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 260,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Utils.text(
                                                                  text: "QTY: -${dfFilter.osqty}",
                                                                  fontWeight: FontWeight.w600,
                                                                  fontSize: 10,
                                                                color: Color(0xFF4A5568)
                                                              ),
                                                              Utils.text(
                                                                  text: "RATE: -${dfFilter.osrate}",
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Color(0xFF4A5568)
                                                              ),
                                                              Utils.text(
                                                                  text: "Closing Price: -${dfFilter.closingPrice}",
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: Color(0xFF4A5568)
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Utils.text(
                                        //       text: "OS Rate : ",
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //     Utils.text(
                                        //       text: "${dfFilter.osrate}" == "" ? "-" : "${dfFilter.osrate}",
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       textOverFlow: TextOverflow.ellipsis,
                                        //     ),
                                        //     const Spacer(),
                                        //     Utils.text(
                                        //       text: "Position : ",
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //     Utils.text(
                                        //       text: dfFilter.position == "" ? "-" : dfFilter.position,
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       textOverFlow: TextOverflow.ellipsis,
                                        //     ),
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   height: 10,
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Utils.text(
                                        //       text: "Des : ",
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //     Utils.text(
                                        //       text: (dfFilter.description.length ?? 0) > 15
                                        //           ? "${dfFilter.description.substring(0, 15)}..."
                                        //           : dfFilter.description,
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       textOverFlow: TextOverflow.ellipsis,
                                        //     ),
                                        //     const Spacer(),
                                        //     Utils.text(
                                        //       text: "Amount : ",
                                        //       color: Colors.black,
                                        //       fontSize: 12,
                                        //       fontWeight: FontWeight.bold,
                                        //     ),
                                        //     Utils.text(
                                        //       text: "${dfFilter.amount}" == "" ? "-" : dfFilter.amount.toStringAsFixed(2),
                                        //       color: "${dfFilter.amount}".startsWith("-") ? Colors.red : Colors.green,
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
                                                        visible: dfFilter.description != "",
                                                        child: Row(
                                                          children: [
                                                            Utils.text(
                                                              text: (dfFilter.description.length ?? 0) > 10 ? "${dfFilter.description.substring(0,10)}..." : dfFilter.description,
                                                              color: Colors.black,
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w600,
                                                              textAlign: TextAlign.start,
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
                                                                            text: dfFilter.description,
                                                                            color: Colors.black,
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
                                                              visible: dfFilter.position != "",
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
                                                                        text: dfFilter.position,
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
                                                                    text: "OS Qty",
                                                                    color: kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "OS Rate",
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
                                                                    text: "${dfFilter.osqty}" == "" ? "-" : "${dfFilter.osqty}",
                                                                    color: kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "${dfFilter.osrate}" == "" ? "-" : "${dfFilter.osrate}",
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
                                                                    text: "OS Rate",
                                                                    color: kBlackColor87,
                                                                    fontSize: 11,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "OS Qty",
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
                                                                    text: "${dfFilter.osrate}" == "" ? "-" : "${dfFilter.osrate}",
                                                                    color: kBlackColor87,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                  Utils.text(
                                                                    text: "${dfFilter.osqty}" == "" ? "-" : "${dfFilter.osqty}",
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
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Utils.text(
                                                                    text: "Amount",
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
                                                                    text: "${dfFilter.amount}",
                                                                    color: "${dfFilter.amount}".startsWith("-") ? Colors.red : Colors.green,
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
                        ) : Center(
                          child: Utils.text(
                              text: "No data Found!",
                              color: kBlackColor,
                              fontSize: 13
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data found'),);
                      }
                    },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !totalData.isNull,
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
                          text: "${totalData?.amount}",
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

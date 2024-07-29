// ignore_for_file: unrelated_type_equality_checks

import 'package:connect/ConnectApp/Models/LedgerReportModel/LedgerReportModel.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsOfLedgerScreen extends StatefulWidget {
  const DetailsOfLedgerScreen({super.key});

  @override
  State<DetailsOfLedgerScreen> createState() => _DetailsOfLedgerScreenState();
}

class _DetailsOfLedgerScreenState extends State<DetailsOfLedgerScreen> {

  dynamic arguments = Get.arguments;
  ReportData? reportData;

  @override
  void initState() {
    super.initState();
    reportData = arguments['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Utils.text(
          text: "Ledger Report Details",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: reportData?.narration != "",
                      child: Row(
                        children: [
                          Expanded(
                            child: Utils.text(
                              text: reportData?.narration ?? "",
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: reportData?.cocd != "",
                      child: Row(
                        children: [
                          Container(
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Colors.deepPurpleAccent.shade700
                                    .withOpacity(0.1)),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Utils.text(
                                text: reportData?.cocd ?? "",
                                color: Colors.deepPurple, fontSize: 09,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 7,
                          )
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
                          border: Border.all(
                              color: Colors.grey.shade800.withOpacity(0.2))),
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
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Voucher Date",
                                  color: kBlackColor87, fontSize: 11,
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
                                  text: reportData?.billDate == "" ? "-" : "${reportData?.billDate}",
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: reportData?.voucherDate == "" ? "-" : "${reportData?.voucherDate}",
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
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "COCD",
                                  color: kBlackColor87, fontSize: 11,
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
                                  text: reportData?.voucherNo == "" ? "-" : "${reportData?.voucherNo}",
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: reportData?.cocd == "" ? "-" : "${reportData?.cocd}",
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
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "CR Amount",
                                  color: kBlackColor87, fontSize: 11,
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
                                  text: reportData?.drAmt == "" ? "-" : "${reportData?.drAmt}",
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: reportData?.crAmt == "" ? "-" : "${reportData?.crAmt}",
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
                                  color: kBlackColor87, fontSize: 11,
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
                                  text: "${reportData?.balance}",
                                  color: "${reportData?.balance}".startsWith("-") ? Colors.red : Colors.green,
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
            )
          ],
        ),
      ),
    );
  }
}

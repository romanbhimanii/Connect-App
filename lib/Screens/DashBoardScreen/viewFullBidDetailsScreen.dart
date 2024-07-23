// ignore_for_file: camel_case_types

import 'package:connect/Models/ClientWiseBidReport/ClientWiseBidReport.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class viewFullBidDetailsScreen extends StatefulWidget {
  const viewFullBidDetailsScreen({super.key});

  @override
  State<viewFullBidDetailsScreen> createState() => _viewFullBidDetailsScreenState();
}

class _viewFullBidDetailsScreenState extends State<viewFullBidDetailsScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  dynamic arguments = Get.arguments;
  ClientBidReport? clientBidReport;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    clientBidReport = arguments['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Utils.text(
          text: "Bid Details",
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
                    Row(
                      children: [
                        Expanded(
                          child: Utils.text(
                            text:  clientBidReport?.clientName ?? "",
                                color: kBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
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
                              text: clientBidReport?.clientBenId ?? "",
                                  color: Colors.deepPurple, fontSize: 09,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        )
                      ],
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
                                  text: "Application Number",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text:  "Bid Ref. No.",
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
                                  text:  "${clientBidReport?.applicationNo}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text:  "${clientBidReport?.bidReferenceNo}",
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
                                  text:  "Bid Quantity",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Bid Amount",
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
                                  text: "${clientBidReport?.bidQty}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text:  "${clientBidReport?.bidAmount}",
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
                                  text: "Category",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Mandate Status",
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
                                  text: "${clientBidReport?.category}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                                Text(
                                  clientBidReport?.mandateStatus == null
                                      ? "-"
                                      : (clientBidReport!.mandateStatus?.length ?? 0) > 20
                                      ? "${clientBidReport?.mandateStatus?.substring(0, 20)}..."
                                      : clientBidReport?.mandateStatus ?? "",
                                  style: GoogleFonts.poppins(
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                                  text: "Price",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Reason",
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
                                  text: "${clientBidReport?.price}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text:   clientBidReport?.reason == "" ? "-" : "${clientBidReport?.reason}",
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
                                  text:  "Symbol",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Date",
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
                                  text:  "${clientBidReport?.symbol}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text:  "${clientBidReport?.timestamp}",
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
                                  text: "UPI ID",
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
                                  text:  "${clientBidReport?.upi}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
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

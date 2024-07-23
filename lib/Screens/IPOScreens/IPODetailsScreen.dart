// ignore_for_file: must_be_immutable

import 'package:connect/Models/IpoModels/IpoModel.dart';
import 'package:connect/Screens/IPOScreens/ApplyIPOScreen.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IPODetailsScreen extends StatefulWidget {
  String? name;
  IpoDetails data;
  IPODetailsScreen({super.key,required this.name, required this.data});

  @override
  State<IPODetailsScreen> createState() => _IPODetailsScreenState();
}

class _IPODetailsScreenState extends State<IPODetailsScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  int issueSize = 0;
  double minPriceValue = 0.0;
  double totalIssueSize = 0.0;

  int minBidQty = 0;
  double minPriceValue1 = 0.0;
  double minimumInvestment = 0.0;

  int maxBidQty = 0;
  double maxPriceValue = 0.0;
  double maximumInvestment = 0.0;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    int issueSize = int.parse(widget.data.issueSize);
    minPriceValue = double.parse(widget.data.cutoffPrice);
    totalIssueSize = issueSize * minPriceValue;

    minBidQty = int.parse(widget.data.minBidQuantity);
    minPriceValue1 = double.parse(widget.data.minPrice);
    minimumInvestment = minBidQty * minPriceValue1;

    maxBidQty = int.parse(widget.data.minBidQuantity);
    maxPriceValue = double.parse(widget.data.cutoffPrice);
    maximumInvestment = minBidQty * maxPriceValue;
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
            text: "IPO Details",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
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
                            text:   widget.data.name,
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
                              text: widget.data.ipoType,
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
                                  text: "Bid Start Date",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Bid End Date",
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
                                  text: widget.data.biddingStartDate,
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.data.biddingEndDate,
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
                                  text: "Cutoff Price",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Symbol",
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
                                  text: "₹${widget.data.cutoffPrice}",
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600
                                ),
                                Utils.text(
                                  text: widget.data.symbol,
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
                                  text: "Bid Price",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text : "Lot Size",
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
                                  text: "₹${widget.data.minPrice}",
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: "${widget.data.lotSize} Shares",
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
                                  text: "Retail Discount",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Issue Size",
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
                                  text:  "₹${widget.data.polDiscountPrice}",
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: "₹ ${formatIndianCurrency(totalIssueSize)}",
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
                                  text: "IPO Type",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "ISIN",
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
                                  text: widget.data.ipoType,
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.data.isin,
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
                                  text:  "Min Bid Quantity",
                                      color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Min Price",
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
                                 text:  "₹${widget.data.minBidQuantity}",
                                     color: kBlackColor87,
                                     fontSize: 13,
                                     fontWeight: FontWeight.w600,
                               ),
                                Utils.text(
                                  text: "₹${widget.data.minPrice}",
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Divider(
                                color: Colors.grey.shade800.withOpacity(0.15),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Minimum Investment",
                                      color: Colors.grey.shade800,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "₹$minimumInvestment / 1 Lot",
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
                                  text: "Maximum Investment",
                                      color: Colors.grey.shade800,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "₹$maximumInvestment / 1 Lot",
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
                    const SizedBox(
                      height: 40,
                    ),
                    Visibility(
                      visible: widget.name == "open IPO",
                      child: InkWell(
                        onTap: () {
                          Get.to(const Applyiposcreen(), arguments: ({
                              "name": widget.data.name,
                              "bidPrice": widget.data.cutoffPrice,
                              "maxValue": double.parse(widget.data.cutoffPrice),
                              "minValue": double.parse(widget.data.minPrice),
                              "lotSize": double.parse(widget.data.lotSize),
                              "categories" : widget.data.categories,
                              "symbol" : widget.data.symbol
                            }),
                          );
                        },
                        child: Utils.gradientButton(
                          message: "Apply Now",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
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

  String formatIndianCurrency(double amount) {
    if (amount >= 1e7) {
      double crore = amount / 1e7;
      return '${crore.toStringAsFixed(2)} Cr';
    } else if (amount >= 1e5) {
      double lakh = amount / 1e5;
      return '${lakh.toStringAsFixed(2)} Lakh';
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}

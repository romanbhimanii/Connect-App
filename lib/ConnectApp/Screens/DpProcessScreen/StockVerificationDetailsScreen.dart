
import 'package:connect/ConnectApp/Models/StockVerificationDpProcessModel/StockVerificationDpProcessModel.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StockVerificationDetailsScreen extends StatefulWidget {
  const StockVerificationDetailsScreen({super.key});

  @override
  State<StockVerificationDetailsScreen> createState() => _StockVerificationDetailsScreenState();
}

class _StockVerificationDetailsScreenState extends State<StockVerificationDetailsScreen> {

  dynamic arguments = Get.arguments;
  Holding? filteredDf;
  double? bidValue = 0.0;
  double minValue = 0.0;
  double maxValue = 0.0;
  double totalAmount = 0.0;
  bool isValid = true;
  String errorMessage = '';
  final formKey = GlobalKey<FormState>();
  bool value = false;
  final TextEditingController ePledgeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDf = arguments['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: "Stock Verification",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
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
                border: Border.all(
                  color: const Color(0xFF292D32),
                ),
              ),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: filteredDf?.scripName != "",
                        child: Row(
                          children: [
                            Expanded(
                              child: Utils.text(
                                text: filteredDf?.scripName ?? "",
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
                        visible: filteredDf?.isin != "",
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color: Colors.deepPurpleAccent.shade700
                                    .withOpacity(0.1),),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Utils.text(
                                  text: filteredDf?.isin ?? "",
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
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(05),
                          border: Border.all(
                            color: Colors.grey.shade800.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.text(
                                    text: "NON",
                                    color: kBlackColor87,
                                    fontSize: 11,
                                  ),
                                  Utils.text(
                                    text: "Margin",
                                    color: kBlackColor87,
                                    fontSize: 11,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 05,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.text(
                                    text: filteredDf?.pledgeQty == ""
                                        ? "-"
                                        : "${filteredDf?.pledgeQty}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Utils.text(
                                    text: filteredDf?.colQty == ""
                                        ? "-"
                                        : "${filteredDf?.colQty}",
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.text(
                                    text: "POA",
                                    color: kBlackColor87,
                                    fontSize: 11,
                                  ),
                                  Utils.text(
                                    text: "Net",
                                    color: kBlackColor87,
                                    fontSize: 11,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 05,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.text(
                                    text: filteredDf?.freeQty == ""
                                        ? "-"
                                        : "${filteredDf?.freeQty}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Utils.text(
                                    text: filteredDf?.net == ""
                                        ? "-"
                                        : "${filteredDf?.net}",
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.text(
                                    text: "Closing Price",
                                    color: kBlackColor87,
                                    fontSize: 11,
                                  ),
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Utils.text(
                                    text: filteredDf?.scripValue == ""
                                        ? "-"
                                        : "${filteredDf?.scripValue}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Utils.text(
                                    text: filteredDf?.amount == ""
                                        ? "-"
                                        : "${filteredDf?.amount}",
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                controller: ePledgeController,
                                keyboardType:
                                const TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  hintText: "Enter E-Pledge Amount",
                                  hintStyle: GoogleFonts.inter(
                                      color:
                                      Colors.grey.shade800.withOpacity(0.4),
                                      fontSize: 13),
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: isValid
                                          ? Colors.blueGrey.shade600
                                          .withOpacity(0.15)
                                          : Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: isValid ? Colors.blue : Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onChanged: (text) {
                                  if(text.isNotEmpty){
                                    setState(() {
                                      bidValue = double.parse(text);
                                      maxValue =
                                          double.parse(filteredDf?.net ?? "");
                                      double scripValue = double.parse(
                                          filteredDf?.scripValue ?? "");
                                      totalAmount =
                                          (bidValue ?? 0.0) * scripValue;
                                      if (bidValue == null ||
                                          (bidValue ?? 0.0) < minValue ||
                                          (bidValue ?? 0.0) > maxValue) {
                                        isValid = false;
                                        errorMessage =
                                        "Please enter a price within the range (₹$minValue - ₹$maxValue)";
                                      } else {
                                        isValid = true;
                                        errorMessage = '';
                                      }
                                    });
                                  }
                                },
                                onTapOutside: (PointerDownEvent event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter correct Amount!';
                                  }
                                  return null;
                                },
                              ),
                              if (!isValid)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Utils.text(
                                      text: errorMessage,
                                      color: Colors.red,
                                      fontSize: 11),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utils.text(
                              text: "Total Value",
                              fontSize: 13,
                              color: Colors.black),
                          Utils.text(
                              text: "₹$totalAmount",
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 05,
            ),
            Row(
              children: [
                Checkbox(
                  value: value,
                  activeColor: const Color(0xFF007FEB),
                  onChanged: (value1) {
                    setState(() {
                      value = value1 ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Utils.text(
                      text: "Pledge Reason",
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: InkWell(
                  onTap: () {
                    if (value == true &&
                        formKey.currentState!.validate() &&
                        isValid) {
                      Utils.showLoadingDialogue(context);
                      double bidPrice = double.parse(ePledgeController.text);
                    } else {
                      Utils.toast(
                          msg: value == false
                              ? "Please accept the Pledge Reason!"
                              : "Please enter correct Amount!");
                    }
                  },
                  child: Utils.gradientButton(
                      message: "Submit"
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

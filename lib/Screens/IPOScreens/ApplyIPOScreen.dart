// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/BidSubmitModel/BidSubmitModel.dart';
import 'package:connect/Models/ProfileClientDetails/ProfileClientDetails.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Applyiposcreen extends StatefulWidget {
  const Applyiposcreen({super.key});

  @override
  State<Applyiposcreen> createState() => _ApplyiposcreenState();
}

class _ApplyiposcreenState extends State<Applyiposcreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  dynamic arguments = Get.arguments;
  String name = "";
  String bidPrice = "";
  Future<AccountProfile>? futureAccountProfile;
  String dropdownvalue = 'Item 1';
  int number = 1;
  final formKey = GlobalKey<FormState>();
  TextEditingController bidPriceController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  double minValue = 0.0;
  double maxValue = 0.0;
  double lotSize = 0.0;
  double? bidValue = 0.0;
  bool isValid = true;
  String errorMessage = '';
  List<String> categories = [];
  double totalAmount = 0.0;
  double totalBidQuantity = 0.0;
  bool value = false;
  String symbol = "";

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    name = arguments["name"];
    bidPriceController.text = arguments["bidPrice"];
    minValue = arguments["minValue"];
    maxValue = arguments["maxValue"];
    lotSize = arguments["lotSize"];
    categories = arguments["categories"];
    symbol = arguments["symbol"];
    totalAmount = lotSize * maxValue * number;
    loadData();
  }

  void loadData() {
    futureAccountProfile = ApiServices().fetchAccountProfile(token: Appvariables.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.grey[200],
        title: Utils.text(
            text: name,
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  fetchProfileClientDetails(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateUpi(String? value) {
    final RegExp upiRegExp = RegExp(r'^[\w.-]+@[\w.-]+$');
    if (value == null || value.isEmpty) {
      return 'Please enter your UPI ID';
    } else if (!upiRegExp.hasMatch(value)) {
      return 'Please enter a valid UPI ID (e.g., xxxx@Bankname)';
    }
    return null;
  }

  void submitBid(
      {String? symbol,
      String? category,
      String? upiId,
      String? boId,
      double? quantity,
      double? price,
      double? amount}) async {
    BidRequest request = BidRequest(
      symbol: symbol ?? "",
      category: category ?? "",
      upiId: upiId ?? "",
      quantity: quantity ?? 0.0,
      price: price ?? 0.0,
      amount: amount ?? 0.0,
      boId: boId ?? "",
    );

    try {
      BidResponse response = await ApiServices().submitBid(request,Appvariables.token);
      if(response.status == "success"){
        Get.back();
        FocusScope.of(context).unfocus();
        AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            btnOkColor: const Color.fromRGBO(27, 82, 52, 1.0),
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            btnOkOnPress: () {
              FocusScope.of(context).unfocus();
            },
            title: response.message,
            desc: response.data.exchange == "NSE" ? 'Application No: ${response.data.applicationNo}\n\nBid Reference No: ${response.data.bidReferenceNo}' : 'Application No: ${response.data.applicationNo}',
            titleTextStyle: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: const Color.fromRGBO(27, 82, 52, 1.0)),
            descTextStyle: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.w600, color: kBlackColor))
            .show();
      }else if(response.status == "error"){
        Get.back();
        FocusScope.of(context).unfocus();
        showAlerterror(context);
      }
      if (kDebugMode) {
        print('Bid Submitted: ${response.data.message}');
      }
    } catch (e) {
      Get.back();
      FocusScope.of(context).unfocus();
      showAlerterror(context);
    }
  }

  void showAlerterror(BuildContext context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.error,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          FocusScope.of(context).unfocus();
        },
        title: 'ERROR!',
        desc: 'Failed to Submit Bid!',
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
        descTextStyle: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.bold, color: kBlackColor))
      .show();
  }

  void showAlertsuccess(BuildContext context) {
    AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        btnOkColor: const Color.fromRGBO(27, 82, 52, 1.0),
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          FocusScope.of(context).unfocus();
        },
        title: 'This is SUCCESS',
        desc: 'this is your description text',
        titleTextStyle: GoogleFonts.poppins(
            fontSize: 20, fontWeight: FontWeight.bold, color: const Color.fromRGBO(27, 82, 52, 1.0)),
        descTextStyle: GoogleFonts.poppins(
            fontSize: 12, fontWeight: FontWeight.bold, color: kBlackColor))
      .show();
  }

  Widget fetchProfileClientDetails() {
    return FutureBuilder<AccountProfile>(
      future: futureAccountProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
        } else if (snapshot.hasError) {
          return Utils.text(
              text: "Error: ${snapshot.error}",
              color: kBlackColor,
              fontSize: 15,
              fontWeight: FontWeight.bold);
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return Column(
            children: [
              Container(
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
                        children: [
                          Utils.text(
                              text: "Client ID :- ",
                              fontSize: 13,
                              color: kBlackColor),
                          Utils.text(
                              text: data.personalDetails.assClientId,
                              color: kBlackColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Utils.text(
                              text: "CDSL NO :- ",
                              fontSize: 13,
                              color: kBlackColor),
                          Utils.text(
                              text: data.personalDetails.clientDpCode,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor),
                          // DropdownButton(
                          //   value: dropdownvalue,
                          //   icon: const Icon(Icons.keyboard_arrow_down),
                          //   items: items.map((String items) {
                          //     return DropdownMenuItem(
                          //       value: items,
                          //       child: Text(items),
                          //     );
                          //   }).toList(),
                          //   onChanged: (String? newValue) {
                          //     setState(() {
                          //       dropdownvalue = newValue ?? "";
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Utils.text(
                      text: "Note:",
                      fontWeight: FontWeight.bold,
                      color: kBlackColor,
                      fontSize: 14),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                    child: Utils.text(
                        text:
                            "IPO window will remain open from 10:00 AM till 5:00 PM on trading days. You can accept the UPI mandate request till 5:00 PM on the day of IPO close date. If you don't receive the UPI request till the end of the day due to delays from the bank, kindly delete and apply again.",
                        color: kBlackColor,
                        fontSize: 09,
                        textAlign: TextAlign.start),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
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
                              text: "Number of Lots",
                              fontSize: 13,
                              color: kBlackColor),
                          Utils.text(
                              text: "Maximum Lots : 13",
                              fontSize: 13,
                              color: kBlackColor),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (number > 1) {
                                setState(() {
                                  number--;
                                  totalBidQuantity = number * lotSize;
                                  if (bidValue == 0.0) {
                                    totalAmount = lotSize * maxValue * number;
                                  } else {
                                    totalAmount =
                                        lotSize * (bidValue ?? 0.0) * number;
                                  }
                                });
                              }
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(05),
                                  color: Colors.blueGrey.shade600
                                      .withOpacity(0.15)),
                              child: const Center(
                                child: Icon(
                                  Icons.remove,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width - 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                border: Border.all(
                                    color: Colors.blueGrey.shade600
                                        .withOpacity(0.15))),
                            child: Center(
                              child: Utils.text(
                                  text: "$number",
                                  color: kBlackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                number++;
                                totalBidQuantity = number * lotSize;
                                if (bidValue == 0.0) {
                                  totalAmount = lotSize * maxValue * number;
                                } else {
                                  totalAmount =
                                      lotSize * (bidValue ?? 0.0) * number;
                                }
                              });
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(05),
                                color:
                                    Colors.blueGrey.shade600.withOpacity(0.15),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: kBlackColor,
                                ),
                              ),
                            ),
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
                              fontSize: 13,
                              color: kBlackColor),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: bidPriceController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isValid
                                  ? Colors.blueGrey.shade600.withOpacity(0.15)
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
                          setState(() {
                            bidValue = double.tryParse(text);
                            totalAmount = lotSize * (bidValue ?? 0.0) * number;
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
                        },
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
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
              const SizedBox(
                height: 15,
              ),
              Container(
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
                              text: "Enter your UPI ID",
                              fontSize: 13,
                              color: kBlackColor),
                        ],
                      ),
                      const SizedBox(
                        height: 05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utils.text(
                              text: "Use UPI ID linked to your bank account",
                              fontSize: 11,
                              color: kBlackColor),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: upiController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          labelText: "Enter your UPI(xxxx@Bankname)",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade600.withOpacity(0.15),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 1.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        validator: validateUpi,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
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
                              text: "Total Payable Amount",
                              fontSize: 13,
                              color: kBlackColor),
                          Utils.text(
                              text: "₹$totalAmount",
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: kBlackColor),
                        ],
                      ),
                      const SizedBox(
                        height: 05,
                      ),
                      Divider(
                        color: Colors.blueGrey.shade600.withOpacity(0.15),
                        height: 10,
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utils.text(
                              text: "Order Value",
                              fontSize: 11,
                              color: kBlackColor),
                          Utils.text(
                              text: "₹$totalAmount",
                              fontSize: 11,
                              color: kBlackColor),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utils.text(
                              text: "Available Retail Discount",
                              fontSize: 11,
                              color: kBlackColor),
                          Utils.text(
                              text: "₹00", fontSize: 11, color: kBlackColor),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Checkbox(
                    value: value,
                    activeColor: const Color(0xFF2970E8),
                    onChanged: (value1) {
                      setState(() {
                        value = value1 ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Utils.text(
                        text:
                            "I hereby understand that I have read the Red Herring Prospectus and I am an eligible UPI bidder as per the application provision of the SEBI(Issue of Capital and Disclosure Requirement) Regulation, 2018.",
                        color: kBlackColor,
                        fontSize: 10,
                        textAlign: TextAlign.start),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (value == true && formKey.currentState!.validate()) {
                    Utils.showLoadingDialogue(context);
                    double bidPrice = double.parse(bidPriceController.text);
                    submitBid(
                      amount: totalAmount,
                      boId: data.personalDetails.clientDpCode,
                      category: categories[0],
                      price: bidPrice,
                      quantity: totalBidQuantity,
                      symbol: symbol,
                      upiId: upiController.text
                    );
                  }else{
                    Utils.toast(msg: value == false ? "Please accept the rules and regulations!" : "Please enter correct upi id!");
                  }
                },
                child: Utils.gradientButton(
                  message: "Submit",
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          );
        } else {
          return Center(
            child: Utils.text(
              text: "No data found",
              color: kBlackColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          );
        }
      },
    );
  }
}

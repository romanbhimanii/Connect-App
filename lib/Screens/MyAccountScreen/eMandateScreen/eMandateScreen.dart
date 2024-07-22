// ignore_for_file: camel_case_types, deprecated_member_use

import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/BankDetailsModel/BankDetailsModel.dart';
import 'package:connect/Models/ProfileClientDetails/ProfileClientDetails.dart';
import 'package:connect/Screens/MyAccountScreen/FundScreen/FundScreen.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class eMandateScreen extends StatefulWidget {
  const eMandateScreen({super.key});

  @override
  State<eMandateScreen> createState() => _eMandateScreenState();
}

class _eMandateScreenState extends State<eMandateScreen> {

  double fontSize = 34;
  final double minFontSize = 09;
  final double maxFontSize = 34;
  final double fieldWidth = 180;
  Future<AccountProfile>? futureAccountProfile;
  bool isOnlineEmandate = true;
  final ConnectivityService connectivityService = ConnectivityService();
  BankDetailsResponse? bankDetails;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String selectedPaymentMethod = 'Net Banking';
  String selectedBankName = "";
  String selectedBankAccountNumber = "";
  String selectedBankIFSCCode = "";
  String selectedBankMICRCode = "";
  String selectedBankAccountType = "";

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchBankDetails();
  }

  Future<void> fetchBankDetails() async {
    try {
      BankDetailsResponse response = await ApiServices().fetchBankDetails(token: Appvariables.token);
      futureAccountProfile = ApiServices().fetchAccountProfile(token: Appvariables.token);
      setState(() {
        bankDetails = response;
        if (bankDetails != null && bankDetails!.data.bankName.isNotEmpty) {
          selectedBankName = bankDetails!.data.bankName.values.first;
          selectedBankAccountNumber = bankDetails!.data.bankAccountNumber.values.first;
          selectedBankIFSCCode = bankDetails!.data.ifscCode.values.first;
          selectedBankMICRCode = bankDetails!.data.micrCode.values.first;
          selectedBankAccountType = bankDetails!.data.bankAccountType.values.first;
        }
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        hasError = true;
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  void _adjustFontSize(String text) {
    setState(() {
      double newFontSize = maxFontSize;
      double textWidth = _calculateTextWidth(text, newFontSize);

      while (textWidth > fieldWidth && newFontSize > minFontSize) {
        newFontSize -= 1;
        textWidth = _calculateTextWidth(text, newFontSize);
      }

      fontSize = newFontSize;
    });
  }

  double _calculateTextWidth(String text, double fontSize) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF777777).withOpacity(0.10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset("assets/icons/BankLogoFund.svg",height: 80,width: 80,),
                      const SizedBox(
                        width: 05,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Utils.text(
                                text: "₹", 
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F3F62),
                              ),
                              const SizedBox(
                                width: 05,
                              ),
                              SizedBox(
                                height: 50,
                                width: fieldWidth,
                                child: TextFormField(
                                  controller: _controller,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize,
                                    color: const Color(0xFF0F3F62),
                                  ),
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
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
                                    contentPadding: const EdgeInsets.all(0),
                                    fillColor: Colors.transparent,
                                  ),
                                  onTapOutside: (PointerDownEvent event) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  onChanged: (value) {
                                    _adjustFontSize(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 07,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF9FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: selectedBankAccountNumber,
                                        color: const Color(0xFF0F3F62),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                      Utils.text(
                                        text: selectedBankName,
                                        color: const Color(0xFF0F3F62),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  PopupMenuButton<BankDetail>(
                                    icon: const Icon(Icons.auto_fix_high_sharp, color: Color(0xFF00A9FF)),
                                    color: Colors.white,
                                    onSelected: (BankDetail result) async {
                                      setState(() {
                                        selectedBankName = result.bankName;
                                        selectedBankAccountNumber = result.bankAccountNumber;
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      if (bankDetails?.data.bankName.entries == null || bankDetails?.data.bankAccountNumber.entries == null) {
                                        return [];
                                      }

                                      final bankNameMap = Map<String, String>.fromEntries(bankDetails!.data.bankName.entries);
                                      final bankAccountNumberMap = Map<String, String>.fromEntries(bankDetails!.data.bankAccountNumber.entries);

                                      List<PopupMenuEntry<BankDetail>> popupMenuItems = [];

                                      for (final nameEntry in bankNameMap.entries) {
                                        final accountNumber = bankAccountNumberMap[nameEntry.key];

                                        if (accountNumber != null) {
                                          popupMenuItems.add(
                                            PopupMenuItem<BankDetail>(
                                              value: BankDetail(nameEntry.value, accountNumber),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Utils.text(
                                                    text: nameEntry.value,
                                                    color: const Color(0xFF0F3F62),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Utils.text(
                                                    text: accountNumber,
                                                    color: const Color(0xFF0F3F62),
                                                  ),
                                                  const Divider(),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                      return popupMenuItems;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    isOnlineEmandate = !isOnlineEmandate;
                    setState(() {});
                  },
                  child: Container(
                    height: 70,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isOnlineEmandate ? const Color(0xFFEAF9FF) : const Color(0xFFF2F2F7)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/OnlineEmandateIcon.svg",height: 25,width: 25,color: isOnlineEmandate ? const Color.fromRGBO(15, 63, 98, 1.0) : const Color.fromRGBO(55, 71, 79, 1.0)),
                        const SizedBox(
                          width: 10,
                        ),
                        Utils.text(
                          text: "Online",
                          color: isOnlineEmandate ? const Color(0xFF0F3F62) : const Color(0xFF37474F),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    isOnlineEmandate = !isOnlineEmandate;
                    setState(() {});
                  },
                  child: Container(
                    height: 70,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isOnlineEmandate ? const Color(0xFFF2F2F7) : const Color(0xFFEAF9FF)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icons/PhysicalEmandateIcon.svg",height: 32,width: 32,color: isOnlineEmandate ? const Color.fromRGBO(55, 71, 79, 1.0) : const Color.fromRGBO(15, 63, 98, 1.0)),
                        const SizedBox(
                          width: 10,
                        ),
                        Utils.text(
                            text: "Physical",
                            color: isOnlineEmandate ? const Color(0xFF37474F) : const Color(0xFF0F3F62),
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isOnlineEmandate,
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = "Net Banking";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedPaymentMethod == "Net Banking" ? const Color(0xFFEAF9FF) : const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: SvgPicture.asset("assets/icons/creditCardIcon.svg",height: 30,width: 30,color: selectedPaymentMethod == "Net Banking" ? const Color.fromRGBO(15, 63, 98, 1.0) : const Color.fromRGBO(136, 136, 136, 1.0)),
                                ),
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Utils.text(
                                text: "Net Banking",
                                color: selectedPaymentMethod == "Net Banking" ? const Color(0xFF0F3F62) : const Color(0xFF888888),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const Spacer(),
                              Radio<String>(
                                value: 'Net Banking',
                                groupValue: selectedPaymentMethod,
                                activeColor: const Color(0xFF0F3F62),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = "Debit";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedPaymentMethod == "Debit" ? const Color(0xFFEAF9FF) : const Color(0xFFFAFAFA),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: SvgPicture.asset("assets/icons/DebitEmandateIcon.svg",height: 30,width: 30,color: selectedPaymentMethod == "Net Banking" ? const Color.fromRGBO(136, 136, 136, 1.0) : const Color.fromRGBO(15, 63, 98, 1.0)),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 13,
                              ),
                              Utils.text(
                                text: "Debit",
                                color: selectedPaymentMethod == "Debit" ? const Color(0xFF0F3F62) : const Color(0xFF888888),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              const Spacer(),
                              Radio<String>(
                                value: 'Debit',
                                groupValue: selectedPaymentMethod,
                                activeColor: const Color(0xFF0F3F62),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPaymentMethod = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Utils.text(
                          text: "Customer Details",
                          color: const Color(0xFF00A9FF),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Utils.text(
                              text: "Customer Name",
                              fontSize: 12,
                              color: const Color(0xFF777777),
                            ),
                          ],
                        ),
                        FutureBuilder<AccountProfile>(future: futureAccountProfile,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                  child:  Lottie.asset('assets/lottie/loading.json',height: 20,width: 20));
                            } else if (snapshot.hasError) {
                              return Utils.text(
                                  text: "Error: ${snapshot.error}",
                                  color: kBlackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600);
                            } else if (snapshot.hasData) {
                              final data = snapshot.data!.data;
                              return Row(
                                children: [
                                  Utils.text(
                                    text: data.personalDetails.clientDpName,
                                    color: const Color(0xFF313131),
                                    fontSize: 15,
                                  ),
                                ],
                              );
                            } else {
                              return Center(
                                child: Utils.text(
                                  text: "No name found",
                                  color: const Color(0xFF313131),
                                  fontSize: 15,
                                ),
                              );
                            }
                          },
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Utils.text(
                              text: "Bank Name",
                              fontSize: 12,
                              color: const Color(0xFF777777),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Utils.text(
                              text: selectedBankName,
                              color: const Color(0xFF313131),
                              fontSize: 15,
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.text(
                              text: "Account Number",
                              fontSize: 12,
                              color: const Color(0xFF777777),
                            ),
                            Utils.text(
                              text: "IFSC Code",
                              fontSize: 12,
                              color: const Color(0xFF777777),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.text(
                              text: selectedBankAccountNumber,
                              color: const Color(0xFF313131),
                              fontSize: 15,
                            ),
                            Utils.text(
                              text: selectedBankIFSCCode,
                              color: const Color(0xFF313131),
                              fontSize: 15,
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.text(
                              text: "MICR Code",
                              fontSize: 12,
                              color: const Color(0xFF777777),
                            ),
                            Utils.text(
                              text: "Account Type",
                              fontSize: 12,
                              color: const Color(0xFF777777),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Utils.text(
                              text: selectedBankMICRCode,
                              color: const Color(0xFF313131),
                              fontSize: 15,
                            ),
                            Utils.text(
                              text: selectedBankAccountType,
                              color: const Color(0xFF313131),
                              fontSize: 15,
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Utils.gradientButton(
                        message: "Next"
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: !isOnlineEmandate,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Utils.gradientButton(
                        message: "Download Pdf"
                      ),
                    ),
                  ],
                )
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

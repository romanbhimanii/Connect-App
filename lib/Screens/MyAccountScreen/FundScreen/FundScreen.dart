import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/BankDetailsModel/BankDetailsModel.dart';
import 'package:connect/Models/FundPayInModel/FundPayInModel.dart';
import 'package:connect/Models/FundPayOutModel/FundPayOutModel.dart';
import 'package:connect/Screens/MyAccountScreen/FundScreen/FundPayInRequestScreen.dart';
import 'package:connect/Screens/MyAccountScreen/FundScreen/FundPayOutRequestScreen.dart';
import 'package:connect/Screens/MyAccountScreen/FundScreen/PayInScreen.dart';
import 'package:connect/Screens/MyAccountScreen/FundScreen/PayOutScreen.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class Fundscreen extends StatefulWidget {
  const Fundscreen({super.key});

  @override
  State<Fundscreen> createState() => _FundscreenState();
}

class _FundscreenState extends State<Fundscreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  Future<FundPayinResponse>? futureFundPayin;
  Future<PayOutModel>? futureFundPayOut;
  BankDetailsResponse? bankDetails;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String selectedBankName = "";
  String selectedBankAccountNumber = "";

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((
        List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchBankDetails();
    fetchFundPayIn();
  }

  Future<void> fetchFundPayIn() async {
    futureFundPayin =
        ApiServices().fetchFundPayin(authToken: Appvariables.token);
    futureFundPayOut =
        ApiServices().fetchFundPayOut(authToken: Appvariables.token);
  }

  Future<void> fetchBankDetails() async {
    try {
      BankDetailsResponse response = await ApiServices().fetchBankDetails(
          token: Appvariables.token);
      setState(() {
        bankDetails = response;
        if (bankDetails != null && bankDetails!.data.bankName.isNotEmpty) {
          selectedBankName = bankDetails!.data.bankName.values.first;
          selectedBankAccountNumber =
              bankDetails!.data.bankAccountNumber.values.first;
        }
        isLoading = false;
      });
    } catch (error) {
      if(mounted){
        setState(() {
          hasError = true;
          errorMessage = error.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      SvgPicture.asset(
                        "assets/icons/BankLogoFund.svg", height: 80,
                        width: 80,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Utils.text(
                            text: "Rs. 5550000",
                            color: const Color(0xFF0F3F62),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
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
                                    icon: const Icon(Icons.auto_fix_high_sharp,
                                        color: Color(0xFF00A9FF)),
                                    color: Colors.white,
                                    onSelected: (BankDetail result) async {
                                      setState(() {
                                        selectedBankName = result.bankName;
                                        selectedBankAccountNumber =
                                            result.bankAccountNumber;
                                      });
                                    },
                                    itemBuilder: (BuildContext context) {
                                      if (bankDetails?.data.bankName.entries ==
                                          null ||
                                          bankDetails?.data.bankAccountNumber
                                              .entries == null) {
                                        return [];
                                      }

                                      final bankNameMap = Map<String,
                                          String>.fromEntries(
                                          bankDetails!.data.bankName.entries);
                                      final bankAccountNumberMap = Map<
                                          String,
                                          String>.fromEntries(
                                          bankDetails!.data.bankAccountNumber
                                              .entries);

                                      List<PopupMenuEntry<
                                          BankDetail>> popupMenuItems = [];

                                      for (final nameEntry in bankNameMap
                                          .entries) {
                                        final accountNumber = bankAccountNumberMap[nameEntry
                                            .key];

                                        if (accountNumber != null) {
                                          popupMenuItems.add(
                                            PopupMenuItem<BankDetail>(
                                              value: BankDetail(nameEntry.value,
                                                  accountNumber),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Utils.text(
                                                    text: nameEntry.value,
                                                    color: const Color(
                                                        0xFF0F3F62),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Utils.text(
                                                    text: accountNumber,
                                                    color: const Color(
                                                        0xFF0F3F62),
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
              height: 20,
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
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return PayInScreen(bankDetails: bankDetails,);
                              },));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEAF9FF),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset("assets/icons/payInIcon.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Utils.text(
                                    text: "Pay In",
                                    color: const Color(0xFF0F3F62),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return PayOutScreen(bankDetails: bankDetails,);
                              },));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFFEAF9FF),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset("assets/icons/payOutIcon.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Utils.text(
                                    text: "Pay Out",
                                    color: const Color(0xFF0F3F62),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Utils.text(
                      text: "Pay In Request",
                      color: const Color(0xFF00A9FF),
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return const Fundpayinrequestscreen();
                      },));
                    },
                    child: Utils.text(
                        text: "View All",
                        color: const Color(0xFF00A9FF),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<FundPayinResponse>(
              future: futureFundPayin,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Lottie.asset(
                          'assets/lottie/loading.json', height: 100,
                          width: 100));
                } else if (snapshot.hasError) {
                  return Center(child: Utils.text(
                    text: "No Data Found!",
                    color: kBlackColor,
                    fontSize: 13,
                  ),);
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return Center(child: Utils.text(
                    text: "No data found",
                    color: kBlackColor,
                    fontSize: 13,
                  ),);
                } else {
                  final data = snapshot.data!.data;
                  return Flexible(
                    child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: data.isNotEmpty ? InkWell(
                            onTap: () {},
                            child: Card(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                        height: 35,
                                                        width: 35,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade800
                                                                    .withOpacity(
                                                                    0.1))),
                                                        child: Center(
                                                          child: Utils.text(
                                                            text: "${index +
                                                                1}",
                                                            color: kBlackColor,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Utils.text(
                                                          text: "Client Code : ${item
                                                              .clientCode}",
                                                          color: kBlackColor),
                                                      const SizedBox(height: 5),
                                                      Utils.text(
                                                          text: "Account No : ${item
                                                              .accountNo}",
                                                          color: kBlackColor),
                                                      const SizedBox(height: 5),
                                                      Utils.text(
                                                          text: "Segment : ${item
                                                              .segment}",
                                                          color: kBlackColor),
                                                      const SizedBox(height: 5),
                                                      Utils.text(
                                                          text: "Amount : ${item
                                                              .txnAmt}",
                                                          color: kBlackColor),
                                                      const SizedBox(height: 5),
                                                      Utils.text(
                                                          text: "Date : ${item
                                                              .txnDate}",
                                                          color: kBlackColor),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ) : Center(
                            child: Utils.text(
                                text: "No data Found!",
                                color: kBlackColor,
                                fontSize: 13
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Utils.text(
                      text: "Pay Out Request",
                      color: const Color(0xFF00A9FF),
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return const FundPayOutRequestScreen();
                      },));
                    },
                    child: Utils.text(
                        text: "View All",
                        color: const Color(0xFF00A9FF),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<PayOutModel>(
              future: futureFundPayOut,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Lottie.asset(
                          'assets/lottie/loading.json', height: 100,
                          width: 100));
                } else if (snapshot.hasError) {
                  return Center(child: Utils.text(
                    text: "Error: ${snapshot.error}",
                    color: kBlackColor,
                    fontSize: 13,
                  ),);
                } else
                if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
                  return Center(child: Utils.text(
                    text: "No data found",
                    color: kBlackColor,
                    fontSize: 13,
                  ),);
                } else {
                  final data = snapshot.data!.data;
                  return Flexible(
                    child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = data?[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                          child: data!.isNotEmpty ? InkWell(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF9FF),
                                borderRadius: BorderRadius.circular(10),),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Utils.text(
                                            text: "Account No",
                                            fontSize: 10,
                                            color: const Color(0xFF4A5568)),
                                        Utils.text(
                                            text: "Amount",
                                            fontSize: 10,
                                            color: const Color(0xFF4A5568)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 03,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Utils.text(
                                            text: item?.bankAccNo,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0F3F62)),
                                        Utils.text(
                                            text: item?.amount,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF0F3F62)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ) : Center(
                            child: Utils.text(
                                text: "No data Found!",
                                color: kBlackColor,
                                fontSize: 13
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BankDetail {
  final String bankName;
  final String bankAccountNumber;

  BankDetail(this.bankName, this.bankAccountNumber);
}
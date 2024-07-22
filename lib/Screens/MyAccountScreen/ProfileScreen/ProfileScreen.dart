import 'dart:io';
import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/BankDetailsModel/BankDetailsModel.dart';
import 'package:connect/Models/ProfileClientDetails/ProfileClientDetails.dart';
import 'package:connect/Screens/MyAccountScreen/ProfileScreen/AddBankAccountScreen.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  Future<AccountProfile>? futureAccountProfile;
  Future<BankDetailsResponse>? futureBankDetails;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isPersonalDetail = false;
  bool isBankDetails = false;
  bool isDPDetails = false;
  bool isNomineeDetails = false;
  bool isIncomeDetails = false;
  bool isChecked = false;
  File? file1;
  List<int>? file1Bytes;
  String? _signatureProofFileName;
  String? income;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    loadData();
  }

  void loadData() {
    futureAccountProfile = ApiServices().fetchAccountProfile(token: Appvariables.token);
    futureBankDetails = ApiServices().fetchBankDetails(token: Appvariables.token);
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      _signatureProofFileName = result.files.single.path;
      file1 = File(_signatureProofFileName ?? "");
      file1Bytes = await file1!.readAsBytes();
      setState(() {});
    } else {
      if (kDebugMode) {
        print('No file selected');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isPersonalDetail = !isPersonalDetail;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF007AFF).withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/ProfileIconAccount.svg"),
                            const SizedBox(width: 10),
                            Utils.text(
                                text: "Personal Details",
                                color: const Color(0xFF4A5568),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            const Spacer(),
                            Icon(
                              isPersonalDetail
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: const Color.fromRGBO(27, 82, 52, 1.0),
                              size: 35,
                            ),
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
              Visibility(
                visible: isPersonalDetail,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<AccountProfile>(
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
                            fontWeight: FontWeight.w600);
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.data;
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: "CLIENT ID",
                                        fontSize: 12,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Utils.text(
                                          text:
                                              data.personalDetails.assClientId,
                                          fontSize: 14,
                                          color: const Color(0xFF1E1E1E),
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black12.withOpacity(0.06),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: "BO ID",
                                        fontSize: 12,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Utils.text(
                                          text:
                                              data.personalDetails.clientDpCode,
                                          fontSize: 14,
                                          color: const Color(0xFF1E1E1E),
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: data
                                                .personalDetails.clientDpCode,
                                          ),
                                        );
                                        Utils.toast(
                                            msg: "BO ID Copied into ClipBoard");
                                      },
                                      icon: const Icon(
                                        Icons.copy,
                                        size: 20,
                                      ))
                                ],
                              ),
                              Divider(
                                color: Colors.black12.withOpacity(0.06),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: "NAME",
                                        fontSize: 12,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Utils.text(
                                          text:
                                              data.personalDetails.clientDpName,
                                          fontSize: 14,
                                          color: const Color(0xFF1E1E1E),
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black12.withOpacity(0.06),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: "EMAIL ID",
                                        fontSize: 12,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Utils.text(
                                          text:
                                              data.personalDetails.clientIdMail,
                                          fontSize: 14,
                                          color: const Color(0xFF1E1E1E),
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black12.withOpacity(0.06),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: "MOBILE NO",
                                        fontSize: 12,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Utils.text(
                                          text: data.personalDetails.mobileNo,
                                          fontSize: 14,
                                          color: const Color(0xFF1E1E1E),
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black12.withOpacity(0.06),
                              ),
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Utils.text(
                                        text: "GENDER",
                                        fontSize: 12,
                                        color: const Color(0xFF777777),
                                        fontWeight: FontWeight.w800,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Utils.text(
                                          text: data.personalDetails.sex,
                                          fontSize: 14,
                                          color: const Color(0xFF1E1E1E),
                                          fontWeight: FontWeight.w500)
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black12.withOpacity(0.06),
                              ),
                            ],
                          ),
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
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isBankDetails = !isBankDetails;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF007AFF).withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/BankDetailsIconAccount.svg"),
                            const SizedBox(width: 10),
                            Utils.text(
                                text: "Bank Details",
                                color: const Color(0xFF4A5568),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            const Spacer(),
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.to(const Addbankaccountscreen());
                            //   },
                            //   child: Container(
                            //     height: 30,
                            //     decoration: BoxDecoration(
                            //         color: const Color.fromRGBO(27, 82, 52, 1.0),
                            //         borderRadius: BorderRadius.circular(05)),
                            //     child: Padding(
                            //       padding:
                            //           const EdgeInsets.symmetric(horizontal: 8.0),
                            //       child: Center(
                            //         child: Utils.text(
                            //             text: "Add Bank Account",
                            //             color: Colors.white,
                            //             fontSize: 12),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 05,
                            // ),
                            Icon(
                              isBankDetails
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: const Color.fromRGBO(27, 82, 52, 1.0),
                              size: 35,
                            )
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
              Visibility(
                visible: isBankDetails,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<BankDetailsResponse>(
                    future: futureBankDetails,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Utils.text(
                                text: 'Error: ${snapshot.error}',
                                color: kBlackColor));
                      } else if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemCount: snapshot.data!.data.bankName.length,
                          itemBuilder: (context, index) {
                            final bankName = snapshot.data!.data.bankName['$index']!;
                            final bankAccountNumber = snapshot.data!.data.bankAccountNumber['$index']!;
                            final ifscCode = snapshot.data!.data.ifscCode['$index']!;
                            final bankAccountType = snapshot.data!.data.bankAccountType['$index']!;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Utils.text(
                                            text: "Bank Name",
                                            color: const Color(0xFF4A5568),
                                            fontSize: 10,
                                          ),
                                          Utils.text(
                                            text: "Account Number",
                                            color: const Color(0xFF4A5568),
                                            fontSize: 10,
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
                                              text: bankName,
                                              color: const Color(0xFF4A5568),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                          Utils.text(
                                              text: bankAccountNumber,
                                              color: const Color(0xFF4A5568),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
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
                                            text: "IFSC Code",
                                            color: const Color(0xFF4A5568),
                                            fontSize: 10,
                                          ),
                                          Utils.text(
                                            text: "Account Type",
                                            color: const Color(0xFF4A5568),
                                            fontSize: 10,
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
                                              text: ifscCode,
                                              color: const Color(0xFF4A5568),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                          Utils.text(
                                              text: bankAccountType,
                                              color: const Color(0xFF4A5568),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(
                            child: Utils.text(
                                text: 'No data available',
                                color: kBlackColor,
                                fontSize: 15));
                      }
                    },
                  ),
                ),
              ),
              Visibility(
                visible: isBankDetails,
                child: const SizedBox(
                  height: 05,
                ),
              ),
              Visibility(
                visible: isBankDetails,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Utils.text(
                      text: 'Do You Want To Add Bank Account? ',
                      color: const Color(0xFF4A5568),
                      fontSize: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(const Addbankaccountscreen());
                      },
                      child: Utils.text(
                        text: "Add Bank Account",
                          color: const Color(0xFF0066F6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isDPDetails = !isDPDetails;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF007AFF).withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/DpDetailsIconAccount.svg"),
                            const SizedBox(width: 10),
                            Utils.text(
                                text: "DP Details",
                                color: const Color(0xFF4A5568),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            const Spacer(),
                            Icon(
                              isDPDetails
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: const Color.fromRGBO(27, 82, 52, 1.0),
                              size: 35,
                            )
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
              Visibility(
                visible: isDPDetails,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<AccountProfile>(
                    future: futureAccountProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Utils.text(
                                text: 'Error: ${snapshot.error}',
                                color: kBlackColor));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.text(
                                      text: "Client Name",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Utils.text(
                                      text: data.dpDetails.clientDpName,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black12.withOpacity(0.06),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.text(
                                      text: "BO ID",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Utils.text(
                                      text: data.dpDetails.clientDpCode,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black12.withOpacity(0.06),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.text(
                                      text: "Depository",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Utils.text(
                                      text: data.dpDetails.depository,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            child: Utils.text(
                                text: 'No data available',
                                color: kBlackColor,
                                fontSize: 15));
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isNomineeDetails = !isNomineeDetails;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF007AFF).withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/NomineeDetailsIconAccount.svg"),
                            const SizedBox(width: 10),
                            Utils.text(
                                text: "Nominee Details",
                                color: const Color(0xFF4A5568),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            const Spacer(),
                            Icon(
                              isNomineeDetails
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: const Color.fromRGBO(27, 82, 52, 1.0),
                              size: 35,
                            )
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
              Visibility(
                visible: isNomineeDetails,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<AccountProfile>(
                    future: futureAccountProfile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Utils.text(
                                text: 'Error: ${snapshot.error}',
                                color: kBlackColor));
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.text(
                                      text: "Client Name",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Utils.text(
                                      text: data.nomineeDetails.nomineeName,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black12.withOpacity(0.06),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.text(
                                      text: "Nominee Status",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Utils.text(
                                      text: data.nomineeDetails.nomineeoptout,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.black12.withOpacity(0.06),
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Utils.text(
                                      text: "I / We wish to make a Nomination?",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Utils.text(
                                      text: "Modification In Process!!!!",
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            child: Utils.text(
                                text: 'No data available',
                                color: kBlackColor,
                                fontSize: 15));
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isIncomeDetails = !isIncomeDetails;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF007AFF).withOpacity(0.15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/IncomeModificationIconAccount.svg"),
                            const SizedBox(width: 10),
                            Utils.text(
                                text: "Income Modification",
                                color: const Color(0xFF4A5568),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            const Spacer(),
                            Icon(
                              isIncomeDetails
                                  ? Icons.arrow_drop_down_rounded
                                  : Icons.arrow_drop_up_rounded,
                              color: const Color.fromRGBO(27, 82, 52, 1.0),
                              size: 35,
                            )
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
              Visibility(
                visible: isIncomeDetails,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9).withOpacity(0.20),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Visibility(
                        visible: isIncomeDetails,
                        child: const SizedBox(
                          height: 05,
                        ),
                      ),
                      Visibility(
                        visible: isIncomeDetails,
                        child: RichText(
                          text: TextSpan(
                            text: 'Your Income : ',
                            style: GoogleFonts.poppins(color: kBlackColor),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'ONE CRORE TO FIVE CRORES',
                                  style: GoogleFonts.poppins(
                                      color: kBlackColor,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                          visible: isIncomeDetails,
                          child: const SizedBox(height: 10)),
                      Visibility(
                        visible: isIncomeDetails,
                        child: CheckboxListTile(
                          value: isChecked,
                          contentPadding: const EdgeInsets.all(0),
                          activeColor: const Color.fromRGBO(27, 82, 52, 1.0),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          title: Utils.text(
                              text: "Select If You Want To Modify",
                              color: kBlackColor,
                              fontSize: 13,
                              textAlign: TextAlign.justify),
                        ),
                      ),
                      Visibility(
                          visible: isIncomeDetails,
                          child: const SizedBox(height: 10)),
                      Visibility(
                        visible: isChecked && isIncomeDetails,
                        child: InkWell(
                          onTap: () {
                            ApiServices().modifyIncomeDetails(
                                token: Appvariables.token,
                                isSendOrVerifyOtp: "send_otp");
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                      key: _formKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.close),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _otpController,
                                            decoration: const InputDecoration(
                                              fillColor: Color.fromRGBO(
                                                  27, 82, 52, 0.2),
                                              labelText: 'Enter OTP',
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter OTP';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              fillColor: const Color.fromRGBO(
                                                  27, 82, 52, 0.1),
                                              labelText: 'Select Income Range'
                                                  '',
                                              labelStyle: GoogleFonts.poppins(),
                                              border:
                                                  const OutlineInputBorder(),
                                            ),
                                            items: <String>[
                                              'UpTo 1 Lac',
                                              '1-5 Lac',
                                              '5-10 Lac',
                                              '10-20 Lac',
                                              '> 25 Lac'
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Utils.text(
                                                  text: value,
                                                  color: kBlackColor,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              income = newValue ?? "";
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select account type';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(height: 20),
                                          UploadField(
                                            label: 'Bank Proof',
                                            fileName: _signatureProofFileName,
                                            onPressed: () => _pickFile(),
                                          ),
                                          const SizedBox(height: 20),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      27, 82, 52, 1.0),
                                            ),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                ApiServices()
                                                    .modifyIncomeDetails(
                                                        token:
                                                            Appvariables.token,
                                                        file: file1,
                                                        fileBytes: file1Bytes,
                                                        income: income,
                                                        otp:
                                                            _otpController.text,
                                                        isSendOrVerifyOtp:
                                                            "verify_otp");
                                                Get.back();
                                              }
                                            },
                                            child: Utils.text(
                                                text: 'VERIFY OTP',
                                                color: kBlackColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(05),
                              color: const Color.fromRGBO(27, 82, 52, 1.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Center(
                                child: Utils.text(
                                  text: "Send Otp",
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

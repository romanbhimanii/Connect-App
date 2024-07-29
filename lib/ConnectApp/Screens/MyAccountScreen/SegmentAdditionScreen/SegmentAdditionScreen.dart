// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/ProfileClientDetails/ProfileClientDetails.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SegmentAdditionScreen extends StatefulWidget {
  const SegmentAdditionScreen({super.key});

  @override
  State<SegmentAdditionScreen> createState() => _SegmentAdditionScreenState();
}

class _SegmentAdditionScreenState extends State<SegmentAdditionScreen> {
  Future<AccountProfile>? futureAccountProfile;
  bool cashValue = false;
  bool cashValue1 = false;
  bool mutualFundValue = false;
  bool mutualFundValue1 = false;
  bool fAndoValue = false;
  bool fAndoValue1 = false;
  bool currencyDerivativesValue = false;
  bool currencyDerivativesValue1 = false;
  bool SLBMValue = false;
  bool SLBMValue1 = false;
  final _formKey = GlobalKey<FormState>();
  String? _selectedProof;
  String? _selectedProofName;
  File? file1;
  List<int>? file1Bytes;
  PlatformFile? _pickedFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      _selectedProofName = result.files.single.path;
      _pickedFile = result.files.first;
      file1 = File(_selectedProofName ?? "");
      file1Bytes = await file1!.readAsBytes();
      setState(() {});
    } else {
      if (kDebugMode) {
        print('No file selected');
      }
    }
  }

  void _verifySegment() async {
    if (_formKey.currentState!.validate()) {
      Utils.showLoadingDialogue(context);
      var response = await ApiServices().segmentSendOtp(
        clientCode: Appvariables.clientCode,
        authToken: Appvariables.token,
        isSendOrVerifyOtp: "verify_otp",
        context: context,
        segment: cashValue1
            ? "Cash"
            : mutualFundValue1
                ? "Mutual Fund"
                : fAndoValue1
                    ? "Future & Options"
                    : currencyDerivativesValue1
                        ? "Currency Derivatives"
                        : SLBMValue1
                            ? "SLBM"
                            : "",
        fileType: 'jpg',
        file: file1,
        fileBytes: file1Bytes,
      );
      if (response != null) {
        var url = await ApiServices().submitForm(response);
        navigateToWebView(context, url);
      }
    }
  }

  void navigateToWebView(BuildContext context, String url) {
    if (url != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewScreen(url: url),
        ),
      );
    } else {
      Utils.toast(msg: "URL not found in the XML content.");
    }
  }

  void loadData() {
    futureAccountProfile = ApiServices().fetchAccountProfile(token: Appvariables.token);
    if(!futureAccountProfile.isNull){
      setState(() {
        _loading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return fetchProfileClientDetails();
  }

  Widget fetchProfileClientDetails() {
    return FutureBuilder<AccountProfile>(
      future: futureAccountProfile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Lottie.asset('assets/lottie/loading.json',
                  height: 100, width: 100));
        } else if (snapshot.hasError) {
          return Center(
            child: Utils.noDataFound(),
          );
        }
        else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          List<String> segments = data.dpDetails.activateSegment.split(', ');
          if (segments.contains("Mutual fund")) {
            mutualFundValue = true;
          }
          if (segments.contains("Cash")) {
            cashValue = true;
          }
          if (segments.contains("Future & Options")) {
            fAndoValue = true;
          }
          if (segments.contains("Currency Derivatives")) {
            currencyDerivativesValue = true;
          }
          if (segments.contains("SLBM")) {
            SLBMValue = true;
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.text(
                          text: "Cash", color: Colors.black, fontSize: 15),
                      const SizedBox(
                        width: 05,
                      ),
                      Switch(
                        activeColor: const Color(0xFF00A9FF),
                        value: cashValue,
                        onChanged: (value) {
                          setState(() {
                            cashValue = value;
                            cashValue1 = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.text(
                        text: "Mutual Fund",
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      const SizedBox(
                        width: 05,
                      ),
                      Switch(
                        activeColor: const Color(0xFF00A9FF),
                        value: mutualFundValue,
                        onChanged: (value) {
                          setState(() {
                            mutualFundValue = value;
                            mutualFundValue1 = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.text(
                          text: "Future & Options",
                          color: Colors.black,
                          fontSize: 15),
                      const SizedBox(
                        width: 05,
                      ),
                      Switch(
                        activeColor: const Color(0xFF00A9FF),
                        value: fAndoValue,
                        onChanged: (value) {
                          setState(() {
                            fAndoValue = value;
                            fAndoValue1 = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.text(
                          text: "Currency Derivatives",
                          color: Colors.black,
                          fontSize: 15),
                      const SizedBox(
                        width: 05,
                      ),
                      Switch(
                        activeColor: const Color(0xFF00A9FF),
                        value: currencyDerivativesValue,
                        onChanged: (value) {
                          setState(() {
                            currencyDerivativesValue = value;
                            currencyDerivativesValue1 = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Utils.text(
                          text: "SLBM", color: Colors.black, fontSize: 15),
                      const SizedBox(
                        width: 05,
                      ),
                      Switch(
                        activeColor: const Color(0xFF00A9FF),
                        value: SLBMValue,
                        onChanged: (value) {
                          setState(() {
                            SLBMValue = value;
                            SLBMValue1 = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Utils.text(
                          text: "List of Financial Proof",
                          fontSize: 17,
                          fontWeight: FontWeight.bold)
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Utils.text(
                        text: "1.Net Worth Certificate",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.text(
                        text: "2.ITR Acknowledgement",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.text(
                        text: "3.Latest Demat Holding Statement",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.text(
                        text: "4.Annual Accounts",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.text(
                        text: "5.Latest Salary Slip OR Latest Form 16",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Utils.text(
                        text: "6.Bank A/c Statement for last 6 months",
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Utils.text(
                          text:
                              "7.Any other relevant document/s substantiating ownership of assets",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () async {
                      if (cashValue1 ||
                          mutualFundValue1 ||
                          fAndoValue1 ||
                          currencyDerivativesValue1 ||
                          SLBMValue1) {
                        if (fAndoValue1 || currencyDerivativesValue1) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('New Segment Add'),
                                  content: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DropdownButtonFormField<String>(
                                          value: _selectedProof,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedProof = value!;
                                            });
                                          },
                                          items: [
                                            'Net Worth Certificate',
                                            'ITR Acknowledgement',
                                            'Latest Demat Holding Statement',
                                            'Annual Accounts',
                                            'Latest Salary Slip Or Latest Form 16',
                                            'Bank A/C Statement for Last 6 Months',
                                            'Any other Relevant Documents\nSubstantiating Ownership of Assets'
                                          ].map((column) {
                                            return DropdownMenuItem(
                                              value: column,
                                              child: Utils.text(
                                                text: column,
                                                color: Colors.black,
                                                fontSize: 10,
                                              ),
                                            );
                                          }).toList(),
                                          validator: (value) => value == null
                                              ? 'Please select a proof'
                                              : null,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(4),
                                            fillColor: const Color.fromRGBO(
                                                27, 82, 52, 0.1),
                                            labelText: 'Select One Proof',
                                            labelStyle: GoogleFonts.inter(
                                                color: Colors.black),
                                            border: const OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blueGrey.shade600
                                                    .withOpacity(0.15),
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Utils.text(
                                                  text: "Income Proof",
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        InkWell(
                                          onTap: () {
                                            _pickFile();
                                          },
                                          child: Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: kPrimaryColor
                                                    .withOpacity(0.15)),
                                            child: Center(
                                              child: Utils.text(
                                                text: _pickedFile == null
                                                    ? 'Upload File'
                                                    : _pickedFile!.name.length >
                                                            15
                                                        ? "${_pickedFile!.name.substring(0, 15)}..."
                                                        : _pickedFile!.name,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    InkWell(
                                      onTap: () {
                                        _verifySegment();
                                      },
                                      child: Utils.gradientButton(
                                        message: "Verify Segment"
                                      ),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          Utils.showLoadingDialogue(context);
                          var response = await ApiServices().segmentSendOtp(
                              clientCode: Appvariables.clientCode,
                              authToken: Appvariables.token,
                              isSendOrVerifyOtp: "verify_otp",
                              segment: cashValue1
                                  ? "Cash"
                                  : mutualFundValue1
                                      ? "Mutual Fund"
                                      : fAndoValue1
                                          ? "Future & Options"
                                          : currencyDerivativesValue1
                                              ? "Currency Derivatives"
                                              : SLBMValue1
                                                  ? "SLBM"
                                                  : "",
                              fileType: 'jpg',
                              file: file1,
                              fileBytes: file1Bytes,
                              context: context);
                          if (response != null) {
                            var url = await ApiServices().submitForm(response);
                            navigateToWebView(context, url);
                          }
                        }
                      }
                    },
                    child: cashValue1 ||
                            mutualFundValue1 ||
                            fAndoValue1 ||
                            currencyDerivativesValue1 ||
                            SLBMValue1
                        ? Utils.gradientButton(message: "Add Segment")
                        : Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Center(
                                child: Utils.text(
                                  text: "Add Segment",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
        else {
          return Utils.noDataFound();
        }
      },
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse("https://esign.egov-nsdl.com${widget.url}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        title: Utils.text(
            text: "Verify your Otp",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

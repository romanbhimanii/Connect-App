// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'dart:io';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Addbankaccountscreen extends StatefulWidget {
  const Addbankaccountscreen({super.key});

  @override
  State<Addbankaccountscreen> createState() => _AddbankaccountscreenState();
}

class _AddbankaccountscreenState extends State<Addbankaccountscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  final _formKey = GlobalKey<FormState>();
  bool isDefaultAccount = false;
  bool isChecked = false;
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  DropDownValueModel? accountType;
  final SingleValueDropDownController _cnt = SingleValueDropDownController();

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                  border: Border.all(color: const Color(0xFF292D32),),
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: "Add Bank Account",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: accountController,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: 'Account Number',
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF777777)
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF3F3F3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF3F3F3),
                      width: 1.0,
                    ),
                  ),
                ),
                cursorColor: const Color(0xFF777777),
                keyboardType: TextInputType.number,
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ifscController,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: 'IFSC Code',
                  labelStyle: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF777777)
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF3F3F3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF3F3F3),
                      width: 1.0,
                    ),
                  ),
                ),
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IFSC code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     fillColor: Colors.transparent,
              //     labelText: 'Select Account Type',
              //     labelStyle: GoogleFonts.inter(
              //         fontSize: 13,
              //         color: const Color(0xFF777777),
              //     ),
              //     border: const UnderlineInputBorder(),
              //     contentPadding: const EdgeInsets.all(0),
              //     enabledBorder: const UnderlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Color(0xFFF3F3F3),
              //         width: 1.0,
              //       ),
              //     ),
              //     focusedBorder: const UnderlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Color(0xFFF3F3F3),
              //         width: 1.0,
              //       ),
              //     ),
              //   ),
              //   items:
              //       <String>['Saving', 'Current', 'Other'].map((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Row(
              //         children: [
              //           Checkbox(
              //             value: accountType == value,
              //             onChanged: (bool? newValue) {
              //               if (newValue != null && newValue) {
              //                 setState(() {
              //                   accountType = value;
              //                 });
              //               }
              //             },
              //           ),
              //           Utils.text(
              //             text: value,
              //             color: kBlackColor,
              //           ),
              //         ],
              //       ),
              //     );
              //   }).toList(),
              //   onChanged: (newValue) {
              //     accountType = newValue ?? "";
              //   },
              //   validator: (value) {
              //     if (value == null) {
              //       return 'Please select account type';
              //     }
              //     return null;
              //   },
              // ),
              DropDownTextField(
                controller: _cnt,
                clearOption: true,
                enableSearch: false,
                dropdownRadius: 10,
                padding: const EdgeInsets.all(0),
                textFieldDecoration: InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: 'Select Account Type',
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF777777),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                  border: const UnderlineInputBorder(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF3F3F3),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF3F3F3),
                      width: 1.0,
                    ),
                  ),
                ),
                clearIconProperty: IconProperty(color: Colors.black),
                validator: (value) {
                  if (value == null) {
                    return "Required field";
                  } else {
                    return null;
                  }
                },
                dropDownItemCount: 3,
                dropDownList: const [
                  DropDownValueModel(name: 'Saving', value: "Saving"),
                  DropDownValueModel(name: 'Current', value: "Current"),
                  DropDownValueModel(name: 'Other', value: "Other"),
                ],
                onChanged: (val) {
                  accountType = val;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    activeColor: const Color(0xFF00A9FF),
                    inactiveThumbColor: Colors.white,
                    value: isDefaultAccount,
                    onChanged: (value) {
                      setState(() {
                        isDefaultAccount = value;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  Utils.text(
                    text: "Default Account",
                    color: const Color(0xFF333333),
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Radio(
                  //         activeColor: const Color.fromRGBO(27, 82, 52, 1.0),
                  //         value: true,
                  //         groupValue: isDefaultAccount,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             isDefaultAccount = value as bool;
                  //           });
                  //         },
                  //       ),
                  //       Utils.text(
                  //         text: "Yes",
                  //         color: kBlackColor,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Expanded(
                  //   child: Row(
                  //     children: [
                  //       Radio(
                  //         activeColor: const Color.fromRGBO(27, 82, 52, 1.0),
                  //         value: false,
                  //         groupValue: isDefaultAccount,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             isDefaultAccount = value as bool;
                  //           });
                  //         },
                  //       ),
                  //       Utils.text(
                  //         text: "No",
                  //         color: kBlackColor,
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: isChecked,
                activeColor: const Color(0xFF00A9FF),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
                title: Utils.text(
                    text: "I hereby take the sole responsibility for the correctness of my Bank Account number and other details mentioned above. I undertake that I will not hold the Company responsible in any manner for any transactions effected by the Company due to incorrect bank account number or other details stated by me.",
                    color: kBlackColor,
                    fontSize: 9,
                    textAlign: TextAlign.justify),
              ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     if (_formKey.currentState!.validate() && isChecked) {
              //       showDialog(
              //         context: context,
              //         builder: (BuildContext context) => OTPDialog(
              //           accountNumber: accountController.text,
              //           accountType: accountType,
              //           ifscCode: ifscController.text,
              //           isDefault: isChecked == false ? "No" : "Yes",
              //         ),
              //       );
              //       ApiServices().addNewBankAccount(
              //           token: Appvariables.token,
              //           accountNumber: accountController.text,
              //           ifscCode: ifscController.text,
              //           isDefault: isChecked == false ? "No" : "Yes",
              //           accountType: accountType,
              //           isSendOtpOrVerifyOtp: "send_otp",
              //           file2Bytes: [],
              //           file2: File(""),
              //           file1Bytes: [],
              //           file1: File(""),
              //           otp: "");
              //     } else if (!isChecked) {
              //       Utils.toast(msg: "You have to must accept the terms and conditions");
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color.fromRGBO(27, 82, 52, 1.0),
              //       foregroundColor: Colors.white),
              //   child: Utils.text(
              //       text: "SUBMIT",
              //       color: Colors.white,
              //       fontSize: 16,
              //       fontWeight: FontWeight.bold),
              // ),
              const Spacer(),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate() && isChecked) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => OTPDialog(
                        accountNumber: accountController.text,
                        accountType: accountType?.value,
                        ifscCode: ifscController.text,
                        isDefault: isChecked == false ? "No" : "Yes",
                      ),
                    );
                    ApiServices().addNewBankAccount(
                        token: Appvariables.token,
                        accountNumber: accountController.text,
                        ifscCode: ifscController.text,
                        isDefault: isChecked == false ? "No" : "Yes",
                        accountType: accountType?.value,
                        isSendOtpOrVerifyOtp: "send_otp",
                        file2Bytes: [],
                        file2: File(""),
                        file1Bytes: [],
                        file1: File(""),
                        otp: "");
                  } else if (!isChecked) {
                    Utils.toast(msg: "You have to must accept the terms and conditions");
                  }
                },
                child: Utils.gradientButton(
                  message: "SUBMIT"
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OTPDialog extends StatefulWidget {
  String? accountNumber;
  String? ifscCode;
  String? isDefault;
  String? accountType;

  OTPDialog(
      {super.key,
      this.accountNumber,
      this.ifscCode,
      this.isDefault,
      this.accountType});

  @override
  _OTPDialogState createState() => _OTPDialogState();
}

class _OTPDialogState extends State<OTPDialog> {
  final _otpController = TextEditingController();
  String? _signatureProofFileName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? file1;
  String? _bankProofFileName;
  List<int>? file1Bytes;
  File? file2;
  List<int>? file2Bytes;

  Future<void> _pickFile(String fileType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      if (fileType == 'bank') {
        _bankProofFileName = result.files.single.path;
        file1 = File(_bankProofFileName ?? "");
        file1Bytes = await file1!.readAsBytes();
      } else if (fileType == 'signature') {
        _signatureProofFileName = result.files.single.path;
        file2 = File(_signatureProofFileName ?? "");
        file2Bytes = await file2!.readAsBytes();
      }
      setState(() {});
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  fillColor: Colors.white,
                  labelText: 'Enter OTP',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              UploadField(
                label: 'Bank Proof',
                fileName: _bankProofFileName,
                onPressed: () => _pickFile('bank'),
              ),
              const SizedBox(height: 10),
              UploadField(
                label: 'Signature Proof',
                fileName: _signatureProofFileName,
                onPressed: () => _pickFile('signature'),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    ApiServices().addNewBankAccount(
                        token: Appvariables.token,
                        accountNumber: widget.accountNumber,
                        ifscCode: widget.ifscCode,
                        isDefault: widget.isDefault,
                        accountType: widget.accountType,
                        isSendOtpOrVerifyOtp: "verify_otp",
                        otp: _otpController.text,
                        file1: file1,
                        file1Bytes: file1Bytes,
                        file2: file2,
                        file2Bytes: file2Bytes);
                    Get.back();
                  }
                },
                child: Utils.gradientButton(
                  message: "Verify Otp"
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UploadField extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback onPressed;

  const UploadField({
    super.key,
    required this.label,
    required this.fileName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Utils.text(
          text: label,
          color: Colors.grey.shade800.withOpacity(0.4),
          fontSize: 13
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Colors.grey.shade800.withOpacity(0.2),
                  Colors.grey.shade800.withOpacity(0.5)
                ])
            ),
            child: Center(
              child: Utils.text(
                  text: fileName ?? 'Upload File',
                  color: Colors.black,
                fontSize: 15,
                textOverFlow: TextOverflow.ellipsis
              ),
            ),
          ),
        ),
      ],
    );
  }
}

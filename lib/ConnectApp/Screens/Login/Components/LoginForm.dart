// ignore_for_file: must_be_immutable

import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Screens/Login/ForgotPasswordScreen/ForgotPasswordScreen.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  String appName = "";

  LoginForm({super.key, required this.appName});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final ConnectivityService connectivityService = ConnectivityService();
  final TextEditingController emailController = TextEditingController();
  bool isShowPassword = false;
  final TextEditingController passwordController = TextEditingController();
  int _radioVal = 0;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Utils.text(
                  text:
                      widget.appName == "connect" ? "Username" : "Branch Code",
                  color: const Color(0xFF001533),
                  fontSize: 14)
            ],
          ),
          const SizedBox(
            height: 05,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Colors.black,
            onSaved: (email) {},
            style: GoogleFonts.inter(
              color: kBlackColor,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.appName == "connect"
                  ? "Enter Your Username"
                  : "Enter Your Branch Code",
              hintStyle: GoogleFonts.inter(fontSize: 12),
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
              fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
            ),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return widget.appName == "connect"
                    ? "Please Enter Your Username"
                    : "Please Enter Your Branch Code";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Utils.text(
                  text: "Password",
                  color: const Color(0xFF001533),
                  fontSize: 14)
            ],
          ),
          const SizedBox(
            height: 05,
          ),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            obscureText: isShowPassword ? false : true,
            cursorColor: Colors.black,
            style: GoogleFonts.inter(
              color: kBlackColor,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Enter Your password",
              hintStyle: GoogleFonts.inter(fontSize: 12),
              fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    child: Icon(
                      isShowPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    )),
              ),
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
            ),
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Visibility(
            visible: widget.appName == "backoffice",
            child: Row(
              children: [
                Radio(
                  value: 0,
                  groupValue: _radioVal,
                  activeColor: const Color(0xFF0F3F62),
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _radioVal = value;
                      });
                    }
                  },
                ),
                Utils.text(text: "Self", color: Colors.black, fontSize: 15),
                Radio(
                  value: 1,
                  groupValue: _radioVal,
                  activeColor: const Color(0xFF0F3F62),
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _radioVal = value;
                      });
                    }
                  },
                ),
                Utils.text(text: "Team", color: Colors.black, fontSize: 15),
              ],
            ),
          ),
          Visibility(
            visible: widget.appName == "backoffice",
            child: const SizedBox(height: 20),
          ),
          Row(
            children: [
              Utils.text(
                  text: "Do not remember your password?",
                  color: const Color(0xFF001533),
                  fontSize: 13)
            ],
          ),
          const SizedBox(
            height: 05,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Get.to(Forgotpasswordscreen(appName: widget.appName,));
                },
                child: Utils.text(
                    text: "Click here to recover it!",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kTextColor),
              )
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Utils.showLoadingDialogue(context);
                if (widget.appName == "connect") {
                  ApiServices().login(
                      username: emailController.text,
                      password: passwordController.text,
                      context: context);
                } else {
                  BackOfficeApiService().backOfficeLogin(
                      context: context,
                    password: passwordController.text,
                    branchCode: emailController.text,
                    userType: _radioVal == 0 ? "self" : "team"
                  );
                }
              }
            },
            child: Utils.gradientButton(message: "LOGIN"),
          ),
        ],
      ),
    );
  }
}

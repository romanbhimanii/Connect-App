// ignore_for_file: use_super_parameters, must_be_immutable

import 'package:connect/ConnectApp/Screens/Login/Components/LoginForm.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  String appName = "";
  LoginScreen({Key? key,required this.appName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Utils.text(
                  text: "Sign into your\nAccount",
                  color: kTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 27
                ),
                const SizedBox(height: 8),
                Utils.text(
                  text: appName == "connect" ? 'Log into your Connect Arham account' : 'Log into your Back Office Arham account',
                  fontSize: 16,
                  color: Colors.black54,
                ),
                const SizedBox(height: 40),
                LoginForm(appName: appName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
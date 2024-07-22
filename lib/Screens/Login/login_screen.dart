// ignore_for_file: use_super_parameters

import 'package:connect/Screens/Login/Components/LoginForm.dart';
import 'package:connect/Screens/Login/Components/LoginScreenTopImage.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  text: 'Log into your Connect Arham account',
                  fontSize: 16,
                  color: Colors.black54,
                ),
                const SizedBox(height: 40),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
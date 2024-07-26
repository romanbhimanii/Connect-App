// ignore_for_file: use_super_parameters

import 'package:connect/ConnectApp/Screens/Welcome/Components/WelcomeImageScreen.dart';
import 'package:connect/ConnectApp/Screens/Welcome/Components/loginSignUpButton.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final ConnectivityService connectivityService = ConnectivityService();

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
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               WelcomeImage()
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: LoginAndSignupBtn(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
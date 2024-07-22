// ignore_for_file: use_build_context_synchronously

import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> hasConnectionMethod() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged => _connectivity.onConnectivityChanged;

  Future<void> checkConnectivityAndProceed(BuildContext context, Function proceed) async {
    bool hasConnection = await hasConnectionMethod();
    if (hasConnection) {
      proceed();
    } else {
      showNoInternetDialog(context);
    }
  }

  void showNoInternetDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Utils.text(
              text: "Oops!",
              color: kBlackColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/icons/noInternet.svg",
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Utils.text(
                  text: "Please check your internet\nconnection and try again.",
                  color: kBlackColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () async {
               Get.back();
              bool hasConnection = await hasConnectionMethod();
              if (hasConnection) {
                 Get.back();
              } else {
                showNoInternetDialog(context);
              }
            },
            child: Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(27, 82, 52, 1.0),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Center(
                child: Utils.text(
                  text: "Retry",
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
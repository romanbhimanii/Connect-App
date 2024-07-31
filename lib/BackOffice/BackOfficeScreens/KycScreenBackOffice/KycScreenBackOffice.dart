import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KycScreenBackOffice extends StatefulWidget {
  const KycScreenBackOffice({super.key});

  @override
  State<KycScreenBackOffice> createState() => _KycScreenBackOfficeState();
}

class _KycScreenBackOfficeState extends State<KycScreenBackOffice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Utils.text(
            text: "Kyc",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: GestureDetector(
                onTap: () {
                  Get.to(const SettingsScreen());
                },
                child: SvgPicture.asset(
                  "assets/icons/DeSelectSettingIcon.svg",
                  height: 27,
                  width: 27,
                )),
          )
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kBlackColor),
      ),
      body: Center(
        child: Utils.text(
            text: "Back Office Kyc",
            fontSize: 20,
            color: Colors.black
        ),
      ),
    );
  }
}

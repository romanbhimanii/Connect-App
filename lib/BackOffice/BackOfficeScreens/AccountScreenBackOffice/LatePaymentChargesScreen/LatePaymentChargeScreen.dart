import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';

class LatePaymentChargeScreen extends StatefulWidget {
  const LatePaymentChargeScreen({super.key});

  @override
  State<LatePaymentChargeScreen> createState() => _LatePaymentChargeScreenState();
}

class _LatePaymentChargeScreenState extends State<LatePaymentChargeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
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
            text: "Late Payment Charges",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: kBlackColor),
            color: Colors.white,
            onSelected: (String result) async {
              if (result == "Export") {
                showMenu(
                  context: context,
                  color: Colors.white,
                  position: const RelativeRect.fromLTRB(100, 0, 0, 0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'CSV',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.table_chart,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Utils.text(
                            text: "CSV",
                            color: Colors.black,
                            fontSize: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ).then((value) async {
                  if (value == 'CSV') {
                    // if (await futureRiskReport != null) {
                    //   futureRiskReport?.then((response) {
                    //     if (response != null || response!.data.isNotEmpty) {
                    //       exportCommonReportToCsv(response.data);
                    //     }
                    //   });
                    // }else{
                    //   Utils.toast(msg: "Please Search Any Client Details!");
                    // }
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Export',
                child: Row(
                  children: [
                    const Icon(
                      Icons.download,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Utils.text(
                      text: "Export",
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}

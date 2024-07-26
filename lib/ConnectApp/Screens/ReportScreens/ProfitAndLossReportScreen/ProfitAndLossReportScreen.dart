
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Profitandlossreportscreen extends StatefulWidget {
  const Profitandlossreportscreen({super.key});

  @override
  State<Profitandlossreportscreen> createState() =>
      _ProfitandlossreportscreenState();
}

class _ProfitandlossreportscreenState extends State<Profitandlossreportscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  List<String> title = [
    "Ledger",
    "Equity",
    "Future Option",
    "Currency Derivatives",
    "PNL Summary",
    "Holdings"
  ];

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
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                  border: Border.all(color: const Color(0xFF292D32))
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.grey[200],
        scrolledUnderElevation: 0.0,
        title: Utils.text(
            text: "Profit And Loss",           color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Image(
                    image: AssetImage("assets/images/zip.png"),
                    height: 35,
                    width: 35,
                  ),
                  TextButton(
                      onPressed: () {
                        Utils.showLoadingDialogue(context);
                        ApiServices().downloadReportDocuments(
                            token: Appvariables.token,
                            type: "all",
                            downloadType: "all",
                            year: "2024",
                            context: context
                        );
                      },
                      child: Utils.text(
                          text: "Download All as Zip",
                          color: const Color.fromRGBO(27, 82, 52, 1.0),
                          fontSize: 15,
                          fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Utils.text(
                              text: title[index],
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              textAlign: TextAlign.center),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: index == 1 || index == 2 || index == 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (index == 1) {
                                        Utils.showLoadingDialogue(context);
                                        ApiServices().downloadReportDocuments(
                                            token: Appvariables.token,
                                            type: "equity",
                                            downloadType: "PDF",
                                            year: "2024",
                                            context: context
                                        );
                                      }else if(index == 2){
                                        Utils.showLoadingDialogue(context);
                                        ApiServices().downloadReportDocuments(
                                            token: Appvariables.token,
                                            type: "future_option",
                                            downloadType: "PDF",
                                            year: "2024",
                                            context: context
                                        );
                                      }else if(index == 3){
                                        Utils.showLoadingDialogue(context);
                                        ApiServices().downloadReportDocuments(
                                            token: Appvariables.token,
                                            type: "currency_derivatives",
                                            downloadType: "PDF",
                                            year: "2024",
                                            context: context
                                        );
                                      }
                                    },
                                    child: const Image(
                                      image:
                                          AssetImage("assets/images/pdf.png"),
                                      height: 40,
                                      width: 40,
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      if (index == 1) {
                                        Utils.showLoadingDialogue(context);
                                        ApiServices().downloadReportDocuments(
                                            token: Appvariables.token,
                                            type: "equity",
                                            downloadType: "Excel",
                                            year: "2024",
                                            context: context
                                        );
                                      }else if(index == 2){
                                        Utils.showLoadingDialogue(context);
                                        ApiServices().downloadReportDocuments(
                                            token: Appvariables.token,
                                            type: "future_option",
                                            downloadType: "Excel",
                                            year: "2024",
                                            context: context
                                        );
                                      }else if(index == 3){
                                        Utils.showLoadingDialogue(context);
                                        ApiServices().downloadReportDocuments(
                                            token: Appvariables.token,
                                            type: "currency_derivatives",
                                            downloadType: "Excel",
                                            year: "2024",
                                            context: context
                                        );
                                      }
                                    },
                                    child: const Image(
                                      image:
                                          AssetImage("assets/images/excel.png"),
                                      height: 40,
                                      width: 40,
                                    )),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: index == 0 || index == 4 || index == 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (index == 0) {
                                      Utils.showLoadingDialogue(context);
                                      ApiServices().downloadReportDocuments(
                                          token: Appvariables.token,
                                        type: "ledger",
                                        downloadType: "PDF",
                                        year: "2024",context: context
                                      );
                                    }else if(index == 4){
                                      Utils.showLoadingDialogue(context);
                                      ApiServices().downloadReportDocuments(
                                          token: Appvariables.token,
                                          type: "pnl_summary",
                                          downloadType: "PDF",
                                          year: "2024",context: context
                                      );
                                    }else if(index == 5){
                                      Utils.showLoadingDialogue(context);
                                      ApiServices().downloadReportDocuments(
                                          token: Appvariables.token,
                                          type: "holding",
                                          downloadType: "PDF",
                                          year: "2024",context: context
                                      );
                                    }
                                  },
                                  child: const Image(
                                    image: AssetImage("assets/images/pdf.png"),
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

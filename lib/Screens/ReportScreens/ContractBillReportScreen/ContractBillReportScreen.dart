import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/ContractBillReportModel/ContractBillReportModel.dart';
import 'package:connect/Utils/AppDrawer.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Contractbillreportscreen extends StatefulWidget {
  const Contractbillreportscreen({super.key});

  @override
  State<Contractbillreportscreen> createState() => _ContractbillreportscreenState();
}

class _ContractbillreportscreenState extends State<Contractbillreportscreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  Future<ContractBillReportModel?>? contractBill;
  List<bool>? isShow;

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchContractBillReport();
  }

  Future<void> fetchContractBillReport() async {
    setState(() {
      contractBill = ApiServices().fetchContractBills(
        fromDate: "2024-04-01",
        toDate: "2024-06-27",
        authToken: Appvariables.token,
        clientCode: Appvariables.clientCode,
      );
    });
    contractBill?.then((data) {
      setState(() {
        isShow = List<bool>.filled((data?.data?.length ?? 0), false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  border: Border.all(color: const Color(0xFF292D32))
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        title: Utils.text(
          text: "Bill Report",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchContractBillReport,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: FutureBuilder<ContractBillReportModel?>(
                    future: contractBill,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
                      } else {
                        if (snapshot.hasError) {
                          return Center(child: Utils.text(
                            text: 'Error: ${snapshot.error.toString()}',
                            color: kBlackColor
                          ));
                        } else if (!snapshot.hasData || snapshot.data!.data == null || snapshot.data!.data!.isEmpty) {
                          return Center(child: Utils.text(
                            text: 'No data available',
                            color: kBlackColor,
                          ));
                        } else {
                          final data = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.data?.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              final ledgerReport = data.data?[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isShow?[index] = !(isShow?[index] ?? false);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFEAF9FF),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Utils.text(
                                                text: "Generate Date : ",
                                                color: kBlackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Utils.text(
                                                text: ledgerReport?.generateDate == "" ? "-" : ledgerReport?.generateDate,
                                                color: kBlackColor,
                                                fontSize: 12,
                                                textOverFlow: TextOverflow.ellipsis,
                                              ),
                                              const Spacer(),
                                              Utils.text(
                                                text: "Client Id : ",
                                                color: kBlackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Utils.text(
                                                text: "${ledgerReport?.clientId}" == "" ? "-" : "${ledgerReport?.clientId}",
                                                color: kBlackColor,
                                                fontSize: 12,
                                                textOverFlow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Utils.text(
                                                text: "Client Name : ",
                                                color: kBlackColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              Utils.text(
                                                text: (ledgerReport?.clientName?.length ?? 0) > 10
                                                    ? "${ledgerReport?.clientName?.substring(0, 10)}..."
                                                    : ledgerReport?.clientName,
                                                color: kBlackColor,
                                                fontSize: 12,
                                                textOverFlow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Visibility(
                                            visible: (isShow?[index] ?? false),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(05.0),
                                                    child: Column(
                                                      children: [
                                                        Divider(
                                                          color: Colors.grey.shade800.withOpacity(0.2),
                                                        ),
                                                        const SizedBox(
                                                          height: 05,
                                                        ),
                                                        Visibility(
                                                          visible: ledgerReport?.docfilename != "",
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              InkWell(
                                                                onTap:(){
                                                                  Utils.showLoadingDialogue(context);
                                                                  ApiServices().downloadPDF(
                                                                      pdfFileName: ledgerReport?.docfilename,
                                                                      pdfUrl: ledgerReport?.path,
                                                                      context: context,
                                                                  );
                                                                },
                                                                child: Container(
                                                                  height: 25,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(05),
                                                                    color: Colors.deepPurpleAccent.shade700.withOpacity(0.1),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                                    child: Center(
                                                                      child: Utils.text(
                                                                        text: ledgerReport?.docfilename?.toString() ?? 'N/A',
                                                                        color: Colors.deepPurple,
                                                                        fontSize: 14,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 7,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

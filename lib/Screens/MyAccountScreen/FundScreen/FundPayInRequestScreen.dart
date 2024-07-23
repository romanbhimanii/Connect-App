import 'dart:io';
import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/FundPayInModel/FundPayInModel.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/ConnectivityService.dart';
import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Fundpayinrequestscreen extends StatefulWidget {
  const Fundpayinrequestscreen({super.key});

  @override
  State<Fundpayinrequestscreen> createState() => _FundpayinrequestscreenState();
}

class _FundpayinrequestscreenState extends State<Fundpayinrequestscreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  Future<FundPayinResponse>? futureFundPayin;
  String selectedColumn = 'Date';
  String selectedOperator = 'contains';
  String filterValue = '';

  final List<String> columns = ['ID', 'Client Code', 'Account No', 'Segment', 'Amount', 'Date'];
  final List<String> operators = ['contains', 'equals', 'starts with', 'ends with', 'is empty', 'is not empty', 'is any of'];
  List<FundPayinData> filteredData = [];
  List<FundPayinData> originalData = [];

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchFundPayIn();
  }

  Future<void> fetchFundPayIn() async {
    futureFundPayin = ApiServices().fetchFundPayin(authToken: Appvariables.token);
    futureFundPayin?.then((response) {
      setState(() {
        filteredData = response.data;
        originalData = response.data;
      });
    });
  }

  void applyFilter() {
    setState(() {
      filteredData = originalData.where((item) {
        int index = originalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'ID':
            return applyOperator(index.toString());
          case 'Client Code':
            return applyOperator(item.clientCode);
          case 'Account No':
            return applyOperator(item.accountNo);
          case 'Segment':
            return applyOperator(item.segment);
          case 'Amount':
            return applyOperator(item.txnAmt.toString());
          case 'Date':
            return applyOperator(item.txnDate);
          default:
            return false;
        }
      }).toList();
    });
  }

  bool applyOperator(String value) {
    switch (selectedOperator) {
      case 'contains':
        return value.contains(filterValue);
      case 'equals':
        return value == filterValue;
      case 'starts with':
        return value.startsWith(filterValue);
      case 'ends with':
        return value.endsWith(filterValue);
      case 'is empty':
        return value.isEmpty;
      case 'is not empty':
        return value.isNotEmpty;
      case 'is any of':
        List<String> values = filterValue.split(',');
        return values.contains(value);
      default:
        return false;
    }
  }

  Future<void> exportToCSV(List<FundPayinData> data) async {
    List<List<dynamic>> rows = [];
    rows.add(["ID", "Client Code", "Account No", "Segment", "Amount", "Date"]);

    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.clientCode,
        item.accountNo,
        item.segment,
        item.txnAmt,
        item.txnDate,
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus = await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String path = "${directory?.path}/fund_payin.csv";
      File file = File(path);

      await file.writeAsString(csv);
      Utils.toast(msg: "Exported to $path");
    } else {
      Utils.toast(msg: "Permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: kBlackColor),
            color: Colors.white,
            onSelected: (String result) async {
              if (result == 'Export') {
                if (await futureFundPayin != null) {
                  futureFundPayin?.then((response) {
                    if (response.data.isNotEmpty) {
                      exportToCSV(response.data);
                    }
                  });
                }
              } else if (result == "Filters") {
                Get.bottomSheet(
                  backgroundColor: Colors.white,
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 07,
                            ),
                            Row(
                              children: [
                                Utils.text(
                                  text: "Filters",
                                  color: kBlackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                TextButton(onPressed: () {
                                  setState(() {
                                    fetchFundPayIn();
                                    Get.back();
                                  });
                                }, child: Utils.text(
                                  text: "Reset",
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedColumn,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedColumn = value!;
                                      });
                                    },
                                    items: columns.map((column) {
                                      return DropdownMenuItem(
                                        value: column,
                                        child: Utils.text(
                                          text: column,
                                          color: kBlackColor
                                        ),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      fillColor: Color.fromRGBO(27, 82, 52, 0.1),
                                      labelText: 'Columns',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: selectedOperator,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedOperator = value!;
                                      });
                                    },
                                    items: operators.map((operator) {
                                      return DropdownMenuItem(
                                        value: operator,
                                        child: Utils.text(
                                          text: operator,
                                          color: kBlackColor
                                        ),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      fillColor: Color.fromRGBO(27, 82, 52, 0.1),
                                      labelText: 'Operator',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  filterValue = value;
                                });
                              },
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(27, 82, 52, 0.1),
                                labelText: 'Filter Value',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(27, 82, 52, 1.0),
                              ),
                              onPressed: () {
                                applyFilter();
                                Get.back();
                              },
                              child: Utils.text(
                                text: 'Apply Filter',
                                color: Colors.white
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Filters',
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: Color.fromRGBO(27, 82, 52, 1.0),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Utils.text(
                      text: "Filters",
                      color: const Color.fromRGBO(27, 82, 52, 1.0),
                      fontSize: 15,
                    )
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Export',
                child: Row(
                  children: [
                    const Icon(
                      Icons.download,
                      color: Color.fromRGBO(27, 82, 52, 1.0),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Utils.text(
                      text: "Export",
                      color: const Color.fromRGBO(27, 82, 52, 1.0),
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
          text: "Fund Pay-In Requests",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: FutureBuilder<FundPayinResponse>(
        future: futureFundPayin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
          } else if (snapshot.hasError) {
            return Center(child: Utils.text(
              text: "Error: ${snapshot.error}",
              color: kBlackColor,
              fontSize: 13,
            ),);
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return Center(child: Utils.text(
              text: "No data found",
              color: kBlackColor,
              fontSize: 13,
            ),);
          } else {
            return ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: filteredData.isNotEmpty ? InkWell(
                    onTap: () {},
                    child: Card(
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(color: Colors.grey.shade800.withOpacity(0.1))),
                                                child: Center(
                                                  child: Utils.text(
                                                    text: "${index + 1}",
                                                    color: kBlackColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Utils.text(text: "Client Code : ${item.clientCode}", color: kBlackColor),
                                              const SizedBox(height: 5),
                                              Utils.text(text: "Account No : ${item.accountNo}", color: kBlackColor),
                                              const SizedBox(height: 5),
                                              Utils.text(text: "Segment : ${item.segment}", color: kBlackColor),
                                              const SizedBox(height: 5),
                                              Utils.text(text: "Amount : ${item.txnAmt}", color: kBlackColor),
                                              const SizedBox(height: 5),
                                              Utils.text(text: "Date : ${item.txnDate}", color: kBlackColor),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) : Center(
                    child: Utils.text(
                      text: "No data Found!",
                      color: kBlackColor,
                      fontSize: 13
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

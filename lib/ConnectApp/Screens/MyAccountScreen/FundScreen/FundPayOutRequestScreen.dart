import 'dart:io';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/FundPayOutModel/FundPayOutModel.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class FundPayOutRequestScreen extends StatefulWidget {
  const FundPayOutRequestScreen({super.key});

  @override
  State<FundPayOutRequestScreen> createState() => _FundPayOutRequestScreenState();
}

class _FundPayOutRequestScreenState extends State<FundPayOutRequestScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  Future<PayOutModel>? futureFundPayin;
  String selectedColumn = 'Entry Date';
  String selectedOperator = 'contains';
  String filterValue = '';

  final List<String> columns = ['ID', 'Amount', 'Account No', 'UCC', 'Entry Date'];
  final List<String> operators = ['contains', 'equals', 'starts with', 'ends with', 'is empty', 'is not empty', 'is any of'];
  List<Data>? filteredData = [];
  List<Data>? originalData = [];

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchFundPayOut();
  }

  Future<void> fetchFundPayOut() async {
    futureFundPayin = ApiServices().fetchFundPayOut(authToken: Appvariables.token);
    futureFundPayin?.then((response) {
      setState(() {
        filteredData = response.data;
        originalData = response.data;
      });
    });
  }

  void applyFilter() {
    setState(() {
      filteredData = originalData?.where((item) {
        int index = (originalData?.indexOf(item) ?? 0) + 1;
        switch (selectedColumn) {
          case 'ID':
            return applyOperator(index.toString());
          case 'Amount':
            return applyOperator(item.amount ?? "");
          case 'Account No':
            return applyOperator(item.bankAccNo ?? "");
          case 'UCC':
            return applyOperator(item.uCC ?? "");
          case 'Entry Date':
            return applyOperator(item.entryDate.toString());
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

  Future<void> exportToCSV(List<Data>? data) async {
    List<List<dynamic>> rows = [];
    rows.add(["ID", "Amount", "Account No", "UCC", "Entry Date"]);

    for (int i = 0; i < data!.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.amount,
        item.bankAccNo,
        item.uCC,
        item.entryDate,
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
      String downloadsFolderPath = await ApiServices().getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      String path = "${directory.path}/fund_payout.csv";
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
                    if (response.data!.isNotEmpty) {
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
                                    fetchFundPayOut();
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
                            InkWell(
                              onTap: () {
                                applyFilter();
                                Get.back();
                              },
                              child: Utils.gradientButton(
                                message: "Apply Filter"
                              ),
                            )
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
            text: "Fund Pay-Out Requests",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
      body: FutureBuilder<PayOutModel>(
        future: futureFundPayin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100));
          } else if (snapshot.hasError) {
            return Utils.noDataFound();
          } else if (!snapshot.hasData || snapshot.data!.data!.isEmpty) {
            return Utils.noDataFound();
          } else {
            return ListView.builder(
              itemCount: filteredData!.length,
              itemBuilder: (context, index) {
                final item = filteredData![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 05),
                  child: filteredData!.isNotEmpty ? InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                       color: const Color(0xFFEAF9FF),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                    text: "Account No",
                                    fontSize: 10,
                                    color: const Color(0xFF4A5568)),
                                Utils.text(
                                    text: "Amount",
                                    fontSize: 10,
                                    color: const Color(0xFF4A5568)),
                              ],
                            ),
                            const SizedBox(
                              height: 03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                    text: item.bankAccNo,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F3F62)),
                                Utils.text(
                                    text: item.amount,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F3F62)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                    text: "Entry Date",
                                    fontSize: 10,
                                    color: const Color(0xFF4A5568)),
                                Utils.text(
                                    text: "UCC",
                                    fontSize: 10,
                                    color: const Color(0xFF4A5568)),
                              ],
                            ),
                            const SizedBox(
                              height: 03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                    text: item.entryDate,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F3F62)),
                                Utils.text(
                                    text: item.uCC,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F3F62)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ) : Utils.noDataFound()
                );
              },
            );
          }
        },
      ),
    );
  }
}

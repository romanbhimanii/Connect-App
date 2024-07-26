// ignore_for_file: must_be_immutable

import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/IpoModels/IpoModel.dart';
import 'package:connect/ConnectApp/Screens/IPOScreens/IPODetailsScreen.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Viewalliposcreen extends StatefulWidget {
  String? name;
  Viewalliposcreen({super.key,required this.name});

  @override
  State<Viewalliposcreen> createState() => _ViewalliposcreenState();
}

class _ViewalliposcreenState extends State<Viewalliposcreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  final ApiServices _apiService = ApiServices();
  Future<IpoDetailsResponse>? upcomingIPO;
  Future<IpoDetailsResponse>? openIPO;
  List<IpoDetails> upcomingFilteredData = [];
  List<IpoDetails> openFilteredData = [];
  List<IpoDetails> upcomingOriginalData = [];
  List<IpoDetails> openOriginalData = [];
  String selectedColumn = 'Ipo Type';
  String selectedOperator = 'contains';
  String filterValue = '';

  final List<String> columns = ['ID', 'Ipo Type'];
  final List<String> operators = ['contains', 'equals', 'starts with', 'ends with', 'is empty', 'is not empty', 'is any of'];

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchIpoData();
  }

  Future<void> fetchIpoData() async {
    upcomingIPO = _apiService.fetchUpcomingIpoDetails();
    upcomingIPO?.then((response) {
      setState(() {
        upcomingFilteredData = response.data;
        upcomingOriginalData = response.data;
      });
    });
    openIPO = _apiService.fetchOpenIpoDetails();
    openIPO?.then((response) {
      setState(() {
        openFilteredData = response.data;
        openOriginalData = response.data;
      });
    });
  }

  void applyOpenIpoFilter() {
    setState(() {
      openFilteredData = openOriginalData.where((item) {
        int index = openOriginalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'ID':
            return applyOperator(index.toString());
          case 'Ipo Type':
            return applyOperator(item.ipoType);
          default:
            return false;
        }
      }).toList();
    });
  }

  void applyUpcomingIpoFilter() {
    setState(() {
      upcomingFilteredData = upcomingOriginalData.where((item) {
        int index = upcomingOriginalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'ID':
            return applyOperator(index.toString());
          case 'Ipo Type':
            return applyOperator(item.ipoType);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: 50,
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
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: widget.name == "open IPO" ? "Open Ipo" : "Upcoming Ipo",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: kBlackColor),
            color: Colors.white,
            onSelected: (String result) async {
             if (result == "Filters") {
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
                                    fetchIpoData();
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
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: DropdownButtonFormField<String>(
                            //         value: selectedColumn,
                            //         onChanged: (value) {
                            //           setState(() {
                            //             selectedColumn = value!;
                            //           });
                            //         },
                            //         items: columns.map((column) {
                            //           return DropdownMenuItem(
                            //             value: column,
                            //             child: Utils.text(
                            //                 text: column,
                            //                 color: kBlackColor
                            //             ),
                            //           );
                            //         }).toList(),
                            //         decoration: const InputDecoration(
                            //           fillColor: Color.fromRGBO(27, 82, 52, 0.1),
                            //           labelText: 'Columns',
                            //           border: OutlineInputBorder(),
                            //         ),
                            //       ),
                            //     ),
                            //     const SizedBox(width: 10),
                            //     Expanded(
                            //       child: DropdownButtonFormField<String>(
                            //         value: selectedOperator,
                            //         onChanged: (value) {
                            //           setState(() {
                            //             selectedOperator = value!;
                            //           });
                            //         },
                            //         items: operators.map((operator) {
                            //           return DropdownMenuItem(
                            //             value: operator,
                            //             child: Utils.text(
                            //                 text: operator,
                            //                 color: kBlackColor
                            //             ),
                            //           );
                            //         }).toList(),
                            //         decoration: const InputDecoration(
                            //           fillColor: Color.fromRGBO(27, 82, 52, 0.1),
                            //           labelText: 'Operator',
                            //           border: OutlineInputBorder(),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 10),
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  filterValue = value;
                                });
                              },
                              decoration: const InputDecoration(
                                fillColor: Color.fromRGBO(27, 82, 52, 0.1),
                                labelText: 'Enter Ipo Type',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                widget.name == "open IPO" ? applyOpenIpoFilter() : applyUpcomingIpoFilter();
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
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                widget.name == "open IPO" ? openIPOsList() : upcomingIPOs(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget openIPOsList() {
    return FutureBuilder<IpoDetailsResponse>(
      future: openIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                  child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return openFilteredData.isNotEmpty ? Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: openFilteredData.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = openFilteredData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 05.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return IPODetailsScreen(name: widget.name,data: ipo,);
                        },));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:  const Color(0xFFEAF9FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Utils.text(
                                text: ipo.name,
                                color: const Color(0xFF001533),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.start,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Lot Size : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.lotSize,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'IPO Type : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.ipoType,
                                                      style: GoogleFonts.inter(
                                                        color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Bid Start Date : ',
                                                  style: GoogleFonts.inter(
                                                    color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingStartDate,
                                                      style: GoogleFonts.inter(
                                                        color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xFF2970E8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Center(
                                        child: Utils.text(
                                          text: "Apply Now",
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ) : Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        }
      },
    );
  }

  Widget upcomingIPOs() {
    return FutureBuilder<IpoDetailsResponse>(
      future: upcomingIPO,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                  child:  Lottie.asset('assets/lottie/loading.json',height: 100,width: 100)),
            ],
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!.data;
          return upcomingFilteredData.isNotEmpty ?  Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: upcomingFilteredData.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final ipo = upcomingFilteredData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 05.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return IPODetailsScreen(name: widget.name,data: ipo,);
                        },));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color:  const Color(0xFFEAF9FF),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10),
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
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Utils.text(
                                                text: ipo.name,
                                                color: const Color(0xFF001533),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Lot Size : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.lotSize,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'IPO Type : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.ipoType,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  text: 'Bid Start Date : ',
                                                  style: GoogleFonts.inter(
                                                      color: const Color(0xFF4A5568),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: ipo.biddingStartDate,
                                                      style: GoogleFonts.inter(
                                                          color: const Color(0xFF001533),
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                  );
                },
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ) : Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        } else {
          return Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Utils.noDataFound(),
            ],
          );
        }
      },
    );
  }

}

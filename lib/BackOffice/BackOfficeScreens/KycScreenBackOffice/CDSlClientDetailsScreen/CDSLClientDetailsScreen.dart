// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsDpDetailsModel/CDSLClientDetailsDpDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsTradingDetailsModel/CDSLClientDetailsTradingDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeScreens/KycScreenBackOffice/CDSlClientDetailsScreen/FullDpDetailsScreen.dart';
import 'package:connect/BackOffice/BackOfficeScreens/KycScreenBackOffice/CDSlClientDetailsScreen/FullTradingDetailsScreen.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/SettingsScreen/SettingsScreen.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:csv/csv.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class CDSLClientDetailsScreen extends StatefulWidget {
  const CDSLClientDetailsScreen({super.key});

  @override
  State<CDSLClientDetailsScreen> createState() =>
      _CDSLClientDetailsScreenState();
}

class _CDSLClientDetailsScreenState extends State<CDSLClientDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Future<List<DPDetails>>? futureDPDetails;
  Future<TradingDetailsResponse>? futureTradingDetails;
  final TextEditingController clientCodeController = TextEditingController();
  String selectedColumn = 'Sr No';
  String selectedColumn1 = 'Sr No';
  String selectedOperator = 'contains';
  String filterValue = '';
  List<DPDetails> dpDetailsOriginalData = [];
  List<DPDetails> dpDetailsFilteredData = [];
  List<TradingDetail> tradingDetailsFilteredData = [];
  List<TradingDetail> tradingDetailsOriginalData = [];

  final List<String> dpDetailsColumns = [
    'Sr No',
    'Branch Code',
    'Trading Client Id',
    'Bo Id',
    'First Holder Name',
    'ITPA No',
    'Account Status',
    'BO Sub Status',
    'Account Open Date',
    'BO Date Of Birth',
    'BO Address Line 1',
    'BO Address Line 2',
    'BO Address Line 3',
    'BO Address City',
    'BO Address State',
    'Bo Address Country',
    'BO Address Pin',
    'Mobile Number',
    'Email Id',
    'Bank Name',
    'Bank Account Number',
    'MICR Code',
    'Second Holder Name',
    'Pan No(Second Holder)',
    'Third Holder Name',
    'Pan No(Third Holder)',
    'POA Name',
    'POA Enabled',
    'Nominee Name',
    'Risk Category',
    'Guardian Pan No',
  ];
  final List<String> tradingDetailsColumns = [
    'Sr No',
    'Company Code',
    'MICR Code',
    'Bank Account Number',
    'Bank Name',
    'Client Dp Code',
    'DP Id',
    'DP Name',
    'Client Id',
    'Client Name',
    'Client Address Line 1',
    'Client Address Line 2',
    'Client Address Line 3',
    'Remeshire Group',
    'Remeshire Name',
    'Mobile Number',
    'Client ID Email',
    'Pan Number',
  ];
  final List<String> operators = [
    'contains',
    'equals',
    'starts with',
    'ends with',
    'is empty',
    'is not empty',
    'is any of'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener((){
      setState(() {});
    });
    fetchDpDetails();
  }

  Future<void> fetchDpDetails() async {
    futureDPDetails = BackOfficeApiService()
        .fetchDPDetails(token: Appvariablesbackoffice.token);
    futureDPDetails?.then((response) {
      setState(() {
        dpDetailsFilteredData = response;
        dpDetailsOriginalData = response;
      });
    });
  }

  Future<void> fetchTradingDetails() async {
    if (clientCodeController.text != "") {
      futureTradingDetails = BackOfficeApiService().fetchTradingDetails(
          clientCode: clientCodeController.text,
          token: Appvariablesbackoffice.token);
      futureTradingDetails?.then((response) {
        setState(() {
          tradingDetailsFilteredData = response.data;
          tradingDetailsOriginalData = response.data;
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void applyDpDetailsFilter() {
    setState(() {
      dpDetailsFilteredData = dpDetailsOriginalData.where((item) {
        int index = dpDetailsOriginalData.indexOf(item) + 1;
        switch (selectedColumn) {
          case 'Sr No':
            return applyOperator(index.toString());
          case 'Branch Code':
            return applyOperator(item.branchCode);
          case 'Trading Client Id':
            return applyOperator(item.tradingClientId);
          case 'Bo Id':
            return applyOperator(item.boId);
          case 'First Holder Name':
            return applyOperator(item.firstHoldName);
          case 'ITPA No':
            return applyOperator(item.itpaNo);
          case 'Account Status':
            return applyOperator(item.accStat);
          case 'BO Sub Status':
            return applyOperator(item.boSubStat);
          case 'Account Open Date':
            return applyOperator(item.accOpenDate);
          case 'BO Date Of Birth':
            return applyOperator(item.boDob);
          case 'BO Address Line 1':
            return applyOperator(item.boAdd1);
          case 'BO Address Line 2':
            return applyOperator(item.boAdd2);
          case 'BO Address Line 3':
            return applyOperator(item.boAdd3);
          case 'BO Address City':
            return applyOperator(item.boAddCity);
          case 'BO Address State':
            return applyOperator(item.boAddState);
          case 'Bo Address Country':
            return applyOperator(item.boAddCountry);
          case 'BO Address Pin':
            return applyOperator(item.boAddPin);
          case 'Mobile Number':
            return applyOperator(item.mobileNum);
          case 'Email Id':
            return applyOperator(item.emailId);
          case 'Bank Name':
            return applyOperator(item.bankName);
          case 'Bank Account Number':
            return applyOperator(item.bankAccNo);
          case 'MICR Code':
            return applyOperator(item.micrCode);
          case 'Second Holder Name':
            return applyOperator(item.secondHoldName);
          case 'Pan No(Second Holder)':
            return applyOperator(item.panNo2 ?? "");
          case 'Third Holder Name':
            return applyOperator(item.thirdHoldName);
          case 'Pan No(Third Holder)':
            return applyOperator(item.panNo3 ?? "");
          case 'POA Name':
            return applyOperator(item.poaName);
          case 'POA Enabled':
            return applyOperator(item.poaEnabled);
          case 'Nominee Name':
            return applyOperator(item.nominName ?? "");
          case 'Risk Category':
            return applyOperator(item.riskCategory);
          case 'Guardian Pan No':
            return applyOperator(item.guardianPanNo ?? "");
          default:
            return false;
        }
      }).toList();
    });
  }

  void applyTradingDetailsFilter() {
    setState(() {
      tradingDetailsFilteredData = tradingDetailsOriginalData.where((item) {
        int index = tradingDetailsOriginalData.indexOf(item) + 1;
        switch (selectedColumn1) {
          case 'Sr No':
            return applyOperator(index.toString());
          case 'Company Code':
            return applyOperator(item.companyCode);
          case 'MICR Code':
            return applyOperator(item.micrCode);
          case 'Bank Account Number':
            return applyOperator(item.bankAcno);
          case 'Bank Name':
            return applyOperator(item.bankName);
          case 'Client Dp Code':
            return applyOperator(item.clientDpCode);
          case 'DP Id':
            return applyOperator(item.dpId);
          case 'DP Name':
            return applyOperator(item.dpName);
          case 'Client Id':
            return applyOperator(item.clientId);
          case 'Client Name':
            return applyOperator(item.clientName);
          case 'Client Address Line 1':
            return applyOperator(item.clResiAdd1);
          case 'Client Address Line 2':
            return applyOperator(item.clResiAdd2);
          case 'Client Address Line 3':
            return applyOperator(item.clResiAdd3);
          case 'Remeshire Group':
            return applyOperator(item.remeshireGroup);
          case 'Remeshire Name':
            return applyOperator(item.remeshireName);
          case 'Mobile Number':
            return applyOperator(item.mobileNo);
          case 'Client ID Email':
            return applyOperator(item.clientIdMail);
          case 'Pan Number':
            return applyOperator(item.panNo);
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

  Future<void> exportDpDetailsToCsv(List<DPDetails> data) async {
    List<List<dynamic>> rows = [];
    rows.add([
      'Sr No',
      'Branch Code',
      'Trading Client Id',
      'Bo Id',
      'First Holder Name',
      'ITPA No',
      'Account Status',
      'BO Sub Status',
      'Account Open Date',
      'BO Date Of Birth',
      'BO Address Line 1',
      'BO Address Line 2',
      'BO Address Line 3',
      'BO Address City',
      'BO Address State',
      'Bo Address Country',
      'BO Address Pin',
      'Mobile Number',
      'Email Id',
      'Bank Name',
      'Bank Account Number',
      'MICR Code',
      'Second Holder Name',
      'Pan No(Second Holder)',
      'Third Holder Name',
      'Pan No(Third Holder)',
      'POA Name',
      'POA Enabled',
      'Nominee Name',
      'Risk Category',
      'Guardian Pan No']);

    for (int i = 0; i < data.length; i++) {
      var item = data[i];
      rows.add([
        i + 1,
        item.branchCode,
        item.tradingClientId,
        item.boId,
        item.firstHoldName,
        item.itpaNo,
        item.accStat,
        item.boSubStat,
        item.accOpenDate,
        item.boDob,
        item.boAdd1,
        item.boAdd2,
        item.boAdd3,
        item.boAddCity,
        item.boAddState,
        item.boAddCountry,
        item.boAddPin,
        item.mobileNum,
        item.emailId,
        item.bankName,
        item.bankAccNo,
        item.micrCode,
        item.secondHoldName,
        item.panNo2,
        item.thirdHoldName,
        item.panNo3,
        item.poaName,
        item.poaEnabled,
        item.nominName,
        item.riskCategory,
        item.guardianPanNo,
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime time = DateTime.now();
      String year = prefs.getString('backOfficeYear') ?? "${time.year}";
      String reportYear = '';
      if(year == ""){
        reportYear = "${time.year}";
      }
      else if(year == "2024"){
        reportYear = "2024";
      }else if(year == "2023"){
        reportYear = "2023";
      }else if(year == "2022"){
        reportYear = "2022";
      }else if(year == "2021"){
        reportYear = "2021";
      }

      String path = "${directory?.path}/Dp Details of $reportYear.csv";
      File file = File(path);

      await file.writeAsString(csv);
      OpenFile.open(path);
      Utils.toast(msg: "Exported to $path");
    } else {
      Utils.toast(msg: "Permission denied");
    }
  }

  Future<void> exportDpDetailsToPdf(List<DPDetails> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Table.fromTextArray(
            headers: [
              'Sr No',
              'Branch Code',
              'Trading Client Id',
              'Bo Id',
              'First Holder Name',
              'ITPA No',
              'Account Status',
              'BO Sub Status',
              'Account Open Date',
              'BO Date Of Birth',
              'BO Address Line 1',
              'BO Address Line 2',
              'BO Address Line 3',
              'BO Address City',
              'BO Address State',
              'Bo Address Country',
              'BO Address Pin',
              'Mobile Number',
              'Email Id',
              'Bank Name',
              'Bank Account Number',
              'MICR Code',
              'Second Holder Name',
              'Pan No(Second Holder)',
              'Third Holder Name',
              'Pan No(Third Holder)',
              'POA Name',
              'POA Enabled',
              'Nominee Name',
              'Risk Category',
              'Guardian Pan No',
            ],
            data: List<List<dynamic>>.generate(
              data.length,
                  (index) => [
                index + 1,
                data[index].branchCode,
                data[index].tradingClientId,
                data[index].boId,
                data[index].firstHoldName,
                data[index].itpaNo,
                data[index].accStat,
                data[index].boSubStat,
                data[index].accOpenDate,
                data[index].boDob,
                data[index].boAdd1,
                data[index].boAdd2,
                data[index].boAdd3,
                data[index].boAddCity,
                data[index].boAddState,
                data[index].boAddCountry,
                data[index].boAddPin,
                data[index].mobileNum,
                data[index].emailId,
                data[index].bankName,
                data[index].bankAccNo,
                data[index].micrCode,
                data[index].secondHoldName,
                data[index].panNo2,
                data[index].thirdHoldName,
                data[index].panNo3,
                data[index].poaName,
                data[index].poaEnabled,
                data[index].nominName,
                data[index].riskCategory,
                data[index].guardianPanNo,
              ],
            ),
          );
        },
      ),
    );

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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime time = DateTime.now();
      String year = prefs.getString('backOfficeYear') ?? "${time.year}";
      String reportYear = '';
      if(year == ""){
        reportYear = "${time.year}";
      }
      else if(year == "2024"){
        reportYear = "2024";
      }else if(year == "2023"){
        reportYear = "2023";
      }else if(year == "2022"){
        reportYear = "2022";
      }else if(year == "2021"){
        reportYear = "2021";
      }

      String path = "${directory?.path}/DpDetails_$reportYear.pdf";
      final file = File(path);

      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(path);
      Utils.toast(msg: "Exported to $path");
    } else {
      Utils.toast(msg: "Permission denied");
    }
  }

  Future<void> generateInvoice() async {
    // Create a PDF document.
    final PdfDocument document = PdfDocument();
    // Add page to the PDF
    final PdfPage page = document.pages.add();
    // Get page client size
    final Size pageSize = page.getClientSize();
    // Generate PDF grid.
    final PdfGrid grid = getGrid();
    // Draw grid
    drawGrid(page, grid, pageSize);
    // Save the PDF document
    final List<int> bytes = document.saveSync();
    // Dispose the document.
    document.dispose();
    // Save and launch the file.
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    String path = "${directory?.path}/dp_details.pdf";
    final file = File(path);

    await file.writeAsBytes(bytes);
    await OpenFile.open(path);
  }

  // Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, Size pageSize) {
    // Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    // Set grid columns width
    for (int i = 0; i < grid.columns.count; i++) {
      grid.columns[i].width = (pageSize.width - 40) / grid.columns.count;
    }
    // Draw the PDF grid and get the result.
    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(20, 20, pageSize.width - 40, pageSize.height - 40),
    );
  }

  // Create PDF grid and return
  PdfGrid getGrid() {
    // Create a PDF grid
    final PdfGrid grid = PdfGrid();
    // Specify the columns count to the grid.
    grid.columns.add(count: 30);
    // Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    // Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Branch Code';
    headerRow.cells[1].value = 'Trading Client ID';
    headerRow.cells[2].value = 'BO ID';
    headerRow.cells[3].value = 'First Holder Name';
    headerRow.cells[4].value = 'ITPA No';
    headerRow.cells[5].value = 'Account Status';
    headerRow.cells[6].value = 'BO Sub Status';
    headerRow.cells[7].value = 'Account Open Date';
    headerRow.cells[8].value = 'BO DOB';
    headerRow.cells[9].value = 'BO Address 1';
    headerRow.cells[10].value = 'BO Address 2';
    headerRow.cells[11].value = 'BO Address 3';
    headerRow.cells[12].value = 'BO City';
    headerRow.cells[13].value = 'BO State';
    headerRow.cells[14].value = 'BO Country';
    headerRow.cells[15].value = 'BO Pin';
    headerRow.cells[16].value = 'Mobile Number';
    headerRow.cells[17].value = 'Email ID';
    headerRow.cells[18].value = 'Bank Name';
    headerRow.cells[19].value = 'Bank Account No';
    headerRow.cells[20].value = 'MICR Code';
    headerRow.cells[21].value = 'Second Holder Name';
    headerRow.cells[22].value = 'PAN No 2';
    headerRow.cells[23].value = 'Third Holder Name';
    headerRow.cells[24].value = 'PAN No 3';
    headerRow.cells[25].value = 'POA Name';
    headerRow.cells[26].value = 'POA Enabled';
    headerRow.cells[27].value = 'Nominee Name';
    headerRow.cells[28].value = 'Risk Category';
    headerRow.cells[29].value = 'Guardian PAN No';

    // Add rows
    addRow(grid, '001', 'T123', 'B01234', 'John Doe', '123456', 'Active', 'Sub Active', '01-01-2020', '01-01-1980',
        '123 Street', 'City', 'State', 'Country', '123456', '456789', '1234567890', 'john@example.com', 'Bank 1', '123456789', '123456', 'Jane Doe', 'PAN123', 'Jim Doe', 'PAN456', 'N/A', 'Yes', 'Nominee', 'Low', 'GuardianPAN', '123');

    return grid;
  }

  // Add a row to the grid
  void addRow(PdfGrid grid, String branchCode, String tradingClientId, String boId, String firstHolderName, String itpaNo,
      String accountStatus, String boSubStatus, String accountOpenDate, String boDob, String boAdd1, String boAdd2,
      String boAdd3, String boCity, String boState, String boCountry, String boPin, String mobileNum, String emailId,
      String bankName, String bankAccNo, String micrCode, String secondHoldName, String panNo2, String thirdHoldName,
      String panNo3, String poaName, String poaEnabled, String nomineeName, String riskCategory, String guardianPanNo) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = branchCode;
    row.cells[1].value = tradingClientId;
    row.cells[2].value = boId;
    row.cells[3].value = firstHolderName;
    row.cells[4].value = itpaNo;
    row.cells[5].value = accountStatus;
    row.cells[6].value = boSubStatus;
    row.cells[7].value = accountOpenDate;
    row.cells[8].value = boDob;
    row.cells[9].value = boAdd1;
    row.cells[10].value = boAdd2;
    row.cells[11].value = boAdd3;
    row.cells[12].value = boCity;
    row.cells[13].value = boState;
    row.cells[14].value = boCountry;
    row.cells[15].value = boPin;
    row.cells[16].value = mobileNum;
    row.cells[17].value = emailId;
    row.cells[18].value = bankName;
    row.cells[19].value = bankAccNo;
    row.cells[20].value = micrCode;
    row.cells[21].value = secondHoldName;
    row.cells[22].value = panNo2;
    row.cells[23].value = thirdHoldName;
    row.cells[24].value = panNo3;
    row.cells[25].value = poaName;
    row.cells[26].value = poaEnabled;
    row.cells[27].value = nomineeName;
    row.cells[28].value = riskCategory;
    row.cells[29].value = guardianPanNo;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        title: Utils.text(
          text: "Client Details",
          color: const Color(0xFF00A9FF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
          ),
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
                                    fetchDpDetails();
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
                                    value: _tabController?.index == 0 ? selectedColumn : selectedColumn1,
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _tabController?.index == 0 ? selectedColumn : selectedColumn1 = value!;
                                      });
                                    },
                                    items: _tabController?.index == 0 ? dpDetailsColumns.map((column) {
                                      return DropdownMenuItem(
                                        value: column,
                                        child: Utils.text(
                                            text: column,
                                            color: kBlackColor,
                                            textOverFlow: TextOverflow.ellipsis
                                        ),
                                      );
                                    }).toList() : tradingDetailsColumns.map((column) {
                                      return DropdownMenuItem(
                                        value: column,
                                        child: Utils.text(
                                            text: column,
                                            color: kBlackColor,
                                            textOverFlow: TextOverflow.ellipsis
                                        ),
                                      );
                                    }).toList(),
                                    decoration: const InputDecoration(
                                      fillColor: Colors.transparent,
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
                                      fillColor: Colors.transparent,
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
                                fillColor: Colors.transparent,
                                labelText: 'Filter Value',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                _tabController?.index == 0 ? applyDpDetailsFilter() : applyTradingDetailsFilter();
                                Get.back();
                              },
                              child: Utils.gradientButton(
                                  message: "Apply Filter"
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              else if (result == "Export") {
                showMenu(
                  context: context,
                  color: Colors.white,
                  position: const RelativeRect.fromLTRB(100, 0, 0, 0),
                  items: <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'PDF',
                      child: Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Utils.text(
                            text: "PDF",
                            color: Colors.black,
                            fontSize: 15,
                          )
                        ],
                      ),
                    ),
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
                  if (value == 'PDF') {
                    if (await futureDPDetails != null) {
                      futureDPDetails?.then((response) {
                        if (response.isNotEmpty) {
                          generateInvoice();
                        }
                      });
                    }
                  } else if (value == 'CSV') {
                    if (await futureDPDetails != null) {
                      futureDPDetails?.then((response) {
                        if (response.isNotEmpty) {
                          exportDpDetailsToCsv(response);
                        }
                      });
                    }
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Filters',
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Utils.text(
                      text: "Filters",
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
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
        bottom: TabBar(
          dividerHeight: 0.0,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          automaticIndicatorColorAdjustment: true,
          controller: _tabController,
          labelPadding: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.all(0),
          indicatorPadding: const EdgeInsets.all(05),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFF00A9FF),
              width: 1,
            ),
          ),
          labelStyle:
              GoogleFonts.inter(color: const Color(0xFF00A9FF), fontSize: 15),
          unselectedLabelStyle:
              GoogleFonts.inter(color: kBlackColor, fontSize: 15),
          indicatorColor: kBlackColor,
          tabs: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'DP Details'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Tab(text: 'Trading Details'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RefreshIndicator(
              onRefresh: fetchDpDetails,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: fetchDpDetailsWidget(),
                  ),
                ],
              ))),
          RefreshIndicator(
              onRefresh: fetchTradingDetails,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: clientCodeController,
                      textInputAction: TextInputAction.next,
                      cursorColor: Colors.black,
                      onEditingComplete: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        fetchTradingDetails();
                      },
                      style: GoogleFonts.inter(
                        color: kBlackColor,
                      ),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Enter Client Code",
                        hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey.shade600.withOpacity(0.15),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                            width: 1.0,
                          ),
                        ),
                        fillColor: const Color(0xFFE4E4E4).withOpacity(0.3),
                      ),
                      onTapOutside: (PointerDownEvent event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter Client Code";
                        }
                        return null;
                      },
                    ),
                    Visibility(
                      visible: clientCodeController.text != "",
                      child: fetchTradingDetailsWidget(),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget fetchDpDetailsWidget() {
    return FutureBuilder<List<DPDetails>>(
      future: futureDPDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Center(
                  child: Lottie.asset('assets/lottie/loading.json',height: 100,width: 100))
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return dpDetailsFilteredData.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: dpDetailsFilteredData.length,
            itemBuilder: (context, index) {
              final data = dpDetailsFilteredData[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 05),
                child: InkWell(
                  onTap: () {
                    Get.to(FullDpDetailScreen(dpDetails: data));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAF9FF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Utils.text(
                                  text: data.firstHoldName == ""
                                      ? "-"
                                      : data.firstHoldName,
                                  color: const Color(0xFF37474F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  textOverFlow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Utils.text(
                                    text: "Client Id",
                                    color: const Color(0xFF4A5568)
                                        .withOpacity(0.70),
                                    fontSize: 10,
                                  ),
                                  Utils.text(
                                      text: data.tradingClientId == ""
                                          ? "-"
                                          : data.tradingClientId,
                                      color: const Color(0xFF37474F),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.text(
                                      text: "ITPA NO",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.itpaNo,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.text(
                                      text: "A/C Open Date",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.accOpenDate,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.text(
                                      text: "A/C Status",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.accStat,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.text(
                                      text: "BO City",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.boAddCity,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.text(
                                      text: "BO State",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.boAddState,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.text(
                                      text: "BO PinCode",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.boAddPin,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ],
                          ),
                          // Visibility(
                          //   visible: (isShow?[index] ?? false),
                          //   child: Column(
                          //     children: [
                          //       SizedBox(
                          //         width: double.infinity,
                          //         child: Padding(
                          //           padding:
                          //           const EdgeInsets.all(05.0),
                          //           child: Column(
                          //             children: [
                          //               Divider(
                          //                 color: Colors
                          //                     .grey.shade800
                          //                     .withOpacity(0.2),
                          //               ),
                          //               const SizedBox(
                          //                 height: 05,
                          //               ),
                          //               Visibility(
                          //                 visible:
                          //                 data.firstHoldName != "",
                          //                 child: Row(
                          //                   children: [
                          //                     Utils.text(
                          //                       text: (data.firstHoldName
                          //                           .length ??
                          //                           0) >
                          //                           10
                          //                           ? "${data.firstHoldName.substring(0, 10)}..."
                          //                           : data
                          //                           .firstHoldName,
                          //                       color: Colors.black,
                          //                       fontSize: 16,
                          //                       fontWeight:
                          //                       FontWeight.w600,
                          //                       textAlign:
                          //                       TextAlign.start,
                          //                     ),
                          //                     const SizedBox(
                          //                       width: 05,
                          //                     ),
                          //                     GestureDetector(
                          //                         onTap: () {
                          //                           showDialog(
                          //                             context:
                          //                             context,
                          //                             builder:
                          //                                 (context) {
                          //                               return AlertDialog(
                          //                                 backgroundColor: Colors.white,
                          //                                 shape: OutlineInputBorder(
                          //                                     borderRadius: BorderRadius.circular(15),
                          //                                     borderSide: const BorderSide(
                          //                                         color: Colors.white
                          //                                     )
                          //                                 ),
                          //                                 contentPadding:
                          //                                 const EdgeInsets
                          //                                     .all(
                          //                                     10),
                          //                                 content:
                          //                                 Column(
                          //                                   mainAxisSize:
                          //                                   MainAxisSize.min,
                          //                                   children: [
                          //                                     Utils
                          //                                         .text(
                          //                                       text:
                          //                                       data.firstHoldName,
                          //                                       color:
                          //                                       Colors.black,
                          //                                       fontSize:
                          //                                       16,
                          //                                       fontWeight:
                          //                                       FontWeight.w600,
                          //                                       textAlign:
                          //                                       TextAlign.start,
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               );
                          //                             },
                          //                           );
                          //                         },
                          //                         child: const Icon(
                          //                           Icons.info,
                          //                           color:
                          //                           Colors.grey,
                          //                           size: 20,
                          //                         )),
                          //                     const Spacer(),
                          //                     Visibility(
                          //                       visible:
                          //                       data.boId != "",
                          //                       child: Row(
                          //                         children: [
                          //                           Container(
                          //                             height: 15,
                          //                             decoration:
                          //                             BoxDecoration(
                          //                               borderRadius:
                          //                               BorderRadius.circular(
                          //                                   05),
                          //                               color: Colors
                          //                                   .deepPurpleAccent
                          //                                   .shade700
                          //                                   .withOpacity(
                          //                                   0.1),
                          //                             ),
                          //                             child:
                          //                             Padding(
                          //                               padding: const EdgeInsets
                          //                                   .symmetric(
                          //                                   horizontal:
                          //                                   5.0),
                          //                               child: Utils
                          //                                   .text(
                          //                                 text: data
                          //                                     .boId,
                          //                                 color: Colors
                          //                                     .deepPurple,
                          //                                 fontSize:
                          //                                 09,
                          //                               ),
                          //                             ),
                          //                           ),
                          //                           const SizedBox(
                          //                             width: 7,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //               const SizedBox(
                          //                 height: 10,
                          //               ),
                          //               Container(
                          //                 width: double.infinity,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                   BorderRadius
                          //                       .circular(05),
                          //                   border: Border.all(
                          //                       color: Colors
                          //                           .grey.shade800
                          //                           .withOpacity(
                          //                           0.2)),
                          //                 ),
                          //                 child: Padding(
                          //                   padding:
                          //                   const EdgeInsets
                          //                       .all(10.0),
                          //                   child: Column(
                          //                     children: [
                          //                       const SizedBox(
                          //                         height: 10,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Utils.text(
                          //                             text:
                          //                             "Branch Code",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                           Utils.text(
                          //                             text:
                          //                             "Trading Client ID",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 05,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Utils.text(
                          //                             text: data.branchCode ==
                          //                                 ""
                          //                                 ? "-"
                          //                                 : data.branchCode,
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 13,
                          //                             fontWeight:
                          //                             FontWeight
                          //                                 .w600,
                          //                           ),
                          //                           Utils.text(
                          //                             text: data.tradingClientId ==
                          //                                 ""
                          //                                 ? "-"
                          //                                 : data.tradingClientId,
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 13,
                          //                             fontWeight:
                          //                             FontWeight
                          //                                 .w600,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Utils.text(
                          //                             text:
                          //                             "ITPA No",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                           Utils.text(
                          //                             text:
                          //                             "A/C Status",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 05,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Utils.text(
                          //                             text: data.itpaNo ==
                          //                                 ""
                          //                                 ? "-"
                          //                                 : data.itpaNo,
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 13,
                          //                             fontWeight:
                          //                             FontWeight
                          //                                 .w600,
                          //                           ),
                          //                           Utils.text(
                          //                             text: data.accStat ==
                          //                                 ""
                          //                                 ? "-"
                          //                                 : data.accStat,
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 13,
                          //                             fontWeight:
                          //                             FontWeight
                          //                                 .w600,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               Utils.text(
                          //                                 text:
                          //                                 "BO Sub Status",
                          //                                 color:
                          //                                 kBlackColor87,
                          //                                 fontSize: 11,
                          //                               ),
                          //                               const SizedBox(
                          //                                 width: 05,
                          //                               ),
                          //                               GestureDetector(
                          //                                   onTap: () {
                          //                                     showDialog(
                          //                                       context:
                          //                                       context,
                          //                                       builder:
                          //                                           (context) {
                          //                                         return AlertDialog(
                          //                                           backgroundColor: Colors.white,
                          //                                           shape: OutlineInputBorder(
                          //                                             borderRadius: BorderRadius.circular(15),
                          //                                             borderSide: const BorderSide(
                          //                                               color: Colors.white
                          //                                             )
                          //                                           ),
                          //                                           contentPadding:
                          //                                           const EdgeInsets
                          //                                               .all(
                          //                                               10),
                          //                                           content:
                          //                                           Column(
                          //                                             mainAxisSize:
                          //                                             MainAxisSize.min,
                          //                                             children: [
                          //                                               Utils
                          //                                                   .text(
                          //                                                 text:
                          //                                                 data.boSubStat,
                          //                                                 color:
                          //                                                 Colors.black,
                          //                                                 fontSize:
                          //                                                 16,
                          //                                                 fontWeight:
                          //                                                 FontWeight.w600,
                          //                                                 textAlign:
                          //                                                 TextAlign.start,
                          //                                               ),
                          //                                             ],
                          //                                           ),
                          //                                         );
                          //                                       },
                          //                                     );
                          //                                   },
                          //                                   child: const Icon(
                          //                                     Icons.info,
                          //                                     color:
                          //                                     Colors.grey,
                          //                                     size: 15,
                          //                                   )),
                          //                             ],
                          //                           ),
                          //                           Utils.text(
                          //                             text:
                          //                             "A/C Open Date",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 05,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           SizedBox(
                          //                             width: 160,
                          //                             child: Utils.text(
                          //                               text: data.boSubStat ==
                          //                                   ""
                          //                                   ? "-"
                          //                                   : data.boSubStat,
                          //                               color:
                          //                               kBlackColor87,
                          //                               fontSize: 13,
                          //                               fontWeight: FontWeight.w600,
                          //                               textOverFlow: TextOverflow.ellipsis
                          //                             ),
                          //                           ),
                          //                           Utils.text(
                          //                             text: data.accOpenDate ==
                          //                                 ""
                          //                                 ? "-"
                          //                                 : data.accOpenDate,
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 13,
                          //                             fontWeight:
                          //                             FontWeight
                          //                                 .w600,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Utils.text(
                          //                             text:
                          //                             "BO DOB",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                           Utils.text(
                          //                             text:
                          //                             "Email Id",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 05,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Utils.text(
                          //                             text:
                          //                             data.boDob,
                          //                             color: kBlackColor87,
                          //                             fontSize: 13,
                          //                             fontWeight:
                          //                             FontWeight
                          //                                 .w600,
                          //                           ),
                          //                           SizedBox(
                          //                             width: 160,
                          //                             child: Utils.text(
                          //                               text:
                          //                               data.emailId,
                          //                               color: kBlackColor87,
                          //                               fontSize: 13,
                          //                               fontWeight: FontWeight.w600,
                          //                               textOverFlow: TextOverflow.ellipsis
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           Row(
                          //                             children: [
                          //                               Utils.text(
                          //                                 text:
                          //                                 "Bank Name",
                          //                                 color:
                          //                                 kBlackColor87,
                          //                                 fontSize: 11,
                          //                               ),
                          //                               const SizedBox(
                          //                                 width: 05,
                          //                               ),
                          //                               GestureDetector(
                          //                                   onTap: () {
                          //                                     showDialog(
                          //                                       context:
                          //                                       context,
                          //                                       builder:
                          //                                           (context) {
                          //                                         return AlertDialog(
                          //                                           backgroundColor: Colors.white,
                          //                                           shape: OutlineInputBorder(
                          //                                               borderRadius: BorderRadius.circular(15),
                          //                                               borderSide: const BorderSide(
                          //                                                   color: Colors.white
                          //                                               )
                          //                                           ),
                          //                                           contentPadding:
                          //                                           const EdgeInsets
                          //                                               .all(
                          //                                               10),
                          //                                           content:
                          //                                           Column(
                          //                                             mainAxisSize:
                          //                                             MainAxisSize.min,
                          //                                             children: [
                          //                                               Utils
                          //                                                   .text(
                          //                                                 text:
                          //                                                 data.bankName,
                          //                                                 color:
                          //                                                 Colors.black,
                          //                                                 fontSize:
                          //                                                 16,
                          //                                                 fontWeight:
                          //                                                 FontWeight.w600,
                          //                                                 textAlign:
                          //                                                 TextAlign.start,
                          //                                               ),
                          //                                             ],
                          //                                           ),
                          //                                         );
                          //                                       },
                          //                                     );
                          //                                   },
                          //                                   child: const Icon(
                          //                                     Icons.info,
                          //                                     color:
                          //                                     Colors.grey,
                          //                                     size: 15,
                          //                                   )),
                          //                             ],
                          //                           ),
                          //                           Utils.text(
                          //                             text:
                          //                             "A/C NO",
                          //                             color:
                          //                             kBlackColor87,
                          //                             fontSize: 11,
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       const SizedBox(
                          //                         height: 05,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment:
                          //                         MainAxisAlignment
                          //                             .spaceBetween,
                          //                         children: [
                          //                           SizedBox(
                          //                             width: 140,
                          //                             child: Utils.text(
                          //                               text:
                          //                               data.bankName,
                          //                               color: kBlackColor87,
                          //                               fontSize: 13,
                          //                               fontWeight: FontWeight.w600,
                          //                               textOverFlow: TextOverflow.ellipsis
                          //                             ),
                          //                           ),
                          //                           Utils.text(
                          //                               text:
                          //                               data.bankAccNo,
                          //                               color: kBlackColor87,
                          //                               fontSize: 13,
                          //                               fontWeight: FontWeight.w600,
                          //                               textOverFlow: TextOverflow.ellipsis
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ) : Column(
            children: [
              const SizedBox(
                height: 200,
              ),
              Center(
                child: Utils.noDataFound(),
              )
            ],
          );
        }
      },
    );
  }

  Widget fetchTradingDetailsWidget() {
    return Expanded(child: FutureBuilder<TradingDetailsResponse>(
      future: futureTradingDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            children: [
              const SizedBox(
                height: 180,
              ),
              Center(
                  child: Lottie.asset('assets/lottie/loading.json',height: 100,width: 100))
            ],
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final tradingDetails = snapshot.data!;
          return tradingDetailsFilteredData.isNotEmpty ? ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: tradingDetailsFilteredData.length,
            itemBuilder: (context, index) {
              final data = tradingDetailsFilteredData[index];
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 05),
                child: InkWell(
                  onTap: () {
                    Get.to(FullTradingDetailsScreen(data: data,));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFEAF9FF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Utils.text(
                                  text: data.clientName == ""
                                      ? "N/A"
                                      : data.clientName,
                                  color: const Color(0xFF37474F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  textOverFlow: TextOverflow.ellipsis,
                                ),
                              ),
                              const Spacer(),
                              Column(
                                children: [
                                  Utils.text(
                                    text: "Company Code",
                                    color: const Color(0xFF4A5568)
                                        .withOpacity(0.70),
                                    fontSize: 10,
                                  ),
                                  Utils.text(
                                      text: data.companyCode == ""
                                          ? "N/A"
                                          : data.companyCode,
                                      color: const Color(0xFF37474F),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Utils.text(
                                      text: "Client ID",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.clientId,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.text(
                                      text: "A/C No",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.bankAcno,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Utils.text(
                                      text: "Dp Id",
                                      fontSize: 10,
                                      color: const Color(0xFF4A5568)),
                                  Utils.text(
                                      text: data.dpId,
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
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
          ) : Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Utils.noDataFound(),
              )
            ],
          );
        } else {
          return const Center(child: Text('No data found'));
        }
      },
    ));
  }
}

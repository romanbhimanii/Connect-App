import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/Providers/ClientDetailsProvider/ClientDetailsProvider.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeTaxAccountBackOfficeScreen extends StatefulWidget {
  const IncomeTaxAccountBackOfficeScreen({super.key});

  @override
  State<IncomeTaxAccountBackOfficeScreen> createState() =>
      _IncomeTaxAccountBackOfficeScreenState();
}

class _IncomeTaxAccountBackOfficeScreenState
    extends State<IncomeTaxAccountBackOfficeScreen> {
  final ConnectivityService connectivityService = ConnectivityService();
  bool isOpenClientDetails = false;
  final TextEditingController clientCodeController = TextEditingController();
  List<bool> isDownloading = List.filled(6, false);
  int? year;
  Offset tapPosition = Offset.zero;

  List<String> title = [
    "Ledger",
    "Equity",
    "Future Option",
    "Currency Derivatives",
    "PNL Summary",
    "Holding",
  ];

  List<String> icons = [
    "assets/icons/ProfileIconAccount.svg",
    "assets/icons/BankDetailsIconAccount.svg",
    "assets/icons/DpDetailsIconAccount.svg",
    "assets/icons/NomineeDetailsIconAccount.svg",
    "assets/icons/GlobalSummaryIcon.svg",
    "assets/icons/payInIcon.svg"
  ];

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    loadYear();
  }

  void storePosition(TapDownDetails details) {
    tapPosition = details.globalPosition;
  }

  void showPopupMenu(
      BuildContext context, int index, String? clientCode) async {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (overlay == null) {
      return;
    }
    final position = RelativeRect.fromRect(
      Rect.fromPoints(tapPosition, tapPosition),
      Offset.zero & overlay.size,
    );

    final value = await showMenu<String>(
      context: context,
      position: position,
      color: Colors.white,
      items: <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'PDF',
          child: Row(
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "PDF",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'CSV',
          child: Row(
            children: [
              Icon(
                Icons.table_chart,
                color: Colors.black,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "CSV",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );

    if (value == 'CSV') {
      await handleDownload(
          clientCode: clientCode, index: index, downloadType: "Excel");
    } else {
      await handleDownload(
          clientCode: clientCode, index: index, downloadType: "PDF");
    }
  }

  void loadYear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now();
    String reportYear = prefs.getString('backOfficeYear') ?? "${time.year}";
    year = int.parse(reportYear);
  }

  Future<void> handleDownload(
      {int? index, String? clientCode, String? downloadType}) async {
    setState(() {
      isDownloading[index ?? 0] = true;
    });
    try {
      await BackOfficeApiService().downloadProfitAndLossAccountBackOffice(
          token: Appvariablesbackoffice.token,
          context: context,
          year: year.toString(),
          type: index == 0
              ? "ledger"
              : index == 1
                  ? "equity"
                  : index == 2
                      ? "future_option"
                      : index == 3
                          ? "currency_derivatives"
                          : index == 4
                              ? "pnl_summary"
                              : index == 5
                                  ? "holding"
                                  : "",
          downloadType: downloadType,
          clientCode: clientCode);
    } finally {
      setState(() {
        isDownloading[index ?? 0] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ClientDetailProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
            text: "Profit And Loss",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    isOpenClientDetails = !isOpenClientDetails;
                  });
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFE4E4E4).withOpacity(0.3),
                    border: Border.all(
                      color: Colors.blueGrey.shade600.withOpacity(0.15),
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Row(
                      children: [
                        Utils.text(
                            text: 'Enter Details',
                            fontSize: 12,
                            color: const Color(0xFF91919F)),
                        const Spacer(),
                        Icon(
                          isOpenClientDetails
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFF91919F),
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isOpenClientDetails,
                child: const SizedBox(
                  height: 10,
                ),
              ),
              Visibility(
                visible: isOpenClientDetails,
                child: TextFormField(
                  controller: clientCodeController,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  onEditingComplete: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isOpenClientDetails = !isOpenClientDetails;
                    });
                    provider.findClientByCode(clientCodeController.text);
                  },
                  style: GoogleFonts.inter(
                    color: kBlackColor,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: "Enter Client Code",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 12, color: const Color(0xFF91919F)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blueGrey.shade600.withOpacity(0.15),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
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
              ),
              const SizedBox(
                height: 10,
              ),
              if (provider.selectedClient != null)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blueGrey.shade600.withOpacity(0.15),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              height: 55,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFE4E4E4).withOpacity(0.3),
                                border: Border.all(
                                  color: Colors.blueGrey.shade600
                                      .withOpacity(0.15),
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Utils.text(
                                        text: provider.selectedClient?.boName ??
                                            'Client Not Found',
                                        fontSize: 12,
                                        color: const Color(0xFF91919F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (provider.selectedClient != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFE4E4E4)
                                        .withOpacity(0.3),
                                    border: Border.all(
                                      color: Colors.blueGrey.shade600
                                          .withOpacity(0.15),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                      child: Utils.text(
                                        text:
                                            provider.selectedClient?.clientId ??
                                                'Client Not Found',
                                        fontSize: 12,
                                        color: const Color(0xFF91919F),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFE4E4E4)
                                        .withOpacity(0.3),
                                    border: Border.all(
                                      color: Colors.blueGrey.shade600
                                          .withOpacity(0.15),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Center(
                                        child: Utils.text(
                                          text: provider
                                                  .selectedClient?.boPanNo ??
                                              'Client Not Found',
                                          fontSize: 12,
                                          color: const Color(0xFF91919F),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: title.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTapDown: storePosition,
                          onTap: () async {
                            index == 1 || index == 2 || index == 3
                                ? showPopupMenu(context, index,
                                    provider.selectedClient?.clientId ?? '')
                                : await handleDownload(
                                    index: index,
                                    downloadType: "PDF",
                                    clientCode:
                                        provider.selectedClient?.clientId ??
                                            '');
                          },
                          child: Container(
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4E4E4).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color:
                                    Colors.blueGrey.shade600.withOpacity(0.15),
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    icons[index],
                                    height: 24,
                                    width: 24,
                                    color: const Color(0xFF91919F),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Utils.text(
                                      text: title[index],
                                      fontSize: 12,
                                      color: const Color(0xFF91919F),
                                    ),
                                  ),
                                  if (isDownloading[index])
                                    const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.download,
                                      color: Color(0xFF91919F),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Utils.text(
                      text: 'No client details available',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF91919F),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

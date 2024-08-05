import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/ConnectivityService.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IncomeTaxAccountBackOfficeScreen extends StatefulWidget {
  const
  IncomeTaxAccountBackOfficeScreen({super.key});

  @override
  State<IncomeTaxAccountBackOfficeScreen> createState() => _IncomeTaxAccountBackOfficeScreenState();
}

class _IncomeTaxAccountBackOfficeScreenState extends State<IncomeTaxAccountBackOfficeScreen> {

  final ConnectivityService connectivityService = ConnectivityService();
  bool isOpenClientDetails = false;
  final TextEditingController clientCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectivityService.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        connectivityService.showNoInternetDialog(context);
      }
    });
    fetchDpDetails();
  }

  Future<void> fetchDpDetails() async {
    Appvariablesbackoffice.futureDPDetails = BackOfficeApiService()
        .fetchDPDetails(token: Appvariablesbackoffice.token);
    Appvariablesbackoffice.futureDPDetails?.then((response) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        color: Color(0xFF91919F),
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
                  fetchDpDetails();
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
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blueGrey.shade600.withOpacity(0.15),
                  width: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

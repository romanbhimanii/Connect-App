// ignore_for_file: must_be_immutable

import 'package:connect/Models/BankDetailsModel/BankDetailsModel.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PayInScreen extends StatefulWidget {
  BankDetailsResponse? bankDetails;
  PayInScreen({super.key, this.bankDetails});

  @override
  State<PayInScreen> createState() => _PayInScreenState();
}

class _PayInScreenState extends State<PayInScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedPaymentMethod = 'Net Banking';
  String? selectedBankAccount;
  String? selectedExchange;
  TextEditingController upiController = TextEditingController();
  final List<String> items = [
    "Equity",
    "Commodity"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color(0x44000000).withOpacity(0.0),
        centerTitle: true,
        title: Utils.text(
          text: "Add Balance",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold
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
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SvgPicture.asset("assets/icons/PayInBackground.svg", fit: BoxFit.cover),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Utils.text(
                      text: "How Much?",
                      color: const Color(0xFF0F3F62),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Utils.text(
                      text: "₹5,23,451",
                      color: const Color(0xFF0F3F62),
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                            child: Utils.text(
                              text: "Select Payment Method",
                              color: const Color(0xFF0F3F62),
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = "Net Banking";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedPaymentMethod == "Net Banking" ? const Color(0xFFEAF9FF) : const Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset("assets/icons/creditCardIcon.svg"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 13,
                                    ),
                                    Utils.text(
                                      text: "Net Banking",
                                      color: selectedPaymentMethod == "Net Banking" ? const Color(0xFF0F3F62) : const Color(0xFF888888),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const Spacer(),
                                    Radio<String>(
                                      value: 'Net Banking',
                                      groupValue: selectedPaymentMethod,
                                      activeColor: const Color(0xFF0F3F62),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPaymentMethod = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = "UPI Id";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedPaymentMethod == "UPI Id" ? const Color(0xFFEAF9FF) : const Color(0xFFFAFAFA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Image(image: AssetImage("assets/icons/UpiIcon.png")),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 13,
                                    ),
                                    Utils.text(
                                      text: "UPI Id",
                                      color: selectedPaymentMethod == "UPI Id" ? const Color(0xFF0F3F62) : const Color(0xFF888888),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    const Spacer(),
                                    Radio<String>(
                                      value: 'UPI Id',
                                      groupValue: selectedPaymentMethod,
                                      activeColor: const Color(0xFF0F3F62),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPaymentMethod = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.keyboard_arrow_down_rounded,color: Color(0xFF91919F),size: 40,),
                                iconSize: 25,
                              ),
                              hint: Utils.text(
                                  text: "Select Bank",
                                  color: const Color(0xFF91919F),
                                  fontSize: 16,),
                              items: [
                                if(widget.bankDetails?.data.bankName.entries != null || widget.bankDetails?.data.bankAccountNumber.entries != null)...{
                                  for(final nameEntry in Map<String, String>.fromEntries(widget.bankDetails!.data.bankName.entries).entries)...{
                                    if(Map<String, String>.fromEntries(widget.bankDetails!.data.bankAccountNumber.entries)[nameEntry.key] != null)...{
                                      DropdownMenuItem<String>(child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Utils.text(
                                          text: "${nameEntry.value}-${Map<String, String>.fromEntries(widget.bankDetails!.data.bankAccountNumber.entries)[nameEntry.key]}",
                                          color: const Color(0xFF4A5568),
                                          fontSize: 15
                                        ),
                                      ),)
                                    }
                                  }
                                }
                              ],
                              value: selectedBankAccount,
                              onChanged: (String? value) {
                                setState(() {
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 04),
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFF1F1FA)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.keyboard_arrow_down_rounded,color: Color(0xFF91919F),size: 40,),
                                iconSize: 25,
                              ),
                              hint: Utils.text(
                                  text: "Select Exchange",
                                  color: const Color(0xFF91919F),
                                  fontSize: 16,),
                              items: items
                                  .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Utils.text(
                                      text: item,
                                      color: const Color(0xFF4A5568),
                                      fontSize: 15,),
                                ),
                              ))
                                  .toList(),
                              value: selectedExchange,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedExchange = value;
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 04),
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFF1F1FA)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: selectedPaymentMethod == "UPI Id",
                            child: TextFormField(
                              controller: upiController,
                              textInputAction: TextInputAction.done,
                              cursorColor: const Color.fromRGBO(27, 82, 52, 1.0),
                              style: GoogleFonts.inter(
                                color: const Color(0xFF4A5568),
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: "Enter UPI Id",
                                hintStyle: GoogleFonts.poppins(
                                    color: const Color(0xFF91919F),
                                    fontSize: 16,
                                ),
                                fillColor: const Color(0xFFF1F1FA).withOpacity(0.1),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color:Color(0xFFF1F1FA),
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF1F1FA),
                                    width: 1.0,
                                  ),
                                ),
                              ),
                              onTapOutside: (PointerDownEvent event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Upi Id';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Utils.gradientButton(
                            message: "Pay Using $selectedPaymentMethod"
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

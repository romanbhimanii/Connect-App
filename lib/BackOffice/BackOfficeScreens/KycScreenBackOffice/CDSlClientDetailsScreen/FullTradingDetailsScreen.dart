// ignore_for_file: must_be_immutable

import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsTradingDetailsModel/CDSLClientDetailsTradingDetailsModel.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';

class FullTradingDetailsScreen extends StatefulWidget {
  TradingDetail data;
  FullTradingDetailsScreen({super.key, required this.data});

  @override
  State<FullTradingDetailsScreen> createState() => _FullTradingDetailsScreenState();
}

class _FullTradingDetailsScreenState extends State<FullTradingDetailsScreen> {
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
                  border: Border.all(color: const Color(0xFF292D32))
              ),
              child: const Center(
                child: Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF292D32),size: 18,),
              ),
            ),
          ),
        ),
        title: Utils.text(
            text: widget.data.clientName,
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Utils.text(
                            text: widget.data.clientName,
                            color: kBlackColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 15,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(05),
                              color: Colors.deepPurpleAccent.shade700
                                  .withOpacity(0.1)),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Utils.text(
                              text: widget.data.dpId,
                              color: Colors.deepPurple, fontSize: 09,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(05),
                          border: Border.all(
                              color: Colors.grey.shade800.withOpacity(0.2))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Company Code",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "MICR Code",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.data.companyCode == "" || widget.data.companyCode == "null" ? "N/A" : widget.data.companyCode,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.data.micrCode == "" || widget.data.micrCode == "null" ? "N/A" : widget.data.micrCode,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Bank A/C No",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Bank Name",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                    text: widget.data.bankAcno == "" || widget.data.bankAcno == "null" ? "N/A" : widget.data.bankAcno,
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600
                                ),
                                Utils.text(
                                  text: widget.data.bankName == "" || widget.data.bankName == "null" ? "N/A" : widget.data.bankName,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text:
                                  "Client Dp Code",
                                  color:
                                  kBlackColor87,
                                  fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Dp Code",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Utils.text(
                                      text: widget.data.clientDpCode == "" || widget.data.clientDpCode == "null" ? "N/A" : widget.data.clientDpCode,
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      textOverFlow: TextOverflow.ellipsis
                                  ),
                                ),
                                Utils.text(
                                  text: widget.data.dpId == "" || widget.data.dpId == "null" ? "N/A" : widget.data.dpId,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Dp Name",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Client Id",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.data.dpName == "" || widget.data.dpName == "null" ? "N/A" : widget.data.dpName,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.data.clientId == "" || widget.data.clientId == "null" ? "N/A" : widget.data.clientId,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: "Remeshire Group",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Remeshire Name",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.data.remeshireGroup == "" || widget.data.remeshireGroup == "null" ? "N/A" : widget.data.remeshireGroup,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.data.remeshireName == "" || widget.data.remeshireName == "null" ? "N/A" : widget.data.remeshireName,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text:  "Mobile No",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Email",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.data.mobileNo == "" || widget.data.mobileNo == "null" ? "N/A" : widget.data.mobileNo,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.data.clientIdMail == "" || widget.data.clientIdMail == "null" ? "N/A" : widget.data.clientIdMail,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Utils.text(
                                  text: "Pan No",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              children: [
                                Utils.text(
                                  text: widget.data.panNo == "" || widget.data.panNo == "null" ? "N/A" : widget.data.panNo,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Utils.text(
                                  text: "Address",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(child: Utils.text(
                                  text: "${widget.data.clResiAdd1}, ${widget.data.clResiAdd2}, ${widget.data.clResiAdd3}. ",
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),)
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: must_be_immutable

import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsDpDetailsModel/CDSLClientDetailsDpDetailsModel.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';

class FullDpDetailScreen extends StatefulWidget {
  DPDetails dpDetails;
  FullDpDetailScreen({super.key, required this.dpDetails});

  @override
  State<FullDpDetailScreen> createState() => _FullDpDetailScreenState();
}

class _FullDpDetailScreenState extends State<FullDpDetailScreen> {
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
            text: widget.dpDetails.firstHoldName,
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
                            text: widget.dpDetails.firstHoldName,
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
                              text: widget.dpDetails.boId,
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
                                  text: "Branch Code",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Trading Client Id",
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
                                  text: widget.dpDetails.branchCode == "" || widget.dpDetails.branchCode == "null" ? "N/A" : widget.dpDetails.branchCode,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.tradingClientId == "" || widget.dpDetails.tradingClientId == "null" ? "N/A" : widget.dpDetails.tradingClientId,
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
                                  text: "Bo ID",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "ITPA No",
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
                                    text: widget.dpDetails.boId == "" || widget.dpDetails.boId == "null" ? "N/A" : widget.dpDetails.boId,
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600
                                ),
                                Utils.text(
                                  text: widget.dpDetails.itpaNo == "" || widget.dpDetails.itpaNo == "null" ? "N/A" : widget.dpDetails.itpaNo,
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
                                Row(
                                  children: [
                                    Utils.text(
                                      text:
                                      "BO Sub Status",
                                      color:
                                      kBlackColor87,
                                      fontSize: 11,
                                    ),
                                    const SizedBox(
                                      width: 05,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context:
                                            context,
                                            builder:
                                                (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: const BorderSide(
                                                        color: Colors.white
                                                    )
                                                ),
                                                contentPadding:
                                                const EdgeInsets
                                                    .all(
                                                    10),
                                                content:
                                                Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    Utils
                                                        .text(
                                                      text:
                                                      widget.dpDetails.boSubStat,
                                                      color:
                                                      Colors.black,
                                                      fontSize:
                                                      16,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      textAlign:
                                                      TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.info,
                                          color:
                                          Colors.grey,
                                          size: 15,
                                        )),
                                  ],
                                ),
                                Utils.text(
                                  text: "A/C Status",
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
                                    text: widget.dpDetails.boSubStat == "" || widget.dpDetails.boSubStat == "null" ? "N/A" : widget.dpDetails.boSubStat,
                                    color: kBlackColor87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    textOverFlow: TextOverflow.ellipsis
                                  ),
                                ),
                                Utils.text(
                                  text: widget.dpDetails.accStat == "" || widget.dpDetails.accStat == "null" ? "N/A" : widget.dpDetails.accStat,
                                  color: widget.dpDetails.accStat != "Active" ? Colors.red : Colors.green,
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
                                  text: "A/C Open Date",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Bo Dob",
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
                                  text: widget.dpDetails.accOpenDate == "" || widget.dpDetails.accOpenDate == "null" ? "N/A" : widget.dpDetails.accOpenDate,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.boDob == "" || widget.dpDetails.boDob == "null" ? "N/A" : widget.dpDetails.boDob,
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
                                  text: "Mobile Number",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Email Id",
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
                                  text: widget.dpDetails.mobileNum == "                 " || widget.dpDetails.mobileNum == "null" ? "N/A" : widget.dpDetails.mobileNum,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.emailId == "" || widget.dpDetails.emailId == "null" ? "N/A" : widget.dpDetails.emailId,
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
                                  text:  "Bank Name",
                                  color: kBlackColor87, fontSize: 11,
                                ),
                                Utils.text(
                                  text: "Bank A/C NO",
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
                                  text: widget.dpDetails.bankName == "" || widget.dpDetails.bankName == "null" ? "N/A" : widget.dpDetails.bankName,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.bankAccNo == "" || widget.dpDetails.bankAccNo == "null" ? "N/A" : widget.dpDetails.bankAccNo,
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
                                  text: "Second Holder Name",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "Pan No(Second Holder)",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.dpDetails.secondHoldName == "" || widget.dpDetails.secondHoldName == "null" ? "N/A" : widget.dpDetails.secondHoldName,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.panNo2 == "" || widget.dpDetails.panNo2 == "null" ? "N/A" : widget.dpDetails.panNo2,
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
                                  text: "Third Holder Name",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "Pan No(Third Holder)",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.dpDetails.thirdHoldName == "" || widget.dpDetails.thirdHoldName == "null" ? "N/A" : widget.dpDetails.thirdHoldName,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.panNo3 == "" || widget.dpDetails.panNo3 == "null" ? "N/A" : widget.dpDetails.panNo3,
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
                                Row(
                                  children: [
                                    Utils.text(
                                      text:
                                      "POA Name",
                                      color:
                                      kBlackColor87,
                                      fontSize: 11,
                                    ),
                                    const SizedBox(
                                      width: 05,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context:
                                            context,
                                            builder:
                                                (context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: const BorderSide(
                                                        color: Colors.white
                                                    )
                                                ),
                                                contentPadding:
                                                const EdgeInsets
                                                    .all(
                                                    10),
                                                content:
                                                Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    Utils
                                                        .text(
                                                      text:
                                                      widget.dpDetails.poaName,
                                                      color:
                                                      Colors.black,
                                                      fontSize:
                                                      16,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      textAlign:
                                                      TextAlign.start,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.info,
                                          color:
                                          Colors.grey,
                                          size: 15,
                                        )),
                                  ],
                                ),
                                Utils.text(
                                  text: "MICR Code",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: Utils.text(
                                      text: widget.dpDetails.poaName == "" || widget.dpDetails.poaName == "null" ? "N/A" : widget.dpDetails.poaName,
                                      color: kBlackColor87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      textOverFlow: TextOverflow.ellipsis
                                  ),
                                ),
                                Utils.text(
                                  text: widget.dpDetails.micrCode == "" || widget.dpDetails.micrCode == "null" ? "N/A" : widget.dpDetails.micrCode,
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
                                  text: "POA Enabled",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "Nominee Name",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.dpDetails.poaEnabled == "" || widget.dpDetails.poaEnabled == "null" ? "N/A" : widget.dpDetails.poaEnabled,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.nominName == "" || widget.dpDetails.nominName == "null" ? "N/A" : widget.dpDetails.nominName,
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
                                  text: "Risk Category",
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                                Utils.text(
                                  text: "Guardian Pan NO",
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.text(
                                  text: widget.dpDetails.riskCategory == "" || widget.dpDetails.riskCategory == "null" ? "N/A" : widget.dpDetails.riskCategory,
                                  color: kBlackColor87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                Utils.text(
                                  text: widget.dpDetails.guardianPanNo == "" || widget.dpDetails.guardianPanNo == "null" ? "N/A" : widget.dpDetails.guardianPanNo,
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
                                  text: "${widget.dpDetails.boAdd1}, ${widget.dpDetails.boAdd2}, ${widget.dpDetails.boAdd3}, ${widget.dpDetails.boAddCity}, ${widget.dpDetails.boAddState}, ${widget.dpDetails.boAddCountry} - ${widget.dpDetails.boAddPin}. ",
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

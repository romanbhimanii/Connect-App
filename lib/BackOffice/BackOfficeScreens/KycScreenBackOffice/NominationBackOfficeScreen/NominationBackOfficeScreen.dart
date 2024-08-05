import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class NominationBackOfficeScreen extends StatefulWidget {
  const NominationBackOfficeScreen({super.key});

  @override
  State<NominationBackOfficeScreen> createState() =>
      _NominationBackOfficeScreenState();
}

class _NominationBackOfficeScreenState
    extends State<NominationBackOfficeScreen> {

  final _formKey = GlobalKey<FormState>();
  String link = "";
  final TextEditingController clientCodeController = TextEditingController();

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
            text: "Nomination Link Generator",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
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
              },
              style: GoogleFonts.inter(
                color: kBlackColor,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Enter Client Code",
                hintStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF91919F)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.blueGrey.shade600.withOpacity(0.15),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
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
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFE4E4E4).withOpacity(0.3),
                  border: Border.all(
                      color: Colors.blueGrey.shade800.withOpacity(0.2))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(child: Utils.text(
                        text: link == "" ? "Link" : link,
                        fontSize: link == "" ? 12 : 15,
                        textOverFlow: TextOverflow.ellipsis,
                        color: link == "" ? const Color(0xFF91919F) : kBlackColor))
                  ],
                ),
              ),
            ),
            Visibility(
              visible: link != "",
              child: const SizedBox(
              height: 15,
            ),),
            Visibility(
              visible: link != "",
              child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                          text: link),
                    );
                    Utils.toast(
                        msg:
                        "Link Copied into ClipBoard");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(08),
                        border: Border.all(
                            color: Colors.blueGrey.shade800.withOpacity(0.3)
                        )),
                    child: const Padding(
                      padding: EdgeInsets.all(08),
                      child: Icon(Icons.copy,color: Colors.grey,size: 20,),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Share.share(link);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(08),
                        border: Border.all(
                            color: Colors.blueGrey.shade800.withOpacity(0.3)
                        )),
                    child: const Padding(
                      padding: EdgeInsets.all(08),
                      child: Image(image: AssetImage("assets/BackOffice/Icons/whatsapp.png"),height: 20,width: 20,color: Colors.grey,),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    final Email email = Email(
                      body: link,
                      subject: 'Nomination Link',
                      recipients: ['example@example.com'],
                      isHTML: false,
                    );

                    try {
                      await FlutterEmailSender.send(email);
                    } catch (error) {
                      Utils.toast(msg: error.toString());
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(08),
                        border: Border.all(
                            color: Colors.blueGrey.shade800.withOpacity(0.3)
                        )),
                    child: const Padding(
                      padding: EdgeInsets.all(08),
                      child: Icon(Icons.mail,color: Colors.grey,size: 20,),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async{
                if(_formKey.currentState!.validate()){
                  Utils.showLoadingDialogue(context);
                  link = await BackOfficeApiService().fetchNomineeDetails(
                    clientCode: clientCodeController.text,
                    token: Appvariablesbackoffice.token,
                  );
                  setState(() {});
                }
              },
              child: Utils.gradientButton(message: "Create Link"),
            )
          ],
        ),
      ),)
    );
  }
}

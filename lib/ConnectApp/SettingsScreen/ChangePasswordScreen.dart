
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Utils/AppVariables.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  dynamic arguments = Get.arguments;
  String clientCode = "";
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Utils.text(
                        text: "Change Password?",
                        color: kTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Utils.text(
                  text: 'Please fill out your current password as well as new password in below fields.',
                  fontSize: 13,
                  color: Colors.black54,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Utils.text(
                        text: "Current Password",
                        color: const Color(0xFF001533),
                        fontSize: 14
                    )
                  ],
                ),
                const SizedBox(
                  height: 05,
                ),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  onSaved: (email) {},
                  style: GoogleFonts.inter(
                    color: kBlackColor,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Your Current Password",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 12
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:Colors.blueGrey.shade600.withOpacity(0.15),
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
                      return 'Please Enter Your Current Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Utils.text(
                        text: "New Password",
                        color: const Color(0xFF001533),
                        fontSize: 14
                    )
                  ],
                ),
                const SizedBox(
                  height: 05,
                ),
                TextFormField(
                  controller: newPassController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  onSaved: (email) {},
                  style: GoogleFonts.inter(
                    color: kBlackColor,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Your New Password",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 12
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:Colors.blueGrey.shade600.withOpacity(0.15),
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
                      return 'Please enter your New Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Utils.text(
                        text: "Confirm Password",
                        color: const Color(0xFF001533),
                        fontSize: 14
                    )
                  ],
                ),
                const SizedBox(
                  height: 05,
                ),
                TextFormField(
                  controller: confirmPassController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: Colors.black,
                  onSaved: (email) {},
                  style: GoogleFonts.inter(
                    color: kBlackColor,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Your Confirm Password",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 12
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:Colors.blueGrey.shade600.withOpacity(0.15),
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
                      return 'Please enter your Confirm Password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if(_formKey.currentState!.validate()){
                      if(newPassController.text == confirmPassController.text){
                        Utils.showLoadingDialogue(context);
                        ApiServices().updatePassword(Appvariables.token, otpController.text, confirmPassController.text);
                      }else{
                        Utils.toast(msg: "Password Doesn't Match");
                      }
                    }
                  },
                  child: Utils.gradientButton(
                      message: "Change Password",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

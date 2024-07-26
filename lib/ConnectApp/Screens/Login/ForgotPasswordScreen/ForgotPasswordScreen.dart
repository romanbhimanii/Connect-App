import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Screens/Login/ForgotPasswordScreen/ResetPasswordScreen.dart';
import 'package:connect/ConnectApp/Screens/Login/login_screen.dart';
import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Forgotpasswordscreen extends StatefulWidget {
  const Forgotpasswordscreen({super.key});

  @override
  State<Forgotpasswordscreen> createState() => _ForgotpasswordscreenState();
}

class _ForgotpasswordscreenState extends State<Forgotpasswordscreen> {

  final TextEditingController forgotPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        text: "Forgot Password?",
                        color: kTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 27
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Utils.text(
                  text: 'Please enter your Branch Code that you used to register and we will send you an email with an OTP.',
                  fontSize: 13,
                  color: Colors.black54,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Utils.text(
                        text: "Client Code",
                        color: const Color(0xFF001533),
                        fontSize: 14
                    )
                  ],
                ),
                const SizedBox(
                  height: 05,
                ),
                TextFormField(
                  controller: forgotPasswordController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: const Color.fromRGBO(27, 82, 52, 1.0),
                  onSaved: (email) {},
                  style: GoogleFonts.inter(
                    color: kBlackColor,
                  ),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: "Enter Your Client Code",
                    hintStyle: GoogleFonts.inter(
                        fontSize: 12,
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
                      return 'Please enter your Client Code';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Utils.text(
                      text: "Do You Remember The Password? ",
                      color: const Color(0xFF001533),
                      fontSize: 12
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(const LoginScreen());
                      },
                      child: Utils.text(
                        text: "Login here",
                        color: kTextColor
                      ),
                    )
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    if(_formKey.currentState!.validate()){
                      Utils.showLoadingDialogue(context);
                      var response = await ApiServices().forgotPassword(clientCode: forgotPasswordController.text,context: context);
                      if(response != null){
                        Get.to(const Resetpasswordscreen(),arguments: ({
                          'clientId' : forgotPasswordController.text
                        }));
                      }
                    }
                  },
                  child: Utils.gradientButton(
                    message: "Send Otp"
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

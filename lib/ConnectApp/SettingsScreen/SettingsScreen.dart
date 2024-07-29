
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Screens/MyAccountScreen/MyAccountScreen.dart';
import 'package:connect/ConnectApp/SettingsScreen/ChangePasswordScreen.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: Utils.text(
            text: "Settings",
            color: const Color(0xFF00A9FF),
            fontSize: 20,
            fontWeight: FontWeight.bold),
        leadingWidth: 50,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Utils.text(
                  text: "Account",
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                  return const Myaccountscreen();
                },),);
              },
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Image(image: AssetImage("assets/SettingIcons/ProfileIcon.png"),height: 23,width: 23,),
                    const SizedBox(
                      width: 10,
                    ),
                    Utils.text(
                      text: "Profile"
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,size: 20,)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            InkWell(
              onTap: () {
                Get.to(const ChangePasswordScreen());
              },
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Image(image: AssetImage("assets/SettingIcons/ChangePasswordIcon.png"),height: 23,width: 23,),
                    const SizedBox(
                      width: 10,
                    ),
                    Utils.text(
                        text: "Change Password"
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,size: 20,)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            InkWell(
              onTap: () {
                Utils.showLoadingDialogue(context);
                ApiServices().logoutUser(context: context);
              },
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Image(image: AssetImage("assets/SettingIcons/LogOut.png"),height: 23,width: 23,),
                    const SizedBox(
                      width: 10,
                    ),
                    Utils.text(
                      text: "Logout"
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,size: 20,)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Utils.text(
                  text: "Utils",
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                _launchInAppWithBrowserOptions(Uri.parse("https://www.arhamshare.com/statics/terms-of-use.aspx"));
              },
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Image(image: AssetImage("assets/SettingIcons/TermsAndConditionIcon.png"),height: 23,width: 23,),
                    const SizedBox(
                      width: 10,
                    ),
                    Utils.text(
                      text: "Terms & Conditions",
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,size: 20,),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            InkWell(
              onTap: () {
                Share.share('check Out This App on Play Store! https://play.google.com/store/apps/details?id=com.connect-app.arham&hl=en');
              },
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Image(image: AssetImage("assets/SettingIcons/ShareIcon.png"),height: 23,width: 23,),
                    const SizedBox(
                      width: 10,
                    ),
                    Utils.text(
                      text: "Share App",
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios,size: 20,),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            SizedBox(
              height: 40,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Image(image: AssetImage("assets/SettingIcons/AboutUsIcon.png"),height: 23,width: 23,),
                  const SizedBox(
                    width: 10,
                  ),
                  Utils.text(
                    text: "About Us",
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios,size: 20,),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Utils.text(
                text: "Developed By ANVTech",
              ), Utils.text(
                text: "Version 1.0.0",
              ),],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchInAppWithBrowserOptions(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
      browserConfiguration: const BrowserConfiguration(showTitle: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

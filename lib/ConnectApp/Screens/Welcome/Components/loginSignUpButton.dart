// ignore_for_file: must_be_immutable

import 'package:connect/ConnectApp/Screens/Login/login_screen.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/material.dart';

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen(appName: "connect",);
                },
              ),
            );
          },
          child: Utils.gradientButton(
            message: "Connect App"
          )
        ),
        const SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginScreen(appName: "backoffice",);
                },
              ),
            );
          },
          child: Utils.gradientButton(
            message: "Back Office"
          )
        ),
      ],
    );
  }
}
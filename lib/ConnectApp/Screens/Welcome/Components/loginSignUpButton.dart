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
                  return const LoginScreen();
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
            Utils.toast(msg: "Back Office in Development!");
          },
          child: Utils.gradientButton(
            message: "Back Office"
          )
        ),
      ],
    );
  }
}
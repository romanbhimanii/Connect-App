import 'package:connect/Screens/Signup/SignUpScreen.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:flutter/material.dart';
import '../../Login/login_screen.dart';

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
            message: "LOGIN"
          )
        ),
      ],
    );
  }
}
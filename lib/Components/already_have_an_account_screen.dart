// ignore_for_file: use_super_parameters

import 'package:connect/Utils/Utils.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Utils.text(
          text: login ? "Don’t have an Account ? " : "Already have an Account ? ",
          color: Colors.black,
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Utils.text(
            text: login ? "Sign Up" : "Sign In",
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        )
      ],
    );
  }
}
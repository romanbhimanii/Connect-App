import 'package:connect/Utils/Constant.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: Image(image: AssetImage("assets/images/AppIcon.png"),height: 150,width: 150,),
            ),
            Spacer(),
          ],
        ),
        Utils.text(
            text: "CONNECT ARHAM",
            fontWeight: FontWeight.bold,
            fontSize: 19
        ),
        Utils.text(
            text: "Sign in to stay connected with us",
            fontSize: 14
        ),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}

import 'package:connect/ConnectApp/Utils/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';


class Utils {

  static Widget text(
      {String? text,
      FontWeight? fontWeight,
      double? fontSize,
      Color? color,
      TextAlign? textAlign,
      TextOverflow? textOverFlow,
      int? maxLines}) {
    return Text(
      text ?? "",
      style: GoogleFonts.inter(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color,
      ),
      textAlign: textAlign,
      overflow: textOverFlow,
      maxLines: maxLines,
    );
  }

  static showLoadingDialogue(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

  static toast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kBlackColor,
      textColor: Colors.white,
      fontSize: 13.0,
    );
  }

  static Widget gradientButton({String? message}){
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: [
            Color(0xFF007FEB),
            Color(0xFF00A9FF),
          ],),
      ),
      child: Center(
        child: Utils.text(
            text: message,
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget noDataFound(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset("assets/icons/NoDataFound.svg"),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Utils.text(
              text: "No data Found!",
              color: kBlackColor,
              fontSize: 17,
          ),
        ),
      ],
    );
  }
}

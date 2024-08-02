import 'dart:convert';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsDpDetailsModel/CDSLClientDetailsDpDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsTradingDetailsModel/CDSLClientDetailsTradingDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/DashBoardDetailsModelBackOffice/DashBoardDetailsModelBackOffice.dart';
import 'package:connect/BackOffice/BackOfficeModels/LoginModelBackOffice/LoginModelBackOffice.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/BackOffice/Utils/BottomNavBar.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BackOfficeApiService {
  String baseUrl = "http://192.168.130.8:2020";

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Appvariablesbackoffice.token = prefs.getString('backOfficeToken') ?? "";
  }

  Future<String> loadYear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now();
    String year = prefs.getString('backOfficeYear') ?? "${time.year}";
    if (year == "") {
      Appvariablesbackoffice.year = "${time.year}-${time.year + 1}";
    } else if (year == "2024") {
      Appvariablesbackoffice.year = "2023-2024";
    } else if (year == "2023") {
      Appvariablesbackoffice.year = "2022-2023";
    } else if (year == "2022") {
      Appvariablesbackoffice.year = "2021-2022";
    } else if (year == "2021") {
      Appvariablesbackoffice.year = "2020-2021";
    }
    return Appvariablesbackoffice.year;
  }

  Future<void> backOfficeLogin(
      {String? branchCode,
      String? password,
      String? userType,
      required BuildContext context}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apb/v1/user/login'),
        headers: <String, String>{
          'accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'branch_code': branchCode ?? "",
          'user_type': userType ?? "",
          'password': password ?? "",
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final loginResponse = LoginModelBackOffice.fromJson(responseData);
        LoginModelBackOffice.fromJson(responseData);
        Utils.toast(msg: "Login Successfully");
        if (kDebugMode) {
          debugPrint('Token: ${loginResponse.data?.token}');
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Appvariablesbackoffice.branchCode = loginResponse.data?.branchCode;
        await prefs.remove('backOfficeToken');
        await prefs.setString(
            'backOfficeToken', loginResponse.data?.token ?? "");
        loadToken();
        Get.back();
        Get.offAll(const BottomNavBar());
      } else {
        Get.back();
        Utils.toast(msg: "Login failed! Please try again.");
      }
    } catch (e) {
      Get.back();
      Utils.toast(msg: "Internal Server Error!");
    }
  }

  Future<dynamic> backOfficeForgotPassword(
      {String? clientCode,
      String? userType,
      required BuildContext context}) async {
    final String endpoint =
        '$baseUrl/apb/v1/user/forgot-password?branch_code=$clientCode&user_type=$userType';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        Utils.toast(msg: "Otp Send Successfully On Registered E-Mail");
        Get.back();
        return response;
      } else {
        Utils.toast(msg: "Internal Server Error!");
        Get.back();
        return;
      }
    } catch (e) {
      Utils.toast(msg: "Internal Server Error!");
      Get.back();
      return;
    }
  }

  Future<void> backOfficeResetPassword(
      {String? clientCode,
      String? otp,
      String? password,
      String? userType,
      required BuildContext context}) async {
    try {
      final url = Uri.parse(
          '$baseUrl/apb/v1/user/set-password?branch_code=$clientCode&user_type=$userType&otp=$otp&password=$password');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['message'] == "Invalid OTP.") {
          Utils.toast(msg: "Invalid Otp!. Please Enter Correct Otp.");
          Get.back();
        } else {
          Utils.toast(msg: "Password reset Successfully!");
          Get.back();
        }
      } else {
        Utils.toast(msg: "Internal Server Error!");
        Get.back();
      }
    } catch (e) {
      Utils.toast(msg: "Internal Server Error!");
      Get.back();
    }
  }

  Future<DashboardResponse> fetchDashboardData({required String token}) async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/apb/v1/user/dashboard'),
        headers: {
          'accept': 'application/json',
          'authToken': token,
        },
      );

      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load dashboard data');
      }
    }catch(e){
      throw Exception('Internal Server Error!');
    }
  }

  Future<List<DPDetails>> fetchDPDetails({required String? token}) async {
    try{
      final response = await http.get(
        Uri.parse('$baseUrl/apb/v1/user/report/dp_details'),
        headers: {
          'accept': 'application/json',
          'authToken': token ?? "",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] as List;
        return data.map((json) => DPDetails.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load DP details');
      }
    }catch(e){
      throw Exception('Internal Server Error!');
    }
  }

  Future<TradingDetailsResponse> fetchTradingDetails(
      {required String? clientCode, required String? token}) async {
    try{
      final url = Uri.parse('$baseUrl/apb/v1/user/report/trading_details');
      final headers = {
        'accept': 'application/json',
        'authToken': token ?? "",
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({'client_code': clientCode});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return TradingDetailsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load trading details');
      }
    }catch(e){
      throw Exception('Internal Server Error!');
    }
  }
}

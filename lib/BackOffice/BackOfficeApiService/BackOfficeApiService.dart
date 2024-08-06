import 'dart:convert';
import 'dart:io';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsDpDetailsModel/CDSLClientDetailsDpDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/CDSLClientDetailsTradingDetailsModel/CDSLClientDetailsTradingDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/CommonReportAccountModelBackOffice/CommonReportAccountModelBackOffice.dart';
import 'package:connect/BackOffice/BackOfficeModels/DashBoardClientDetailsModel/DashBoardClientDetailsModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/DashBoardDetailsModelBackOffice/DashBoardDetailsModelBackOffice.dart';
import 'package:connect/BackOffice/BackOfficeModels/KycDpLedgerModel/KycDpLedgerModel.dart';
import 'package:connect/BackOffice/BackOfficeModels/LoginModelBackOffice/LoginModelBackOffice.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:connect/BackOffice/Utils/BottomNavBar.dart';
import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/ContractBillReportModel/ContractBillReportModel.dart';
import 'package:connect/ConnectApp/Utils/Utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackOfficeApiService {
  String baseUrl = "http://192.168.130.8:2020";
  String baseUrl1 = "http://192.168.130.43:1818";

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
    try {
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
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<List<DPDetails>> fetchDPDetails({required String? token}) async {
    try {
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
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<TradingDetailsResponse> fetchTradingDetails(
      {required String? clientCode, required String? token}) async {
    try {
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
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<DpLedgerReport> fetchDpLedgerReport(
      {required String clientCode,
      required String fromDate,
      required String toDate,
      required String token}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/apb/v1/user/report/dp_ledger'),
        headers: <String, String>{
          'accept': 'application/json',
          'authToken': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'client_code': clientCode,
          'from_date': fromDate,
          'to_date': toDate,
        }),
      );

      if (response.statusCode == 200) {
        return DpLedgerReport.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load DP Ledger Report');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<String> fetchNomineeDetails(
      {String? clientCode, String? token}) async {
    final String url = '$baseUrl1/v1/nominee_details?source=ap';

    final Map<String, String> formData = {
      'client_code': clientCode ?? "",
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'accept': 'application/json',
          'Authtoken': token ?? "",
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        Get.back();
        return responseData['data'];
      } else {
        Get.back();
        throw Exception('Failed to generate link!');
      }
    } catch (e) {
      Get.back();
      throw Exception('Internal Server Error!');
    }
  }

  Future<ApiResponse> fetchClientDetails(
      {required String year, required String token}) async {
    try {
      String url = '$baseUrl/apb/v1/user/client_detail?year=$year';
      Map<String, String> headers = {
        'accept': 'application/json',
        'authToken': token,
      };
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(response.body);
      } else {
        throw Exception('Failed to load client details');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<void> downloadProfitAndLossAccountBackOffice(
      {String? token,
      required BuildContext context,
      String? year,
      String? clientCode,
      String? downloadType,
      String? type}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await ApiServices().getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      String url = '$baseUrl1/v1/user/report/pnl?source=ap';

      final headers = {
        'accept': 'application/json',
        'auth-token': token ?? "",
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        "download_type": downloadType,
        "type": type,
        "client_code": clientCode,
        "year": type == "ledger" ? int.parse(year ?? "2024") : year,
      });

      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          final filePath =
              '${directory.path}/${type == "ledger" ? "Report Download Ledger.pdf" : type == "equity" ? downloadType == "Excel" ? "Report Download Equity.xlsx" : "Report Download Equity.pdf" : type == "future_option" ? downloadType == "Excel" ? "Report Download Future Option.xlsx" : "Report Download Future Option.pdf" : type == "currency_derivatives" ? downloadType == "Excel" ? "Report Download Currency Derivatives.xlsx" : "Report Download Currency Derivatives.pdf" : type == "pnl_summary" ? "Report Download PNL summary.pdf" : type == "holding" ? "Report Download Holding.pdf" : type == "all" ? "Report Download All.zip" : ""}';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          OpenFile.open(filePath);
          Utils.toast(msg: "Exported to $filePath");
        } else {
          Utils.toast(msg: "Failed to download file");
        }
      } catch (e) {
        Utils.toast(msg: "Internal Server Error!");
        debugPrint('Error: $e');
      }
    } else {
      Utils.toast(msg: "Permission denied");
    }
  }

  Future<ContractBillReportModel?> fetchContractBillsBackOffice(
      {String? authToken,
        String? fromDate,
        String? toDate,
        String? source,
        String? companyCode,
        String? clientCode}) async {
    try {
      String Url =
          '$baseUrl1/v1/user/report/contractbills';

      final Map<String, dynamic> requestData = {
        "company_code": [companyCode],
        "from_date": fromDate,
        "to_date": toDate,
        "client_code": clientCode
      };

      final response = await http.post(
        Uri.parse('$Url?source=$source'),
        headers: {
          'accept': 'application/json',
          'auth-token': authToken ?? "",
          'Content-Type': 'application/json'
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return ContractBillReportModel.fromJson(jsonResponse);
      } else {
        debugPrint('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      throw Exception('Internal Server Error!$e');
    }
  }

  Future<RiskReport?> fetchRiskReport(
      {String? companyCode, String? clientCode, String? authToken}) async {

    final url = '$baseUrl/apb/v1/user/report/risk_common_report';

    final body = jsonEncode({
      'company_code': companyCode,
      'client_code': clientCode,
    });

    final response = await http.post(Uri.parse(url), headers: {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'authToken': authToken ?? "",
    }, body: body);

    if (response.statusCode == 200) {
      return RiskReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load risk report');
    }
  }
}

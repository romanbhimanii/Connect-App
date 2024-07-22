// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:connect/Models/BankDetailsModel/BankDetailsModel.dart';
import 'package:connect/Models/BidSubmitModel/BidSubmitModel.dart';
import 'package:connect/Models/ClientWiseBidReport/ClientWiseBidReport.dart';
import 'package:connect/Models/ContractBillReportModel/ContractBillReportModel.dart';
import 'package:connect/Models/EPledgeModel/EPledgeModel.dart';
import 'package:connect/Models/EddpiDpProcessModel/EddpiDpProcessModel.dart';
import 'package:connect/Models/FundPayInModel/FundPayInModel.dart';
import 'package:connect/Models/FundPayOutModel/FundPayOutModel.dart';
import 'package:connect/Models/GlobalDetailsModel/GlobalDetailsModel.dart';
import 'package:connect/Models/GlobalSummaryReportModel/GlobalSummaryReportModel.dart';
import 'package:connect/Models/HoldingReportModel/HoldingReportModel.dart';
import 'package:connect/Models/IncomeTaxReportModel/IncomeTaxReportModel.dart';
import 'package:connect/Models/IpoModels/IpoModel.dart';
import 'package:connect/Models/LedgerReportModel/LedgerReportModel.dart';
import 'package:connect/Models/LoginModel/LoginModel.dart';
import 'package:connect/Models/PositionReportModel/PositionReportModel.dart';
import 'package:connect/Models/ProfileClientDetails/ProfileClientDetails.dart';
import 'package:connect/Models/StockVerificationDpProcessModel/StockVerificationDpProcessModel.dart';
import 'package:connect/Models/TotalBalanceModel/TotalbalanceModel.dart';
import 'package:connect/Screens/Login/login_screen.dart';
import 'package:connect/Utils/AppDrawer.dart';
import 'package:connect/Utils/AppVariables.dart';
import 'package:connect/Utils/Utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class ApiServices {

  Future<void> login({String? username, String? password, required BuildContext context}) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.130.43:1818/v1/user/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username ?? "",
          'password': password ?? "",
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(responseData);
        LoginResponse.fromJson(responseData);
        Utils.toast(msg: "Login Successfully");
        if (kDebugMode) {
          debugPrint('Token: ${loginResponse.data.token}');
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Appvariables.clientCode = loginResponse.data.clientCode;
        await prefs.remove('token');
        await prefs.setString('token', loginResponse.data.token);
        loadToken();
        Get.back();
        Get.offAll(const AppDrawer());
      } else {
        Get.back();
        Utils.toast(msg: "Login failed! Please try again.");
      }
    } catch (e) {
      Get.back();
      Utils.toast(msg: "Internal Server Error!");
    }
  }

  Future<void> logoutUser({required BuildContext context}) async {
    final url = Uri.parse('http://192.168.130.43:1818/v1/user/logout');
    final headers = {
      'accept': 'application/json',
      'authToken': Appvariables.token,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: '',
      );

      if (response.statusCode == 200) {
        Utils.toast(msg: "You Are Log out From Current Session");
        Get.offAll(const LoginScreen());
      } else {
        Utils.toast(msg: "Internal Server Error!");
        Get.back();
      }
    } catch (e) {
      Utils.toast(msg: "Internal Server Error!");
      Get.back();
    }
  }

  Future<dynamic> forgotPassword({String? clientCode, required BuildContext context}) async {
    final String endpoint = 'http://192.168.130.43:1818/v1/user/forgot-password?client_code=$clientCode';

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

  Future<void> resetPassword(
      {String? clientCode, String? otp, String? password, required BuildContext context}) async {
    try{
      final url = Uri.parse('http://192.168.130.43:1818/v1/user/reset-password?client_code=$clientCode&otp=$otp&password=$password');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if(responseData['message'] == "Invalid OTP."){
          Utils.toast(msg: "Invalid Otp!. Please Enter Correct Otp.");
          Get.back();
        }else{
          Utils.toast(msg: "Password reset Successfully!");
          Get.back();
        }
      } else {
        Utils.toast(msg: "Internal Server Error!");
        Get.back();
      }
    }catch(e){
      Utils.toast(msg: "Internal Server Error!");
      Get.back();
    }
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Appvariables.token = prefs.getString('token') ?? "";
  }

  Future<String> loadYear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime time = DateTime.now();
    String year = prefs.getString('year') ?? "${time.year}";
    if(year == ""){
      Appvariables.year = "${time.year}-${time.year+1}";
    }
    else if(year == "2024"){
      Appvariables.year = "2023-2024";
    }else if(year == "2023"){
      Appvariables.year = "2022-2023";
    }else if(year == "2022"){
      Appvariables.year = "2021-2022";
    }else if(year == "2021"){
      Appvariables.year = "2020-2021";
    }
    return Appvariables.year;
  }

  Future<TotalBalanceModel> fetchTotalBalanceData({String? token,String? year}) async {
    try {
      String url = 'http://192.168.130.43:1818/v1/user/dashboard?year=$year';
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'auth-token': token ?? "",
      };

      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return TotalBalanceModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<IpoDetailsResponse> fetchUpcomingIpoDetails() async {
    try {
      String baseUrl =
          'http://192.168.102.146:3012/ipo/v1/get-ipo-details?source=mobile_app';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'condition': 'upcoming',
        }),
      );

      if (response.statusCode == 200) {
        return IpoDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load IPO details');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<IpoDetailsResponse> fetchOpenIpoDetails() async {
    try {
      String baseUrl =
          'http://192.168.102.146:3012/ipo/v1/get-ipo-details?source=mobile_app';
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'condition': 'current',
        }),
      );

      if (response.statusCode == 200) {
        return IpoDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load IPO details');
      }
    } catch (e) {
      throw Exception('Failed to load IPO details $e');
    }
  }

  Future<AccountProfile> fetchAccountProfile({String? token}) async {
    try {
      String baseUrl = 'http://192.168.130.43:1818/v1';
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'authToken': token ?? "",
      };

      final response = await http.get(
          Uri.parse('$baseUrl/account_profile/personal_details'),
          headers: headers);

      if (response.statusCode == 200) {
        return AccountProfile.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load account profile');
      }
    } catch (e) {
      throw Exception('Failed to load account profile $e');
    }
  }

  Future<BankDetailsResponse> fetchBankDetails({String? token}) async {
    try {
      final url = Uri.parse(
          'http://192.168.130.43:1818/v1/account_profile/bank_details');
      final headers = {
        'Content-Type': 'application/json',
        'authToken': token ?? "",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return BankDetailsResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load bank details');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<BidResponse> submitBid(BidRequest request, String? token) async {
    try {
      const String baseUrl = 'http://192.168.130.46:3012';
      final url = Uri.parse(
          '$baseUrl/ipo/v1/bid/bidSubmit?client_code=${Appvariables.clientCode}&source=connect');
      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'authToken': token ?? '',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        return BidResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to submit bid');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  // add from date and to date dynamically
  Future<ClientBidReportResponse> fetchClientBidReports({String? token}) async {
    try {
      const String baseUrl = 'http://192.168.130.46:3012/ipo/v1/get-client-wise-bid-report?from_date=2024-02-28&to_date=2024-02-28&source=connect';
      String authToken = token ?? "";

      final url = Uri.parse(baseUrl);
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'authToken': authToken,
        },
      );

      if (response.statusCode == 200) {
        return ClientBidReportResponse.fromJson(response.body);
      } else {
        throw Exception('Data Not Found');
      }
    } catch (e) {
      throw Exception('Failed to load data$e');
    }
  }

  Future<void> sendOtp(
      {String? mobileNumber,
      String? token,
      String? type,
      String? otp,
      String? mobileOrEmail}) async {
    try {
      const String baseUrl =
          'http://192.168.130.43:1818/v1/account_profile/profile_modifications';

      final url = Uri.parse('$baseUrl?process=$type&types=$mobileOrEmail');

      final response = await http.post(
        url,
        headers: {
          'accept': 'application/json',
          'authToken': token ?? "",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'input': mobileNumber,
          'otp': type == "send_otp" ? "" : otp ?? "",
        }),
      );

      if (response.statusCode == 200) {
        Utils.toast(msg: type == "send_otp"
            ? "Otp Sent Successfully"
            : "Otp Verify Successfully");
      } else {
        Utils.toast(msg: type == "send_otp"
            ? "Error While Sending Otp!"
            : "Otp doesn't Verify!");
      }
    } catch (e) {
      Utils.toast(msg: "Internal Server Error!");
    }
  }

  Future<void> addNewBankAccount(
      {String? token,
      String? accountNumber,
      String? ifscCode,
      String? isDefault,
      String? accountType,
      String? isSendOtpOrVerifyOtp,
      String? otp,
      File? file1,
      File? file2,
      List<int>? file1Bytes,
      List<int>? file2Bytes}) async {
    String url =
        'http://192.168.130.43:1818/v1/account_profile/bank-modification?process=$isSendOtpOrVerifyOtp';
    String authToken = token ?? "";

    final http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse(url))
      ..headers['accept'] = 'application/json'
      ..headers['authToken'] = authToken
      ..fields['micr_code'] = ''
      ..fields['set_default'] = isDefault ?? ""
      ..fields['acc_number'] = accountNumber ?? ""
      ..fields['otp'] = isSendOtpOrVerifyOtp == "send_otp" ? '' : otp ?? ''
      ..fields['account_type'] = accountType ?? ""
      ..fields['is_penny'] = 'true'
      ..fields['ifsc_code'] = ifscCode ?? ""
      ..files.add(http.MultipartFile.fromBytes(
        'file2',
        file2Bytes ?? [],
        filename: basename(isSendOtpOrVerifyOtp == "send_otp" ? '' : file2!.path),
        contentType: MediaType('image', 'jpeg'),
      ))
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          file1Bytes ?? [],
          filename:
              basename(isSendOtpOrVerifyOtp == "send_otp" ? '' : file1!.path),
          contentType: MediaType('image', 'jpeg'),
        ),
      );

    try {
      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        Utils.toast(msg: isSendOtpOrVerifyOtp == "send_otp" ? "Otp Sent Successfully" : "Otp Verify Successfully");
        debugPrint('Response: $responseBody');
      } else {
        Utils.toast(msg: isSendOtpOrVerifyOtp == "send_otp" ? "Error While Sending Otp!" : "Otp doesn't Verify!");
        debugPrint('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      Utils.toast(msg: "Internal Server Error!");
      debugPrint('Error: $e');
    }
  }

  Future<void> modifyIncomeDetails(
      {String? token,
      List<int>? fileBytes,
      String? isSendOrVerifyOtp,
      File? file,
      String? income,
      String? otp,}) async {
    final url = Uri.parse(
        'http://192.168.130.43:1818/v1/account_profile/income-modification?process=$isSendOrVerifyOtp');
    final authToken = token ?? '';

    var request = http.MultipartRequest('POST', url)
      ..headers['accept'] = 'application/json'
      ..headers['authToken'] = authToken
      ..fields['otp'] = isSendOrVerifyOtp == "send_otp" ? '' : otp ?? ""
      ..fields['income'] = income ?? ""
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes ?? [],
        filename: isSendOrVerifyOtp == "send_otp" ? '' : basename(file!.path),
        contentType: MediaType('image', 'jpeg'),
      ));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        Utils.toast(msg: isSendOrVerifyOtp == "send_otp"
            ? "Otp Sent Successfully"
            : "Otp Verify Successfully");
        debugPrint('Response: $responseData');
      } else {
        Utils.toast(msg: isSendOrVerifyOtp == "send_otp"
            ? "Error While Sending Otp!"
            : "Otp doesn't Verify!");
        debugPrint('Failed to send OTP. Status code: ${response.statusCode}');
      }
    } catch (e) {
      Utils.toast(msg: "Internal Server Error!");
    }
  }

  Future<FundPayinResponse> fetchFundPayin(
      {String? authToken}) async {
    try {
      const String baseUrl = 'http://192.168.130.43:1818/v1';

      final response = await http.get(
        Uri.parse(
            '$baseUrl/account_profile/list_of_funds_payout_payin?type=fund_payin'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'authToken': authToken ?? "",
        },
      );

      if (response.statusCode == 200) {
        return FundPayinResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load fund payin data');
      }
    } catch (e) {
      throw Exception('Failed to load fund payin data');
    }
  }

  Future<PayOutModel> fetchFundPayOut(
      {String? authToken}) async {
    try {
      const String baseUrl = 'http://192.168.130.43:1818/v1';

      final response = await http.get(
        Uri.parse(
            '$baseUrl/account_profile/list_of_funds_payout_payin?type=fund_payout'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'authToken': authToken ?? "",
        },
      );

      if (response.statusCode == 200) {
        return PayOutModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load fund payin data');
      }
    } catch (e) {
      throw Exception('Failed to load fund payin data');
    }
  }

  Future<bool> downloadClientDetails({String? token, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url =
          'http://192.168.130.43:1818/v1/account_profile/download_client_details';
      final headers = {
        'accept': 'application/json',
        'authToken': token ?? '',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/clientDetails.pdf';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          OpenFile.open(filePath);
          Utils.toast(msg: "Exported to $filePath");
          return true;
        } else {
          Utils.toast(msg: "Failed to download file");
          debugPrint('Failed to download file: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        Utils.toast(msg: "Internal Server Error!");
        debugPrint('Error: $e');
        return false;
      }
    } else {
      Utils.toast(msg: "Permission denied");
      return false;
    }
  }

  Future<void> downloadHoldingReport({String? token, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus = await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url = 'http://192.168.130.43:1818/v1/account_profile/download_holdings';
      final headers = {
        'accept': 'application/json',
        'authToken': token ?? '',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/holdingsReport.pdf';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          OpenFile.open(filePath);
          Utils.toast(msg: "Exported to $filePath");
        } else {
          Utils.toast(msg: "Failed to download file");
          debugPrint('Failed to download file: ${response.statusCode}');
        }
      } catch (e) {
        Utils.toast(msg: "Internal Server Error!");
      }
    } else {
      Utils.toast(msg: "Permission denied");
    }
  }

  Future<void> downloadGlobalSummary({String? token, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url =
          'http://192.168.130.43:1818/v1/account_profile/download_global_summary';
      final headers = {
        'accept': 'application/json',
        'authToken': token ?? '',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/globalSummary.pdf';

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

  Future<void> downloadIncomeTax({String? token, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url = 'http://192.168.130.43:1818/v1/excel/download_income_tax';
      final headers = {
        'accept': 'application/json',
        'authToken': token ?? '',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/incomeTax.xlsx';

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

  Future<void> downloadGlobalDetails({String? token, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url = 'http://192.168.130.43:1818/v1/excel/download_global_details';
      final headers = {
        'accept': 'application/json',
        'authToken': token ?? '',
      };

      try {
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/globalDetails.xlsx';

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

  Future<void> downloadLedger({String? token, required BuildContext context, int? year}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus = await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url = 'http://192.168.130.43:1818/v1/user/report/pnl?source=connect';

      final headers = {
        'accept': 'application/json',
        'auth-token': token ?? "",
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        "download_type": "PDF",
        "type": "ledger",
        "client_code": Appvariables.clientCode,
        "year": year,
      });

      try {
        final response = await http.post(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/downloadLedger.pdf';

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

  Future<HoldingReportModel> fetchHoldingsReport(
      {String? clientCode, String? date, String? token}) async {
    try {
      final url = Uri.parse(
          'http://192.168.130.43:1818/v1/user/report/holding?source=connect');
      final headers = {
        'accept': 'application/json',
        'auth-token': token ?? '',
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({"client_code": clientCode, "date": date});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return HoldingReportModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load holding report');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<LedgerReport> fetchLedgerReport(
      {String? token,
      String? clientCode,
      String? fromDate,
        String? margin,
      String? toDate}) async {
    try {
      const String baseUrl = 'http://192.168.130.43:1818/v1/user/report/ledger';
      const String source = 'connect';

      final url = Uri.parse('$baseUrl?source=$source');
      final headers = {
        'accept': 'application/json',
        'auth-token': token ?? "",
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        'client_code': clientCode,
        'from_date': fromDate,
        'to_date': toDate,
        'cocd': [
          'BSE_CASH,NSE_CASH,CD_NSE,MF_BSE,NSE_DLY,NSE_FNO,NSE_SLBM,MTF'
        ],
        'margin': margin,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        return LedgerReport.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch ledger report');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<PositionReportResponse> fetchPositionReport(
      {String? date, String? token, String? cocd}) async {
    try {
      String apiUrl = 'http://192.168.130.43:1818/v1/user/report/position';
      String authToken = token ?? '';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'accept': 'application/json',
          'auth-token': authToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cocd': ["NSE_FNO"],
          'date': date,
        }),
      );

      if (response.statusCode == 200) {
        return PositionReportResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load position report');
      }
    } catch (e) {
      debugPrint('Internal Server Error!$e');
      throw Exception('Internal Server Error!$e');
    }
  }

  Future<GlobalSummary>? fetchGlobalSummary(
      {String? toDate, String? token, String? openBalance}) async {
    try {
      String baseUrl =
          'http://192.168.130.43:1818/v1/user/report/globalsummary';
      String authToken = token ?? '';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'accept': 'application/json',
          'auth-token': authToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cocd': ["BSE_CASH,NSE_CASH,NSE_FNO,CD_NSE"],
          'to_date': toDate,
          'with_opening': openBalance,
        }),
      );

      if (response.statusCode == 200) {
        return GlobalSummary.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load global summary');
      }
    } catch (e) {
      throw Exception('Internal Server Error!$e');
    }
  }

  Future<GlobalDetailsResponse> fetchGlobalDetails(
      {String? authToken, String? fromDate, String? toDate, int? year}) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.130.43:1818/v1/user/report/globaldetails'),
        headers: <String, String>{
          'accept': 'application/json',
          'auth-token': authToken ?? "",
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from_date': fromDate ?? "",
          'to_date': toDate ?? "",
          "year": year,
        }),
      );

      if (response.statusCode == 200) {
         return GlobalDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load global details');
      }
    } catch (e) {
      throw Exception('Internal Server Error!');
    }
  }

  Future<void> downloadReportDocuments(
      {String? token, String? type, String? downloadType, String? year, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);

      const url =
          'http://192.168.130.43:1818/v1/user/report/pnl?source=connect';
      final headers = {
        'accept': 'application/json',
        'auth-token': token ?? "",
        'Content-Type': 'application/json',
      };
      final body = jsonEncode({
        "download_type": downloadType ?? "",
        "type": type,
        "client_code": Appvariables.clientCode,
        "year": year,
      });

      try {
        final response =
            await http.post(Uri.parse(url), headers: headers, body: body);

        if (response.statusCode == 200) {
          final filePath = '${directory.path}/${type == "ledger" ? "Report Download Ledger.pdf" : type == "equity" ? downloadType == "Excel" ? "Report Download Equity.xlsx" : "Report Download Equity.pdf" : type == "future_option" ? downloadType == "Excel" ? "Report Download Future Option.xlsx" : "Report Download Future Option.pdf" : type == "currency_derivatives" ? downloadType == "Excel" ? "Report Download Currency Derivatives.xlsx" : "Report Download Currency Derivatives.pdf" : type == "pnl_summary" ? "Report Download PNL summary.pdf" : type == "holding" ? "Report Download Holding.pdf" : type == "all" ? "Report Download All.zip" : ""}';

          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);
           Get.back();

          OpenFile.open(filePath);
          Utils.toast(msg: "Exported to $filePath");
        } else {
          Get.back();
          Utils.toast(msg: "Failed to download file");
        }
      } catch (e) {
        Get.back();
        Utils.toast(msg: "Internal Server Error!");
        debugPrint('Error: $e');
      }
    } else {
      Get.back();
      Utils.toast(msg: "Permission denied");
    }
  }

  Future<IncomeTaxReport?> getIncomeTaxReport(
      {String? financialYear, String? token}) async {
    try {
      String baseUrl = 'http://192.168.130.43:1818/v1/user/report/incometax';
      String authToken = token ?? '';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'accept': 'application/json',
          'auth-token': authToken,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'financial_year': financialYear}),
      );

      if (response.statusCode == 200) {
        return IncomeTaxReport.fromJson(jsonDecode(response.body));
      } else {
        debugPrint('Failed to load report: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      throw Exception('Internal Server Error!$e');
    }
  }

  Future<ContractBillReportModel?> fetchContractBills(
      {String? authToken,
      String? fromDate,
      String? toDate,
      String? clientCode}) async {
    try {
      String baseUrl =
          'http://192.168.130.43:1818/v1/user/report/contractbills';

      final Map<String, dynamic> requestData = {
        "company_code": ["ALL"],
        "from_date": fromDate,
        "to_date": toDate,
        "client_code": clientCode
      };

      final response = await http.post(
        Uri.parse('$baseUrl?source=connect'),
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

  Future<void> downloadPDF({String? pdfUrl, String? pdfFileName, required BuildContext context}) async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    bool permissionStatus;

    if (deviceInfo.version.sdkInt > 32) {
      permissionStatus =
          await Permission.manageExternalStorage.request().isGranted;
    } else {
      permissionStatus = await Permission.storage.request().isGranted;
    }

    if (permissionStatus) {
      String downloadsFolderPath = await getDownloadsFolderPath();
      Directory directory = Directory(downloadsFolderPath);
      File file = File('${directory.path}/$pdfFileName');

      try {
        final url = Uri.parse(pdfUrl ?? "");
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;

          await file.writeAsBytes(bytes, flush: true);

          Get.back();

          OpenFile.open(file.path);
          Utils.toast(msg: "Exported to ${file.path}");
        } else {
          Get.back();
          Utils.toast(msg: "Failed to download file");
        }
      } catch (e) {
        Get.back();
        Utils.toast(msg: "Internal Server Error!");
        debugPrint('Error: $e');
      }
    } else {
      Get.back();
      Utils.toast(msg: "Permission denied");
    }
  }

  Future<EPledgeModel?> ePledgeDpProcess({String? token}) async {
    try {
      final url =
          Uri.parse("http://192.168.130.43:1818/v1/margin_epledge_data");
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'authToken': token ?? "",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return EPledgeModel.fromJson(jsonResponse);
      } else {
        throw Exception("Failed to Load Data!");
      }
    } catch (e) {
      throw Exception("Internal Server Error!$e");
    }
  }

  Future<dynamic> segmentSendOtp({
    required String clientCode,
    required String authToken,
    List<int>? fileBytes,
    File? file,
    String isSendOrVerifyOtp = '',
    String otp = '',
    String segment = '',
    String fileType = '',
    String filePath = '',
    required BuildContext context
  }) async {
    try{
      var url = Uri.parse('http://192.168.130.43:1818/v1/account_profile/segmentAddition?process=$isSendOrVerifyOtp&source=connect');

      var request = http.MultipartRequest('POST', url)
        ..headers['accept'] = 'application/json'
        ..headers['authToken'] = authToken
        ..fields['client_code'] = clientCode
        ..fields['otp'] = otp
        ..fields['segment'] = segment
        ..fields['file_type'] = fileType
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          fileBytes ?? [],
          filename: isSendOrVerifyOtp == "send_otp" ? '' : segment == "Future & Options" || segment == "Currency Derivatives" ? basename(file!.path) : "",
          contentType: MediaType('image', 'jpeg'),
        ));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonData = jsonDecode(responseData.body);
        Utils.toast(msg: isSendOrVerifyOtp == "send_otp"
            ? "Otp Sent Successfully"
            : "Otp Verify Successfully");
         Get.back();
         Get.back();
        return jsonData['data']['data'];
      } else {
        Utils.toast(msg: isSendOrVerifyOtp == "send_otp"
            ? "Error While Sending Otp!"
            : "Otp doesn't Verify!");
        Get.back();
        return;
      }
    }catch(e){
      Utils.toast(msg: "Internal Server Error!");
      Get.back();
      return;
    }
  }

  Future<dynamic> submitForm(String apiResponse) async {
    try{
      final url = Uri.parse('https://esign.egov-nsdl.com/nsdl-esp/authenticate/esign-doc/');
      final headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final body = {
        'msg': apiResponse,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 302) {
        final location = response.headers['location'];
        if (location != null) {
          return location;
        } else {
          Utils.toast(msg: "Internal Server Error!");
          return;
        }
      } else {
        Utils.toast(msg: "Internal Server Error!");
        return;
      }
    }catch(e){
      Utils.toast(msg: "Internal Server Error!");
      return;
    }
  }

  Future<String> getDownloadsFolderPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download/';
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<DetailedFileResponse?> fetchEddpiDpProcessUserData(String clientCode) async {
    final url = 'http://192.168.130.37:3220/v1/detailed_file?client_code=$clientCode';
    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authtoken': Appvariables.token,
    };

    try {
      final response = await http.get(Uri.parse(url),headers: headers);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        DetailedFileResponse detailedFileResponse = DetailedFileResponse.fromJson(data);
        return detailedFileResponse;
      } else {
        throw Exception("Data Not Found!");
      }
    } catch (e) {
      throw Exception("Internal Server Error!");
    }
  }

  Future<HoldingDataResponse?> fetchStockVerificationDpProcessData() async {
    final url = Uri.parse('http://192.168.130.37:3220/edis/v1/edis-holding-data?source=connect');
    Map<String, String> headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'Authtoken': Appvariables.token,
    };

    try {
      final response = await http.get(url,headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HoldingDataResponse.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception("Internal Server Error!");
    }
  }
}





import 'package:connect/ConnectApp/ApiServices/ApiServices.dart';
import 'package:connect/ConnectApp/Models/IpoModels/IpoModel.dart';
import 'package:flutter/material.dart';

class IpoProvider with ChangeNotifier {
  final ApiServices _apiService = ApiServices();
  IpoDetailsResponse? _upcomingIpoDetails;
  IpoDetailsResponse? _openIpoDetails;

  IpoDetailsResponse? get upcomingIpoDetails => _upcomingIpoDetails;
  IpoDetailsResponse? get openIpoDetails => _openIpoDetails;

  Future<void> fetchUpcomingIpoDetails() async {
    if (_upcomingIpoDetails == null) {
      _upcomingIpoDetails = await _apiService.fetchUpcomingIpoDetails(source: "mobile_app");
      notifyListeners();
    }
  }

  Future<void> fetchOpenIpoDetails() async {
    if (_openIpoDetails == null) {
      _openIpoDetails = await _apiService.fetchOpenIpoDetails(source: "mobile_app");
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    _upcomingIpoDetails = null;
    _openIpoDetails = null;
    await fetchUpcomingIpoDetails();
    await fetchOpenIpoDetails();
  }
}

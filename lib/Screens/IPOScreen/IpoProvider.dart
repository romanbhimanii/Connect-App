import 'package:flutter/material.dart';
import 'package:connect/ApiServices/ApiServices.dart';
import 'package:connect/Models/IpoModels/IpoModel.dart';

class IpoProvider with ChangeNotifier {
  final ApiServices _apiService = ApiServices();
  IpoDetailsResponse? _upcomingIpoDetails;
  IpoDetailsResponse? _openIpoDetails;

  IpoDetailsResponse? get upcomingIpoDetails => _upcomingIpoDetails;
  IpoDetailsResponse? get openIpoDetails => _openIpoDetails;

  Future<void> fetchUpcomingIpoDetails() async {
    if (_upcomingIpoDetails == null) {
      _upcomingIpoDetails = await _apiService.fetchUpcomingIpoDetails();
      notifyListeners();
    }
  }

  Future<void> fetchOpenIpoDetails() async {
    if (_openIpoDetails == null) {
      _openIpoDetails = await _apiService.fetchOpenIpoDetails();
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

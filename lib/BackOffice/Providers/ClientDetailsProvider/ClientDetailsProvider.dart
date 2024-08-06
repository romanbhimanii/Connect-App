import 'package:connect/BackOffice/BackOfficeApiService/BackOfficeApiService.dart';
import 'package:connect/BackOffice/BackOfficeModels/DashBoardClientDetailsModel/DashBoardClientDetailsModel.dart';
import 'package:connect/BackOffice/Utils/AppVariablesBackOffice.dart';
import 'package:flutter/material.dart';

class ClientDetailProvider with ChangeNotifier {
  ApiResponse? _apiResponse;
  bool _isLoading = false;
  ClientDetail? _selectedClient;

  ApiResponse? get apiResponse => _apiResponse;
  bool get isLoading => _isLoading;
  ClientDetail? get selectedClient => _selectedClient;

  Future<void> fetchClientDetails() async {
    _isLoading = true;
    notifyListeners();

    try {
      _apiResponse = await BackOfficeApiService().fetchClientDetails(
        token: Appvariablesbackoffice.token ?? "",
        year: "2024"
      );
    } catch (e) {
      throw Exception('Internal Server Error!');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedClient() {
    _selectedClient = null;
    notifyListeners();
  }

  void findClientByCode(String clientCode) {
    if (_apiResponse != null) {
      _selectedClient = _apiResponse!.data.firstWhere(
              (client) => client.clientId == clientCode,
          orElse: () => ClientDetail(
              clientId: '',
              boName: 'Client Not Found',
              boPanNo: '',
              accOpenDate: '',
              tradeStatus: ''));
      notifyListeners();
    }
  }
}

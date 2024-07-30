class DashboardResponse {
  final String status;
  final String message;
  final DashboardData data;

  DashboardResponse({required this.status, required this.message, required this.data});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      status: json['status'],
      message: json['message'],
      data: DashboardData.fromJson(json['data']),
    );
  }
}

class DashboardData {
  final String currentMonthBrokerage;
  final String previousMonthBrokerage;
  final String noOfClient;
  final String tradedClient;
  final String nonTradedClient;
  final String finished;
  final String rejection;
  final String completedPr;

  DashboardData({
    required this.currentMonthBrokerage,
    required this.previousMonthBrokerage,
    required this.noOfClient,
    required this.tradedClient,
    required this.nonTradedClient,
    required this.finished,
    required this.rejection,
    required this.completedPr,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      currentMonthBrokerage: json['Current_Month_Brokerage'].toString(),
      previousMonthBrokerage: json['Previous_Month_Brokerage'].toString(),
      noOfClient: json['no_of_client'].toString(),
      tradedClient: json['traded_client'].toString(),
      nonTradedClient: json['non_traded_client'].toString(),
      finished: json['finished'].toString(),
      rejection: json['rejection'].toString(),
      completedPr: json['completed_pr'].toString(),
    );
  }
}

import 'dart:convert';

import 'package:bookkart_flutter/models/dashboard/dashboard_response.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'api_store.g.dart';

class ApiStore = _ApiStore with _$ApiStore;

abstract class _ApiStore with Store {
  static const DASHBOARD_RESPONSE = "DASHBOARD_RESPONSE";

  @observable
  DashboardResponse dashboardResponse = DashboardResponse();

  @action
  void setDashboardResponse(DashboardResponse res) {
    dashboardResponse = res;
    setValue(DASHBOARD_RESPONSE, dashboardResponse.toJson());
  }

  @action
  DashboardResponse? getDashboardFromCache() {
    if (getStringAsync(DASHBOARD_RESPONSE).isNotEmpty) {
      dashboardResponse = DashboardResponse.fromJson(jsonDecode(getStringAsync(DASHBOARD_RESPONSE)));
      return dashboardResponse;
    } else {
      return null;
    }
  }
}

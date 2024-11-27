// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ApiStore on _ApiStore, Store {
  late final _$dashboardResponseAtom =
      Atom(name: '_ApiStore.dashboardResponse', context: context);

  @override
  DashboardResponse get dashboardResponse {
    _$dashboardResponseAtom.reportRead();
    return super.dashboardResponse;
  }

  @override
  set dashboardResponse(DashboardResponse value) {
    _$dashboardResponseAtom.reportWrite(value, super.dashboardResponse, () {
      super.dashboardResponse = value;
    });
  }

  late final _$_ApiStoreActionController =
      ActionController(name: '_ApiStore', context: context);

  @override
  void setDashboardResponse(DashboardResponse res) {
    final _$actionInfo = _$_ApiStoreActionController.startAction(
        name: '_ApiStore.setDashboardResponse');
    try {
      return super.setDashboardResponse(res);
    } finally {
      _$_ApiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  DashboardResponse? getDashboardFromCache() {
    final _$actionInfo = _$_ApiStoreActionController.startAction(
        name: '_ApiStore.getDashboardFromCache');
    try {
      return super.getDashboardFromCache();
    } finally {
      _$_ApiStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dashboardResponse: ${dashboardResponse}
    ''';
  }
}

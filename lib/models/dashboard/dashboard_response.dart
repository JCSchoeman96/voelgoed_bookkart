import 'package:bookkart_flutter/models/common_models/social_links_model.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/models/dashboard/dashboard_category.dart';

class DashboardResponse {
  Social? socialLink;
  String? appLang;
  String? paymentMethod;
  bool? enableCoupons;
  CurrencySymbol? currencySymbol;
  List<BookDataModel>? suggestedForYou;
  List<BookDataModel>? youMayLike;
  List<BookDataModel>? featured;
  List<BookDataModel>? newest;
  List<DashboardCategory>? category;

  DashboardResponse({
    this.socialLink,
    this.appLang,
    this.paymentMethod,
    this.enableCoupons,
    this.currencySymbol,
    this.suggestedForYou = const <BookDataModel>[],
    this.youMayLike = const <BookDataModel>[],
    this.featured = const <BookDataModel>[],
    this.category = const <DashboardCategory>[],
    this.newest = const <BookDataModel>[],
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      socialLink: json['social_link'] is Map ? Social.fromJson(json['social_link']) : Social(),
      paymentMethod: json['payment_method'] is String ? json['payment_method'] : "",
      appLang: json['app_lang'] is String ? json['app_lang'] : "",
      enableCoupons: json['enable_coupons'] is bool ? json['enable_coupons'] : false,
      currencySymbol: json['currency_symbol'] is Map ? CurrencySymbol.fromJson(json['currency_symbol']) : CurrencySymbol(),
      suggestedForYou: json['suggested_for_you'] is List ? (json['suggested_for_you'] as List).map((e) => BookDataModel.fromJson(e)).toList() : [],
      youMayLike: json['you_may_like'] is List ? (json['you_may_like'] as List).map((e) => BookDataModel.fromJson(e)).toList() : [],
      featured: json['featured'] is List ? (json['featured'] as List).map((e) => BookDataModel.fromJson(e)).toList() : [],
      category: json['category'] is List ? (json['category'] as List).map((e) => DashboardCategory.fromJson(e)).toList() : [],
      newest: json['newest'] is List ? (json['newest'] as List).map((e) => BookDataModel.fromJson(e)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.socialLink != null) {
      data['social_link'] = this.socialLink!.toJson();
    }
    data['app_lang'] = this.appLang;
    data['payment_method'] = this.paymentMethod;
    data['enable_coupons'] = this.enableCoupons;
    if (this.currencySymbol != null) {
      data['currency_symbol'] = this.currencySymbol!.toJson();
    }
    if (this.suggestedForYou != null) {
      data['suggested_for_you'] = this.suggestedForYou!.map((v) => v.toJson()).toList();
    }
    if (this.youMayLike != null) {
      data['you_may_like'] = this.youMayLike!.map((v) => v.toJson()).toList();
    }
    if (this.featured != null) {
      data['featured'] = this.featured!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.newest != null) {
      data['newest'] = this.newest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrencySymbol {
  String? currencySymbol;
  String? currency;

  CurrencySymbol({this.currencySymbol, this.currency});

  CurrencySymbol.fromJson(Map<String, dynamic> json) {
    currencySymbol = json['currency_symbol'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency_symbol'] = this.currencySymbol;
    data['currency'] = this.currency;
    return data;
  }
}

import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/category_list_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/models/dashboard/book_purchase_model.dart';
import 'package:bookkart_flutter/models/dashboard/dashboard_response.dart';
import 'package:bookkart_flutter/models/dashboard/header_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> dashboardFromCache({required Function(List<HeaderModel> header) onHeaderCreated}) async {
  log('GET-DASHBOARD-DATA-REST-API');
  if (apiStore.getDashboardFromCache() != null) {
    DashboardResponse dashboardResponse = apiStore.getDashboardFromCache()!;
    setSocialLink(dashboardResponse);

    appStore.setLoading(true);
    List<HeaderModel> temp = [];

    HeaderModel? newest = await createHeaderData(
      dashboardResponse.newest.validate(),
      locale.headerNewestBookTitle,
      locale.headerNewestBookMessage,
      BOOK_TYPE_NEW,
    );

    HeaderModel? featured = await createHeaderData(
      dashboardResponse.featured.validate(),
      locale.headerFeaturedBookMessage,
      locale.headerNewestBookMessage,
      BOOK_TYPE_FEATURED,
    );

    HeaderModel? suggestedForYou = await createHeaderData(
      dashboardResponse.suggestedForYou.validate(),
      locale.headerForYouBookMessage,
      locale.headerNewestBookMessage,
      BOOK_TYPE_SUGGESTION,
    );

    HeaderModel? youMayLike = await createHeaderData(
      dashboardResponse.youMayLike.validate(),
      locale.headerLikeBookMessage,
      locale.headerNewestBookMessage,
      BOOK_TYPE_LIKE,
    );

    if (newest != null) temp.add(newest);

    if (featured != null) temp.add(featured);

    if (suggestedForYou != null) temp.add(suggestedForYou);

    if (youMayLike != null) temp.add(youMayLike);

    onHeaderCreated.call(temp);
    appStore.setLoading(false);
  }
}

Future<DashboardResponse> getDashboardDataRestApi({required Function(List<HeaderModel> header) onHeaderCreated}) async {
  log('GET-DASHBOARD-DATA-REST-API');
  appStore.setLoading(true);
  DashboardResponse dashboardResponse = DashboardResponse.fromJson(
    await responseHandler(await buildHttpResponse("iqonic-api/api/v1/woocommerce/get-dashboard", method: HttpMethodType.GET, isTokenRequired: false)),
  );
  setSocialLink(dashboardResponse);
  List<HeaderModel> temp = [];

  HeaderModel? newest = await createHeaderData(
    dashboardResponse.newest.validate(),
    locale.headerNewestBookTitle,
    locale.headerNewestBookMessage,
    BOOK_TYPE_NEW,
  );

  HeaderModel? featured = await createHeaderData(
    dashboardResponse.featured.validate(),
    locale.headerFeaturedBookMessage,
    locale.headerNewestBookMessage,
    BOOK_TYPE_FEATURED,
  );

  HeaderModel? suggestedForYou = await createHeaderData(
    dashboardResponse.suggestedForYou.validate(),
    locale.headerForYouBookMessage,
    locale.headerNewestBookMessage,
    BOOK_TYPE_SUGGESTION,
  );

  HeaderModel? youMayLike = await createHeaderData(
    dashboardResponse.youMayLike.validate(),
    locale.headerLikeBookMessage,
    locale.headerNewestBookMessage,
    BOOK_TYPE_LIKE,
  );

  if (newest != null) temp.add(newest);

  if (featured != null) temp.add(featured);

  if (suggestedForYou != null) temp.add(suggestedForYou);

  if (youMayLike != null) temp.add(youMayLike);

  onHeaderCreated.call(temp);
  appStore.setLoading(false);

  apiStore.setDashboardResponse(dashboardResponse);
  return dashboardResponse;
}

Future<HeaderModel?> createHeaderData(book, title, message, type) async {
  String image1 = "";
  String image2 = "";

  if (book.length > 0) {
    if (book[0].images != null) {
      image1 = book[0].images[0].src.toString();
    }

    if (book.length > 1) {
      if (book[1].images != null) {
        image2 = book[1].images[0].src.toString();
      } else {
        image2 = image1;
      }
    } else {
      image2 = image1;
    }
    return HeaderModel(title, message, image1, image2, type);
  }

  return null;
}

void setSocialLink(DashboardResponse res) {
  appStore.setLoading(false);
  log("${res.toJson().toString()}");
  if (res.socialLink != null) {
    if (getStringAsync(CURRENCY_NAME) != res.currencySymbol?.currency.validate()) setValue(CURRENCY_NAME, res.currencySymbol?.currency.validate());
    if (getStringAsync(WHATSAPP) != res.socialLink!.whatsapp.validate()) setValue(WHATSAPP, res.socialLink!.whatsapp.validate());
    if (getStringAsync(FACEBOOK) != res.socialLink!.facebook.validate()) setValue(FACEBOOK, res.socialLink!.facebook.validate());
    if (getStringAsync(TWITTER) != res.socialLink?.twitter.validate()) setValue(TWITTER, res.socialLink?.twitter.validate());
    if (getStringAsync(INSTAGRAM) != res.socialLink?.instagram.validate()) setValue(INSTAGRAM, res.socialLink?.instagram.validate());
    if (getStringAsync(CONTACT) != res.socialLink?.contact.validate()) setValue(CONTACT, res.socialLink?.contact.validate());
    if (getStringAsync(PRIVACY_POLICY) != res.socialLink?.privacyPolicy.validate()) setValue(PRIVACY_POLICY, res.socialLink?.privacyPolicy.validate());
    if (getStringAsync(TERMS_AND_CONDITIONS) != res.socialLink?.termCondition.validate()) setValue(TERMS_AND_CONDITIONS, res.socialLink?.termCondition.validate());
    if (getStringAsync(COPYRIGHT_TEXT) != res.socialLink?.copyrightText.validate()) setValue(COPYRIGHT_TEXT, res.socialLink?.copyrightText.validate());
    if (getStringAsync(CURRENCY_SYMBOL) != res.currencySymbol?.currencySymbol.validate()) setValue(CURRENCY_SYMBOL, parseHtmlString(res.currencySymbol?.currencySymbol.validate()));
    if (getStringAsync(CURRENCY_NAME) != res.currencySymbol?.currency.validate()) setValue(CURRENCY_NAME, res.currencySymbol?.currency.validate());
    if (getStringAsync(PAYMENT_METHOD) != res.paymentMethod.validate()) appStore.setPaymentMethod(res.paymentMethod.validate());
  }
}

List<BookPurchaseResponse> tempServices = [];

Future<List<LineItems>> getPurchasedRestApi({
  required int page,
  int perPage = PER_PAGE_ITEM,
  required List<LineItems> services,
  required Function(List<BookPurchaseResponse> list) list,
  Function(bool)? lastPageCallBack,
}) async {
  appStore.setLoading(true);
  log('GET-PURCHASED-REST-API');

  Iterable res = await responseHandler(await buildHttpResponse("iqonic-api/api/v1/woocommerce/get-customer-orders?parent=0&page=$page&per_page=$perPage"));

  if (page == 1) {
    tempServices.clear();
    services.clear();
  }

  tempServices.addAll(res.map((e) {
    return BookPurchaseResponse.fromJson(e);
  }).toList());

  list.call(tempServices);

  tempServices.forEachIndexed((element, index) {
    if (element.lineItems.validate().isNotEmpty) {
      services.addAll(element.lineItems.validate());
    }
  });

  lastPageCallBack?.call(res.length != PER_PAGE_ITEM);
  appStore.setLoading(false);
  return services;
}

Future<List<CategoriesListResponse>> getCatListRestApi(int page, {int perPage = PER_PAGE_ITEM, required List<CategoriesListResponse> categories, Function(bool)? lastPageCallBack}) async {
  log('GET-CAT-LIST-REST-API');

  Iterable res = await responseHandler(await buildHttpResponse("wc/v3/products/categories?parent=0&page=$page&per_page=$perPage",isTokenRequired: false));

  if (page == 1) categories.clear();
  categories.addAll(res.map((e) => CategoriesListResponse.fromJson(e)).toList());

  lastPageCallBack?.call(res.length != PER_PAGE_ITEM);

  return categories;
}

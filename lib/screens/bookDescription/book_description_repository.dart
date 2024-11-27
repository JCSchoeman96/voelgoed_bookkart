import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/models/book_description/category_model.dart';
import 'package:bookkart_flutter/models/book_description/my_cart_model.dart';
import 'package:bookkart_flutter/models/book_description/paid_book_response.dart';
import 'package:bookkart_flutter/models/dashboard/reviews_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/models/book_description/all_book_list_response.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';

Future<BaseResponseModel> addToCartBook(Map<String, dynamic> request) async {
  log('ADD-TO-CART-BOOK');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse(
    'iqonic-api/api/v1/cart/add-cart',
    request: request,
    method: HttpMethodType.POST,
  )));
}

Future<PaidBookResponse> getPaidBookFileListRestApi(Map<String, dynamic> request) async {
  log('GET-PAID-BOOK-FILE-LIST-REST-API');
  return PaidBookResponse.fromJson(await responseHandler(
    await buildHttpResponse(
      "iqonic-api/api/v1/woocommerce/get-book-downloads",
      request: request,
      method: HttpMethodType.POST,
      isTokenRequired: appStore.isLoggedIn,
    ),
  ));
}

Future<BookDataModel> getBookDetailsRestWithLoading(BuildContext context, {required Map<String, dynamic> request}) async {
  log('GET-BOOK-DETAILS-REST-API');

  appStore.setLoading(true);
  BookDataModel res = await getBookDescriptionData(context, request).then((value) {
    appStore.setLoading(false);
    return value;
  }).catchError((e) {
    appStore.setLoading(false);
    throw e;
  });

  return res;
}

Future<BookDataModel> getBookDescriptionData(BuildContext context, Map<String, dynamic> request) async {
  Iterable it = await responseHandler(
    await buildHttpResponse(
      "iqonic-api/api/v1/woocommerce/get-product-details",
      request: request,
      isTokenRequired: appStore.isLoggedIn,
      method: HttpMethodType.POST,
    ),
    isBookDetails: true,
    req: request,
  );
  BookDataModel res = BookDataModel.fromJson(it.first);

  if (res.type == VARIABLE || res.type == GROUPED || res.type == EXTERNAL) {
    toast(locale.lblBookTypeNotSupported);
    finish(getContext);
  }
  return res;
}

Future<List<MyCartResponse>> getCartBook() async {
  log('GET-CART-BOOK-API');
  Iterable it = await responseHandler(await buildHttpResponse('iqonic-api/api/v1/cart/get-cart'));

  return it.map((e) => MyCartResponse.fromJson(e)).toList();
}

Future<List<Reviews>> getProductReviews({required int id}) async {
  log('GET-PRODUCT-REVIEWS-API');
  Iterable reviewList = await responseHandler(await buildHttpResponse('wc/v1/products/$id/reviews', isTokenRequired: false));
  return reviewList.map((model) => Reviews.fromJson(model)).toList();
}

Future<List<CategoryModel>> getSubCategories(parent) async {
  log('GET-SUBCATEGORIES-API');

  Iterable it = await responseHandler(await buildHttpResponse('wc/v3/products/categories?parent=$parent', method: HttpMethodType.GET, isTokenRequired: false));
  return it.map((e) => CategoryModel.fromJson(e)).toList();
}

Future<Reviews> bookReviewRestApi(Map<String, dynamic> request) async {
  log('BOOK-REVIEW-REST-API');
  return Reviews.fromJson(await responseHandler(await buildHttpResponse(
    "wc/v3/products/reviews",
    request: request,
    method: HttpMethodType.POST,
  )));
}

/// same reviewer can't sent same review multiple time
Future<List<BookDataModel>> getAllBookRestApi({
  required bool isCategoryBook,
  Map<String, dynamic>? request,
  required requestType,
  required List<BookDataModel> services,
  required Function(dynamic p0) lastPageCallBack,
  required int page,
}) async {
  log('GET-ALL-BOOK-REST-API');
  Map<String, dynamic> req = {};

  Map<String, dynamic> requestCombination = {
    "newest": "newest",
    "you_may_like": "special_product",
    "suggested_for_you": "special_product",
    "product_visibility": "featured",
  };

  log(requestCombination[requestType]);
  (isCategoryBook) ? req = request! : req = {requestCombination[requestType]: requestType, 'product_per_page': PER_PAGE_ITEM};

  AllBookListResponse res = AllBookListResponse.fromJson(
    await responseHandler(
      await buildHttpResponse(
        "iqonic-api/api/v1/woocommerce/get-product?parent=0&page=$page&per_page=$PER_PAGE_ITEM",
        request: req,
        method: HttpMethodType.POST,
        isTokenRequired: false,
      ),
    ),
  );

  if (page == 1) services.clear();
  services.addAll(res.data.validate());
  lastPageCallBack.call(res.data.validate().length != PER_PAGE_ITEM);

  return services;
}

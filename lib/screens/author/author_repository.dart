import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/models/author/author_list_model.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<AuthorListResponse>> getAuthorListRestApi({required int page, int perPage = PER_PAGE_ITEM, required List<AuthorListResponse> authorList, Function(bool)? lastPageCallBack}) async {
  log('GET-AUTHOR-LIST-REST-API');

  return buildHttpResponse("iqonic-api/api/v1/woocommerce/get-vendors?&paged=$page&number=$perPage",isTokenRequired: false).then((value) async {
    Iterable res = await responseHandler(value);

    if (page == 1) {
      authorList.clear();

      res.forEach((element) {
        authorList.add(AuthorListResponse.fromJson(element));
      });
    } else {
      if (res.validate().isNotEmpty) {
        res.forEach((element) {
          authorList.add(AuthorListResponse.fromJson(element));
        });
      }

      lastPageCallBack?.call(res.length != (PER_PAGE_ITEM));
    }

    return authorList;
  }).catchError((e) {
    log("ERROR WHILE MAKING REQUEST");
    throw e;
  });
}

Future<List<BookDataModel>> getAuthorBookListRestApi({required id, required int page, int perPage = PER_PAGE_ITEM, required List<BookDataModel> services, Function(bool)? lastPageCallBack}) async {
  log('GET-AUTHOR-BOOK-LIST-REST-API');

  return await buildHttpResponse("iqonic-api/api/v1/woocommerce/get-vendor-products?vendor_id=$id&paged=$page&number=$perPage",isTokenRequired: false).then((value) async {
    return responseHandler(value).then((res) {
      /// IF FIRST PAGE THE CLEAR THE DATA AND SET NEW DATA

      if (page == 1) {
        services.clear();
        res.forEach((element) {
          services.add(BookDataModel.fromJson(element));
        });
      } else {
        res.forEach((element) {
          services.add(BookDataModel.fromJson(element));
        });

        lastPageCallBack?.call(res.length != PER_PAGE_ITEM);
      }

      return services;
    }).catchError((e) {
      log("ERROR WHILE HANDING ERROR");

      throw e;
    });
  }).catchError((e) {
    log("ERROR WHILE RETRYING BOOK LIST OF AUTHOR");
    throw e;
  });
}

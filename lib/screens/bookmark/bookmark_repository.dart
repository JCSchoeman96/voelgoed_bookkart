import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/models/bookmark/bookmark_response_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/base_response_model.dart';

Future<List<BookmarkResponse>> getBookmarkRestApi() async {
  log('GET-BOOKMARK-REST-API');
  Iterable res = await responseHandler(await buildHttpResponse("iqonic-api/api/v1/wishlist/get-wishlist"), isBookMarkBook: true);
  return res.map((e) => BookmarkResponse.fromJson(e)).toList();
}

Future<BaseResponseModel> removeFromBookmarkRestApi(request) async {
  log('REMOVE-FROM-BOOKMARK-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse('iqonic-api/api/v1/wishlist/delete-wishlist/', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> addToBookmarkRestApi(request) async {
  log('ADD-TO-BOOKMARK-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse('iqonic-api/api/v1/wishlist/add-wishlist', request: request, method: HttpMethodType.POST)));
}

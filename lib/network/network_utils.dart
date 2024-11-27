import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/network/functions.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookmark/bookmark_repository.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

Future<Map<String, String>> buildTokenHeader({
  required bool requireToken,
  bool isFlutterWave = false,
  String flutterWaveSecretKey = '',
}) async {
  Map<String, String> multipleHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };

  if (appStore.isLoggedIn && isFlutterWave) {
    multipleHeaders.putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer $flutterWaveSecretKey");
  } else {
    if (appStore.isLoggedIn) {
      if (requireToken) {
        multipleHeaders.putIfAbsent('token', () => appStore.token);
        multipleHeaders.putIfAbsent('id', () => appStore.userId.toString());
      } else
        multipleHeaders.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
    }
  }

  return multipleHeaders;
}

Future buildHttpResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  bool isTokenRequired = true,
  bool isFlutterWave = false,
  String flutterWaveSecretKey = '',
  bool addConsumerKey = true,
}) async {
  if (await isNetworkAvailable()) {
    Uri url = Uri.parse(getOAuthURL(requestMethod: method.name, endpoint: endPoint, addConsumerKeys: addConsumerKey));

    Map<String, String> headers = await buildTokenHeader(
      requireToken: isTokenRequired,
      flutterWaveSecretKey: flutterWaveSecretKey,
      isFlutterWave: isFlutterWave,
    );

    Response response;

    if (method == HttpMethodType.POST) {
      response = await post(url, body: jsonEncode(request), headers: headers);
    } else if (method == HttpMethodType.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethodType.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    apiPrint(
      url: url.toString(),
      endPoint: endPoint,
      headers: jsonEncode(headers),
      hasRequest: method == HttpMethodType.POST || method == HttpMethodType.PUT,
      request: jsonEncode(request),
      statusCode: response.statusCode,
      responseBody: response.body,
      methodtype: method.name,
    );

    return response;
  } else {
    throw errorInternetNotAvailable;
  }
}

Future responseHandler(Response response, {Map<String, dynamic>? req, isBookDetails = false, isPurchasedBook = false, isBookMarkBook = false}) async {
  if ((response.statusCode).isSuccessful()) {
    if (response.body.contains("jwt_auth_no_auth_header")) {
      throw 'Authorization header not found.';
    } else if (response.body.contains("jwt_auth_invalid_token")) {
      String email = appStore.userEmail;

      if (email != "" && appStore.password != "") {
        Map<String, String> request = {"username": email, "password": appStore.password};

        if (await isNetworkAvailable()) {
          await getLoginUserRestApi(request).then((res) async {
            await appStore.setToken(res.token.validate());
            await appStore.setLoggedIn(true);

            await appStore.setUserId(res.userId.validate());
            await appStore.setTokenExpired(true);

            if (isBookDetails) {
              getBookDetailsRestWithLoading(getContext, request: req!);
            } else if (isBookMarkBook) {
              getBookmarkRestApi();
            } else {
              openSignInScreen();
            }
          }).catchError((onError) {
            openSignInScreen();
          });
        } else {
          openSignInScreen();
        }
      } else {
        openSignInScreen();
      }
    } else {
      return jsonDecode(response.body);
    }
  } else {
    appStore.setLoading(false);
    if (response.statusCode == 404) {
      if (response.body.contains("email_missing")) {
        throw 'Email Not Found';
      }
      if (response.body.contains("not_found")) {
        throw 'Current password is invalid';
      }
      if (response.body.contains("empty_wishlist")) {
        throw 'No Product Available';
      } else {
        if (response.body.contains('message'))
          throw (response.body as Map)['message'];
        else
          throw errorSomethingWentWrong;
      }
    } else if (response.statusCode == 406) {
      if (response.body.contains("code")) {
        throw response.body.contains("message");
      }
    } else if (response.statusCode == 405) {
      throw 'Method Not Allowed';
    } else if (response.statusCode == 500) {
      throw 'Internal Server Error';
    } else if (response.statusCode == 501) {
      throw 'Not Implemented';
    } else if (response.statusCode == 403) {
      if (response.body.contains("jwt_auth")) {
        throw 'Invalid Credential.';
      } else {
        throw 'Forbidden';
      }
    } else if (response.statusCode == 401) {
      throw 'Unauthorized';
    } else if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else if ((response.body).isJson()) {
      throw 'Invalid Json';
    } else {
      throw 'Please try again later.';
    }
  }
}

void apiPrint({
  String url = "",
  String endPoint = "",
  String headers = "",
  String request = "",
  int statusCode = 0,
  String responseBody = "",
  String methodtype = "",
  bool hasRequest = false,
}) {
  log("┌───────────────────────────────────────────────────────────────────────────────────────────────────────");
  log("\u001b[93m Url: \u001B[39m $url");
  log("\u001b[93m Header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) log("\u001b[93m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  log("${statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m"}");
  log('Response ($methodtype) $statusCode: $responseBody');
  log("\u001B[0m");
  log("└───────────────────────────────────────────────────────────────────────────────────────────────────────");
}

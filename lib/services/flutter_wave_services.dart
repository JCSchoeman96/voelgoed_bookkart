import 'dart:convert';

import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/cart/model/verify_transaction_response.dart' as vtr;
import 'package:bookkart_flutter/screens/cart/transaction_repository.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';
import '../network/network_utils.dart';
class FlutterWaveServices {
  final Customer customer = Customer(
    name: appStore.userName,
    phoneNumber: appStore.userContactNumber,
    email: appStore.userEmail,
  );

  void payWithFlutterWave({
    int? bookId,
    int? orderId,
    required num totalAmount,
    required String flutterWavePublicKey,
    required String flutterWaveSecretKey,
    required bool isTestMode,
    required BuildContext ctx,
  }) async {
    String transactionId = Uuid().v1();

    Flutterwave flutterWave = Flutterwave(
      context: getContext,
      publicKey: FLUTTER_WAVE_PUBLIC_KEY,
      currency: getStringAsync(CURRENCY_NAME),
      redirectUrl: BASE_URL,
      txRef: transactionId,
      amount: totalAmount.validate().toStringAsFixed(0),
      customer: customer,
      paymentOptions: "card, payattitude, barter",
      customization: Customization(title: "Pay With Flutterwave", logo: ic_logo),
      isTestMode: isTestMode,
    );

    /// Note : after flutter
    await flutterWave.charge().then((value) {
      if (value.status == "successful") {
        appStore.setLoading(true);

        verifyPayment(
          transactionId: value.transactionId.validate(),
          flutterWaveSecretKey: flutterWaveSecretKey,
        ).then((v) {
          if (orderId == null) {
            if (v.status == "success") {
              toast(v.status);
              createNativeOrder(
                getContext,
                paymentMethodName: PAYMENT_METHOD_FLUTTER_WAVE,
                bookId: bookId,
                transactionId: value.transactionId.validate(),
              ).then((v) {
                toast("Purchase successful");
                finish(ctx);
                finish(ctx);
              });
            } else {
              toast(v.status);
              afterTransaction(msg: v.status.toString(), isSuccess: true);
            }
          } else {
            Map<String, dynamic> request = {'set_paid': v.status == "success", 'status': v.status};

            updateOrderRestApi(request, orderId).then((value) {
              LiveStream().emit(REFRESH_ORDER_DETAIL);
            }).catchError(onError);
          }
        }).catchError((e) {
          if (orderId != null) afterTransaction();
        });
      } else {
        afterTransaction(msg: 'Order cancelled');
      }
    }).catchError((e) {
      if (orderId != null) afterTransaction();
    });
  }
}

Future<vtr.VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  log('VERIFY-PAYMENT-API');
  return vtr.VerifyTransactionResponse.fromJson(await responseHandler(
    await buildHttpFlutterWaveResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", isFlutterWave: true, flutterWaveSecretKey: flutterWaveSecretKey),
  ));
}

Future buildHttpFlutterWaveResponse(
  String endPoint, {
  HttpMethodType method = HttpMethodType.GET,
  Map? request,
  bool isTokenRequired = true,
  bool isFlutterWave = false,
  String flutterWaveSecretKey = '',
  bool addConsumerKey = true,
}) async {
  if (await isNetworkAvailable()) {
    Uri url = Uri.parse(endPoint);

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

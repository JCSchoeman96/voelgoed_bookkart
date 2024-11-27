import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/base_response_model.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/cart/cart_functions.dart';
import 'package:bookkart_flutter/screens/cart/model/checkout_model.dart';
import 'package:bookkart_flutter/screens/cart/model/line_items_model.dart';
import 'package:bookkart_flutter/screens/cart/model/order_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<BaseResponseModel> deleteOrderRestApi(String request) async {
  log('DELETE-ORDER-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse("wc/v3/orders/$request", isTokenRequired: false)));
}

Future<void> clearCart() async {
  log('CLEAR-CART');
  await responseHandler(await buildHttpResponse('iqonic-api/api/v1/cart/clear-cart'));
}

Future<CheckoutResponse> checkoutURLRestApi(Map<String, dynamic> request) async {
  log('CHECK-OUT-URL-REST-API');
  return CheckoutResponse.fromJson(await responseHandler(await buildHttpResponse("iqonic-api/api/v1/woocommerce/get-checkout-url", request: request, method: HttpMethodType.POST)));
}

Future<OrderResponse> bookOrderRestApi(Map<String, dynamic> request) async {
  log('BOOK-ORDER-REST-API');
  return OrderResponse.fromJson(await responseHandler(await buildHttpResponse("wc/v3/orders", request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteFromCart(Map<String, dynamic> request) async {
  log('DELETE-FROM-CART');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse('iqonic-api/api/v1/cart/delete-cart/', request: request, method: HttpMethodType.POST)));
}

Future<bool> createNativeOrder(
  BuildContext context, {
  int? bookId,
  required String paymentMethodName,
  String status = "completed",
  String transactionId = "",
  bool isSingleItem = false,
}) async {
  log('CREATE-NATIVE-ORDER');
  if (!appStore.isLoggedIn) {
    SignInScreen().launch(context);
    return false;
  }

  Map<String, dynamic> request = {
    'currency': getStringAsync(CURRENCY_NAME),
    'customer_id': appStore.userId,
    'payment_method': paymentMethodName,
    'set_paid': true,
    'status': status,
    'transaction_id': transactionId,
  };

  List<LineItemsRequest> lineItems = [];

  if (bookId != null) {
    lineItems.add(LineItemsRequest(product_id: bookId, quantity: "1"));
  } else {
    appStore.cartList.forEach((element) {
      lineItems.add(LineItemsRequest(
        product_id: element.proId,
        quantity: element.quantity,
      ));
    });
  }

  request.putIfAbsent('line_items', () => lineItems);

  log(request);

  return await bookOrderRestApi(request).then((res) {
    afterTransaction(isClearCart: bookId == null, isSuccess: true);

    LiveStream().emit(REFRESH_LIST);
    return true;
  }).catchError((onError) {
    afterTransaction();
    return false;
  });
}

Future<OrderResponse> getOrderDetail({required int id}) async {
  return OrderResponse.fromJson(await responseHandler(await buildHttpResponse('wc/v3/orders/$id')));
}

Future<BaseResponseModel> updateOrderRestApi(request, orderId) async {
  log('UPDATE-ORDER-REST-API');
  return BaseResponseModel.fromJson(await responseHandler(await buildHttpResponse("wc/v3/orders/$orderId", request: request, method: HttpMethodType.POST)));
}

void afterTransaction({
  bool isClearCart = false,
  bool isSuccess = false,
  String msg = '',
}) {
  appStore.setLoading(true);

  if (isClearCart) {
    removeCart();
  }

  getCartDetails();

  if (!isSuccess) {
    if (msg.isEmpty)
      toast(locale.lblError);
    else
      toast(msg);
  } else {
    toast("Purchase successful");
  }
}

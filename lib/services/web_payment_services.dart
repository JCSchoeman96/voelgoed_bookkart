
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/book_description/my_cart_model.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/cart/model/line_items_model.dart';
import 'package:bookkart_flutter/screens/cart/transaction_repository.dart';
import 'package:bookkart_flutter/screens/cart/view/web_view_screen.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WebPayment {
  WebPayment();

  List<LineItemsRequest> lineItems = [];

  Future placeOrder({required BuildContext context, int? id}) async {
    if (id != null) {
      lineItems.add(LineItemsRequest(product_id: id, quantity: "1"));
    } else {
      for (MyCartResponse myCart in appStore.cartList) {
        lineItems.add(LineItemsRequest(product_id: myCart.proId, quantity: myCart.quantity));
      }
    }

    Map<String, dynamic> request = {
      'currency': getStringAsync(CURRENCY_NAME),
      'customer_id': appStore.userId.toString(),
      'payment_method': "",
      'set_paid': false,
      'status': "pending",
      'transaction_id': "",
      'line_items': lineItems,
    };

    log(request);

    appStore.setLoading(true);

    await bookOrderRestApi(request).then((response) {
      appStore.setLoading(false);

      if (!appStore.isLoggedIn) SignInScreen().launch(getContext);

      getCheckOutUrl(context: context, orderId: response.id.validate(), isClearCart: id == null, callAfterTraction: true);
    }).catchError((error) {
      afterTransaction();
    });
  }

  Future getCheckOutUrl({required BuildContext context, required int orderId, bool isClearCart = false, required bool callAfterTraction}) async {
    Map<String, String> request = {"order_id": orderId.toString()};
    log(request);

    checkoutURLRestApi(request).then((res) async {
      WebViewScreen(url: res.checkoutUrl.validate(), title: "Payment", orderId: orderId.toString()).launch(navigatorKey.currentState!.context).then((value) {
        appStore.setLoading(true);
        getOrderDetail(id: orderId).then((value) async {
          if (value.status == 'completed') {
            if (callAfterTraction)
              afterTransaction(isClearCart: isClearCart, isSuccess: true);
            else
              LiveStream().emit(REFRESH_ORDER_DETAIL);
          } else {
            if (value.status != 'failed') {
              if (callAfterTraction)
                afterTransaction(isClearCart: isClearCart, isSuccess: true);
              else
                LiveStream().emit(REFRESH_ORDER_DETAIL);
            }
            appStore.setLoading(false);
            if (callAfterTraction)
              afterTransaction(isClearCart: isClearCart, isSuccess: true);
            else
              LiveStream().emit(REFRESH_ORDER_DETAIL);
          }
        }).catchError((e) {
          appStore.setLoading(false);
          log('Error: ${e.toString()}');
        });
      });
    }).catchError((e) {
      if (callAfterTraction) {
        afterTransaction(isClearCart: isClearCart, isSuccess: true);
      }
    });
  }
}

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/cart/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<void> getCartDetails() async {
  if (appStore.isLoggedIn) {
    appStore.setLoading(true);

    await getCartBook().then((value) {
      if (value.validate().length != appStore.cartList.length) {
        appStore.cartList.clear();
        appStore.cartList.addAll(value);
      }

      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });

    calculateTotal();
  }
}

Future<void> addToCart(BuildContext context, {required String bookId}) async {
  if (!appStore.isLoggedIn) SignInScreen().launch(context);

  Map<String, String> request = {'pro_id': bookId, "quantity": "1"};

  appStore.setLoading(true);
  await addToCartBook(request).then((res) async {
    toast(res.message);

    calculateTotal();
    appStore.setLoading(false);
  }).catchError((onError) {
    appStore.setLoading(false);
    calculateTotal();
  }).whenComplete(() {
    getCartDetails();
  });
}

void calculateTotal() {
  appStore.cartTotalAmount = appStore.cartList.sumByDouble((p0) => p0.price.validate().toDouble());
}

bool isCartItemPreExist({required int bookId}) {
  return appStore.cartList.any((element) => element.proId == bookId.toInt());
}

Future<void> removeCart() async {
  appStore.setLoading(true);

  clearCart().then((response) {
    appStore.cartList.clear();
    appStore.cartTotalAmount = 0;
    appStore.setLoading(false);
  }).catchError((e) {
    toast(e.toString());
  });
}

Future<void> removeFromCart(context, {required int removeProductId}) async {
  appStore.setLoading(true);

  Map<String, String> request = {'pro_id': removeProductId.toString()};

  await deleteFromCart(request).then((res) async {
    appStore.cartList.removeWhere((element) {
      return element.proId == removeProductId;
    });

    getCartDetails();
    appStore.setLoading(false);
  }).catchError((onError) {
    getCartDetails();
    appStore.setLoading(false);
    toast("Error removing cart");
  });
}

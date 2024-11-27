
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';
import '../main.dart';
import '../models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import '../screens/cart/transaction_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class RazorPayServices {
  static late Razorpay razorPay;
  static late String razorKeys;
  static late BookDataModel? dataValue;
  static late bool isSingleItems;

  static init({
    required String razorKey,
    BookDataModel? data,
    required bool isSingleItem,
  }) {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, RazorPayServices.handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, RazorPayServices.handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, RazorPayServices.handleExternalWallet);
    razorKeys = razorKey;
    dataValue = data;
    isSingleItems = isSingleItem;
  }

  static void handlePaymentSuccess(PaymentSuccessResponse response) async {
    createNativeOrder(
      getContext,
      paymentMethodName: PAYMENT_METHOD_RAZORPAY,
      isSingleItem: isSingleItems,
      bookId: dataValue?.id,
      transactionId: response.paymentId.validate(),
    );
  }

  static void handlePaymentError(PaymentFailureResponse response) {
    afterTransaction(isClearCart: false, isSuccess: false, msg: 'Order cancelled !!!');
        // afterTransaction(isClearCart: false, msg: 'Order cancelled !!!');
  }

  static void handleExternalWallet(ExternalWalletResponse response) {
    afterTransaction(isClearCart: false, isSuccess: true, msg: 'Handled by externalWallet');
        // afterTransaction(isClearCart: false, msg: 'Handled by externalWallet');

  }

  static void razorPayCheckout(num mAmount) async {
    Map<String, dynamic> options = {
      'key': razorKeys,
      'amount': (mAmount * 100),
      'name': APP_NAME,
      'theme.color': '#5f60b9',
      'description': "",
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'prefill': {'contact': appStore.userContactNumber, 'email': appStore.userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

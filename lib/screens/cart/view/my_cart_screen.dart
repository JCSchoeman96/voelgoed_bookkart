import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/book_description/my_cart_model.dart';
import 'package:bookkart_flutter/screens/cart/cart_functions.dart';
import 'package:bookkart_flutter/screens/cart/component/cart_component.dart';
import 'package:bookkart_flutter/screens/cart/component/payment_sheet_component.dart';
import 'package:bookkart_flutter/services/web_payment_services.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class MyCartScreen extends StatefulWidget {
  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  Future<void> showDialog(BuildContext context) async {
    if (appStore.paymentMethod != NATIVE) {
      WebPayment().placeOrder(context: context);
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext _context) {
          return PaymentSheetComponent(isSingleItem: false);
        },
      );
    }
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    getCartDetails();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblMyCart),
      body: Observer(
        builder: (_) => Stack(
          children: [
            AnimatedListView(
              itemCount: appStore.cartList.length,
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                MyCartResponse cartItem = appStore.cartList[index];

                return OpenBookDescriptionOnTap(
                  bookId: cartItem.proId.toString(),
                  currentIndex: index,
                  child: CartComponent(index: index, cartItem: cartItem).paddingBottom(16),
                );
              },
            ),
            BackgroundComponent(text: locale.lblEmptyCart, showLoadingWhileNotLoading: appStore.cartList.isEmpty).center(),
            AppLoader(loadingVisible: true, isObserver: true),
            if (appStore.cartList.length != 0)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(locale.lblTotal, style: primaryTextStyle()).expand(),
                          Observer(builder: (context) => Text(appStore.cartTotalAmount.toString().getFormattedPrice(), style: boldTextStyle())),
                        ],
                      ),
                      8.height,
                      AppButton(
                        text: locale.lblCheckOut,
                        textColor: white,
                        color: context.primaryColor,
                        width: context.width(),
                        onTap: () {
                          showDialog(context);
                        },
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

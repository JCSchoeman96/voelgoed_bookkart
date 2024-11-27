import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/screens/cart/cart_functions.dart';
import 'package:bookkart_flutter/screens/cart/component/payment_sheet_component.dart';
import 'package:bookkart_flutter/screens/cart/view/my_cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewFileButton extends StatefulWidget {
  final BookDataModel bookInfo;
  final String bookId;

  ViewFileButton({Key? key, required this.bookInfo, required this.bookId})
      : super(key: key);

  @override
  State<ViewFileButton> createState() => _ViewFileButtonState();
}

class _ViewFileButtonState extends State<ViewFileButton> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  Future<void> addItemToCart() async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }

    appStore.setLoading(true);

    if (isCartItemPreExist(bookId: widget.bookId.validate().toInt())) {
      appStore.setLoading(false);
      MyCartScreen().launch(context);
    } else {
      await addToCart(context, bookId: widget.bookId);
    }
  }

  Future<void> buyNow({required BookDataModel bookInfo}) async {
    if (appStore.isLoggedIn) {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return PaymentSheetComponent(bookInfo: bookInfo, isSingleItem: true);
        },
      );
    } else {
      SignInScreen().launch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookInfo.isPurchased.validate() || widget.bookInfo.isFreeBook)
      return SizedBox(width: context.width());

    return Container(
      width: context.width(),
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(defaultRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: addItemToCart,
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: kToolbarHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius)),
              child: Text(
                (isCartItemPreExist(
                        bookId: widget.bookInfo.id.validate().toInt()))
                    ? locale.lblGoToCart
                    : locale.lblAddToCart,
                style: primaryTextStyle(color: white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
              height: 28,
              child: VerticalDivider(
                color: Colors.white,
                thickness: 1.5,
              )),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              buyNow(bookInfo: widget.bookInfo);
            },
            child: Container(
              height: kToolbarHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(defaultRadius)),
              child: Text(
                locale.lblBuyNow,
                style: primaryTextStyle(color: white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/services/flutter_wave_services.dart';
import 'package:bookkart_flutter/services/web_payment_services.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../services/razor_pay_services.dart';

class PaymentSheetComponent extends StatefulWidget {
  final BookDataModel? bookInfo;
  final int? orderID;
  final int? orderAmount;
  final bool isSingleItem;
  PaymentSheetComponent({this.bookInfo, this.orderID, this.orderAmount, required this.isSingleItem});

  @override
  PaymentSheetComponentState createState() => PaymentSheetComponentState();
}

class PaymentSheetComponentState extends State<PaymentSheetComponent> {
  List paymentList = [RAZORPAY, WEB_PAY, WAVE_PAYMENT];

  int? _currentTimeValue = 0;
  int? paymentIndex;

  String selectedCurrency = "";

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: context.cardColor,
          borderRadius: BorderRadius.only(topRight: Radius.circular(defaultRadius), topLeft: Radius.circular(defaultRadius)),
        ),
        padding: EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                if (appStore.paymentMethod == NATIVE)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.lblChoosePaymentMethod, style: boldTextStyle(size: 18)),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.close, color: context.iconColor, size: 24),
                            onPressed: () {
                              finish(context, false);
                            },
                          )
                        ],
                      ),
                      Divider(),
                      AnimatedListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        itemCount: paymentList.length,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).iconTheme.color),
                            child: RadioListTile(
                              value: index,
                              dense: true,
                              title: Text(paymentList[index], style: primaryTextStyle()),
                              activeColor: context.primaryColor,
                              contentPadding: EdgeInsets.all(0),
                              groupValue: _currentTimeValue,
                              onChanged: (dynamic ind) {
                                _currentTimeValue = ind;
                                paymentIndex = index;
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (appStore.isLoggedIn)
                  Observer(
                    builder: (context) {
                      return AppButton(
                        textStyle: boldTextStyle(color: white),
                        text: locale.lblPay +
                            ' ${widget.bookInfo != null ? widget.bookInfo!.price.validate().toString().getFormattedPrice() : appStore.cartList.sumByDouble((p0) => p0.price.validate().toDouble()).toString().getFormattedPrice()}',
                        color: context.primaryColor,
                        onTap: () async {
                          WebPayment webPayment = WebPayment();

                          num totalPrice = widget.bookInfo != null ? widget.bookInfo!.price.validate() : appStore.cartList.sumByDouble((p0) => p0.price.validate().toDouble());

                          if (appStore.paymentMethod == NATIVE) {
                            if (_currentTimeValue == 0) {
                              finish(context);
                               RazorPayServices.init(razorKey: RAZOR_KEY, data: widget.bookInfo, isSingleItem: widget.isSingleItem);
                              await 1.seconds.delay;
                              appStore.setLoading(false);
                              RazorPayServices.razorPayCheckout(totalPrice);
                            } else if (_currentTimeValue == 1) {
                              finish(context);
                              if (widget.orderID != null) {
                                webPayment.getCheckOutUrl(context: context, orderId: widget.orderID.validate(), callAfterTraction: false);
                              } else {
                                (widget.bookInfo != null) ? webPayment.placeOrder(context: context, id: widget.bookInfo!.id.validate()) : webPayment.placeOrder(context: context);
                              }

                              return;
                            } else if (_currentTimeValue == 2) {
                              finish(context);
                              FlutterWaveServices().payWithFlutterWave(
                                bookId: widget.bookInfo != null ? widget.bookInfo!.id : null,
                                orderId: widget.orderID,
                                totalAmount: widget.orderAmount != null ? widget.orderAmount.validate() : totalPrice,
                                flutterWavePublicKey: FLUTTER_WAVE_PUBLIC_KEY,
                                flutterWaveSecretKey: FLUTTER_WAVE_KEY,
                                isTestMode: false,
                                ctx: context,
                              );
                              return;
                            }
                          } else {
                            finish(context);
                            if (widget.orderID != null) {
                              webPayment.getCheckOutUrl(context: context, orderId: widget.orderID.validate(), callAfterTraction: false);
                            } else {
                              (widget.bookInfo != null) ? webPayment.placeOrder(context: context, id: widget.bookInfo!.id.validate()) : webPayment.placeOrder(context: context);
                            }
                          }
                        },
                      ).center();
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

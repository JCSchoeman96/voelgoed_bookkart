import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/book_purchase_model.dart';
import 'package:bookkart_flutter/screens/cart/component/payment_sheet_component.dart';
import 'package:bookkart_flutter/screens/cart/transaction_repository.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class OrderDetailScreen extends StatefulWidget {
  BookPurchaseResponse orderData;

  OrderDetailScreen({required this.orderData});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String? dateFormat;
  bool isChanged = false;

  @override
  void initState() {
    init();
    super.initState();
    LiveStream().on(REFRESH_ORDER_DETAIL, (p0) async {
      getDetail();
    });
  }

  void init() async {
    dateFormat = DateFormat("yMMMd").format(DateTime.parse(widget.orderData.dateCreated!.date.toString()));
  }

  Future<void> getDetail() async {
    appStore.setLoading(true);
    getOrderDetail(id: widget.orderData.id.validate()).then((value) {
      appStore.setLoading(false);
      isChanged = true;
      widget.orderData.status = value.status;
      setState(() {});
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(REFRESH_ORDER_DETAIL);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, isChanged);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appBarWidget(locale.orderDetail),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichTextWidget(
                    list: [
                      TextSpan(text: '${locale.orderId}: ', style: primaryTextStyle()),
                      TextSpan(text: '#' "${widget.orderData.orderKey.validate().splitAfter('order_')}", style: secondaryTextStyle(size: 16)),
                    ],
                  ),
                  6.height,
                  RichTextWidget(
                    list: [
                      TextSpan(text: '${locale.orderCreatedAt}: ', style: primaryTextStyle()),
                      TextSpan(text: dateFormat.validate(), style: secondaryTextStyle(size: 16)),
                    ],
                  ),
                  6.height,
                  RichTextWidget(
                    list: [
                      TextSpan(text: '${locale.status}: ', style: primaryTextStyle()),
                      TextSpan(
                        text: widget.orderData.status.capitalizeFirstLetter(),
                        style: primaryTextStyle(
                          color: widget.orderData.status.validate() == PAYMENT_COMPLETED
                              ? Colors.green
                              : widget.orderData.status.validate() == PAYMENT_CANCELLED || widget.orderData.status.validate() == PAYMENT_FAILED
                                  ? Colors.red
                                  : widget.orderData.status.validate() == PAYMENT_PENDING
                                      ? Colors.orange
                                      : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  if (widget.orderData.paymentMethod.validate().isNotEmpty) ...[
                    Divider(height: 30),
                    Text('${locale.paymentDetails}', style: boldTextStyle(size: 18)),
                    16.height,
                    RichTextWidget(
                      list: [
                        TextSpan(text: '${locale.paymentMethod}: ', style: primaryTextStyle()),
                        TextSpan(text: widget.orderData.paymentMethod.validate().capitalizeFirstLetter(), style: secondaryTextStyle(size: 16)),
                      ],
                    ),
                    6.height,
                    if (widget.orderData.paymentMethodTitle.validate().isNotEmpty)
                      RichTextWidget(
                        list: [
                          TextSpan(text: '${locale.title}: ', style: primaryTextStyle()),
                          TextSpan(text: widget.orderData.paymentMethodTitle.validate().capitalizeFirstLetter(), style: secondaryTextStyle(size: 16)),
                        ],
                      ),
                  ],
                  if (widget.orderData.lineItems.validate().isNotEmpty) ...[
                    Divider(height: 30),
                    Text('${locale.orderItems}', style: boldTextStyle(size: 18)),
                    16.height,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.orderData.lineItems.validate().map((e) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (e.productImages.validate().isNotEmpty)
                              CachedImageWidget(
                                height: 60,
                                width: 50,
                                fit: BoxFit.cover,
                                radius: 8,
                                url: e.productImages.validate()[0].src.validate(),
                              ),
                            16.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${e.name.validate()}', style: boldTextStyle(), maxLines: 2),
                                Text(e.total.validate().getFormattedPrice(), style: boldTextStyle()),
                              ],
                            ).expand(),
                          ],
                        ).paddingSymmetric(vertical: 8);
                      }).toList(),
                    ),
                    20.width,
                    RichTextWidget(
                      list: [
                        TextSpan(text: 'Total Amount: ', style: boldTextStyle()),
                        TextSpan(text: widget.orderData.total.validate().getFormattedPrice(), style: secondaryTextStyle(size: 16)),
                      ],
                    ),
                  ],
                ],
              ).paddingAll(16),
            ),
            AppLoader(isObserver: true),
          ],
        ),
        bottomNavigationBar: widget.orderData.status.validate() == PAYMENT_PENDING
            ? AppButton(
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return PaymentSheetComponent(orderID: widget.orderData.id, orderAmount: widget.orderData.total.toInt(), isSingleItem: false);
                    },
                  );
                },
                color: context.primaryColor,
                elevation: 0,
                shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                text: locale.payNow,
                textStyle: boldTextStyle(color: Colors.white),
              ).paddingAll(16)
            : Offstage(),
      ),
    );
  }
}

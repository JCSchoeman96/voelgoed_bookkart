import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_purchase_model.dart';
import 'package:bookkart_flutter/screens/settings/view/order_detail_screen.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionComponent extends StatefulWidget {
  final BookPurchaseResponse? transactionListData;
  final VoidCallback? callback;
  TransactionComponent({this.transactionListData,this.callback});

  @override
  State<TransactionComponent> createState() => _TransactionComponentState();
}

class _TransactionComponentState extends State<TransactionComponent> {
  LineItems? lineItems;

  String dateFormat = DateFormat("yMMMd").toString();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    widget.transactionListData!.lineItems.validate().forEach((lineItem) => lineItems = lineItem);
    dateFormat = DateFormat("yMMMd").format(DateTime.parse(widget.transactionListData!.dateCreated!.date.toString()));
  }

  Widget buildImageWidget() {
    if (lineItems!.productImages.validate().isNotEmpty) {
      return CachedImageWidget(
        height: 100,
        width: 80,
        fit: BoxFit.cover,
        radius: 8,
        url: lineItems!.productImages.validate()[0].src.validate(),
      );
    } else {
      return Offstage();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lineItems == null) return Offstage();
    return Column(
      children: [
        8.height,
        Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(ic_order_id, height: 24, width: 24, fit: BoxFit.fill, color: context.iconColor),
                  4.width,
                  Text('#' "${widget.transactionListData!.orderKey.validate().splitAfter('order_')}", style: secondaryTextStyle()).expand(),
                  16.width,
                  Text(
                    widget.transactionListData!.status.capitalizeFirstLetter(),
                    style: boldTextStyle(
                      color: widget.transactionListData!.status.validate() == PAYMENT_COMPLETED
                          ? Colors.green
                          : widget.transactionListData!.status.validate() == PAYMENT_CANCELLED || widget.transactionListData!.status.validate() == PAYMENT_FAILED
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),
                ],
              ),
              8.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImageWidget(),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lineItems!.name.validate()}', style: boldTextStyle(), maxLines: 2),
                      Text(dateFormat.validate(), style: secondaryTextStyle()),
                      Marquee(child: Text(widget.transactionListData!.transactionId.splitAfter('ch_').validate(value: "N/A"), style: secondaryTextStyle(size: 12))),
                      Text(lineItems!.total.validate().getFormattedPrice(), style: boldTextStyle()),
                    ],
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
      ],
    ).onTap(() {
      OrderDetailScreen(orderData: widget.transactionListData!).launch(context).then((value) {
        if(value ?? false)  widget.callback?.call();
      });
    });
  }
}

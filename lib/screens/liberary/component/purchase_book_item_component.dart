import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/generated/assets.dart';
import 'package:bookkart_flutter/models/dashboard/book_purchase_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PurchaseBookItemComponent extends StatelessWidget {
  final LineItems bookData;
  final Color bgColor;

  PurchaseBookItemComponent({required this.bookData, required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width() / 2 - 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 60,
                width: 120,
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: bgColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                ),
              ),
              if (bookData.productImages.validate().isNotEmpty)
                Container(
                  decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.only(bottom: 16),
                  child: CachedImageWidget(
                    height: 130,
                    width: 90,
                    url: bookData.productImages.validate()[0].src.validate(),
                    fit: BoxFit.fill,
                  ),
                )
              else
                CachedImageWidget(
                  height: 130,
                  width: 100,
                  url: Assets.imagesImgDefault,
                  fit: BoxFit.cover,
                ),
            ],
          ),
          8.height,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Marquee(child: Text('${bookData.name.validate()}', style: primaryTextStyle())),
              8.height,
              Text(bookData.total.validate().getFormattedPrice(), style: boldTextStyle(size: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

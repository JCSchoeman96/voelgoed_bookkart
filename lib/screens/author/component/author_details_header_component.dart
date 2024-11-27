import 'dart:math';

import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/disabled_rating_bar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/author/author_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorDetailsHeaderComponent extends StatelessWidget {
  final AuthorListResponse authorDetails;

  AuthorDetailsHeaderComponent({required this.authorDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
      color: lightColors[Random().nextInt(lightColors.length)],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedImageWidget(height: 80, width: 80, url: authorDetails.gravatar.validate(), fit: BoxFit.fill).cornerRadiusWithClipRRect(40),
          8.height,
          if (authorDetails.fullName.validate().isNotEmpty) Text(authorDetails.fullName.validate(), style: boldTextStyle(color: Colors.black, size: 22)),
          DisabledRatingBarWidget(size: 15, rating: authorDetails.getRating),
          Text('${authorDetails.getRating} ${locale.lblRatingFrom} ${authorDetails.rating!.count.validate()} ${locale.lblReview.toLowerCase()}', style: secondaryTextStyle(size: 12)),
          16.height,
          if (authorDetails.storeName.validate().isNotEmpty)
            Text.rich(
              TextSpan(
                text: locale.lblStoreName + ': ',
                style: boldTextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: authorDetails.storeName.validate(),
                    style: primaryTextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          8.height,
          if (authorDetails.shopUrl.validate().isNotEmpty)
            TextIcon(
              prefix: Image.asset(ic_shop, height: 22, width: 22, fit: BoxFit.fill, color: Colors.black),
              text: locale.lblVisitMyShop,
              textStyle: primaryTextStyle(color: Colors.black),
              onTap: () {
                return commonLaunchUrl(authorDetails.shopUrl.validate());
              },
            ),
        ],
      ),
    );
  }
}

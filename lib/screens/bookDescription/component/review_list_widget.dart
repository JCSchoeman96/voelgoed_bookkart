import 'package:bookkart_flutter/components/disabled_rating_bar_widget.dart';
import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/reviews_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewListWidget extends StatelessWidget {
  final Reviews data;
  final bool isAuthor;
  final int index;

  ReviewListWidget({required this.data, this.isAuthor = false, required this.index});

  String get getName => isAuthor ? data.commentAuthor.validate(value: locale.lblUnknown) : data.name.validate(value: locale.lblUnknown);

  double get getRatings => isAuthor ? data.ratingNum.validate().toDouble() : data.rating.validate().toDouble();

  String get getDate => isAuthor ? data.commentDate.validate() : data.dateCreated.validate();

  String get getReview => isAuthor ? data.commentContent.validate() : data.review.validate();

  String get getNameInitial => getName.validate(value: APP_NAME)[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: boxDecorationWithRoundedCorners(
        backgroundColor: context.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(2),
                width: 35,
                height: 35,
                decoration: boxDecorationDefault(
                  color: context.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.primaryColor),
                  boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
                ),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: boxDecorationDefault(
                    shape: BoxShape.circle,
                    color: lightColors[index % lightColors.length],
                    boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0),
                  ),
                  child: FittedBox(child: Text(getNameInitial, style: boldTextStyle(color: Colors.black))),
                ),
              ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Marquee(child: Text(parseHtmlString(getName), textAlign: TextAlign.left, style: boldTextStyle(size: 14))),
                  4.height,
                  DisabledRatingBarWidget(rating: getRatings, size: 14),
                ],
              ).expand(),
              Text(reviewConvertDate(getDate), style: secondaryTextStyle(size: 12)),
            ],
          ),
          8.height,
          Text(getReview, textAlign: TextAlign.justify, maxLines: 6, style: secondaryTextStyle()),
        ],
      ),
    );
  }
}

import 'package:bookkart_flutter/components/disabled_rating_bar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/review_list_widget.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/write_review_dialog.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/review_screen.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookDetailReviewComponent extends StatefulWidget {
  final BookDataModel bookInfo;

  BookDetailReviewComponent({required this.bookInfo});

  @override
  BookDetailReviewComponentState createState() => BookDetailReviewComponentState();
}

class BookDetailReviewComponentState extends State<BookDetailReviewComponent> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.bookInfo.reviewsAllowed.validate())
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(locale.lblReviews.capitalizeFirstLetter(), style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16),
          if (appStore.isLoggedIn)
            AppButton(
              text: locale.lblAddReview,
              width: context.width(),
              elevation: 0,
              color: context.scaffoldBackgroundColor,
              textColor: context.primaryColor,
              shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
              onTap: () {
                showInDialog(
                  context,
                  backgroundColor: context.scaffoldBackgroundColor,
                  builder: (p0) {
                    return WriteReviewDialog(bookInfo: widget.bookInfo);
                  },
                );
              },
            ).paddingSymmetric(horizontal: 16, vertical: 16),
          8.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(widget.bookInfo.averageRating.validate(), style: boldTextStyle(size: 40)),
                  12.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DisabledRatingBarWidget(rating: widget.bookInfo.averageRating.validate().toDouble()),
                      4.height,
                      Text("(${widget.bookInfo.ratingCount.validate()} ${locale.lblCustomer} ${locale.lblReviews})", style: secondaryTextStyle(size: 12)),
                    ],
                  ),
                ],
              ),
              if (widget.bookInfo.reviewsAllowed.validate() && widget.bookInfo.reviews.validate().length > 0)
                TextButton(
                  onPressed: () {
                    ReviewScreen(widget.bookInfo.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                  child: Text(locale.lblSeeAll, style: secondaryTextStyle()),
                ),
            ],
          ).paddingSymmetric(horizontal: 16),
          16.height,
          AnimatedListView(
            itemCount: widget.bookInfo.reviews.validate().length,
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 16, right: 16),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ReviewListWidget(data: widget.bookInfo.reviews.validate()[index], isAuthor: true, index: index);
            },
          ),
        ],
      );
    return Offstage();
  }
}

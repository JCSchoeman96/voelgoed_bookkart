import 'dart:async';

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/reviews_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/review_list_widget.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewScreen extends StatefulWidget {
  final int bookId;

  ReviewScreen(this.bookId, {Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  Future<List<Reviews>>? future;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    future = getProductReviews(id: widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblReview, color: context.scaffoldBackgroundColor),
      body: SnapHelperWidget<List<Reviews>>(
        future: future,
        loadingWidget: AppLoader(),
        defaultErrorMessage: locale.lblNoDataFound,
        errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
        onSuccess: (snap) {
          if (snap.validate().isEmpty)
            return BackgroundComponent(text: locale.lblNoReviewFound, showLoadingWhileNotLoading: true).paddingOnly(top: 16, left: 16);
          else
            return AnimatedScrollView(
              children: [
                AnimatedListView(
                  shrinkWrap: true,
                  itemCount: snap.validate().length,
                  padding: EdgeInsets.all(16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ReviewListWidget(data: snap.validate()[index], index: index);
                  },
                )
              ],
            );
        },
      ),
    );
  }
}

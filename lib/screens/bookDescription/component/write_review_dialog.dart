import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WriteReviewDialog extends StatefulWidget {
  final BookDataModel bookInfo;

  WriteReviewDialog({required this.bookInfo});

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  final TextEditingController reviewCont = TextEditingController();

  double? rating;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> postReviewApi() async {
    formKey.currentState!.validate();

    if (reviewCont.text.validate().isNotEmpty || !(rating.validate() <= 1)) {
      hideKeyboard(context);

      Map<String, dynamic> request = {
        'product_id': widget.bookInfo.id.validate().toString(),
        'reviewer': appStore.userFullName,
        'user_id': appStore.userId,
        'reviewer_email': appStore.userEmail,
        'review': (reviewCont.text.validate().isNotEmpty) ? reviewCont.text : " ", 
        'rating': rating,
      };

      appStore.setLoading(true);
      await bookReviewRestApi(request).then((res) async {
        appStore.setLoading(false);
        LiveStream().emit(REFRESH_REVIEW_LIST);
        toast(locale.reviewSubmit);
        finish(context);
      }).catchError((e) {
        if (e.toString() == "Invalid Json") toast(locale.reviewMustBeUnique);

        log(e.toString());
        appStore.setLoading(false);
      });
    } else {
      toast(locale.pleaseSelectTheReview);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: context.width(),
        height: context.height() * 0.47,
        child: Stack(
          children: [
            Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(locale.lblHowMuchDoYouLove, style: boldTextStyle(size: 20)),
                  8.height,
                  Text(locale.lblMoreThanICanSay, style: primaryTextStyle(size: 18)),
                  16.height,
                  RatingBarWidget(
                    allowHalfRating: true,
                    size: 30.0,
                    activeColor: Colors.amber,
                    rating: rating.validate(),
                    onRatingChanged: (value) {
                      rating = value;
                      setState(() {});
                    },
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.MULTILINE,
                    decoration: inputDecoration(context, locale.lblWriteReview, radiusValue: 10),
                    controller: reviewCont,
                    validator: (value) {
                      if (value.validate().isEmpty) return "";
                      return null;
                    },
                  ),
                  16.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        onTap: () {
                          finish(context);
                        },
                        color: context.scaffoldBackgroundColor,
                        elevation: 0,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                        text: locale.lblCancel,
                        textStyle: primaryTextStyle(),
                      ).expand(),
                      16.width,
                      AppButton(
                        onTap: postReviewApi,
                        color: context.primaryColor,
                        textColor: Colors.white,
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                        text: locale.lblSubmit,
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ),
            AppLoader(isObserver: true),
          ],
        ),
      ),
    );
  }
}

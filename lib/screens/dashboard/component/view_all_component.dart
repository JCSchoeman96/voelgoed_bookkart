import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SeeAllButtonComponent extends StatelessWidget {
  final List<BookDataModel> yourBooks;

  final String? requestType;
  final String title;

  SeeAllButtonComponent(this.title, {required this.yourBooks, this.requestType});

  TextDirection buildTextDirection() => appStore.isRTL ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: 4, top: 16, right: 8),
      child: Row(
        children: [
          Marquee(child: Text(title, style: boldTextStyle(size: 18))).expand(),
          8.width,
          TextButton(
            child: Text(locale.lblSeeAll, style: secondaryTextStyle()),
            onPressed: () {
              ViewAllBooksScreen(title: title, requestType: requestType, categoryId: '', isCategoryBook: false, categoryName: '', showSecondDesign: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            },
          ),
        ],
      ),
    );
  }
}

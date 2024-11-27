import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BooksCategoryComponent extends StatelessWidget {
  final BookDataModel bookInfo;

  BooksCategoryComponent({required this.bookInfo});

  @override
  Widget build(BuildContext context) {
    if (bookInfo.categories.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.lblCategories, style: boldTextStyle(size: 18)).paddingLeft(16),
        HorizontalList(
          runSpacing: 8,
          spacing: 16,
          padding: EdgeInsets.only(left: 16, top: 16, right: 16),
          physics: BouncingScrollPhysics(),
          itemCount: bookInfo.categories.validate().length,
          itemBuilder: (context, index) {
            Categories item = bookInfo.categories.validate()[index];

            return GestureDetector(
              onTap: () async {
                await ViewAllBooksScreen(categoryId: item.id.toString(), categoryName: item.name.validate(), isCategoryBook: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
                decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                child: Text(item.name.validate().replaceAll('&amp;', '&').replaceAll(';', ''), style: boldTextStyle(size: 14)),
              ),
            );
          },
        ),
      ],
    );
  }
}

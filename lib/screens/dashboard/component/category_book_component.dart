import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/dashboard_category.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryBookComponent extends StatelessWidget {
  final DashboardCategory categoryBookData;

  CategoryBookComponent({required this.categoryBookData});

  @override
  Widget build(BuildContext context) {
    if (categoryBookData.product.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, bottom: 8, top: 16, right: 8),
          child: Row(
            children: [
              Marquee(child: Text(categoryBookData.name.validate().replaceAll('&amp;', '&'), style: boldTextStyle(size: 18))).expand(),
              TextButton(
                child: Text(locale.lblSeeAll, style: secondaryTextStyle()),
                onPressed: () {
                  ViewAllBooksScreen(categoryId: categoryBookData.catID.toString(), categoryName: categoryBookData.name.validate(), isCategoryBook: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: HorizontalList(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(left: 16),
            itemCount: categoryBookData.product.validate().length,
            runSpacing: 0,
            spacing: 0,
            itemBuilder: (context, i) {
              Color bgColor = bookBackgroundColor[i % bookBackgroundColor.length];
              BookDataModel data = categoryBookData.product.validate()[i];

              return OpenBookDescriptionOnTap(
                bookId: data.id.toString(),
                backgroundColor: bgColor,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BookWidget(newBookData: data, index: i, width: 160).visible(categoryBookData.product.validate().isNotEmpty),
                    16.width,
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

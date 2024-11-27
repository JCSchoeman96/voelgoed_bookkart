import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/colors.dart';

class BookListDashboardComponent extends StatelessWidget {
  final List<BookDataModel> bookList;

  const BookListDashboardComponent({Key? key, required this.bookList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HorizontalList(
      spacing: 0,
      runSpacing: 0,
      physics: BouncingScrollPhysics(),
      itemCount: bookList.length,
      itemBuilder: (BuildContext context, int index) {
        BookDataModel data = bookList[index];

        return OpenBookDescriptionOnTap(
          bookId: data.id.toString(),
          backgroundColor: borderColor,
          child: BookWidget(newBookData: data, index: index, width: 160, showSecondDesign: true),
        );
      },
    );
  }
}

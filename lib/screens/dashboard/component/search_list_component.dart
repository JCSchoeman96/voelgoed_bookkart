import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchListComponent extends StatelessWidget {
  final List<BookDataModel> itemList;

  SearchListComponent({required this.itemList});

  @override
  Widget build(BuildContext context) {
    if (itemList.validate().isNotEmpty) {
      return Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: List.generate(itemList.length, (index) {
            return OpenBookDescriptionOnTap(
              bookId: itemList[index].id.toString(),
              currentIndex: index,
              child: BookWidget(
                newBookData: itemList[index],
                index: index,
                isShowRating: true,
                width: context.width() / 2 - 16,
                showSecondDesign: true,
              ),
            );
          }),
        ),
      );
    } else {
      return Observer(
        builder: (context) {
          return BackgroundComponent(
            text: locale.lblNoBookFound,
            showLoadingWhileNotLoading: !appStore.isLoading,
          ).center();
        },
      );
    }
  }
}

import 'dart:io';

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/liberary/component/free_book_item_component.dart';
import 'package:bookkart_flutter/models/dashboard/offline_book_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FreeBookListScreen extends StatefulWidget {
  @override
  State<FreeBookListScreen> createState() => _FreeBookListScreenState();
}

class _FreeBookListScreenState extends State<FreeBookListScreen> {
  Future<List<OfflineBookList>?> future = dbHelper.queryAllRows(appStore.userId);

  void deleteBook({required List<OfflineBookList> list, required OfflineBookList bookDetail, required int index}) {
    appStore.setLoading(true);

    list[index].offlineBook.forEach((OfflineBook book) async {
      if (File(book.filePath.validate()).existsSync()) {
        await dbHelper.delete(book.filePath.validate());
        await File(book.filePath.validate()).delete();

        List<OfflineBookList>? books = await dbHelper.queryAllRows(appStore.userId);

        list.clear();
        list.addAll(books.validate());
        list.removeWhere((element) => element.id == bookDetail.id);

        appStore.setLoading(false);
        setState(() {});
      } else {
        appStore.setLoading(false);
        toast(locale.lblBookNotAvailableForDelete);
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget<List<OfflineBookList>?>(
      future: future,
      loadingWidget: AppLoader(isObserver: false),
      defaultErrorMessage: locale.lblNoDataFound,
      errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
      onSuccess: (snap) {
        if (snap.validate().isEmpty) return BackgroundComponent(image: img_no_data_found, height: 150, text: locale.lblBookNotAvailable, showLoadingWhileNotLoading: true);

        return AnimatedWrap(
          itemCount: snap.validate().length,
          listAnimationType: ListAnimationType.Scale,
          itemBuilder: (context, index) {
            return FreeBookItemComponent(
              bookDetail: snap.validate()[index],
              bgColor: getBackGroundColor(index: index),
              onRemoveBookUpdate: (bookDetail) {
                showConfirmDialogCustom(
                  context,
                  title: locale.lblAreYouSureWantToDelete,
                  dialogType: DialogType.DELETE,
                  onAccept: (p0) {
                    deleteBook(bookDetail: bookDetail, index: index, list: snap!);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

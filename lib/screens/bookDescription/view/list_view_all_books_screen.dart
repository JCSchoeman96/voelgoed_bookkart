import 'dart:core';

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/component/all_sub_category_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllBooksScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String? title;
  final String? requestType;
  final bool isCategoryBook;
  final bool showSecondDesign;

  @override
  _ViewAllBooksScreenState createState() => _ViewAllBooksScreenState();

  ViewAllBooksScreen({
    required this.isCategoryBook,
    required this.categoryName,
    this.categoryId = "",
    this.title = "",
    this.requestType,
    this.showSecondDesign = false,
  });
}

class _ViewAllBooksScreenState extends State<ViewAllBooksScreen> {
  Future<List<BookDataModel>>? future;
  List<BookDataModel> bookList = [];

  bool isLastPage = false;

  int page = 1;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  Future<void> init() async {
    Map<String, dynamic> request = {
      "category": [widget.categoryId],
      'product_per_page': BOOKS_PER_PAGE
    };

    future = getAllBookRestApi(
      isCategoryBook: widget.isCategoryBook,
      request: request,
      page: page,
      requestType: widget.requestType,
      services: bookList,
      lastPageCallBack: (p0) => isLastPage = p0,
    );
  }

  void onNextPage() {
    if (!isLastPage) {
      page++;
      init();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.categoryName.replaceAll('&amp;', '&').validate(value: widget.title.validate())),
      body: SnapHelperWidget<List<BookDataModel>>(
        future: future,
        loadingWidget: AppLoader(),
        errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
        defaultErrorMessage: locale.lblNoDataFound,
        onSuccess: (snap) {
          if (snap.isEmpty) {
            return BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true).paddingOnly(top: 16, left: 16);
          }

          return AnimatedScrollView(
            padding: EdgeInsets.only(bottom: 16),
            onNextPage: onNextPage,
            children: [
              if (widget.isCategoryBook) AllSubCategoryComponent(categoryId: widget.categoryId.validate()),
              AnimatedWrap(
                itemCount: snap.length,
                runSpacing: 16,
                listAnimationType: ListAnimationType.Scale,
                itemBuilder: (_, index) {
                  BookDataModel bookData = bookList[index];
                  return OpenBookDescriptionOnTap(
                    bookId: bookList[index].id.toString(),
                    currentIndex: index,
                    child: BookWidget(
                      showSecondDesign: widget.showSecondDesign,
                      index: index,
                      newBookData: bookData,
                      width: context.width() / 2 - 0,
                      isShowRating: true,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

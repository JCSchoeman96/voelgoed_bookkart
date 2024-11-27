import 'dart:math';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_slider_card_component.dart';
import 'package:bookkart_flutter/models/dashboard/header_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookStoreSliderComponent extends StatefulWidget {
  final List<HeaderModel> header;

  BookStoreSliderComponent({required this.header});

  @override
  BookStoreSliderComponentState createState() => BookStoreSliderComponentState();
}

class BookStoreSliderComponentState extends State<BookStoreSliderComponent> {
  PageController pageCont = PageController();

  int currentPage = 1;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    pageCont = PageController(initialPage: currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    pageCont.dispose();
    super.dispose();
  }

  double animationAngle(int index, PageController pageCont) {
    double value = 0.0;

    if (pageCont.position.haveDimensions) {
      value = index.toDouble() - (pageCont.page ?? 0);
      value = pi * (value * 0.032).clamp(-1, 1);
    }

    return value;
  }

  void _handleClick({required HeaderModel data}) {
    {
      switch (data.type) {
        case BOOK_TYPE_NEW:
          ViewAllBooksScreen(title: locale.newestBooks, requestType: REQUEST_TYPE_NEWEST, isCategoryBook: false, categoryName: '').launch(context);
          break;

        case BOOK_TYPE_FEATURED:
          ViewAllBooksScreen(title: locale.featuredBooks, requestType: REQUEST_TYPE_PRODUCT_VISIBILITY, isCategoryBook: false, categoryName: '').launch(context);
          break;

        case BOOK_TYPE_SUGGESTION:
          ViewAllBooksScreen(title: locale.booksForYou, requestType: REQUEST_TYPE_SUGGESTED_FOR_YOU, isCategoryBook: false, categoryName: '').launch(context);
          break;

        default:
          ViewAllBooksScreen(title: locale.youMayLike, requestType: REQUEST_TYPE_YOU_MAY_LIKE, categoryName: '', isCategoryBook: false).launch(context);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: PageView.builder(
        itemCount: widget.header.length,
        physics: BouncingScrollPhysics(),
        controller: pageCont,
        itemBuilder: (context, index) {
          HeaderModel data = widget.header.validate()[index];


          return GestureDetector(
            onTap: () {
              _handleClick(data: data);
            },
            child: AnimatedBuilder(
              animation: pageCont,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animationAngle(index, pageCont),
                  child: BookSliderCardComponent(data: data),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

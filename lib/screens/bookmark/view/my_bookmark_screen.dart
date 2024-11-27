import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/bookmark/bookmark_response_model.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:bookkart_flutter/models/common_models/image_model.dart';

import '../../../utils/colors.dart';
import '../bookmark_repository.dart';

class MyBookMarkScreen extends StatefulWidget {
  const MyBookMarkScreen({Key? key}) : super(key: key);

  @override
  State<MyBookMarkScreen> createState() => _MyBookMarkScreenState();
}

class _MyBookMarkScreenState extends State<MyBookMarkScreen> {
  Future<List<BookmarkResponse>>? future;

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    future = getBookmarkRestApi();
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
      appBar: appBarWidget(locale.lblMyBookmark),
      body: SnapHelperWidget<List<BookmarkResponse>>(
        future: future,
        loadingWidget: AppLoader(isObserver: false),
        errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
        defaultErrorMessage: locale.lblNoDataFound,
        onSuccess: (snap) {
          if (snap.validate().isEmpty)
            return Center(
              child: BackgroundComponent(
                text: locale.lblYouHaveBookmark,
                subTitle: locale.lblBookmarkNow,
                image: img_no_data_found,
                showLoadingWhileNotLoading: true,
              ),
            );
          else
            return AnimatedScrollView(
              crossAxisAlignment: CrossAxisAlignment.start,
              padding: EdgeInsets.only(left: 16, top: 16),
              onNextPage: onNextPage,
              children: [
                AnimatedWrap(
                  itemCount: snap.validate().length,
                  listAnimationType: ListAnimationType.Scale,
                  itemBuilder: (context, index) {
                    BookmarkResponse data = snap.validate()[index];
                    return OpenBookDescriptionOnTap(
                      bookId: snap.validate()[index].proId.toString(),
                      backgroundColor: borderColor,
                      onInit: () {
                        init();
                        setState(() {});
                      },
                      child: BookWidget(
                        width: context.width() / 2 - 20,
                        showSecondDesign: true,
                        isShowRating: true,
                        index: index,
                        newBookData: BookDataModel(
                          id: data.proId,
                          name: data.name,
                          sku: data.sku,
                          price: data.price.validate().toDouble(),
                          regularPrice: data.regularPrice.validate().toDouble(),
                          salePrice: data.salePrice.validate().toDouble(),
                          dateCreated: data.createdAt,
                          images: [
                            ImageModel(src: data.thumbnail.validate()),
                          ],
                        ),
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

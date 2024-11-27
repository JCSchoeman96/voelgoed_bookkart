import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/author/author_repository.dart';
import 'package:bookkart_flutter/models/author/author_list_model.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../component/author_details_header_component.dart';

class AuthorDetails extends StatefulWidget {
  final AuthorListResponse authorDetails;

  AuthorDetails({required this.authorDetails, Key? key}) : super(key: key);

  @override
  State<AuthorDetails> createState() => _AuthorDetailsState();
}

class _AuthorDetailsState extends State<AuthorDetails> {
  Future<List<BookDataModel>>? future;

  List<BookDataModel> bookInfoList = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    appStore.setLoading(false);
    super.initState();
    init();
  }

  void init() {
    future = getAuthorBookListRestApi(
      page: page,
      id: widget.authorDetails.id,
      services: bookInfoList,
      lastPageCallBack: (p0) {
        return isLastPage = p0;
      },
    );
  }

  void onNextPage() {
    if (!isLastPage) {
      page++;
      init();
      setState(() {});
    }
  }

  Future<void> onRefresh() {
    page = 1;
    init();
    return 2.seconds.delay;
  }

  bool get descriptionNotEmpty => widget.authorDetails.description.validate().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.authorDetails.fullName),
      body: AnimatedScrollView(
        onSwipeRefresh: onRefresh,
        onNextPage: onNextPage,
        children: [
          AuthorDetailsHeaderComponent(authorDetails: widget.authorDetails),
          SnapHelperWidget<List<BookDataModel>>(
            future: future,
            loadingWidget: AppLoader(),
            errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
            defaultErrorMessage: locale.lblNoDataFound,
            onSuccess: (snap) {
              if (snap.validate().isEmpty) {
                return BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true);
              } else {
                return AnimatedScrollView(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 60),
                  children: [
                    if (descriptionNotEmpty) ReadMoreText(widget.authorDetails.description.validate(), style: primaryTextStyle()),
                    32.height,
                    AnimatedWrap(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        return OpenBookDescriptionOnTap(
                          bookId: snap[index].id.toString(),
                          currentIndex: index,
                          child: BookWidget(
                            newBookData: snap[index],
                            index: index,
                            isShowRating: true,
                            width: context.width() / 2 - 20,
                          ).paddingTop(8),
                        );
                      },
                    )
                  ],
                );
              }
            },
          )
        ],
      ),
    );
  }
}

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/book_description_top_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/book_detail_review_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/books_category_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/description_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/get_author_component.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/screens/cart/view/my_cart_screen.dart';
import 'package:bookkart_flutter/screens/liberary/component/button_download_file_component.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class BookDescriptionScreen extends StatefulWidget {
  final String bookId;
  final Color? backgroundColor;

  BookDescriptionScreen({required this.bookId, this.backgroundColor});

  @override
  State<BookDescriptionScreen> createState() => _BookDescriptionScreenState();
}

class _BookDescriptionScreenState extends State<BookDescriptionScreen> {
  Future<BookDataModel> future = Future(() => BookDataModel());

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(REFRESH_REVIEW_LIST, (p0) async {
      init();
    });
  }

  Future<List<DownloadModel>> getPaidFileDetails() async {
    String time = await getTime();
    Map<String, String> request = {'book_id': widget.bookId, 'time': time, 'secret_salt': await getKey(time)};

    return await getPaidBookFileListRestApi(request).then((res) async {
      return res.data.validate();
    }).catchError((e) {
      throw e;
    });
  }

  void init() async {
    future = getBookDetailsRestWithLoading(context, request: {'product_id': widget.bookId});
  }

  Container _buildDownloadFileComponent(BookDataModel snap) {
    /// Show File After They Paid Or Free

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(top: 16),
      child: (!getBoolAsync(HAS_IN_REVIEW))
          ? SnapHelperWidget<List<DownloadModel>>(
              future: getPaidFileDetails(),
              defaultErrorMessage: locale.lblNoDataFound,
              errorWidget: Offstage(),
              loadingWidget: Text(locale.loadingBook, style: boldTextStyle()).center(),
              onSuccess: (data) {
                if (data.validate().isEmpty)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locale.lblBookNotAvailable, style: boldTextStyle(size: 18)),
                      16.height,
                      BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true, height: 56),
                      Text('Suggested book :', style: boldTextStyle(size: 16)),
                      16.height,
                      ButtonForDownloadFileComponent(
                        isFromAsset: true,
                        bookingData: snap,
                        isSampleFile: false,
                        downloads: DownloadModel(
                          id: '1',
                          name: 'Suggested book',
                          file: 'assets/epub/free_epub.epub',
                        ),
                      ),
                    ],
                  );
                else
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(locale.availableFiles, style: boldTextStyle(size: 18)),
                      16.height,
                      AnimatedWrap(
                        spacing: 16,
                        runSpacing: 16,
                        itemCount: data.length,
                        listAnimationType: ListAnimationType.Scale,
                        itemBuilder: (_, index) {
                          return ButtonForDownloadFileComponent(
                            bookingData: snap,
                            downloads: data[index],
                            isSampleFile: false,
                            isFromAsset: false, // TODO : MAKE FOR LIVE CHANGE LATER
                          );
                        },
                      ),
                    ],
                  );
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.availableFiles, style: boldTextStyle(size: 18)),
                16.height,
                ButtonForDownloadFileComponent(
                  isFromAsset: true,
                  bookingData: snap,
                  isSampleFile: false,
                  downloads: DownloadModel(
                    id: '1',
                    name: 'Sample File',
                    file: 'assets/epub/free_epub.epub',
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SnapHelperWidget<BookDataModel>(
        future: future,
        loadingWidget: AppLoader(isObserver: false, loadingVisible: true),
        defaultErrorMessage: locale.lblNoDataFound,
        errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
        onSuccess: (snap) {
          return Stack(
            children: [
              AnimatedScrollView(
                padding: EdgeInsets.only(bottom: 30, top: kToolbarHeight),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BackButton(),
                      Text(snap.name.validate(), style: boldTextStyle()).expand(),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          if ((isAndroid && !getBoolAsync(HAS_IN_REVIEW)))
                            IconButton(
                              icon: Icon(Icons.shopping_cart_outlined),
                              onPressed: () {
                                if (appStore.isLoggedIn) {
                                  MyCartScreen().launch(context);
                                } else {
                                  SignInScreen().launch(context);
                                }
                              },
                            ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: redColor),
                            child: Observer(
                              builder: (context) {
                                if (appStore.cartList.isNotEmpty) {
                                  return Text(
                                    appStore.cartList.length.toString(),
                                    style: primaryTextStyle(size: 12, color: white),
                                  ).paddingAll(4);
                                } else {
                                  return Offstage();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  16.height,
                  BookDescriptionTopComponent(bookId: widget.bookId, bookInfo: snap, backgroundColor: widget.backgroundColor),
                  16.height,
                  if (snap.isFreeBook.validate() || snap.isPurchased.validate()) _buildDownloadFileComponent(snap),
                  DescriptionComponent(bookInfo: snap),
                  GetAuthorComponent(bookInfo: snap),
                  32.height,
                  BooksCategoryComponent(bookInfo: snap),
                  32.height,
                  BookDetailReviewComponent(bookInfo: snap),
                ],
              ),
              AppLoader(isObserver: true, loadingVisible: true),
            ],
          );
        },
      ),
    );
  }
}

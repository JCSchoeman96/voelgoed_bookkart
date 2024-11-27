import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/cart/cart_functions.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_list_dashboard_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_store_slider_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/category_wise_book_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/view_all_component.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/models/dashboard/dashboard_response.dart';
import 'package:bookkart_flutter/models/dashboard/header_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookStoreViewFragment extends StatefulWidget {
  const BookStoreViewFragment({Key? key}) : super(key: key);

  @override
  State<BookStoreViewFragment> createState() => _BookStoreViewFragmentState();
}

class _BookStoreViewFragmentState extends State<BookStoreViewFragment> {
  Future<DashboardResponse>? future;

  List<HeaderModel> header = [];

  @override
  void initState() {
    if (mounted) {
      super.initState();

      getCartDetails();
      init();
    }
  }

  void init() {
    dashboardFromCache(onHeaderCreated: (val) {
      header = val;
      setState(() {});
    });

    future = getDashboardDataRestApi(onHeaderCreated: (val) => header = val);
  }

  String get getName => appStore.isLoggedIn ? appStore.userFullName.validate(value: appStore.userEmail.splitBefore('@')) : locale.lblGuest;

  Widget buildBookListTypeWidget({required String title, required List<BookDataModel> list, required String requestType}) {
    if (list.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeeAllButtonComponent(title, yourBooks: list, requestType: requestType),
        BookListDashboardComponent(bookList: list),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: CustomAppBar(title1: '', title2: "${locale.lblHello}, ${getName.validate()}", isHome: false),
              elevation: 10.0,
              automaticallyImplyLeading: false,
              expandedHeight: 50,
              floating: true,
            )
          ];
        },
        body: Stack(
          children: [
            SnapHelperWidget<DashboardResponse>(
              initialData: apiStore.getDashboardFromCache(),
              future: future,
              loadingWidget: AppLoader(),
              defaultErrorMessage: locale.lblNoDataFound,
              errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
              onSuccess: (snap) {
                return ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 80),
                  children: [
                    16.height,
                    if (snap.newest.validate().isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(locale.exploreBooks, style: boldTextStyle(size: 20)).paddingLeft(16),
                          16.height,
                          BookStoreSliderComponent(header: header),
                        ],
                      ),
                    CategoryWiseBookComponent(categoryList: snap.category.validate()),
                    buildBookListTypeWidget(title: locale.headerNewestBookTitle, list: snap.newest.validate(), requestType: REQUEST_TYPE_NEWEST),
                    buildBookListTypeWidget(title: locale.headerFeaturedBookTitle, list: snap.featured.validate(), requestType: REQUEST_TYPE_PRODUCT_VISIBILITY),
                    buildBookListTypeWidget(title: locale.booksForYou, list: snap.suggestedForYou.validate(), requestType: REQUEST_TYPE_SUGGESTED_FOR_YOU),
                    buildBookListTypeWidget(title: locale.youMayLike, list: snap.youMayLike.validate(), requestType: REQUEST_TYPE_YOU_MAY_LIKE),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

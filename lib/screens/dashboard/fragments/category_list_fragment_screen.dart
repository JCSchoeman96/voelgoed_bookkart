import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/category_list_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoriesListFragment extends StatefulWidget {
  final bool? showLargeTitle;

  CategoriesListFragment({this.showLargeTitle});

  @override
  _CategoriesListFragmentState createState() => _CategoriesListFragmentState();
}

class _CategoriesListFragmentState extends State<CategoriesListFragment> {
  Future<List<CategoriesListResponse>>? future;

  List<CategoriesListResponse> searchList = [];
  List<CategoriesListResponse> categories = [];

  TextEditingController searchBookCont = TextEditingController();

  bool isLastPage = false;
  int page = 1;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    future = getCatListRestApi(page, categories: categories, lastPageCallBack: (p0) => isLastPage = p0);
    searchList = categories;
  }

  Widget buildCategoryListWidget() {
    if (searchList.isEmpty && searchBookCont.text.isNotEmpty) {
      return BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true);
    } else {
      return AnimatedWrap(
        itemCount: searchList.validate().length,
        itemBuilder: (_, index) {
          CategoriesListResponse data = searchList.validate()[index];
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: context.width() / 3 - 11,
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.circle),
                    child: CachedImageWidget(url: data.image != null ? data.image!.src.validate() : ic_book_logo, color: primaryColor.withOpacity(0.2), width: 70, height: 70, circle: true),
                  ),
                  8.height,
                  Marquee(child: Text(data.name.validate().replaceAll('&amp;', ''), textAlign: TextAlign.center, style: primaryTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            onTap: () {
              hideKeyboard(context);
              ViewAllBooksScreen(categoryId: data.id.toString(), categoryName: data.name.validate(), isCategoryBook: true, showSecondDesign: true)
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.showLargeTitle ?? true) ? appBarWidget(locale.lblCategories) : AppBar(title: CustomAppBar(title1: '', title2: locale.lblCategories, isHome: false)),
      body: Stack(
        children: [
          SnapHelperWidget<List<CategoriesListResponse>>(
            future: future,
            loadingWidget: AppLoader(isObserver: false),
            defaultErrorMessage: locale.lblNoDataFound,
            errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
            onSuccess: (snap) {
              return AnimatedScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    init();
                    setState(() {});
                  }
                },
                children: [
                  AppTextField(
                    controller: searchBookCont,
                    maxLines: 1,
                    cursorColor: context.primaryColor,
                    textStyle: primaryTextStyle(),
                    suffix: ic_search.iconImage(size: 10).paddingAll(14),
                    textFieldType: TextFieldType.OTHER,
                    autoFocus: false,
                    decoration: inputDecoration(context, locale.lblSearchForBooks.validate()),
                    onChanged: (string) async {
                      searchList = categories.where((u) => (u.name!.toLowerCase().contains(string.toLowerCase()))).toList();
                      setState(() {});
                    },
                  ),
                  16.height,
                  buildCategoryListWidget(),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}

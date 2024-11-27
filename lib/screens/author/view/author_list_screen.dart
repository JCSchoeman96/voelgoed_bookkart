import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/author/author_repository.dart';
import 'package:bookkart_flutter/screens/author/component/author_list_component.dart';
import 'package:bookkart_flutter/models/author/author_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorListScreen extends StatefulWidget {
  const AuthorListScreen({Key? key}) : super(key: key);

  @override
  State<AuthorListScreen> createState() => _AuthorListScreenState();
}

class _AuthorListScreenState extends State<AuthorListScreen> {
  Future<List<AuthorListResponse>>? future;

  List<AuthorListResponse> authorList = [];
  List<AuthorListResponse> searchList = [];

  TextEditingController searchCont = TextEditingController();

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    future = getAuthorListRestApi(
      page: page,
      authorList: authorList,
      lastPageCallBack: (p0) {
        return isLastPage = p0;
      },
    );

    searchList = authorList;
    setState(() {});
  }

  Widget buildAuthorListWidget() {
    bool searchListEmpty = searchList.validate().isEmpty;

    if (searchListEmpty) {
      return BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true).paddingOnly(top: 16, left: 16);
    }

    return AnimatedWrap(
      itemCount: searchList.length,
      spacing: 8,
      runSpacing: 32,
      listAnimationType: ListAnimationType.Scale,
      itemBuilder: (context, index) {
        return AuthorListComponent(authorDetails: searchList[index]);
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

  @override
  void dispose() {
    searchCont.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblAuthor),
      body: SnapHelperWidget<List<AuthorListResponse>>(
        future: future,
        loadingWidget: AppLoader(),
        errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
        defaultErrorMessage: locale.lblNoDataFound,
        onSuccess: (snap) {
          return Stack(
            children: [
              AnimatedScrollView(
                primary: false,
                crossAxisAlignment: CrossAxisAlignment.start,
                padding: EdgeInsets.all(16),
                onNextPage: onNextPage,
                children: [
                  AppTextField(
                    cursorColor: context.primaryColor,
                    textStyle: primaryTextStyle(),
                    textFieldType: TextFieldType.OTHER,
                    autoFocus: false,
                    decoration: inputDecoration(context, locale.lblSearchByAuthorName.validate()),
                    suffix: ic_search.iconImage(size: 10).paddingAll(14),
                    controller: searchCont,
                    maxLines: 1,
                    onChanged: (string) {
                      searchList = authorList.where((u) => (u.firstName!.toLowerCase().contains(string.toLowerCase()))).toList();
                      setState(() {});
                    },
                  ),
                  16.height,
                  buildAuthorListWidget()
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

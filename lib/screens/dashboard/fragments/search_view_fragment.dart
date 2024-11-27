import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/component/search_history_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/search_list_component.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/widgets/wave.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchViewFragment extends StatefulWidget {
  const SearchViewFragment({Key? key}) : super(key: key);

  @override
  State<SearchViewFragment> createState() => _SearchViewFragmentState();
}

class _SearchViewFragmentState extends State<SearchViewFragment> {
  Future<List<BookDataModel>>? future;

  List<BookDataModel> bookList = [];
  List<String> searchHistory = [];

  SpeechToText speech = SpeechToText();

  bool isLastPage = false;
  String searchText = locale.lblNo;
  int page = 1;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    speech.initialize();
  }

  void startListening() {
    searchText = "";
    setState(() {});

    speech.listen(
      cancelOnError: true,
      onResult: (result) async {
        searchText = "${result.recognizedWords}";
        searchController.text = searchText;
        setState(() {});
        getViewAllBookData(searchText, isNewSearch: true);
      },
    );

    if (speech.hasRecognized) speech.cancel();
  }

  List<String> get getSearchHistory {
    List<String> data = getStringAsync(SEARCH_TEXT).trim().split(',');
    data.removeAt(data.length - 1);
    return data;
  }

  Future<void> getViewAllBookData(String searchQuery, {bool isNewSearch = false}) async {
    this.searchText = searchQuery;

    if (isNewSearch) {
      bookList.clear();
      page = 1;
    }

    // ONE TIME SAVE HISTORY FUNCTION
    void saveHistory(List<BookDataModel> value) {
      String oldValue = getStringAsync(SEARCH_TEXT);
      if (!oldValue.contains(searchQuery)) setValue(SEARCH_TEXT, oldValue + searchQuery + ",");

      searchHistory = getSearchHistory;
      setState(() {});
    }

    appStore.setLoading(true);
    await getAllBookRestApi(
      requestType: '',
      isCategoryBook: true,
      services: bookList,
      page: page,
      request: {
        'text': searchQuery,
        'product_per_page': BOOKS_PER_PAGE,
        "page": page,
      },
      lastPageCallBack: (p0) {
        return isLastPage = p0;
      },
    ).then((itemList) async {
      saveHistory(itemList);
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    speech.cancel();
    speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomAppBar(title1: '', title2: locale.lblSearch, isHome: false)),
      body: Stack(
        children: [
          AnimatedScrollView(
            primary: false,
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 70),
            onNextPage: () {
              if (!isLastPage) {
                page++;
                getViewAllBookData(searchText.toString(), isNewSearch: false);
                setState(() {});
              }
            },
            children: [
              /// Search Bar
              AppTextField(
                textFieldType: TextFieldType.OTHER,
                maxLines: 1,
                cursorColor: context.primaryColor,
                textStyle: primaryTextStyle(),
                autoFocus: false,
                controller: searchController,
                decoration: inputDecoration(context, locale.lblSearchForBooks.validate()),
                suffix: IconButton(icon: Icon(Icons.mic), onPressed: startListening),
                onFieldSubmitted: (p0) {
                  getViewAllBookData(p0, isNewSearch: true);
                  setState(() {});
                },
              ),

              /// Recent Searches
              SearchHistoryComponent(
                itemList: searchHistory,
                onSearchHistoryItemTap: (e) {
                  getViewAllBookData(e, isNewSearch: true);
                },
                onClearTap: () async {
                  await setValue(SEARCH_TEXT, "");
                  searchHistory.clear();
                  bookList.clear();
                  setState(() {});
                },
              ),
              16.height,

              /// Search List
              SearchListComponent(itemList: bookList),
            ],
          ),
          AppLoader(isObserver: true),
        ],
      ),
      bottomSheet: Container(
        height: 120,
        width: context.width(),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wave(color: context.primaryColor),
            Text(searchText.validate(), style: secondaryTextStyle()),
          ],
        ),
      ).visible(speech.isListening),
    );
  }
}

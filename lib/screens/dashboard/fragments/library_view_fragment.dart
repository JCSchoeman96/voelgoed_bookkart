import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/liberary/component/free_book_list_screen.dart';
import 'package:bookkart_flutter/screens/liberary/component/purchase_book_list.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MyLibraryViewFragment extends StatefulWidget {
  MyLibraryViewFragment({Key? key}) : super(key: key);

  @override
  State<MyLibraryViewFragment> createState() => _MyLibraryViewFragmentState();
}

class _MyLibraryViewFragmentState extends State<MyLibraryViewFragment> with TickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    if (mounted) {
      super.initState();

      tabController.addListener(() {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBar(title1: '', title2: locale.lblLibrary, isHome: false),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.transparent,
          tabs: [
            Container(
              child: Text(locale.lblPurchasedBook, style: primaryTextStyle()).paddingOnly(right: 16, left: 16, top: 8, bottom: 8),
              decoration: tabController.index == 0 ? boxDecorationWithRoundedCorners(backgroundColor: context.cardColor) : null,
            ),
            Container(
              child: Text(locale.lblFreeBook, style: primaryTextStyle()).paddingOnly(right: 16, left: 16, top: 8, bottom: 8),
              decoration: tabController.index == 1 ? boxDecorationWithRoundedCorners(backgroundColor: context.cardColor) : null,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: tabController,
            children: [
              PurchaseBookList(),
              FreeBookListScreen(),
            ],
          ),
        ],
      ),
    );
  }
}

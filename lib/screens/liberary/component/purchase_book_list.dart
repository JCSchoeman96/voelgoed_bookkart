import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/open_book_description_on_tap.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/liberary/component/purchase_book_item_component.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/models/dashboard/book_purchase_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PurchaseBookList extends StatefulWidget {
  const PurchaseBookList({Key? key}) : super(key: key);

  @override
  State<PurchaseBookList> createState() => _PurchaseBookListState();
}

class _PurchaseBookListState extends State<PurchaseBookList> {
  late Future<List<LineItems>> future = getPurchasedRestApi(page: page, services: purchaseBookList, lastPageCallBack: (p0) => isLastPage = p0, list: (list) {});
  List<LineItems> purchaseBookList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPurchasedRestApi(page: page, services: purchaseBookList, lastPageCallBack: (p0) => isLastPage = p0, list: (list) {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget<List<LineItems>>(
      initialData: <LineItems>[],
      future: future,
      loadingWidget: AppLoader(isObserver: false),
      defaultErrorMessage: locale.lblNoDataFound,
      errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
      onSuccess: (snap) {
        if (snap.validate().isEmpty) return BackgroundComponent(showLoadingWhileNotLoading: true, text: locale.lblNoDataFound);
        return AnimatedScrollView(
          padding: EdgeInsets.only(top: 16),
          onNextPage: () {
            if (!isLastPage) {
              page++;
              init();
              setState(() {});
            }
          },
          children: [
            AnimatedWrap(
              spacing: 0,
              itemCount: snap.length,
              listAnimationType: ListAnimationType.Scale,
              itemBuilder: (context, index) {
                if (snap.isNotEmpty) {
                  return OpenBookDescriptionOnTap(
                    bookId: snap.validate()[index].productId.toString(),
                    currentIndex: index,
                    child: PurchaseBookItemComponent(
                      bookData: snap.validate()[index],
                      bgColor: getBackGroundColor(index: index),
                    ).paddingOnly(top: 16, bottom: 16, left: 16),
                  );
                } else
                  return Offstage();
              },
            ),
          ],
        );
      },
    );
  }
}

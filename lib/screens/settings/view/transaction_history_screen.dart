import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/models/dashboard/book_purchase_model.dart';
import 'package:bookkart_flutter/screens/settings/component/transaction_component.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  Future<List<LineItems>>? future;

  List<LineItems> services = [];
  List<BookPurchaseResponse> transactionListData = [];

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
    future = getPurchasedRestApi(
      services: services,
      lastPageCallBack: (p0) => isLastPage = p0,
      perPage: 15,
      page: page,
      list: (list) => transactionListData = list,
    );
  }

  @override
  void dispose() {
    if (appStore.isLoading) appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblTransactionHistory),
      body: SnapHelperWidget<List<LineItems>>(
        future: future,
        loadingWidget: AppLoader(),
        errorBuilder: (e) {
          appStore.setLoading(false);
          return BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true);
        },
        defaultErrorMessage: locale.lblNoDataFound,
        onSuccess: (snap) {
          if (transactionListData.isNotEmpty) {
            return AnimatedListView(
              itemCount: transactionListData.length,
              padding: EdgeInsets.only(left: 8, right: 8),
              physics: ClampingScrollPhysics(),
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  init();
                  setState(() {});
                }
              },
              itemBuilder: (context, index) {
                return TransactionComponent(
                  transactionListData: transactionListData[index],
                  callback: () {
                    setState(() {});
                  },
                );
              },
            );
          }

          return BackgroundComponent(text: locale.lblNoTransactionDataFound, showLoadingWhileNotLoading: true).center();
        },
      ),
    );
  }
}

import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/offline_book_list_model.dart';
import 'package:bookkart_flutter/screens/liberary/component/show_setting_option.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FreeBookItemComponent extends StatelessWidget {
  final OfflineBookList bookDetail;
  final Color bgColor;
  final Function(OfflineBookList bookDetail) onRemoveBookUpdate;

  late final String bookImage;

  FreeBookItemComponent({
    required this.bookDetail,
    required this.bgColor,
    required this.onRemoveBookUpdate,
  }) {
    this.bookImage = bookDetail.frontCover.validate().toString();
  }

  void showSettingOptions(BuildContext context, OfflineBookList downloadData) {
    Set<String> uniqueFilePaths = {};
    List<OfflineBook> uniqueOfflineBooks = [];
    for (var book in downloadData.offlineBook) {
      if (uniqueFilePaths.add(book.filePath ?? '')) {
        uniqueOfflineBooks.add(book);
      }
    }
    downloadData.offlineBook = uniqueOfflineBooks;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ShowSettingOption(offlineList: downloadData);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        appStore.setLoading(false);
        showSettingOptions(context, bookDetail);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          8.height,
          SizedBox(
            width: context.width() / 2,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 70,
                  width: 130,
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: bgColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(120),
                      topRight: Radius.circular(120),
                    ),
                  ),
                ),
                Container(
                  decoration:
                      boxDecorationWithRoundedCorners(borderRadius: radius(10)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: EdgeInsets.only(bottom: 16),
                  child: CachedImageWidget(
                    height: 130,
                    width: 90,
                    url: bookImage,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          8.height,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButton(
                shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
                text: locale.lblDelete,
                textStyle: primaryTextStyle(size: 14, color: Colors.redAccent),
                elevation: 0,
                padding: EdgeInsets.zero,
                onTap: () {
                  onRemoveBookUpdate(bookDetail);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

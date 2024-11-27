import 'package:bookkart_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchHistoryComponent extends StatelessWidget {
  final void Function() onClearTap;
  final void Function(String p) onSearchHistoryItemTap;
  final List<String> itemList;

  SearchHistoryComponent({
    required this.onClearTap,
    required this.onSearchHistoryItemTap,
    required this.itemList,
  });

  @override
  Widget build(BuildContext context) {
    if (itemList.isEmpty) return Offstage();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(locale.lblRecentSearch, style: boldTextStyle(size: 18)),
            TextButton(
              child: Text(locale.lblClearAll, style: secondaryTextStyle(size: 12)),
              onPressed: onClearTap,
            )
          ],
        ),
        AnimatedWrap(
          runSpacing: 4,
          spacing: 8,
          itemCount: itemList.length,
          listAnimationType: ListAnimationType.Scale,
          itemBuilder: (p0, p1) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                hideKeyboard(context);
                onSearchHistoryItemTap.call(itemList[p1]);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text(itemList[p1], style: primaryTextStyle(color: white)),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: context.primaryColor,
                  borderRadius: radius(18),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

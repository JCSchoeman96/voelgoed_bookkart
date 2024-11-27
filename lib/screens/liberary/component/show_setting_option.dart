import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/dashboard/offline_book_list_model.dart';
import 'package:bookkart_flutter/screens/liberary/component/list_of_file_view.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ShowSettingOption extends StatelessWidget {
  final OfflineBookList offlineList;

  ShowSettingOption({required this.offlineList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16),
                  padding: EdgeInsets.only(right: 8),
                  child: Text(locale.lblAllFiles, style: boldTextStyle(size: 20), textAlign: TextAlign.center),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 30),
                  onPressed: () {
                    finish(context);
                  },
                ),
              ],
            ),
            Container(margin: EdgeInsets.only(top: 16), height: 2, color: lightGrayColor),
            if (offlineList.offlineBook.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 20),
                child: AnimatedListView(
                  physics: BouncingScrollPhysics(),
                  itemCount: offlineList.offlineBook.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListOfFileView(
                      isOfflineBook: true,
                      bookId: offlineList.bookId.validate(),
                      downloads: offlineList.offlineBook[index],
                      bookImage: offlineList.frontCover.validate(),
                      bookName: offlineList.bookName.validate(),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/screens/liberary/component/button_download_file_component.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectFileType extends StatelessWidget {
  final List<DownloadModel> downloadFile;
  final BookDataModel bookingData;
  final bool? isSampleFile;

  SelectFileType({required this.downloadFile, required this.bookingData, this.isSampleFile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: false,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius(12)),
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
                )
              ],
            ),
            Container(height: 2, margin: EdgeInsets.only(top: 16), color: lightGrayColor),
            if (downloadFile.isNotEmpty)
              Container(
                margin: EdgeInsets.only(top: 20),
                child: AnimatedListView(
                  itemCount: downloadFile.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ButtonForDownloadFileComponent(
                      downloads: downloadFile[index],
                      isFromAsset: false,
                      isSampleFile: isSampleFile ?? false,
                      bookingData: bookingData,
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

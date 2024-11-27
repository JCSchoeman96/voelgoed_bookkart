import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookView/component/pdf_view_component.dart';
import 'package:bookkart_flutter/models/dashboard/offline_book_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ListOfFileView extends StatefulWidget {
  final OfflineBook downloads;

  final String bookImage;
  final String bookName;
  final String bookId;
  final bool isOfflineBook;

  ListOfFileView({required this.bookId, required this.downloads, required this.bookImage, required this.bookName, required this.isOfflineBook});

  @override
  _ListOfFileViewState createState() => _ListOfFileViewState();
}

class _ListOfFileViewState extends State<ListOfFileView> {
  String fileUrl = "";
  int? totalPage = 0;

  bool isPDFFile = false;
  bool isVideoFile = false;
  bool isAudioFile = false;
  bool isEpubFile = false;
  bool isDefaultFile = false;
  bool isFileExist = true;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() {
    appStore.setLoading(true);
    afterBuildCreated(() {
      appStore.setLoading(false);
    });

    checkFileForDownload();
  }

  void checkFileForDownload() {
    fileUrl = widget.downloads.filePath.toString();
    final String filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);

    isPDFFile = filename.contains(PDF);
    isEpubFile = filename.contains(EPUB);
    isVideoFile = filename.contains(MP4) || filename.contains(MOV) || filename.contains(WEBM);
    isAudioFile = filename.contains(MP3) || filename.contains(FLAC);

    isDefaultFile = !(isPDFFile || isEpubFile || isVideoFile || isAudioFile);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPDFFile) Image.asset(img_pdf, width: 24),
                    if (isVideoFile) Image.asset(img_video, width: 24),
                    if (isAudioFile) Image.asset(img_music, width: 24),
                    if (isEpubFile) Image.asset(img_epub, width: 24),
                    if (isDefaultFile) Image.asset(img_default, width: 24),
                    SizedBox(width: 8),
                    Text(widget.downloads.fileType.validate(), textAlign: TextAlign.center, style: primaryTextStyle(size: 18))
                  ],
                ).flexible(flex: 1),
                if (!isFileExist) Image.asset(img_downloads, width: 24).flexible(flex: 1) else SizedBox()
              ],
            ),
            Container(margin: EdgeInsets.only(top: 16, bottom: 8), height: 1)
          ],
        ),
      ),
      onTap: () async {
        if (await (nativeDecrypt(filePath: File(widget.downloads.filePath.validate()).path))) {
          appStore.setDecryption(false);
          appStore.setEncryption(false);

          if (File(widget.downloads.filePath.validate()).path.contains('.pdf')) {
            if (File(File(widget.downloads.filePath.validate()).path).existsSync())
              PdfViewComponent(bookId: widget.bookId.validate(), filePath: File(widget.downloads.filePath.validate()).path).launch(context).then((value) {
                finish(context);
              });
          }

          setState(() {});
          log("decrypted file path : ${File(widget.downloads.filePath.validate()).path}");
        } else if (File(widget.downloads.filePath.validate()).path.contains(EPUB)) {
          finish(context);
          openEpubFile(
            context,
            filePath: File(widget.downloads.filePath.validate()).path,
            bookID: widget.bookId,
          );
        }
      },
    );
  }
}

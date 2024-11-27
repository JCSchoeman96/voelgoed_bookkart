import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/screens/bookView/view/audio_book_player_screen.dart';
import 'package:bookkart_flutter/screens/bookView/view/epub_view_file.dart';
import 'package:bookkart_flutter/screens/bookView/view/video_book_player_screen.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ButtonForDownloadFileComponent extends StatefulWidget {
  final DownloadModel downloads;
  final bool isSampleFile;
  final BookDataModel bookingData;
  final bool isFromAsset;

  ButtonForDownloadFileComponent({
    required this.isFromAsset,
    required this.downloads,
    required this.bookingData,
    this.isSampleFile = false,
  });

  @override
  ButtonForDownloadFileComponentState createState() => ButtonForDownloadFileComponentState();
}

class ButtonForDownloadFileComponentState extends State<ButtonForDownloadFileComponent> {
  bool get isDefaultFile => !(widget.downloads.filename.contains(PDF) ||
      widget.downloads.filename.contains(MP4) ||
      widget.downloads.filename.contains(MOV) ||
      widget.downloads.filename.contains(WEBM) ||
      widget.downloads.filename.contains(MP3) ||
      widget.downloads.filename.contains(FLAC) ||
      widget.downloads.filename.contains(EPUB));

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    onDispose();

    super.dispose();
  }

  Future<void> onDispose() async {
    String fullFilePath = await getBookFilePath(widget.downloads.id, widget.downloads.file.validate());
    if (await File(fullFilePath).exists()) {
      // if (fullFilePath.isNotEmpty && fullFilePath.contains('.epub')) File(fullFilePath).deleteSync();
    }
  }
  void openFromAsset() {
    /// Opening from assets

    afterBuildCreated(() {
      log("FILE IS NOT DOWNLOADED");
      openEpubFile(
        context,
        bookID: widget.bookingData.id.validate().toString(),
        filePath: 'assets/epub/free_epub.epub',
        isFromAssets: true,
      );
    });
  }

  Future<bool> checkFileIsExist() async {
    return await getBookFilePath(
      widget.downloads.id.validate(),
      widget.downloads.file.validate(),
      isSampleFile: widget.isSampleFile,
    ).then((value) {
      return File('$value').existsSync() ? true : false;
    }).catchError((e) {
      throw e;
    });
  }

  Future<void> navigateToScreen(BuildContext context) async {
    if (widget.downloads.filename.isVideo) {
      await VideoBookPlayerScreen(downloads: widget.downloads).launch(context);
    } else if (widget.downloads.filename.isAudio) {
      await AudioBookPlayerScreen(
        url: widget.downloads.file.validate(),
        bookImage: widget.downloads.file.validate(),
        bookName: widget.downloads.name.validate(),
      ).launch(context);
    } else if (widget.downloads.filename.isPdf || widget.downloads.filename.contains(EPUB)) {
      await PdfEpubViewScreen(
        bookId: widget.bookingData.id.toString(),
        bookImage: widget.bookingData.getImage,
        downloadFile: widget.downloads,
        isPDFFile: widget.downloads.filename.isPdf,

        /// check file exist or not
        isFileExist: await checkFileIsExist(),
        bookName: widget.bookingData.name.validate(),
      ).launch(context);
    } else {
      toast(locale.lblBookTypeNotSupported);
    }
  }

  Widget _buildImage() {
    if (widget.downloads.filename.isPdf) return Image.asset(img_pdf, width: 24, color: context.iconColor);
    if (widget.downloads.filename.isVideo) return Image.asset(img_video, width: 24, color: context.iconColor);
    if (widget.downloads.filename.isAudio) return Image.asset(img_music, width: 24, color: context.iconColor);
    if (widget.downloads.filename.contains(EPUB)) return Image.asset(img_epub, width: 24, color: context.iconColor);
    if (isDefaultFile) return Image.asset(img_default, width: 24, color: context.iconColor);

    return Offstage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() / 2 - 26,
      decoration: boxDecorationDefault(boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0), color: context.cardColor),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          /// For making test we are importing from the asset

          if (widget.isFromAsset && widget.downloads.filename.contains(EPUB)) {
            openFromAsset();
          } else
            await navigateToScreen(context);
        },
        child: Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                8.width,
                Marquee(
                  child: Text(
                    widget.downloads.name.validate().capitalizeFirstLetter(),
                    textAlign: TextAlign.start,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: primaryTextStyle(size: 18, color: context.iconColor),
                  ),
                ).expand()
              ],
            ).expand(),
            16.width,
            if (widget.downloads.filename.isPdf || widget.downloads.filename.contains(EPUB))
              SnapHelperWidget<bool>(
                future: checkFileIsExist(),
                onSuccess: (snap) {
                  if (snap)
                    return Offstage();
                  else
                    return Image.asset(img_downloads, width: 18, color: context.iconColor);
                },
              ),
          ],
        ).paddingSymmetric(vertical: 8),
      ),
    );
  }
}

import 'dart:async';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nb_utils/nb_utils.dart';

class FileViewComponent extends StatefulWidget {
  final void Function(int? page, int? total) pageChange;

  final Completer<PDFViewController> pdfController;

  final String bookId;
  final String filePath;
  final bool pdfFile;

  FileViewComponent({
    required this.pdfFile,
    required this.pdfController,
    required this.filePath,
    required this.bookId,
    required this.pageChange,
    Key? key,
  }) : super(key: key);

  @override
  State<FileViewComponent> createState() => _FileViewComponentState();
}

class _FileViewComponentState extends State<FileViewComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setDecryption(false);
    appStore.setEncryption(false);

    if (mounted) super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pdfFile) {
      return SizedBox(
        height: context.height(),
        child: PDFView(
          filePath: widget.filePath,
          pageSnap: false,
          swipeHorizontal: false,
          nightMode: appStore.isDarkMode,
          defaultPage: appStore.page.validate(),
          onPageChanged: widget.pageChange,
          onViewCreated: (PDFViewController pdfViewController) {
            widget.pdfController.complete(pdfViewController);
          },
          onPageError: (page, error) {
            log('Something gone wrong pdf');
          },
        ),
      );
    }
    return AppButton(
      color: primaryColor,
      text: locale.open,
      shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
      textStyle: boldTextStyle(color: white),
      onTap: () {
        openEpubFile(context, filePath: widget.filePath, bookID: widget.bookId);
      },
    ).center();
  }
}

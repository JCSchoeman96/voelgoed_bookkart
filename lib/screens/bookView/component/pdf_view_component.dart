import 'dart:async';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nb_utils/nb_utils.dart';

class PdfViewComponent extends StatefulWidget {
  final String bookId;
  final String filePath;

  PdfViewComponent({required this.bookId, required this.filePath});

  @override
  _PdfViewComponentState createState() => _PdfViewComponentState();
}

class _PdfViewComponentState extends State<PdfViewComponent> {
  int totalPage = 0;
  final Completer<PDFViewController> pdfCont = Completer<PDFViewController>();

  TextEditingController textEditingCont = TextEditingController();

  @override
  void initState() {
    super.initState();
  }
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onFloatingActionTap(BuildContext context) async {
    showInDialog(
      context,
      title: Text(locale.jumpTo),
      builder: (p0) {
        return AppTextField(
          keyboardType: TextInputType.number,
          textFieldType: TextFieldType.MULTILINE,
          decoration: inputDecoration(context, locale.lblEnterPageNumber, radiusValue: 10),
          controller: textEditingCont,
          maxLines: 1,
          minLines: 1,
        );
      },
      actions: [
        AppButton(
          elevation: 0,
          text: locale.lblCancel,
          textStyle: primaryTextStyle(color: context.primaryColor),
          shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
          onTap: () async {
            finish(context, appStore.page.validate() - 1);
          },
        ),
        AppButton(
          text: locale.lblOk,
          elevation: 0,
          color: context.primaryColor,
          textStyle: primaryTextStyle(color: white),
          shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
          onTap: () async {
            appStore.setPage(textEditingCont.text.toInt());
            finish(context);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    nativeEncrypt(filePath: widget.filePath);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height(),
        child: PDFView(
          filePath: widget.filePath,
          pageSnap: false,
          swipeHorizontal: false,
          nightMode: appStore.isDarkMode,
          defaultPage: appStore.page.validate(),
          onPageChanged: (page, total) {
            setValue(PAGE_NUMBER + widget.bookId.validate(), page);
            appStore.setPage(page.validate() + 1);
            totalPage = total.validate();
            setState(() {});
          },
          onViewCreated: (PDFViewController pdfViewController) {
            pdfCont.complete(pdfViewController);
          },
          onPageError: (page, error) {
            log('Something gone wrong pdf');
          },
        ),
      ),
      floatingActionButton: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () async {
          await onFloatingActionTap(context);
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationRoundedWithShadow(50, backgroundColor: context.cardColor),
          child: Text(locale.lblGoTo + "${" ${appStore.page.validate()} / $totalPage"}", style: boldTextStyle()),
        ),
      ),
    );
  }
}

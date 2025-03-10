import 'dart:async';
import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/screens/bookView/component/file_view_component.dart';
import 'package:bookkart_flutter/models/book_description/downloaded_book_model.dart';
import 'package:bookkart_flutter/models/dashboard/offline_book_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

enum CustomFileType { PDF, EPUB }

class PdfEpubViewScreen extends StatefulWidget {
  final DownloadModel downloadFile;
  final bool isPDFFile;
  final bool isFileExist;
  final String bookImage;

  final String bookName;
  final String bookId;

  final bool? isOffline;
  late final CustomFileType fileType;

  PdfEpubViewScreen({
    required this.bookId,
    required this.bookName,
    required this.bookImage,
    required this.downloadFile,
    required this.isPDFFile,
    required this.isFileExist,
    this.isOffline,
  }) {
    if (isPDFFile) {
      fileType = CustomFileType.PDF;
    } else {
      fileType = CustomFileType.EPUB;
    }
  }

  @override
  State<PdfEpubViewScreen> createState() => _PdfEpubViewScreenState();
}

class _PdfEpubViewScreenState extends State<PdfEpubViewScreen> {
  final Completer<PDFViewController> pdfCont = Completer<PDFViewController>();

  bool isOffline = false;
  TextEditingController textEditingCont = TextEditingController();

  bool isFileDownloading = true;
  bool isDownloadFailFile = false;

  double percentageCompleted = 0;
  String fullFilePath = "";

  int? totalPage = 0;

  bool localEpubFile = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isRequiredToDownloadFile();
  }

  Future<void> isRequiredToDownloadFile() async {
    switch (widget.fileType) {
      case CustomFileType.PDF:
        await openPDF();
        break;

      case CustomFileType.EPUB:
        openEpub();
        break;
    }

    setState(() {});
  }

  bool get isBetweenZeroToHundred {
    return percentageCompleted.toString().substring(0, percentageCompleted.toString().length - 2).toInt() != 0;
  }

  bool get downloadComplete {
    return percentageCompleted.toString().substring(0, percentageCompleted.toString().length - 2).toInt() == 100;
  }

  String get getPercentage {
    return percentageCompleted.toString().substring(0, percentageCompleted.toString().length - 2) + "% ${locale.lblComplete}";
  }

  String get getPageNumbers {
    return locale.lblGoTo + "${widget.isPDFFile ? " ${appStore.page.validate()} / $totalPage" : ''}";
  }

  bool get isFileOpened {
    return (widget.isPDFFile && !isFileDownloading) || (widget.isOffline ?? false);
  }

  openPDF() async {
    String filePath = await getBookFilePath(widget.downloadFile.id, widget.downloadFile.file.validate());

    appStore.setLoading(true);
    bool isFileExistOffline = File(filePath).existsSync();

    if (isFileExistOffline) {
      await getOfflineFile();
    } else {
      await getOnlineFile();
    }

    setPageNumber();
  }

  void setPageNumber() {
    int currentPage = getIntAsync(PAGE_NUMBER + widget.downloadFile.id.validate());

    if (currentPage.toString().isNotEmpty) {
      appStore.setPage(currentPage);
    } else {
      appStore.setPage(0);
    }
  }

  Future<void> getOnlineFile() async {
    if (await checkPermission()) {
      isFileDownloading = true;
      await downloadFile();
    } else {
      await openAppSettings();
      await downloadFile();
    }

    isOffline = false;
  }

  Future<void> getOfflineFile() async {
    appStore.setLoading(false);
    String filePath = await getBookFilePath(widget.downloadFile.id, widget.downloadFile.file.validate());

    if (await nativeDecrypt(filePath: File(filePath).path) && filePath.contains('.pdf')) {
      fullFilePath = File(filePath).path;
      stopLoading();
      setState(() {});
    }

    isOffline = true;
  }

  Future<void> openEpub() async {
    if (await checkPermission()) {
      await downloadFile();
    } else {
      await Future.wait({openAppSettings(), downloadFile()});
    }
  }

  Future<void> downloadFile() async {
    isFileDownloading = true;
    setState(() {});

    await downloadFileFromProvidedLink(
      link: widget.downloadFile.file.validate(),
      locationOfStorage: widget.downloadFile,
      progress: (percentage) async {
        percentageCompleted = percentage;
        setState(() {});
      },
      onError: () {
        isDownloadFailFile = true;
        setState(() {});
      },
      onSuccess: () async {
        fullFilePath = await getBookFilePath(widget.downloadFile.id, widget.downloadFile.file.validate());

        if (fullFilePath.contains('.epub')) {
          finish(context);
          openEpubFile(context, filePath: fullFilePath, bookID: widget.bookId);
          stopLoading();
        }
        stopLoading();
        setState(() {});
      },
    );
  }

  Future<void> insertFileIntoDatabase(String filePath) async {
    // if (filePath.contains('.pdf')) {
      List<OfflineBookList>? data = await dbHelper.queryAllRows(appStore.userId);

      DownloadedBook book = DownloadedBook(
        userId: appStore.userId.toString(),
        bookId: widget.bookId,
        bookName: widget.bookName,
        frontCover: widget.bookImage,
        fileType: widget.isPDFFile ? "PDF FILE" : "EPUB FILE",
        filePath: filePath,
        fileName: '',
      );

      if (data.validate().isEmpty) {
        dbHelper.insert(book);
      } else {
        data?.toSet().toList() ?? [];
        data?.forEach((element) {
          element.offlineBook.forEach((element) {
            if (element.filePath != filePath) {
              dbHelper.insert(book);
            }
          });
        });
      }
        // }
  }

  void stopLoading() {
    isFileDownloading = false;
    isDownloadFailFile = false;
    appStore.setDecryption(false);
    appStore.setEncryption(false);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    disposeFun();
  }

  Future<void> disposeFun() async {
    appStore.setEncryption(true);
    String filePath = await getBookFilePath(widget.downloadFile.id, widget.downloadFile.file.validate());
    await nativeEncrypt(filePath: filePath).then((value) {
      insertFileIntoDatabase(filePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(widget.bookName.toString()),
      body: Stack(
        children: [
          Builder(
            builder: (context) {
              if (isFileDownloading) {
                if (isDownloadFailFile) {
                  return Text(locale.lblDownloadFailed, style: boldTextStyle(size: 20)).paddingOnly(top: 16, bottom: 16).center();
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isBetweenZeroToHundred) Text(getPercentage, style: boldTextStyle(size: 20)).paddingOnly(top: 20),
                        Text((downloadComplete) ? "Encrypting" : "Opening", style: primaryTextStyle(size: 20)),
                      ],
                    ),
                  );
                }
              } else {
                return FileViewComponent(
                  pdfController: pdfCont,
                  bookId: widget.downloadFile.id.validate(),
                  filePath: fullFilePath,
                  pdfFile: widget.isPDFFile,
                  pageChange: (int? page, int? total) {
                    setValue(PAGE_NUMBER + widget.downloadFile.id.validate(), page);
                    appStore.setPage(page.validate() + 1);

                    totalPage = total;
                    setState(() {});
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: isFileOpened
          ? GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: boxDecorationRoundedWithShadow(50, backgroundColor: context.cardColor),
                child: Text(getPageNumbers, style: boldTextStyle()),
              ),
              onTap: () async {
                if (widget.isPDFFile) {
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
                          await (await pdfCont.future).setPage(textEditingCont.text.toInt());
                          finish(context);
                        },
                      ),
                    ],
                  );
                }
              },
            )
          : Offstage(),
    );
  }
}

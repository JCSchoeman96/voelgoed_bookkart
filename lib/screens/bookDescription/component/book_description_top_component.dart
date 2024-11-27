import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/view_file_button.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookDescriptionTopComponent extends StatefulWidget {
  final BookDataModel bookInfo;
  final Color? backgroundColor;
  final String bookId;

  BookDescriptionTopComponent({this.backgroundColor, required this.bookId, required this.bookInfo});

  @override
  State<BookDescriptionTopComponent> createState() => _BookDescriptionTopComponentState();
}

class _BookDescriptionTopComponentState extends State<BookDescriptionTopComponent> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 70,
              width: 140,
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: widget.backgroundColor ?? Colors.grey,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
              ),
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.only(bottom: 16),
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10)),
              child: CachedImageWidget(width: 100, height: 140, fit: BoxFit.fill, url: widget.bookInfo.img),
            ),
          ],
        ),
        16.height,
        if (!getBoolAsync(HAS_IN_REVIEW)) ViewFileButton(bookId: widget.bookId, bookInfo: widget.bookInfo),
      ],
    );
  }
}

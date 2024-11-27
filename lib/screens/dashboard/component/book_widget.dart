import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_data_component.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookWidget extends StatefulWidget {
  final BookDataModel newBookData;
  final int index;
  final double? width;
  final bool? isShowRating;
  final bool showSecondDesign;

  BookWidget({
    required this.newBookData,
    required this.index,
    this.width,
    this.isShowRating,
    this.showSecondDesign = false,
  });

  @override
  BookWidgetState createState() => BookWidgetState();
}

class BookWidgetState extends State<BookWidget> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showSecondDesign) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: widget.width ?? 110,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: context.scaffoldBackgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      width: 100,
                      margin: EdgeInsets.only(left: 14, bottom: 8, top: 4),
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: getBackGroundColor(index: widget.index), width: 2),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      left: 8,
                      top: 10,
                      bottom: 4,
                      child: Container(
                        height: 150,
                        width: 100,
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: context.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: getBackGroundColor(index: widget.index), width: 2),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      bottom: 0,
                      child: Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: CachedImageWidget(
                          height: 150,
                          width: 100,
                          url: widget.newBookData.img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                8.height,
                Text(
                  widget.newBookData.name.validate(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: primaryTextStyle(size: 14),
                ).paddingSymmetric(horizontal: 16),
              ],
            ),
          ),
          if (widget.isShowRating ?? false) BookDataComponent(bookData: widget.newBookData, isShowRating: true)
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: context.scaffoldBackgroundColor,
          width: widget.width ?? 110,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 70,
                    width: 140,
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: getBackGroundColor(index: widget.index),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(120),
                        topRight: Radius.circular(120),
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: 100,
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.only(bottom: 16),
                    child: CachedImageWidget(width: 100, height: 150, url: widget.newBookData.img, fit: BoxFit.fill),
                  ),
                ],
              ),
              8.height,
              Text(
                widget.newBookData.name.toString(),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.start,
                style: primaryTextStyle(size: 14),
              ).paddingSymmetric(horizontal: 16),
            ],
          ),
        ),
        if (widget.isShowRating ?? false) BookDataComponent(bookData: widget.newBookData, isShowRating: true),
      ],
    );
  }
}

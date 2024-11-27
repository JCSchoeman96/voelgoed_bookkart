import 'package:bookkart_flutter/screens/bookDescription/view/book_description_screen.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class OpenBookDescriptionOnTap extends StatelessWidget {
  final String bookId;
  final int currentIndex;
  final Widget child;
  final void Function()? onInit;
  final Color? backgroundColor;

  OpenBookDescriptionOnTap({
    required this.child,
    required this.bookId,
    this.currentIndex = 0,
    this.backgroundColor,
    this.onInit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      behavior: HitTestBehavior.translucent,
      onTap: () {
        BookDescriptionScreen(
          bookId: bookId,
          backgroundColor: backgroundColor ?? getBackGroundColor(index: currentIndex),
        ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide).then((value) {
          if (onInit != null) this.onInit!.call();
        });
      },
    );
  }
}

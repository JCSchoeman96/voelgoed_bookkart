import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CustomAppBar extends StatelessWidget {
  final bool isHome;

  final String title2;
  final String title1;

  CustomAppBar({Key? key, required this.title1, required this.title2, required this.isHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 4),
          child: Text(title1, style: isHome ? primaryTextStyle(size: 28) : boldTextStyle(size: 28)),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.green, width: 3.0))),
        ),
        4.width,
        Marquee(child: Text(title2, style: isHome ? primaryTextStyle(size: 28) : boldTextStyle(size: 28))).expand(),
      ],
    ).paddingLeft(16);
  }
}

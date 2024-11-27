import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughComponent extends StatelessWidget {
  final String textContent;
  final String walkImg;
  final String desc;

  WalkThroughComponent({Key? key, required this.textContent, required this.walkImg, required this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(walkImg, width: context.width() * 0.8, height: context.height() * 0.4),
        SizedBox(height: context.height() * 0.08),
        Text(textContent, style: boldTextStyle(size: 20)),
        Text(desc, maxLines: 3, textAlign: TextAlign.center, style: primaryTextStyle()).paddingOnly(left: 28.0, right: 28.0)
      ],
    ).paddingAll(16);
  }
}

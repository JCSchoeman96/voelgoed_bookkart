import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CachedImageWidget extends StatelessWidget {
  final String url;
  final double height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final String? placeHolderImage;
  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final bool circle;
  final double? radius;

  CachedImageWidget({
    required this.url,
    required this.height,
    this.width,
    this.fit,
    this.color,
    this.placeHolderImage,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    if (url.validate().isEmpty) {
      return Container(
        height: height,
        width: width ?? height,
        color: color ?? grey.withOpacity(0.1),
        alignment: alignment,
        padding: EdgeInsets.all(10),
        child: Image.asset(img_no_data_found, color: appStore.isDarkMode ? Colors.white : Colors.black),
      ).cornerRadiusWithClipRRect(radius ?? (radius ?? (circle ? (height / 2) : 0)));
    } else if (url.validate().startsWith('http')) {
      return Image.network(
        url,
        errorBuilder: (context, error, stackTrace) {
          return Lottie.asset(json_book_loader, height: 100, width: 100).center();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Lottie.asset(json_book_loader, height: 100, width: 100).center();
        },
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment as Alignment? ?? Alignment.center,
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    } else {
      return Image.asset(
        url,
        height: height,
        width: width ?? height,
        fit: fit,
        color: color,
        alignment: alignment ?? Alignment.center,
        errorBuilder: (_, s, d) {
          return Lottie.asset(json_book_loader, height: 100, width: 100).center();
        },
      ).cornerRadiusWithClipRRect(radius ?? (circle ? (height / 2) : 0));
    }
  }
}
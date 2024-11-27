import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class BackgroundComponent extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget? imageWidget;
  final bool showLoadingWhileNotLoading;
  final String? text;
  final String? subTitle;

  final VoidCallback? onRetry;
  final String? retryText;

  BackgroundComponent({
    this.image,
    this.height,
    this.width,
    this.imageWidget,
    this.fit = BoxFit.contain,
    this.text,
    this.subTitle,
    this.onRetry,
    this.showLoadingWhileNotLoading = false,
    this.retryText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showLoadingWhileNotLoading) return Offstage();

    return Observer(
      builder: (context) {
        if (appStore.isLoading) {
          return AppLoader(isObserver: true);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedImageWidget(url: image ?? img_no_data_found, height: height ?? 150),
            16.height,
            if (text.validate().isNotEmpty) Text(text!, style: primaryTextStyle(), textAlign: TextAlign.center),
            4.height,
            if (subTitle.validate().isNotEmpty) Text(subTitle!, style: secondaryTextStyle(), textAlign: TextAlign.center),
            16.height,
            if (onRetry != null)
              AppButton(
                text: retryText ?? 'Try again',
                textColor: white,
                padding: EdgeInsets.zero,
                color: context.primaryColor,
                onTap: () {
                  onRetry?.call();
                },
              ),
          ],
        ).center();
      },
    );
  }
}

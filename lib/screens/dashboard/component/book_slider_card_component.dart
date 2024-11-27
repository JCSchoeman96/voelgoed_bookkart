import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/models/dashboard/header_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookSliderCardComponent extends StatelessWidget {
  final HeaderModel data;

  BookSliderCardComponent({required this.data});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: data.title.validate(),
      child: Container(
        alignment: Alignment.center,
        width: context.width() * 0.80,
        height: 320,
        padding: EdgeInsets.all(16),
        decoration: boxDecorationRoundedWithShadow(
          30,
          backgroundColor: Colors.white,
          blurRadius: 4,
          offset: Offset(0, 4),
          shadowColor: Colors.black26,
          gradient: LinearGradient(
            begin: Alignment(6.123234262925839e-17, 1),
            end: Alignment(-1, 6.123234262925839e-17),
            colors: [
              Color.fromRGBO(185, 205, 254, 1),
              Color.fromRGBO(150, 172, 229, 1),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data.title.validate(), style: secondaryTextStyle(color: Colors.white)),
            4.height,
            Text(data.message.validate(), textAlign: TextAlign.left, style: boldTextStyle(size: 22, color: Colors.white), maxLines: 1),
            32.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RotationTransition(
                  turns: AlwaysStoppedAnimation(-15 / 360),
                  child: CachedImageWidget(
                    url: data.image2,
                    fit: BoxFit.fill,
                    width: context.width() * 0.28,
                    height: context.width() * 0.40,
                  ),
                ),
                RotationTransition(
                  turns: AlwaysStoppedAnimation(22 / 360),
                  child: CachedImageWidget(
                    fit: BoxFit.fill,
                    width: context.width() * 0.28,
                    height: context.width() * 0.40,
                    url: data.image1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).paddingAll(12);
  }
}

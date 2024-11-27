import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DisabledRatingBarWidget extends StatelessWidget {
  final num rating;
  final double? size;
  final Color? ratingColor;

  DisabledRatingBarWidget({required this.rating, this.size, this.ratingColor});

  @override
  Widget build(BuildContext context) {
    return RatingBarWidget(
      onRatingChanged: null,
      itemCount: 5,
      size: size ?? 18,
      disable: true,
      rating: rating.validate().toDouble(),
      // activeColor: ratingBarColor,
      activeColor: ratingColor ?? getRatingBarColor(rating.ceil()),
    );
  }
}

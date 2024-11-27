import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/disabled_rating_bar_widget.dart';
import 'package:bookkart_flutter/models/author/author_list_model.dart';
import 'package:bookkart_flutter/screens/author/view/author_details.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorListComponent extends StatelessWidget {
  final AuthorListResponse authorDetails;

  AuthorListComponent({required this.authorDetails});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await AuthorDetails(authorDetails: authorDetails).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
      },
      child: SizedBox(
        width: context.width() / 3 - 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedImageWidget(width: 70, height: 70, fit: BoxFit.cover, circle: true, url: authorDetails.gravatar.validate()),
            8.height,
            Marquee(child: Text(authorDetails.firstName.validate() + " " + authorDetails.lastName.validate(), style: boldTextStyle(size: 14), textAlign: TextAlign.center)),
            8.height,
            DisabledRatingBarWidget(rating: authorDetails.getRating.validate().toDouble(), size: 14).center(),
          ],
        ),
      ),
    );
  }
}

import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/author/author_repository.dart';
import 'package:bookkart_flutter/models/author/author_list_model.dart';
import 'package:bookkart_flutter/screens/author/view/author_details.dart';
import 'package:bookkart_flutter/screens/author/view/author_wise_book_screen.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class GetAuthorComponent extends StatefulWidget {
  final BookDataModel bookInfo;

  GetAuthorComponent({required this.bookInfo});

  @override
  State<GetAuthorComponent> createState() => _GetAuthorComponentState();
}

class _GetAuthorComponentState extends State<GetAuthorComponent> {
  int isTaped = -1;
  List<AuthorListResponse> auth = [];

  @override
  void initState() {
    super.initState();
    fetchAuthors();
  }

  Future<void> fetchAuthors() async {
    auth = await getAuthorListRestApi(page: 0, perPage: 30, authorList: [], lastPageCallBack: (p0) {});
    setState(() {});
  }

  bool isAuthorMatched() {
    return widget.bookInfo.store != null && auth.any((element) => element.id.validate() == widget.bookInfo.store!.id);
  }

  Future<void> gotoAuthor() async {
    if (isTaped == -1) {
      isTaped = 0;

      if (widget.bookInfo.store != null) {
        if (auth.any((element) => element.id.validate() == widget.bookInfo.store!.id)) {
          AuthorListResponse authorDetails = auth.where((element) => element.id.validate() == widget.bookInfo.store!.id).first;
          await AuthorDetails(authorDetails: authorDetails).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
          isTaped = -1;
          return;
        }
      }

      if (widget.bookInfo.store != null) {
        if (auth.any((element) => element.storeName.validate().isEmpty)) {
          await AuthorWiseBookScreen(authorDetails: widget.bookInfo.store!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
          isTaped = -1;
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: gotoAuthor,
        child: Row(
          children: [
            if (widget.bookInfo.store != null) CachedImageWidget(width: 45, height: 45, url: widget.bookInfo.store!.image.validate(), fit: BoxFit.fill).cornerRadiusWithClipRRect(30),
            16.width,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.bookInfo.store != null) Text(widget.bookInfo.store!.name.validate().toString().trim(), maxLines: 1, softWrap: false, style: boldTextStyle()),
                Text(locale.lblTapToSeeAuthorDetails, textAlign: TextAlign.start, style: secondaryTextStyle()),
              ],
            ),
            Spacer(),
            if (isAuthorMatched()) Icon(Icons.chevron_right, size: 32.0),
          ],
        ),
      ),
    );
  }
}

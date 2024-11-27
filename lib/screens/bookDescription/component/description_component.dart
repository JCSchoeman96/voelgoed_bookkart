import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/select_file_type_component.dart';
import 'package:bookkart_flutter/screens/bookmark/bookmark_repository.dart';
import 'package:bookkart_flutter/models/dashboard/book_data_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class DescriptionComponent extends StatefulWidget {
  final BookDataModel bookInfo;

  DescriptionComponent({required this.bookInfo, Key? key}) : super(key: key);

  @override
  State<DescriptionComponent> createState() => _DescriptionComponentState();
}

class _DescriptionComponentState extends State<DescriptionComponent> {
  List<DownloadModel> downloadFileList = [];

  String sampleFile = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    for (int i = 0; i < widget.bookInfo.attributes.validate().length; i++) {
      if (widget.bookInfo.attributes![i].name == SAMPLE_FILE && widget.bookInfo.attributes![i].options!.isNotEmpty) {
        sampleFile = CONTAINS_DOWNLOAD_FILES;
        downloadFileList.add(DownloadModel(id: "1", name: SAMPLE_FILES, file: widget.bookInfo.attributes![i].options.validate().first.toString()));
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onBookmarkTap() async {
    if (appStore.isLoggedIn) {
      appStore.setLoading(true);

      Map request = {'pro_id': widget.bookInfo.id.validate().toString()};

      if (widget.bookInfo.isAddedWishlist.validate()) {
        await removeFromBookmarkRestApi(request).then((res) async {
          appStore.setLoading(false);
          widget.bookInfo.isAddedWishlist = false;
          toast(res.message);
          setState(() {});
        }).catchError((e) {
          appStore.setLoading(false);
        });
      } else {
        await addToBookmarkRestApi(request).then((res) async {
          appStore.setLoading(false);
          toast(res.message);
          widget.bookInfo.isAddedWishlist = true;
          setState(() {});
        }).catchError((e) {
          appStore.setLoading(false);
        });
      }
      return;
    }
    SignInScreen().launch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Marquee(child: Text(widget.bookInfo.name.validate(), style: boldTextStyle(size: 18))).expand(),
              16.width,
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: onBookmarkTap,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(color: context.cardColor, borderRadius: radius(12)),
                  child: (widget.bookInfo.isAddedWishlist.validate()) ? Icon(Icons.bookmark, size: 24) : Icon(Icons.bookmark_border, size: 24),
                ),
              )
            ],
          ),
          if (!getBoolAsync(HAS_IN_REVIEW))
            Text(
              (widget.bookInfo.isFreeBook) ? locale.lblFree : widget.bookInfo.price.validate().toString().getFormattedPrice(),
              style: boldTextStyle(color: context.primaryColor, size: 20),
            )
          else
            Text('Free', style: boldTextStyle(color: Colors.green, size: 20)),
          16.height,
          if (sampleFile.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Row(
                children: [
                  Image.asset(img_sunglasses, width: 26),
                  8.width,
                  Text(locale.lblFreeTrial, style: primaryTextStyle(), textAlign: TextAlign.center),
                ],
              ),
              onTap: () {
                showInDialog(
                  context,
                  builder: (p0) {
                    return SelectFileType(
                      isSampleFile: true,
                      downloadFile: downloadFileList.validate(),
                      bookingData: widget.bookInfo,
                    );
                  },
                );
              },
            ).paddingBottom(16),
          if (widget.bookInfo.description.validate().isNotEmpty) ...[
            Text(locale.lblWhatIsAbout, style: boldTextStyle(size: 18)),
            4.height,
            ReadMoreText(
              parseHtmlString(widget.bookInfo.description.validate()),
              style: primaryTextStyle(),
              colorClickableText: context.primaryColor,
            ),
          ],
        ],
      ),
    );
  }
}


import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final String orderId;

  WebViewScreen({required this.url, required this.title, required this.orderId});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController webCont = WebViewController();

  bool fetchingFile = true;
  bool? orderDone;

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        widget.title.validate(),
        titleTextStyle: boldTextStyle(),
        backWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            finish(context, {'orderCompleted': orderDone});
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(Colors.transparent)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageStarted: (url) {
                    appStore.setLoading(false);
                  },
                  onNavigationRequest: (request) {
                    log('Navigation Request URL---------------------------------${request.url.validate()}');
                    return NavigationDecision.prevent;
                  },
                ),
              )
              ..addJavaScriptChannel(
                "Toaster",
                onMessageReceived: (msg) {},
              )
              ..loadRequest(Uri.parse(widget.url)),
          ),
          AppLoader(isObserver: true),
        ],
      ),
    );
  }
}

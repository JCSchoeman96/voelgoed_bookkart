import 'dart:async';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/component/list_item_walk_through_compo.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({Key? key}) : super(key: key);

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageCont = PageController();

  int currentIndexPage = 0;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> onPrev() async {
    if (currentIndexPage >= 1) {
      currentIndexPage = currentIndexPage - 1;
      pageCont.jumpToPage(currentIndexPage);
    }

    setState(() {});
  }

  @override
  void dispose() {
    pageCont.dispose();
    super.dispose();
  }

  Future<void> onNext() async {
    if (currentIndexPage < 3) {
      currentIndexPage = currentIndexPage + 1;
      pageCont.jumpToPage(currentIndexPage);
      setState(() {});
    } else {
      appStore.setFirstTime(false, isInitializing: false);
      DashboardScreen().launch(context);
    }
  }

  Future<void> onSkip() async {
    appStore.setFirstTime(false, isInitializing: false);
    DashboardScreen().launch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: pageCont,
            children: [
              WalkThroughComponent(textContent: locale.lblWelcome, walkImg: ic_walk_one, desc: locale.newestBooksDesc),
              WalkThroughComponent(textContent: locale.lblPurchaseOnline, walkImg: ic_walk_two, desc: locale.newestBooksDesc),
              WalkThroughComponent(textContent: locale.lblPushNotification, walkImg: ic_walk_three, desc: locale.newestBooksDesc),
              WalkThroughComponent(textContent: locale.lblEnjoyOfflineSupport, walkImg: ic_walk_four, desc: locale.newestBooksDesc),
            ],
            onPageChanged: (value) {
              currentIndexPage = value;
              setState(() {});
            },
          ),
          Container(
            height: 85,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndexPage != 0)
                  AppButton(
                    height: 40,
                    color: context.primaryColor,
                    text: locale.lblPrev,
                    textColor: context.cardColor,
                    padding: EdgeInsets.all(8),
                    onTap: onPrev,
                  )
                else
                  SizedBox(width: 80, height: 40),
                DotIndicator(
                  pageController: pageCont,
                  indicatorColor: cornflowerBlue,
                  pages: List.generate(4, (index) => index),
                ),
                AppButton(
                  height: 40,
                  color: Colors.white,
                  text: locale.lblNext,
                  textColor: context.primaryColor,
                  padding: EdgeInsets.all(8),
                  onTap: onNext,
                ),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: TextButton(
              onPressed: onSkip,
              child: Text(
                locale.lblSkip,
                style: primaryTextStyle(color: context.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

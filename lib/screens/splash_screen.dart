import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/widgets/colorize_animated_text.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'auth/view/walk_through_screen.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    animationController = getAnimationCont();
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController!, curve: Curves.easeInCirc));
    animationController!.forward();

    setStatusBarColor(Colors.transparent);
    if (getIntAsync(THEME_MODE_INDEX).validate() == THEME_MODE_SYSTEM) {
      appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
    }

    await 4.seconds.delay;

    if (appStore.isFirstTime) {
      WalkThroughScreen().launch(context, isNewTask: true);
    } else {
      DashboardScreen().launch(context, isNewTask: true);
    }
  }

  AnimationController getAnimationCont() => AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  @override
  void dispose() {
    super.dispose();
    animationController!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: SizedBox(
        width: context.width(),
        height: context.height(),
        child: FadeTransition(
          opacity: animation!,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ic_logo, height: 200),
              ColorizeAnimatedText(
                text: locale.appName,
                speed: 4.seconds,
                textStyle: boldTextStyle(size: 50),
                colors: [
                  primaryColor, // Primary Orange
                  accentColor, // Accent Blue
                  primaryColor.withOpacity(0.8),
                  accentColor.withOpacity(0.8),
                  primaryColor.withOpacity(0.6),
                  accentColor.withOpacity(0.6),
                ],
              ).paddingOnly(right: 10, left: 10, top: 20)
            ],
          ),
        ),
      ),
    );
  }
}

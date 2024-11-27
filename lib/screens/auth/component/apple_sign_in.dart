import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/auth/customer_response_model.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/models/auth/login_model.dart';
import 'package:bookkart_flutter/services/auth_services.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AppleSignIn extends StatelessWidget {
  final bool isRemember;
  final String password;
  final String userName;

  AppleSignIn({required this.isRemember, required this.password, required this.userName});

  Future<void> socialLogin(BuildContext context, Map req) async {
    appStore.setLoading(true);
    await appStore.setAvatar(req[PHOTO_URL]);

    await socialLoginApi(req).then((LoginResponse response) async {
      await setUserInfo(response, isRemember: isRemember, password: password, username: userName);

      await appStore.setSocialLogin(true);

      await getCustomer(response.userId).then((Customer res) async {
        await DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide).whenComplete(() {
          appStore.setLoading(false);
        });
        appStore.setLoading(false);
      }).catchError((error) {
        appStore.setLoading(false);
      });

      //
    }).catchError((error) {
      appStore.setLoading(false);
    });
  }

  Future<void> appleSign(BuildContext context) async {
    appStore.setLoading(true);

    if (await TheAppleSignIn.isAvailable()) {
      appStore.setLoading(false);

      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      if (result.credential != null) {
        if (result.status == AuthorizationStatus.authorized && result.credential!.email.validate().isEmpty) {
          Map<String, String> req = {'email': getStringAsync('appleEmail'), 'firstName': getStringAsync('appleGivenName'), 'lastName': getStringAsync(APPLE_FAMILY_NAME), 'photoURL': '', 'accessToken': '12345678', 'loginType': 'apple'};

          socialLogin(context, req);
        } else {
          Map<String, dynamic> req = {
            'email': result.credential!.email.validate(),
            'firstName': result.credential!.fullName!.givenName.validate(),
            'lastName': result.credential!.fullName!.familyName.validate(),
            'photoURL': '',
            'accessToken': '12345678',
            'loginType': 'apple'
          };

          socialLogin(context, req);
        }
      }
    } else {
      appStore.setLoading(false);
      toast(locale.lblAppleSignInNotAvailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isIOS)
      return AppButton(
        onTap: () {
          appleSign(context);
        },
        text: '',
        color: context.cardColor,
        padding: EdgeInsets.all(8),
        textStyle: boldTextStyle(),
        shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
        width: context.width() - context.navigationBarHeight,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.1), boxShape: BoxShape.circle),
              child: Icon(Icons.apple),
            ),
            Text(locale.signInWithApple, style: boldTextStyle(size: 14), textAlign: TextAlign.center).expand(),
          ],
        ),
      );
    else
      return Offstage();
  }
}

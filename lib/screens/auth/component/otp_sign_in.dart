import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/otp_login_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class OtpSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppButton(
      onTap: () {
        hideKeyboard(context);
        appStore.setLoginType(OTP_USER);
        OTPLoginScreen().launch(context);
      },
      text: '',
      padding: EdgeInsets.all(8),
      shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
      textStyle: boldTextStyle(),
      width: context.width() - context.navigationBarHeight,
      color: context.cardColor,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.1), boxShape: BoxShape.circle),
            child: ic_calling.iconImage(size: 20, color: primaryColor).paddingAll(4),
          ),
          Text(locale.signInWithOTP, style: boldTextStyle(size: 14), textAlign: TextAlign.center).expand(),
        ],
      ),
    );
  }
}

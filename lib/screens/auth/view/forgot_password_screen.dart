import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void forgotPwd() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      Map<String, dynamic> request = {'email': emailCont.text.validate()};
      await forgetPassword(request: request);
      finish(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: context.width(),
              decoration: boxDecorationDefault(color: context.primaryColor, borderRadius: radiusOnly(topRight: 8, topLeft: 8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(locale.lblForgotPassword, style: boldTextStyle(color: Colors.white)),
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.white, size: 20),
                    onPressed: () {
                      finish(context);
                    },
                  )
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.resetPasswordStatement, style: secondaryTextStyle()),
                16.height,
                Observer(
                  builder: (_) => AppTextField(
                    textFieldType: TextFieldType.EMAIL,
                    controller: emailCont,
                    autoFocus: true,
                    decoration: inputDecoration(context, locale.hintEnterEmail),
                    errorThisFieldRequired: locale.lblFieldRequired,
                  ).visible(!appStore.isLoading, defaultWidget: Loader()),
                ),
                16.height,
                AppButton(
                  text: locale.resetPassword,
                  height: 40,
                  color: primaryColor,
                  textStyle: primaryTextStyle(color: white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: forgotPwd,
                ),
              ],
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}

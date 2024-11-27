import 'dart:io';

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/screens/auth/component/apple_sign_in.dart';
import 'package:bookkart_flutter/screens/auth/component/google_sign_in.dart';
import 'package:bookkart_flutter/screens/auth/component/otp_sign_in.dart';
import 'package:bookkart_flutter/screens/auth/view/forgot_password_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool isRemember = false;


  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);

    if (Platform.isIOS) {TheAppleSignIn.onCredentialRevoked?.listen((_) {});}

    isRemember = getBoolAsync(REMEMBER_PASSWORD);

    if (isRemember.validate()) {
      usernameCont.text = getStringAsync(EMAIL);
      passwordCont.text = appStore.password;
    }

    appStore.setLoading(false);

    setState(() {});
  }

  //region Method

  void loginUsers() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      appStore.setLoading(true);

      Map<String, String> request = {
        "username": usernameCont.text,
        "password": passwordCont.text,
      };

      try {
        var res = await getLoginUserRestApi(request);
        await appStore.setLoginType(NATIVE_USER);
        appStore.setLoading(false);

        // Navigate to Dashboard after successful login
        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      } catch (e) {
        appStore.setLoading(false);
        toast(e.toString());
      }
    }
  }

  //endregion

  @override
  void dispose() {
    usernameCont.dispose();
    passwordCont.dispose();
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  //region Widget
  Widget _buildTopWidget() {
    return Container(
      child: Column(
        children: [
          Text("${locale.helloAgain}!", style: boldTextStyle(size: 24)).center(),
          16.height,
          Text(
            locale.lblWelcomeBack,
            style: primaryTextStyle(size: 16),
            textAlign: TextAlign.center,
          ).center().paddingSymmetric(horizontal: 32),
          32.height,
        ],
      ),
    );
  }

  Widget _buildFormWidget() {
    return AutofillGroup(
      child: Column(
        children: [
          AppTextField(
            textFieldType: TextFieldType.EMAIL,
            controller: usernameCont,
            focus: userNameFocusNode,
            nextFocus: passwordFocusNode,
            errorThisFieldRequired: locale.lblFieldRequired,
            decoration: inputDecoration(context, locale.hintEnterEmail),
            suffix: ic_message.iconImage(size: 10).paddingAll(14),
            autoFillHints: [
              AutofillHints.email,
            ],
          ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.PASSWORD,
            controller: passwordCont,
            focus: passwordFocusNode,
            suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
            suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
            errorThisFieldRequired: locale.lblFieldRequired,
            decoration: inputDecoration(context, locale.hintEnterPassword),
            autoFillHints: [
              AutofillHints.password,
            ],
            onFieldSubmitted: (s) {
              loginUsers();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRememberWidget() {
    return Column(
      children: [
        8.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundedCheckBox(
              isChecked: isRemember,
              onTap: (value) async {
                await setValue(REMEMBER_PASSWORD, isRemember);
                isRemember = !isRemember;
                setState(() {});
              },
              borderColor: context.primaryColor,
              checkedColor: context.primaryColor,
              text: locale.lblRememberMe,
              textStyle: secondaryTextStyle(),
              size: 20,
            ),
            TextButton(
              onPressed: () {
                showInDialog(
                  context,
                  elevation: 0,
                  contentPadding: EdgeInsets.zero,
                  dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                  builder: (_) => ForgotPasswordScreen(),
                );
              },
              child: Text(locale.lblForgotPassword, style: boldTextStyle(color: primaryColor, fontStyle: FontStyle.italic)),
            ).flexible(),
          ],
        ),
        24.height,
        AppButton(
          color: primaryColor,
          text: locale.lblLogin,
          shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            loginUsers();
          },
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locale.lblHaveAnAccount, style: secondaryTextStyle()),
            TextButton(
              onPressed: () {
                hideKeyboard(context);
                SignUpScreen().launch(context);
              },
              child: Text(
                locale.lblSignUp,
                style: boldTextStyle(color: primaryColor, decoration: TextDecoration.underline, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (context.height() * 0.05).toInt().height,
                  _buildTopWidget(),
                  _buildFormWidget(),
                  _buildRememberWidget(),
                  Column(
                    children: [
                      20.height,
                      Row(
                        children: [
                          Divider(color: context.dividerColor, thickness: 2).expand(),
                          16.width,
                          Text(locale.lblOrContinueWith, style: secondaryTextStyle()),
                          16.width,
                          Divider(color: context.dividerColor, thickness: 2).expand(),
                        ],
                      ),
                      24.height,
                      GoogleSignIn(isRemember: isRemember, password: passwordCont.text, userName: usernameCont.text),
                      16.height,
                      OtpSignIn(),
                      16.height,
                      AppleSignIn(isRemember: isRemember, password: passwordCont.text, userName: usernameCont.text),
                    ],
                  ),
                  30.height,
                ],
              ),
            ),
          ),
          AppLoader(isObserver: true),
        ],
      ),
    );
  }
}
import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/auth/register_response_model.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/view/dashboard_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';


class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  final String? countryCode;
  final bool isOTPLogin;

  SignUpScreen({Key? key, this.phoneNumber, this.countryCode, this.isOTPLogin = false}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailCont = TextEditingController();
  TextEditingController firstNameCon = TextEditingController();
  TextEditingController lastNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode firstNameContFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode lastNameContFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isAcceptedTc = false;

  void registerWithOTP() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isAcceptedTc) {
        appStore.setLoading(true);

        Map<String, dynamic> request = {
          "first_name": firstNameCon.text,
          "last_name": lastNameCont.text,
          "email": emailCont.text,
          "username": widget.phoneNumber,
          "password": widget.phoneNumber,
        };
        await getRegisterUserRestApi(request).then((RegisterResponse res) async {
          toast(res.message);
          if (res.code.isSuccessful()) {
            Map<String, String> request = {
              "username": widget.phoneNumber.toString(),
              "password": widget.phoneNumber.toString(),
            };

            await getLoginUserRestApi(request).then((res) async {
              appStore.setLoading(false);
              DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
            }).catchError((e) {
              appStore.setLoading(false);
              toast(e.toString());
            });
          }

          appStore.setLoading(false);
        }).catchError((e) {
          appStore.setLoading(false);

          toast(e.toString());
        });
      } else {
        toast(locale.pleaseAcceptTermsAndConditions);
      }
    }
  }

  void registerUser() async {
    hideKeyboard(context);
    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isAcceptedTc) {
        appStore.setLoading(true);

        Map<String, dynamic> request = {
          "first_name": firstNameCon.text,
          "last_name": lastNameCont.text,
          "email": emailCont.text,
          "username": emailCont.text,
          "password": passwordCont.text,
        };

        await getRegisterUserRestApi(request).then((RegisterResponse res) {
          appStore.setLoginType(NATIVE_USER);
          toast(res.message);
          if (res.code.isSuccessful()) {
            finish(context);
          }
        }).catchError((e) {
          toast(e.toString());
        });
        appStore.setLoading(false);
      } else {
        toast(locale.pleaseAcceptTermsAndConditions);
      }
    }
  }

  //region Widget
  Widget _buildTopWidget() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          padding: EdgeInsets.all(16),
          child: ic_profile2.iconImage(color: Colors.white),
          decoration: boxDecorationDefault(shape: BoxShape.circle, color: primaryColor),
        ),
        16.height,
        Text(locale.lblHello + " " + locale.lblGuest, style: boldTextStyle(size: 24)).center(),
        16.height,
        Text(locale.signupForBetterExperience, style: primaryTextStyle(size: 18), textAlign: TextAlign.center).center().paddingSymmetric(horizontal: 32),
      ],
    );
  }

  Widget _buildFormWidget() {
    return Wrap(
      runSpacing: 16,
      children: [
        AppTextField(
          controller: firstNameCon,
          autoFocus: false,
          focus: firstNameContFocus,
          nextFocus: lastNameContFocus,
          textFieldType: TextFieldType.NAME,
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
          decoration: inputDecoration(context, locale.lblFirstName),
        ),
        AppTextField(
          controller: lastNameCont,
          autoFocus: false,
          focus: lastNameContFocus,
          nextFocus: emailFocus,
          textFieldType: TextFieldType.NAME,
          suffix: ic_profile2.iconImage(size: 10).paddingAll(14),
          decoration: inputDecoration(context, locale.lblLastName),
        ),
        AppTextField(
          controller: emailCont,
          autoFocus: false,
          focus: emailFocus,
          nextFocus: passwordFocus,
          textFieldType: TextFieldType.EMAIL,
          suffix: ic_message.iconImage(size: 10).paddingAll(14),
          decoration: inputDecoration(context, locale.hintEnterEmail),
        ),
        AppTextField(
          controller: passwordCont,
          textFieldType: TextFieldType.PASSWORD,
          autoFocus: false,
          focus: passwordFocus,
          suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
          nextFocus: confirmPasswordFocus,
          decoration: inputDecoration(context, locale.hintEnterPassword),
        ),
        AppTextField(
          controller: confirmPasswordCont,
          textFieldType: TextFieldType.PASSWORD,
          autoFocus: false,
          readOnly: widget.isOTPLogin.validate() ? widget.isOTPLogin : false,
          suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
          suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
          focus: confirmPasswordFocus,
          decoration: inputDecoration(context, locale.hintReEnterPassword),
          validator: (v) {
            if (passwordCont.text != v) {
              return locale.lblPasswordMustMatch;
            } else if (confirmPasswordCont.text.isEmpty) {
              return errorThisFieldRequired;
            }
            return null;
          },
        ),
        _buildTcAcceptWidget(),
        8.height,
        AppButton(
          text: locale.lblSignUp,
          color: primaryColor,
          shapeBorder: RoundedRectangleBorder(borderRadius: radius()),
          textStyle: boldTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            (widget.isOTPLogin) ? registerWithOTP() : registerUser();
          },
        ),
      ],
    ).paddingTop(16);
  }

  Widget _buildTcAcceptWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RoundedCheckBox(
          borderColor: context.primaryColor,
          checkedColor: context.primaryColor,
          isChecked: isAcceptedTc,
          textStyle: secondaryTextStyle(),
          size: 20,
          onTap: (value) async {
            isAcceptedTc = !isAcceptedTc;
            setState(() {});
          },
        ),
        16.width,
        RichTextWidget(
          list: [
            TextSpan(text: locale.iAgreeToThe + " ", style: secondaryTextStyle()),
            TextSpan(
              text: locale.termsOfService,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(TERMS_CONDITION_URL, launchMode: LaunchMode.externalApplication);
                },
            ),
            TextSpan(text: ' & ', style: secondaryTextStyle()),
            TextSpan(
              text: locale.privacyPolicy,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  commonLaunchUrl(PRIVACY_POLICY_URL, launchMode: LaunchMode.externalApplication);
                },
            ),
          ],
        ).flexible(flex: 2),
      ],
    ).paddingSymmetric(vertical: 16, horizontal: 16);
  }

  Widget _buildFooterWidget() {
    return Column(
      children: [
        16.height,
        RichTextWidget(
          list: [
            TextSpan(text: locale.alreadyHaveAnAccount + " ", style: secondaryTextStyle()),
            TextSpan(
              text: locale.lblSignIn,
              style: boldTextStyle(color: primaryColor, size: 14),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  finish(context);
                },
            ),
          ],
        ),
      ],
    );
  }

  //endregion

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    if (widget.isOTPLogin) {
      passwordCont = TextEditingController(text: widget.phoneNumber);
      confirmPasswordCont = TextEditingController(text: widget.phoneNumber);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.scaffoldBackgroundColor,
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
                children: [
                  _buildTopWidget(),
                  _buildFormWidget(),
                  8.height,
                  _buildFooterWidget(),
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

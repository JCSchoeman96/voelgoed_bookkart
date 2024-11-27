import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode newPasswordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode oldPassNode = FocusNode();

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  @override
  void dispose() {
    oldPasswordCont.clear();
    newPasswordCont.clear();
    confirmPasswordCont.clear();
    super.dispose();
  }

  Future<void> submit() async {
    hideKeyboard(context);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (newPasswordCont.text == confirmPasswordCont.text) {
        Map<String, String> request = {
          'password': oldPasswordCont.text,
          'new_password': newPasswordCont.text,
          'username': appStore.userEmail,
        };

        appStore.setLoading(true);

        await changePassword(request).then((res) {
          appStore.setLoading(false);
          toast(res.message);
          finish(context);
        }).catchError((onError) {
          toast("$onError");
          appStore.setLoading(false);
        });
      } else {
        appStore.setLoading(false);
        toast(locale.lblPasswordMustMatch);
      }
    } else {
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblChangePwd),
      body: Stack(
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.always,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Text(locale.lblNewPwdMustDiff, style: secondaryTextStyle()),
                  16.height,
                  AppTextField(
                    controller: oldPasswordCont,
                    focus: oldPassNode,
                    textFieldType: TextFieldType.PASSWORD,
                    nextFocus: newPasswordNode,
                    decoration: inputDecoration(context, locale.lblOldPwd),
                  ),
                  16.height,
                  AppTextField(
                    controller: newPasswordCont,
                    focus: newPasswordNode,
                    textFieldType: TextFieldType.PASSWORD,
                    nextFocus: confirmPasswordNode,
                    decoration: inputDecoration(context, locale.lblNewPwd),
                  ),
                  16.height,
                  AppTextField(
                    controller: confirmPasswordCont,
                    focus: confirmPasswordNode,
                    textFieldType: TextFieldType.PASSWORD,
                    decoration: inputDecoration(context, locale.lblConfirmPwd),
                    validator: (v) {
                      if (newPasswordCont.text != v) {
                        return locale.lblPasswordMustMatch;
                      } else if (confirmPasswordCont.text.isEmpty) {
                        return errorThisFieldRequired;
                      }
                      return null;
                    },
                  ),
                  16.height,
                  AppButton(
                    color: context.primaryColor,
                    width: context.width(),
                    textColor: Colors.white,
                    text: locale.lblSubmit,
                    onTap: submit,
                  ),
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

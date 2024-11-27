import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({Key? key}) : super(key: key);

  @override
  State<OTPLoginScreen> createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController numberController = TextEditingController();

  Country selectedCountry = defaultCountry();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() => init());
  }

  void init() async {
    appStore.setLoading(false);
  }

  //region Methods
  void sendOTP() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      hideKeyboard(context);

      appStore.setLoading(true);

      toast(locale.sendingOTP);

      await authService.loginWithOTP(
        context,
        phoneNumber: numberController.text.trim(),
        countryCode: selectedCountry.phoneCode,
      ).then((value) {
        //
      }).catchError(
        (e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        },
      );
    }
  }

  Future<void> changeCountry() async {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
        setState(() {});
      },
    );
  }

  // endregion
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
        automaticallyImplyLeading: Navigator.of(context).canPop(),
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
          statusBarColor: context.scaffoldBackgroundColor,
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(locale.hintMobileNumber, style: boldTextStyle()),
                16.height,
                Form(
                  key: formKey,
                  child: AppTextField(
                    controller: numberController,
                    textFieldType: TextFieldType.PHONE,
                    decoration: inputDecoration(context, locale.hintMobileNumber),
                    autoFocus: true,
                    onFieldSubmitted: (s) {
                      sendOTP();
                    },
                  ),
                ),
                30.height,
                AppButton(
                  onTap: () {
                    sendOTP();
                  },
                  text: locale.sendOTP,
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width(),
                ),
                16.height,
                AppButton(
                  text: locale.changeCountry,
                  textStyle: boldTextStyle(),
                  color: context.primaryColor,
                  width: context.width(),
                  onTap: () {
                    changeCountry();
                  },
                ),
              ],
            ),
          ),
          AppLoader(isObserver: true),
        ],
      ),
    );
  }
}

import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class OtpDialogComponent extends StatefulWidget {
  final Function(String? otpCode) onTap;

  OtpDialogComponent({required this.onTap});

  @override
  State<OtpDialogComponent> createState() => _OtpDialogComponentState();
}

class _OtpDialogComponentState extends State<OtpDialogComponent> {
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
    String otpCode = '';

    void submitOtp() {
      if (otpCode.validate().isNotEmpty) {
        if (otpCode.validate().length >= 6) {
          hideKeyboard(context);
          appStore.setLoading(true);
          widget.onTap.call(otpCode);
        } else {
          toast(locale.pleaseEnterValidOTP);
        }
      } else {
        toast(locale.pleaseEnterValidOTP);
      }
    }

    return Scaffold(
      appBar: appBarWidget(
        locale.confirmOTP,
        elevation: 0,
        color: context.scaffoldBackgroundColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
          statusBarColor: context.scaffoldBackgroundColor,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                32.height,
                OTPTextField(
                  pinLength: 6,
                  onChanged: (s) {
                    otpCode = s;
                    log(otpCode);
                  },
                  onCompleted: (pin) {
                    otpCode = pin;
                    submitOtp();
                  },
                ).fit(),
                30.height,
                AppButton(
                  onTap: () {
                    submitOtp();
                  },
                  text: locale.confirm,
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width(),
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

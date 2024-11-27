import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/screens/settings/component/theme_selection_dialog.dart';
import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/auth_repository.dart';
import 'package:bookkart_flutter/screens/auth/view/change_password_screen.dart';
import 'package:bookkart_flutter/screens/auth/view/edit_profile_screen.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/author/view/author_list_screen.dart';
import 'package:bookkart_flutter/screens/bookmark/view/my_bookmark_screen.dart';
import 'package:bookkart_flutter/screens/cart/view/my_cart_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/fragments/category_list_fragment_screen.dart';
import 'package:bookkart_flutter/screens/settings/view/language_screen.dart';
import 'package:bookkart_flutter/screens/settings/view/transaction_history_screen.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }

  void deleteAccountTap() {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      title: locale.lblDeleteAccountConformation,
      negativeText: locale.lblCancel,
      positiveText: locale.lblDelete,
      onAccept: (_) async {
        appStore.setLoading(true);

        /// the account will be deleted here
        await deleteAccount().then((value) {
          appStore.setLoading(false);

          /// the account will be cleared here
          clearData(context);

          toast(value['message']);
        }).catchError((e) {
          toast('error: $e', print: true);
          appStore.setLoading(false);
        });
      },
    );
  }

  void rateUsTap() {
    getPackageName().then((value) {
      String package = '';
      if (isAndroid) package = value;

      commonLaunchUrl(
        isAndroid ? '${getSocialMediaLink(LinkProvider.PLAY_STORE)}$package' : IOS_LINK_FOR_USER,
        launchMode: LaunchMode.externalApplication,
      );
    });
  }

  Future<void> appThemTap() async {
    await showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      builder: (context) {
        return ThemeSelectionDaiLog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomAppBar(title1: '', title2: locale.lblSettings, isHome: false),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                if (appStore.isLoggedIn)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            },
                            child: Observer(builder: (context) {
                              return Container(
                                decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, border: Border.all(color: context.primaryColor, width: 3)),
                                child: CachedImageWidget(
                                  url: appStore.userProfileImage.validate(value: appStore.avatar),
                                  height: 90,
                                  fit: BoxFit.cover,
                                  circle: true,
                                ),
                              );
                            }),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 0,
                            left: 70,
                            top: 65,
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.white), color: context.primaryColor),
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                  onPressed: () async {
                                    await EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                  },
                                  icon: Icon(Icons.edit, size: 15, color: Colors.white),
                                ),
                              ),
                            ).visible(!(appStore.loginType == GOOGLE_USER) && !(appStore.loginType == OTP_USER)),
                          ),
                        ],
                      ),
                      16.height,
                      Text(appStore.userFullName.validate(value: locale.lblGuest), style: primaryTextStyle()),
                      Text(appStore.userEmail.validate(value: locale.lblEmailId), style: primaryTextStyle()),
                    ],
                  ),
                16.height,
                SettingSection(
                  title: Text(locale.lblGeneral.toUpperCase(), style: boldTextStyle(color: primaryColor)),
                  headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                  divider: Offstage(),
                  items: [
                    if (!appStore.isLoggedIn)
                      SettingItemWidget(
                        title: locale.lblSignIn,
                        trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                        leading: ic_profile.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                        onTap: () {
                          SignInScreen().launch(context);
                        },
                      ),
                    SettingItemWidget(
                      title: locale.lblAuthor,
                      leading: ic_author.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                      decoration: BoxDecoration(borderRadius: radius()),
                      trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                      onTap: () {
                        AuthorListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                    ),
                    if (appStore.isLoggedIn)
                      SettingItemWidget(
                        title: locale.lblCategories,
                        leading: ic_category.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                        decoration: BoxDecoration(borderRadius: radius()),
                        trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                        onTap: () {
                          CategoriesListFragment().launch(context);
                        },
                      ),
                    if (appStore.isLoggedIn)
                      Column(
                        children: [
                          SettingItemWidget(
                            title: locale.lblTransactionHistory,
                            leading: ic_payment.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                            decoration: BoxDecoration(borderRadius: radius()),
                            trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                            onTap: () {
                              TransactionHistoryScreen().launch(context);
                            },
                          ),
                          SettingItemWidget(
                            title: locale.lblMyBookmark,
                            leading: ic_bookmark.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                            decoration: BoxDecoration(borderRadius: radius()),
                            trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                            onTap: () {
                              if (!appStore.isLoggedIn) {
                                SignInScreen().launch(context);
                              } else {
                                MyBookMarkScreen().launch(context);
                              }
                            },
                          ),
                          SettingItemWidget(
                            title: locale.lblMyCart,
                            leading: ic_shopping_cart.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                            decoration: BoxDecoration(borderRadius: radius()),
                            trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                            onTap: () {
                              MyCartScreen().launch(context);
                            },
                          ),
                        ],
                      ),
                    if (appStore.isLoggedIn && !appStore.isSocialLogin)
                      SettingItemWidget(
                        title: locale.lblChangePwd,
                        leading: ic_change_password.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                        decoration: BoxDecoration(borderRadius: radius()),
                        trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                        onTap: () {
                          ChangePasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
                    SettingItemWidget(
                      leading: ic_translation.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                      title: locale.language,
                      trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                      onTap: () {
                        LanguagesScreen().launch(context).then((value) {
                          setState(() {});
                        });
                      },
                    ),
                    SettingItemWidget(
                      title: locale.appTheme,
                      trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                      leading: ic_theme.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                      onTap: appThemTap,
                    ),
                  ],
                ),
                SettingSection(
                  title: Text(locale.lblAbout.toUpperCase(), style: boldTextStyle(color: primaryColor), selectionColor: context.primaryColor),
                  headingDecoration: BoxDecoration(color: context.primaryColor.withOpacity(0.1)),
                  divider: Offstage(),
                  items: [
                    SettingItemWidget(
                      leading: ic_star.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                      title: locale.rateUs,
                      trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                      onTap: rateUsTap,
                    ),
                    SettingItemWidget(
                      title: locale.lblTermsConditions,
                      trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                      leading: ic_term_and_condition.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                      decoration: BoxDecoration(borderRadius: radius()),
                      onTap: () {
                        launchUrlCustomTab(getStringAsync(TERMS_AND_CONDITIONS));
                      },
                    ),
                    SettingItemWidget(
                      title: locale.lblPrivacyPolicy,
                      trailing: Icon(Icons.keyboard_arrow_right, size: 20, color: context.iconColor),
                      leading: ic_term_and_condition.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                      decoration: BoxDecoration(borderRadius: radius()),
                      onTap: () {
                        launchUrlCustomTab(getStringAsync(PRIVACY_POLICY));
                      },
                    ),
                    if (appStore.isLoggedIn)
                      SettingItemWidget(
                        padding: EdgeInsets.all(16),
                        title: locale.lblDeleteAccount,
                        decoration: BoxDecoration(borderRadius: radius()),
                        leading: Image.asset(
                          ic_delete,
                          height: SETTING_ICON_SIZE.toDouble(),
                          width: SETTING_ICON_SIZE.toDouble(),
                          color: context.iconColor,
                        ),
                        onTap: deleteAccountTap,
                      ),
                    if (appStore.isLoggedIn)
                      SettingItemWidget(
                        title: locale.lblLogout,
                        leading: ic_logout.iconImage(size: SETTING_ICON_SIZE.toDouble()),
                        decoration: BoxDecoration(borderRadius: radius()),
                        onTap: () {
                          logout(context);
                        },
                      ),
                    150.height.visible(!appStore.isLoggedIn),
                    VersionInfoWidget(prefixText: 'v', textStyle: secondaryTextStyle(size: 14)).center(),
                  ],
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

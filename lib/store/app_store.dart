import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/locale/app_localizations.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/book_description/my_cart_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'app_store.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isReviewLoading = false;

  @observable
  bool isFetching = false;

  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE;

  @observable
  int userId = -1;

  @observable
  String loginType = '';

  @observable
  String userFirstName = '';

  @observable
  String userLastName = '';

  bool isRemember = false;

  String paymentMethod = '';

  @observable
  bool isEncrypting = false;

  @observable
  bool isDecrypting = false;

  @computed
  String get userFullName => '$userFirstName $userLastName'.trim();

  @observable
  String userEmail = '';

  @observable
  String userProfileImage = '';

  @observable
  String userContactNumber = '';

  @observable
  String userName = '';

  @observable
  String token = '';

  @observable
  String userType = '';

  @observable
  String currentEpubPage = '';

  @action
  void setCurrentEpubPage(String value) {
    currentEpubPage = value;
  }

  @action
  void setEncryption(bool value) {
    isEncrypting = value;
  }

  @action
  void setDecryption(bool value) {
    isDecrypting = value;
  }

  @action
  Future<void> setSocialLogin(bool value) async {
    isSocialLogin = value;
    await setValue(IS_SOCIAL_LOGIN, value);
  }

  @action
  Future<void> setDisplayName(String value) async {
    displayName = value;
    await setValue(USER_DISPLAY_NAME, value);
  }

  @action
  Future<void> setDarkMode(bool value, {bool isInitializing = false}) async {
    isDarkMode = value;
    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;
      appBarBackgroundColorGlobal = appBackgroundColorDark;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      appBarBackgroundColorGlobal = scaffoldColor;
    }

    if (isInitializing) await setValue(DARK_MODE, value);
  }

  @action
  Future<void> setRemember(value, {required isInitializing}) async {
    isRemember = value;
    if (!isInitializing) await setValue(REMEMBER_PASSWORD, value);
  }

  @action
  Future<void> setPassword(String value) async {
    password = value;
    await setValue(PASSWORD, value);
  }

  @action
  Future<void> setAvatar(String value) async {
    avatar = value;
    await setValue(AVATAR, value);
  }

  @action
  Future<void> setFirstTime(bool value, {bool isInitializing = false}) async {
    isFirstTime = value;
    if (!isInitializing) await setValue(IS_FIRST_TIME, value);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setUserProfile(String val, {bool isInitializing = false}) async {
    userProfileImage = val;
    if (!isInitializing) await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> setLoginType(String val, {bool isInitializing = false}) async {
    loginType = val;
    if (!isInitializing) await setValue(LOGIN_TYPE, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  @action
  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setContactNumber(String val, {bool isInitializing = false}) async {
    userContactNumber = val;
    if (!isInitializing) await setValue(CONTACT_NUMBER, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(USERNAME, val);
  }

  @action
  Future<void> setPaymentMethod(String val, {bool isInitializing = false}) async {
    paymentMethod = val;
    if (!isInitializing) await setValue(PAYMENT_METHOD, val);
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void setFetching(bool val) {
    isFetching = val;
  }

  @observable
  List<String> cartCount = <String>[].asObservable();

  @observable
  String selectedLanguage = 'en';

  @observable
  int selectedDrawerItem = 0;

  @observable
  List<String> languageCode = ['ar'];

  @observable
  bool isRTL = false;

  @observable
  int? page = 0;

  @observable
  bool isReview = false;

  @observable
  String firstName = '';

  @observable
  String lastName = '';

  @observable
  String displayName = '';

  @observable
  String avatar = '';

  @observable
  String password = '';

  @observable
  bool isFirstTime = true;

  @observable
  bool isSocialLogin = false;

  @observable
  bool isTokenExpired = false;

  @action
  void setPage(int? aIndex) {
    page = aIndex;
  }

  @action
  Future<void> setLanguage(String val, {bool isInitializing = false}) async {
    selectedLanguageCode = val.validate(value: DEFAULT_LANGUAGE);

    selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: selectedLanguageCode);

    if (!isInitializing) {
      await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
    }

    locale = await AppLocalizations().load(Locale(selectedLanguageCode));
  }

  @action
  Future<void> setTokenExpired(bool value) async {
    isTokenExpired = value;
    await setValue(TOKEN_EXPIRED, value);
  }

  @observable
  List<MyCartResponse> cartList = ObservableList();

  @observable
  double cartTotalAmount = 0;
}

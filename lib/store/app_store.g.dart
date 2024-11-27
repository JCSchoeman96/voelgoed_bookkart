// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on _AppStore, Store {
  Computed<String>? _$userFullNameComputed;

  @override
  String get userFullName =>
      (_$userFullNameComputed ??= Computed<String>(() => super.userFullName,
              name: '_AppStore.userFullName'))
          .value;

  late final _$isLoggedInAtom =
      Atom(name: '_AppStore.isLoggedIn', context: context);

  @override
  bool get isLoggedIn {
    _$isLoggedInAtom.reportRead();
    return super.isLoggedIn;
  }

  @override
  set isLoggedIn(bool value) {
    _$isLoggedInAtom.reportWrite(value, super.isLoggedIn, () {
      super.isLoggedIn = value;
    });
  }

  late final _$isDarkModeAtom =
      Atom(name: '_AppStore.isDarkMode', context: context);

  @override
  bool get isDarkMode {
    _$isDarkModeAtom.reportRead();
    return super.isDarkMode;
  }

  @override
  set isDarkMode(bool value) {
    _$isDarkModeAtom.reportWrite(value, super.isDarkMode, () {
      super.isDarkMode = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isReviewLoadingAtom =
      Atom(name: '_AppStore.isReviewLoading', context: context);

  @override
  bool get isReviewLoading {
    _$isReviewLoadingAtom.reportRead();
    return super.isReviewLoading;
  }

  @override
  set isReviewLoading(bool value) {
    _$isReviewLoadingAtom.reportWrite(value, super.isReviewLoading, () {
      super.isReviewLoading = value;
    });
  }

  late final _$isFetchingAtom =
      Atom(name: '_AppStore.isFetching', context: context);

  @override
  bool get isFetching {
    _$isFetchingAtom.reportRead();
    return super.isFetching;
  }

  @override
  set isFetching(bool value) {
    _$isFetchingAtom.reportWrite(value, super.isFetching, () {
      super.isFetching = value;
    });
  }

  late final _$selectedLanguageCodeAtom =
      Atom(name: '_AppStore.selectedLanguageCode', context: context);

  @override
  String get selectedLanguageCode {
    _$selectedLanguageCodeAtom.reportRead();
    return super.selectedLanguageCode;
  }

  @override
  set selectedLanguageCode(String value) {
    _$selectedLanguageCodeAtom.reportWrite(value, super.selectedLanguageCode,
        () {
      super.selectedLanguageCode = value;
    });
  }

  late final _$userIdAtom = Atom(name: '_AppStore.userId', context: context);

  @override
  int get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(int value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  late final _$loginTypeAtom =
      Atom(name: '_AppStore.loginType', context: context);

  @override
  String get loginType {
    _$loginTypeAtom.reportRead();
    return super.loginType;
  }

  @override
  set loginType(String value) {
    _$loginTypeAtom.reportWrite(value, super.loginType, () {
      super.loginType = value;
    });
  }

  late final _$userFirstNameAtom =
      Atom(name: '_AppStore.userFirstName', context: context);

  @override
  String get userFirstName {
    _$userFirstNameAtom.reportRead();
    return super.userFirstName;
  }

  @override
  set userFirstName(String value) {
    _$userFirstNameAtom.reportWrite(value, super.userFirstName, () {
      super.userFirstName = value;
    });
  }

  late final _$userLastNameAtom =
      Atom(name: '_AppStore.userLastName', context: context);

  @override
  String get userLastName {
    _$userLastNameAtom.reportRead();
    return super.userLastName;
  }

  @override
  set userLastName(String value) {
    _$userLastNameAtom.reportWrite(value, super.userLastName, () {
      super.userLastName = value;
    });
  }

  late final _$isEncryptingAtom =
      Atom(name: '_AppStore.isEncrypting', context: context);

  @override
  bool get isEncrypting {
    _$isEncryptingAtom.reportRead();
    return super.isEncrypting;
  }

  @override
  set isEncrypting(bool value) {
    _$isEncryptingAtom.reportWrite(value, super.isEncrypting, () {
      super.isEncrypting = value;
    });
  }

  late final _$isDecryptingAtom =
      Atom(name: '_AppStore.isDecrypting', context: context);

  @override
  bool get isDecrypting {
    _$isDecryptingAtom.reportRead();
    return super.isDecrypting;
  }

  @override
  set isDecrypting(bool value) {
    _$isDecryptingAtom.reportWrite(value, super.isDecrypting, () {
      super.isDecrypting = value;
    });
  }

  late final _$userEmailAtom =
      Atom(name: '_AppStore.userEmail', context: context);

  @override
  String get userEmail {
    _$userEmailAtom.reportRead();
    return super.userEmail;
  }

  @override
  set userEmail(String value) {
    _$userEmailAtom.reportWrite(value, super.userEmail, () {
      super.userEmail = value;
    });
  }

  late final _$userProfileImageAtom =
      Atom(name: '_AppStore.userProfileImage', context: context);

  @override
  String get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(String value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  late final _$userContactNumberAtom =
      Atom(name: '_AppStore.userContactNumber', context: context);

  @override
  String get userContactNumber {
    _$userContactNumberAtom.reportRead();
    return super.userContactNumber;
  }

  @override
  set userContactNumber(String value) {
    _$userContactNumberAtom.reportWrite(value, super.userContactNumber, () {
      super.userContactNumber = value;
    });
  }

  late final _$userNameAtom =
      Atom(name: '_AppStore.userName', context: context);

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
    });
  }

  late final _$tokenAtom = Atom(name: '_AppStore.token', context: context);

  @override
  String get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(String value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$playerIdAtom =
      Atom(name: '_AppStore.playerId', context: context);


  late final _$userTypeAtom =
      Atom(name: '_AppStore.userType', context: context);

  @override
  String get userType {
    _$userTypeAtom.reportRead();
    return super.userType;
  }

  @override
  set userType(String value) {
    _$userTypeAtom.reportWrite(value, super.userType, () {
      super.userType = value;
    });
  }

  late final _$currentEpubPageAtom =
      Atom(name: '_AppStore.currentEpubPage', context: context);

  @override
  String get currentEpubPage {
    _$currentEpubPageAtom.reportRead();
    return super.currentEpubPage;
  }

  @override
  set currentEpubPage(String value) {
    _$currentEpubPageAtom.reportWrite(value, super.currentEpubPage, () {
      super.currentEpubPage = value;
    });
  }

  late final _$cartCountAtom =
      Atom(name: '_AppStore.cartCount', context: context);

  @override
  List<String> get cartCount {
    _$cartCountAtom.reportRead();
    return super.cartCount;
  }

  @override
  set cartCount(List<String> value) {
    _$cartCountAtom.reportWrite(value, super.cartCount, () {
      super.cartCount = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_AppStore.selectedLanguage', context: context);

  @override
  String get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(String value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  late final _$selectedDrawerItemAtom =
      Atom(name: '_AppStore.selectedDrawerItem', context: context);

  @override
  int get selectedDrawerItem {
    _$selectedDrawerItemAtom.reportRead();
    return super.selectedDrawerItem;
  }

  @override
  set selectedDrawerItem(int value) {
    _$selectedDrawerItemAtom.reportWrite(value, super.selectedDrawerItem, () {
      super.selectedDrawerItem = value;
    });
  }

  late final _$languageCodeAtom =
      Atom(name: '_AppStore.languageCode', context: context);

  @override
  List<String> get languageCode {
    _$languageCodeAtom.reportRead();
    return super.languageCode;
  }

  @override
  set languageCode(List<String> value) {
    _$languageCodeAtom.reportWrite(value, super.languageCode, () {
      super.languageCode = value;
    });
  }

  late final _$isRTLAtom = Atom(name: '_AppStore.isRTL', context: context);

  @override
  bool get isRTL {
    _$isRTLAtom.reportRead();
    return super.isRTL;
  }

  @override
  set isRTL(bool value) {
    _$isRTLAtom.reportWrite(value, super.isRTL, () {
      super.isRTL = value;
    });
  }

  late final _$pageAtom = Atom(name: '_AppStore.page', context: context);

  @override
  int? get page {
    _$pageAtom.reportRead();
    return super.page;
  }

  @override
  set page(int? value) {
    _$pageAtom.reportWrite(value, super.page, () {
      super.page = value;
    });
  }

  late final _$isReviewAtom =
      Atom(name: '_AppStore.isReview', context: context);

  @override
  bool get isReview {
    _$isReviewAtom.reportRead();
    return super.isReview;
  }

  @override
  set isReview(bool value) {
    _$isReviewAtom.reportWrite(value, super.isReview, () {
      super.isReview = value;
    });
  }

  late final _$firstNameAtom =
      Atom(name: '_AppStore.firstName', context: context);

  @override
  String get firstName {
    _$firstNameAtom.reportRead();
    return super.firstName;
  }

  @override
  set firstName(String value) {
    _$firstNameAtom.reportWrite(value, super.firstName, () {
      super.firstName = value;
    });
  }

  late final _$lastNameAtom =
      Atom(name: '_AppStore.lastName', context: context);

  @override
  String get lastName {
    _$lastNameAtom.reportRead();
    return super.lastName;
  }

  @override
  set lastName(String value) {
    _$lastNameAtom.reportWrite(value, super.lastName, () {
      super.lastName = value;
    });
  }

  late final _$displayNameAtom =
      Atom(name: '_AppStore.displayName', context: context);

  @override
  String get displayName {
    _$displayNameAtom.reportRead();
    return super.displayName;
  }

  @override
  set displayName(String value) {
    _$displayNameAtom.reportWrite(value, super.displayName, () {
      super.displayName = value;
    });
  }

  late final _$avatarAtom = Atom(name: '_AppStore.avatar', context: context);

  @override
  String get avatar {
    _$avatarAtom.reportRead();
    return super.avatar;
  }

  @override
  set avatar(String value) {
    _$avatarAtom.reportWrite(value, super.avatar, () {
      super.avatar = value;
    });
  }

  late final _$passwordAtom =
      Atom(name: '_AppStore.password', context: context);

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$isFirstTimeAtom =
      Atom(name: '_AppStore.isFirstTime', context: context);

  @override
  bool get isFirstTime {
    _$isFirstTimeAtom.reportRead();
    return super.isFirstTime;
  }

  @override
  set isFirstTime(bool value) {
    _$isFirstTimeAtom.reportWrite(value, super.isFirstTime, () {
      super.isFirstTime = value;
    });
  }

  late final _$isSocialLoginAtom =
      Atom(name: '_AppStore.isSocialLogin', context: context);

  @override
  bool get isSocialLogin {
    _$isSocialLoginAtom.reportRead();
    return super.isSocialLogin;
  }

  @override
  set isSocialLogin(bool value) {
    _$isSocialLoginAtom.reportWrite(value, super.isSocialLogin, () {
      super.isSocialLogin = value;
    });
  }

  late final _$isTokenExpiredAtom =
      Atom(name: '_AppStore.isTokenExpired', context: context);

  @override
  bool get isTokenExpired {
    _$isTokenExpiredAtom.reportRead();
    return super.isTokenExpired;
  }

  @override
  set isTokenExpired(bool value) {
    _$isTokenExpiredAtom.reportWrite(value, super.isTokenExpired, () {
      super.isTokenExpired = value;
    });
  }

  late final _$cartListAtom =
      Atom(name: '_AppStore.cartList', context: context);

  @override
  List<MyCartResponse> get cartList {
    _$cartListAtom.reportRead();
    return super.cartList;
  }

  @override
  set cartList(List<MyCartResponse> value) {
    _$cartListAtom.reportWrite(value, super.cartList, () {
      super.cartList = value;
    });
  }

  late final _$cartTotalAmountAtom =
      Atom(name: '_AppStore.cartTotalAmount', context: context);

  @override
  double get cartTotalAmount {
    _$cartTotalAmountAtom.reportRead();
    return super.cartTotalAmount;
  }

  @override
  set cartTotalAmount(double value) {
    _$cartTotalAmountAtom.reportWrite(value, super.cartTotalAmount, () {
      super.cartTotalAmount = value;
    });
  }

  late final _$setSocialLoginAsyncAction =
      AsyncAction('_AppStore.setSocialLogin', context: context);

  @override
  Future<void> setSocialLogin(bool value) {
    return _$setSocialLoginAsyncAction.run(() => super.setSocialLogin(value));
  }

  late final _$setDisplayNameAsyncAction =
      AsyncAction('_AppStore.setDisplayName', context: context);

  @override
  Future<void> setDisplayName(String value) {
    return _$setDisplayNameAsyncAction.run(() => super.setDisplayName(value));
  }

  late final _$setDarkModeAsyncAction =
      AsyncAction('_AppStore.setDarkMode', context: context);

  @override
  Future<void> setDarkMode(bool value, {bool isInitializing = false}) {
    return _$setDarkModeAsyncAction
        .run(() => super.setDarkMode(value, isInitializing: isInitializing));
  }

  late final _$setRememberAsyncAction =
      AsyncAction('_AppStore.setRemember', context: context);

  @override
  Future<void> setRemember(dynamic value, {required dynamic isInitializing}) {
    return _$setRememberAsyncAction
        .run(() => super.setRemember(value, isInitializing: isInitializing));
  }

  late final _$setPasswordAsyncAction =
      AsyncAction('_AppStore.setPassword', context: context);

  @override
  Future<void> setPassword(String value) {
    return _$setPasswordAsyncAction.run(() => super.setPassword(value));
  }

  late final _$setAvatarAsyncAction =
      AsyncAction('_AppStore.setAvatar', context: context);

  @override
  Future<void> setAvatar(String value) {
    return _$setAvatarAsyncAction.run(() => super.setAvatar(value));
  }

  late final _$setFirstTimeAsyncAction =
      AsyncAction('_AppStore.setFirstTime', context: context);

  @override
  Future<void> setFirstTime(bool value, {bool isInitializing = false}) {
    return _$setFirstTimeAsyncAction
        .run(() => super.setFirstTime(value, isInitializing: isInitializing));
  }

  late final _$setUserTypeAsyncAction =
      AsyncAction('_AppStore.setUserType', context: context);

  @override
  Future<void> setUserType(String val, {bool isInitializing = false}) {
    return _$setUserTypeAsyncAction
        .run(() => super.setUserType(val, isInitializing: isInitializing));
  }

  late final _$setUserProfileAsyncAction =
      AsyncAction('_AppStore.setUserProfile', context: context);

  @override
  Future<void> setUserProfile(String val, {bool isInitializing = false}) {
    return _$setUserProfileAsyncAction
        .run(() => super.setUserProfile(val, isInitializing: isInitializing));
  }

  late final _$setLoginTypeAsyncAction =
      AsyncAction('_AppStore.setLoginType', context: context);

  @override
  Future<void> setLoginType(String val, {bool isInitializing = false}) {
    return _$setLoginTypeAsyncAction
        .run(() => super.setLoginType(val, isInitializing: isInitializing));
  }

  late final _$setTokenAsyncAction =
      AsyncAction('_AppStore.setToken', context: context);

  @override
  Future<void> setToken(String val, {bool isInitializing = false}) {
    return _$setTokenAsyncAction
        .run(() => super.setToken(val, isInitializing: isInitializing));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AppStore.setUserId', context: context);

  @override
  Future<void> setUserId(int val, {bool isInitializing = false}) {
    return _$setUserIdAsyncAction
        .run(() => super.setUserId(val, isInitializing: isInitializing));
  }

  late final _$setUserEmailAsyncAction =
      AsyncAction('_AppStore.setUserEmail', context: context);

  @override
  Future<void> setUserEmail(String val, {bool isInitializing = false}) {
    return _$setUserEmailAsyncAction
        .run(() => super.setUserEmail(val, isInitializing: isInitializing));
  }

  late final _$setFirstNameAsyncAction =
      AsyncAction('_AppStore.setFirstName', context: context);

  @override
  Future<void> setFirstName(String val, {bool isInitializing = false}) {
    return _$setFirstNameAsyncAction
        .run(() => super.setFirstName(val, isInitializing: isInitializing));
  }

  late final _$setLastNameAsyncAction =
      AsyncAction('_AppStore.setLastName', context: context);

  @override
  Future<void> setLastName(String val, {bool isInitializing = false}) {
    return _$setLastNameAsyncAction
        .run(() => super.setLastName(val, isInitializing: isInitializing));
  }

  late final _$setContactNumberAsyncAction =
      AsyncAction('_AppStore.setContactNumber', context: context);

  @override
  Future<void> setContactNumber(String val, {bool isInitializing = false}) {
    return _$setContactNumberAsyncAction
        .run(() => super.setContactNumber(val, isInitializing: isInitializing));
  }

  late final _$setUserNameAsyncAction =
      AsyncAction('_AppStore.setUserName', context: context);

  @override
  Future<void> setUserName(String val, {bool isInitializing = false}) {
    return _$setUserNameAsyncAction
        .run(() => super.setUserName(val, isInitializing: isInitializing));
  }

  late final _$setPaymentMethodAsyncAction =
      AsyncAction('_AppStore.setPaymentMethod', context: context);

  @override
  Future<void> setPaymentMethod(String val, {bool isInitializing = false}) {
    return _$setPaymentMethodAsyncAction
        .run(() => super.setPaymentMethod(val, isInitializing: isInitializing));
  }

  late final _$setLoggedInAsyncAction =
      AsyncAction('_AppStore.setLoggedIn', context: context);

  @override
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) {
    return _$setLoggedInAsyncAction
        .run(() => super.setLoggedIn(val, isInitializing: isInitializing));
  }

  late final _$setLanguageAsyncAction =
      AsyncAction('_AppStore.setLanguage', context: context);

  @override
  Future<void> setLanguage(String val, {bool isInitializing = false}) {
    return _$setLanguageAsyncAction
        .run(() => super.setLanguage(val, isInitializing: isInitializing));
  }

  late final _$setTokenExpiredAsyncAction =
      AsyncAction('_AppStore.setTokenExpired', context: context);

  @override
  Future<void> setTokenExpired(bool value) {
    return _$setTokenExpiredAsyncAction.run(() => super.setTokenExpired(value));
  }

  late final _$_AppStoreActionController =
      ActionController(name: '_AppStore', context: context);

  @override
  void setCurrentEpubPage(String value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setCurrentEpubPage');
    try {
      return super.setCurrentEpubPage(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEncryption(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setEncryption');
    try {
      return super.setEncryption(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDecryption(bool value) {
    final _$actionInfo = _$_AppStoreActionController.startAction(
        name: '_AppStore.setDecryption');
    try {
      return super.setDecryption(value);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFetching(bool val) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setFetching');
    try {
      return super.setFetching(val);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPage(int? aIndex) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.setPage');
    try {
      return super.setPage(aIndex);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoggedIn: ${isLoggedIn},
isDarkMode: ${isDarkMode},
isLoading: ${isLoading},
isReviewLoading: ${isReviewLoading},
isFetching: ${isFetching},
selectedLanguageCode: ${selectedLanguageCode},
userId: ${userId},
loginType: ${loginType},
userFirstName: ${userFirstName},
userLastName: ${userLastName},
isEncrypting: ${isEncrypting},
isDecrypting: ${isDecrypting},
userEmail: ${userEmail},
userProfileImage: ${userProfileImage},
userContactNumber: ${userContactNumber},
userName: ${userName},
token: ${token},
userType: ${userType},
currentEpubPage: ${currentEpubPage},
cartCount: ${cartCount},
selectedLanguage: ${selectedLanguage},
selectedDrawerItem: ${selectedDrawerItem},
languageCode: ${languageCode},
isRTL: ${isRTL},
page: ${page},
isReview: ${isReview},
firstName: ${firstName},
lastName: ${lastName},
displayName: ${displayName},
avatar: ${avatar},
password: ${password},
isFirstTime: ${isFirstTime},
isSocialLogin: ${isSocialLogin},
isTokenExpired: ${isTokenExpired},
cartList: ${cartList},
cartTotalAmount: ${cartTotalAmount},
userFullName: ${userFullName}
    ''';
  }
}

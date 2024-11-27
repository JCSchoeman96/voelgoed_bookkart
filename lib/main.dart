import 'package:bookkart_flutter/locale/language_en.dart';
import 'package:bookkart_flutter/utils/push_notification_service.dart';
import 'package:bookkart_flutter/utils/remote_config.dart';
import 'package:bookkart_flutter/services/auth_services.dart';
import 'package:bookkart_flutter/screens/splash_screen.dart';
import 'package:bookkart_flutter/utils/app_theme.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'models/dashboard/offline_book_list_model.dart';
import 'store/api_store.dart';
import 'store/app_store.dart';
import 'utils/common_base.dart';
import 'utils/database_helper.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('${FirebaseTopicConst.notificationDataKey} : ${message.data}');
  log('${FirebaseTopicConst.notificationKey} : ${message.notification}');
  log('${FirebaseTopicConst.notificationTitleKey} : ${message.notification!.title}');
  log('${FirebaseTopicConst.notificationBodyKey} : ${message.notification!.body}');
}

AppStore appStore = AppStore();
AuthService authService = AuthService();
ApiStore apiStore = ApiStore();

List<OfflineBookList> downloadedList = <OfflineBookList>[];

BaseLanguage locale = LanguageEn();

final DatabaseHelper dbHelper = DatabaseHelper.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().then((value) async {
    PushNotificationService().initFirebaseMessaging();
  }).catchError((e) {
    log('Firebase Initialization Error-----------------------${e.toString()}');
  });

  await initialize(aLocaleLanguageList: languageList());

  defaultRadius = 30;

  defaultRadius = 30;

  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN).validate(), isInitializing: true);
  await appStore.setDarkMode(getBoolAsync(DARK_MODE).validate(), isInitializing: true);
  await appStore.setRemember(getBoolAsync(REMEMBER_PASSWORD).validate(), isInitializing: true);
  await appStore.setFirstTime(getBoolAsync(IS_FIRST_TIME));

  int currentIndex = getIntAsync(THEME_MODE_INDEX).validate();

  if (currentIndex == THEME_MODE_LIGHT) {
    appStore.setDarkMode(false);
  } else if (currentIndex == THEME_MODE_DARK) {
    appStore.setDarkMode(true);
  }
  await setStoreReviewConfig().then((value) async {
    if (isIOS) {
      await setValue(HAS_IN_REVIEW, value.getBool(HAS_IN_APP_STORE_REVIEW));
    } else {
      await setValue(HAS_IN_REVIEW, false);
    }
  }).catchError((e) {
    log('------------------------------------------------------------------------');
    log("Firebase remote config error : ${e.toString()}");
    log('------------------------------------------------------------------------\n\n');
  });
  await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE), isInitializing: true);

  if (appStore.isLoggedIn) {
    await appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME), isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER), isInitializing: true);
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setLoginType(getStringAsync(LOGIN_TYPE), isInitializing: true);
    await appStore.setUserType(getStringAsync(USER_TYPE), isInitializing: true);
    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE), isInitializing: true);
    await appStore.setAvatar(getStringAsync(AVATAR));
    await appStore.setPaymentMethod(getStringAsync(PAYMENT_METHOD), isInitializing: true);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return MaterialApp(
          home: SplashScreen(),
          themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          navigatorKey: navigatorKey,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          locale: Locale(appStore.selectedLanguageCode),
          localizationsDelegates: [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => locale,
        );
      },
    );
  }
}

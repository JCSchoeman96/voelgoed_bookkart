import 'dart:core';

import 'package:flutter/services.dart';

//todo add after v31 push and then

const CHANNEL = 'CHANNEL';
const ENCRYPT = 'ENCRYPT';
const DECRYPT = 'DECRYPT';
const UNLOCK_KEY = "__ENCRYPTED_FILE__";
const platform = const MethodChannel(CHANNEL);

/// links
const PROD_BASE_URL = "https://api.ravepay.co/v3/sdkcheckout/";
const DEBUG_BASE_URL = "https://ravesandboxapi.flutterwave.com/v3/sdkcheckout/";

const PURCHASE_URL = "https://codecanyon.net/item/bookkart-flutter-ebook-reader-app-for-wordpress-with-woocommerce/28780154?s_rank=13";

/// remote configuration constants
const HAS_IN_REVIEW = "HAS_IN_REVIEW";
const HAS_IN_APP_STORE_REVIEW = "HAS_IN_APP_STORE_REVIEW";

/// date format
const REVIEW_DATE_FORMAT = 'dd/MM/yy';

///password
const ENCRYPTION_PASSWORD = '12345678';

///configuration
const BOOKS_PER_PAGE = 15;
const ICON_SIZE = 26.0;
const SETTING_ICON_SIZE = 24;
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;

/// error
const INVALID_PHONE_NUMBER = 'invalid-phone-number';
const INVALID_VERIFICATION_CODE = 'invalid-verification-code';
const IQONIC_PROFILE_IMAGE = "iqonic_profile_image";
const MESSAGE = 'message';

/// download
const CONTAINS_DOWNLOAD_FILES = "ContainsDownloadFiles";
const SALT = '!Q2w#E4r%T6y&U8i(O0p';
const SAMPLE_FILE = 'SampleFile';
const SAMPLE_FILES = "Sample File";
const PLAY_BUTTON = 'play_button';
const PAUSE_BUTTON = 'pause_button';

/// payment
const NATIVE = "native";
const RAZORPAY = "RazorPay";
const WEB_PAY = "WebPay";
const WAVE_PAYMENT = "WavePayment";
const STANDARD_PAYMENT = "payments";

///auth
const GOOGLE_USER = 'Google User';
const APPLE_FAMILY_NAME = 'appleFamilyName';
const PHOTO_URL = 'photoURL';
const INVALID_CREDENTIAL = "Invalid Credential.";
const EMAIL = 'email';
const PASSWORD = 'password';
const REMEMBER_PASSWORD = "remember_password";
const IS_FIRST_TIME = 'IS_FIRST_TIME';

/// file type
const PDF = ".pdf";
const MP4 = ".mp4";
const MOV = ".mov";
const WEBM = ".webm";
const MP3 = ".mp3";
const FLAC = ".flac";
const EPUB = ".epub";

/// etc
const VARIABLE = "variable";
const GROUPED = "grouped";
const EXTERNAL = "external";
const PAYMENT_COMPLETED = "completed";
const PAYMENT_CANCELLED = "cancelled";
const PAYMENT_FAILED = "failed";
const PAYMENT_PENDING = "pending";
const PAYMENT_METHOD_FLUTTER_WAVE = 'flutterwave';
const SEARCH_TEXT = 'searchTextHistory';
const CURRENCY_SYMBOL = 'currency_symbol';
const CURRENCY_NAME = 'currency_name';
const BOOK_TYPE_NEW = 'newest_books';
const BOOK_TYPE_FEATURED = 'featured_books';
const BOOK_TYPE_SUGGESTION = 'books_for_you';
const BOOK_TYPE_LIKE = 'you_may_like';
const REQUEST_TYPE_NEWEST = "newest";
const REQUEST_TYPE_YOU_MAY_LIKE = "you_may_like";
const REQUEST_TYPE_SUGGESTED_FOR_YOU = "suggested_for_you";
const REQUEST_TYPE_PRODUCT_VISIBILITY = "product_visibility";
const PAYMENT_METHOD_RAZORPAY = 'razorpay';

///social links keys
const NATIVE_USER = 'NATIVE_USER';
const WHATSAPP = 'WHATSAPP';
const FACEBOOK = 'FACEBOOK';
const TWITTER = 'TWITTER';
const INSTAGRAM = 'INSTAGRAM';
const CONTACT = 'CONTACT';

///app info
const OTP_USER = 'OTP_USER';
const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERMS_AND_CONDITIONS = 'TERMS_AND_CONDITIONS';
const COPYRIGHT_TEXT = 'COPYRIGHT_TEXT';
const PAYMENT_METHOD = 'PAYMENT_METHOD';
const PAGE_NUMBER = "PAGE_NUMBER_";
const AVATAR = 'AVATAR';
const REFRESH_LIST = "REFRESH_LIST";
const REFRESH_REVIEW_LIST = "REFRESH_REVIEW_LIST";
const REFRESH_LIBRARY_DATA = "REFRESH_LIBRARY_DATA";
const REFRESH_ORDER_DETAIL = "REFRESH_ORDER_DETAIL";

/// user info
const TOKEN_EXPIRED = "TOKEN_EXPIRED";
const IS_SOCIAL_LOGIN = "IS_SOCIAL_LOGIN";
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const TOKEN = 'TOKEN';
const USER_ID = 'USER_ID';
const USER_EMAIL = 'USER_EMAIL';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USERNAME = 'USERNAME';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const USER_TYPE = 'USER_TYPE';
const LOGIN_TYPE = 'LOGIN_TYPE';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const DARK_MODE = 'DARK_MODE';

class FirebaseTopicConst{
  //region Firebase Notification
  static const additionalDataKey = 'additional_data';
  static const notificationGroupKey = 'notification_group';
  static const idKey = 'id';
  static const userWithUnderscoreKey = 'user_';
  static const notificationDataKey = 'Notification Data';
  static const fcmNotificationTokenKey = 'FCM Notification Token';
  static const apnsNotificationTokenKey = 'APNS Notification Token';
  static const notificationErrorKey = 'Notification Error';
  static const notificationTitleKey = 'Notification Title';

  static const notificationKey = 'Notification';

  static const onClickListener= "Error On Notification Click Listener";
  static const onMessageListen= "Error On Message Listen";
  static const onMessageOpened="Error On Message Opened App";
  static const onGetInitialMessage='Error On Get Initial Message';

  static const messageDataCollapseKey='MessageData Collapse Key';

  static const messageDataMessageIdKey='MessageData Message Id';

  static const messageDataMessageTypeKey='MessageData Type';
  static const notificationBodyKey = 'Notification Body';
  static const backgroundChannelIdKey='background_channel';
  static const backgroundChannelNameKey='background_channel';

  static const notificationChannelIdKey='notification';
  static const notificationChannelNameKey='Notification';

  //Other Consts
  static const topicSubscribed = 'topic-----subscribed---->';
  static const topicUnSubscribed = 'topic-----UnSubscribed---->';
//endregion
}
import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get changeCountry;
  String get loadingBook;
  String get suggestedBook;
  String get open;
  String get orderDetail;
  String get orderId;
  String get orderCreatedAt;
  String get status;
  String get paymentDetails;
  String get paymentMethod;
  String get title;
  String get orderItems;
  String get totalAmount;
  String get payNow;
  String get titleBookStore;

  String get titleMyLibrary;

  String get titleSearch;

  String get titleAccount;

  String get msgNoInternet;

  String get headerNewestBookTitle;

  String get headerNewestBookMessage;

  String get headerFeaturedBookTitle;

  String get headerFeaturedBookMessage;

  String get headerForYouBookTitle;

  String get headerForYouBookMessage;

  String get headerLikeBookTitle;

  String get headerLikeBookMessage;

  String get bookStore;

  String get exploreBooks;

  String get newestBooks;

  String get newestBooksDesc;

  String get featuredBooks;

  String get featuredBooksDesc;

  String get booksForYou;

  String get booksForYouDesc;

  String get youMayLike;

  String get youMayLikeDesc;

  String get lblAbout;

  String get lblAuthor;

  String get lblViewFiles;

  String get lblBuyNow;

  String get lblFreeTrial;

  String get lblIntro;

  String get lblAdditionalInformation;

  String get lblCategories;

  String get lblTapToSeeAuthorDetails;

  String get lblHighRecommend;

  String get lblReviews;

  String get lblReview;

  String get lblNoReviewFound;

  String get lblMoreBooksFromAuthor;

  String get lblCancel;

  String get lblChangePwd;

  String get lblSubmit;

  String get lblEditProfile;

  String get lblSave;

  String get lblDownloadFailed;

  String get lblYouHaveBookmark;

  String get lblBookmarkNow;

  String get lblYourBookmarkLibrary;

  String get lblBooks;

  String get lblRememberMe;

  String get lblSignIn;

  String get lblForgotPassword;

  String get lblHaveAnAccount;

  String get lblSignUp;

  String get lblAlreadyHaveAnAccount;

  String get lblYouHaveAnyPurchasedBook;

  String get lblPurchasedNow;

  String get lblYourPurchasedLibrary;

  String get lblLogout;

  String get lblTermPrivacy;

  String get lblMyBookmark;

  String get lblNoBookFound;

  String get lblSearch;

  String get hintSearchByBookName;

  String get lblRecentSearch;

  String get lblNewPwdMustDiff;

  String get lblClearAll;

  String get lblSearchResultFrom;

  String get lblCancelDownload;

  String get lblLive;

  String get lblSearchByAuthorName;

  String get lblSearchByCategories;

  String get lblAreYourLogout;

  String get lblYes;

  String get lblHowMuchDoYouLove;

  String get lblMoreThanICanSay;

  String get lblWriteReview;

  String get lblPaymentCancelled;

  String get lblOldPwd;

  String get lblFieldRequired;

  String get lblNewPwd;

  String get lblUsername;

  String get lblEmailId;

  String get lblProfileSaved;

  String get lblConfirmPwd;

  String get lblPwdNotMatch;

  String get lblFirstName;

  String get lblLastName;

  String get lblFullName;

  String get lblPassword;

  String get lblReEnterPwd;

  String get lblRegistrationCompleted;

  String get lblMode;

  String get lblVersion;

  String get appName;

  String get lblTermsConditions;

  String get lblPrivacyPolicy;

  String get lblFollowUs;

  String get lblWelcome;

  String get lblPurchaseOnline;

  String get lblPushNotification;

  String get lblPrev;

  String get lblNext;

  String get lblEnjoyOfflineSupport;

  String get lblNoInternet;

  String get lblNetworkMsg;

  String get lblOfflineBook;

  String get lblBookNotAvailable;

  String get lblSearchForBooks;

  String get lblAllFiles;

  String get lblNoDataFound;

  String get lblConfirmationUploadImage;

  String get lblNo;

  String get lblError;

  String get lblTryAgain;

  String get hintEnterOldPwd;

  String get hintEnterNewPwd;

  String get hintEnterConfirmPwd;

  String get hintEnterFirstName;

  String get hintEnterLastName;

  String get hintEnterEmail;

  String get hintEnterPassword;

  String get hintEnterFullName;

  String get hintReEnterPassword;

  String get errorEmailAddress;

  String get errorPwdLength;

  String get errorString;

  String get lblOtpVerification;

  String get lblDone;

  String get lblVerify;

  String get hintMobileNumber;

  String get lblPurchasedBook;

  String get lblFreeBook;

  String get lblSmsCode;

  String get lblGoTo;

  String get lblOk;

  String get lblEnterPageNumber;

  String get lblHello;

  String get lblGuest;

  String get lblDescription;

  String get lblMyCart;

  String get lblEmptyCart;

  String get lblTotal;

  String get lblCheckOut;

  String get lblAlreadyInCart;

  String get lblAddToCart;

  String get lblAddedToCart;

  String get lblPaymentFailed;

  String get lblOops;

  String get lblPhoneNoInvalid;

  String get lblPleaseCheckPhoneForCode;

  String get lblCloseAndTryAgain;

  String get lblAppleSignInNotAvailable;

  String get lblSkip;

  String get lblChoosePaymentMethod;

  String get lblPay;

  String get lblAddReview;

  String get lblGoToCart;

  String get lblStoreName;

  String get lblShop;

  String get lblDefaultSettings;

  String get lblSettings;

  String get lblTransactionHistory;

  String get lblNoTransactionDataFound;

  String get lblChooseAnimation;

  String get lblFree;

  String get lblShowMore;

  String get lblShowLess;

  String get lblMy;

  String get lblPurchasedLibrary;

  String get lblFreeLibrary;

  String get lblContent;

  String get lblList;

  String get lblWhatIsAbout;

  String get lblViewAll;

  String get lblLogin;

  String get helloAgain;

  String get lblWelcomeBack;

  String get lblOrContinueWith;

  String get lblSearchForBooksEnter;

  String get lblPurchase;

  String get lblNoCategoriesFound;

  String get lblAreYouSureWantToDelete;

  String get lblHelp;

  String get lblAreYouSureWantToCheckout;

  String get lblUnknown;

  String get lblBookIsAddedToYourLibrary;

  String get lblToSeeDownloadKindleLogin;

  String get lblBookNotAvailableForDelete;

  String get lblBookTypeNotSupported;

  String get lblPasswordMustMatch;

  String get lblAreSureAboutUpdatingYourProfile;

  String get lblSubCategories;

  String get lblLibrary;

  String get lblSeeAll;

  String get lblOtp;

  String get lblEnterOtp;

  String get lblDelete;

  String get lblVisitMyShop;

  String get lblPickTheme;

  String get lightMode;

  String get darkMode;

  String get systemDefault;

  String get gallery;

  String get camera;

  String get resetPasswordStatement;

  String get resetPassword;

  String get pleaseEnterValidOTP;

  String get confirmOTP;

  String get confirm;

  String get sendingOTP;

  String get sendOTP;

  String get signInWithGoogle;

  String get signInWithOTP;

  String get signInWithApple;

  String get pleaseAcceptTermsAndConditions;

  String get signupForBetterExperience;

  String get iAgreeToThe;

  String get termsOfService;

  String get privacyPolicy;

  String get alreadyHaveAnAccount;

  String get pleaseSelectTheReview;

  String get jumpTo;

  String get rateUs;

  String get invalidURL;

  String get language;

  String get appTheme;

  String get reviewBy;

  String get lblGeneral;

  String get lblComplete;

  String get reviewSubmit;

  String get availableFiles;

  String get reviewMustBeUnique;

  String get lblCustomer;

  String get lblRatingFrom;

  String get theEnteredCodeIsInvalidPleaseTryAgain;

  String get lblOTPCodeIsSentToYourMobileNumber;

  String get lblTheEnteredCodeIsInvalidPleaseTryAgain;

  String get toSeeFileInLibraryMustLogin;

  String get lblDeleteAccountConformation;

  String get lblDeleteAccount;
}

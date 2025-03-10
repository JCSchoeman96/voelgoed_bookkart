import 'dart:convert';
import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/models/common_models/download_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:html/parser.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

Future<bool> nativeEncrypt({required String filePath}) async {
  if ((!await File(filePath).exists())) {
    toast("File not found");
    return false;
  }

  if (filePath.contains('.pdf')) {
    try {
      return await platform.invokeMethod(ENCRYPT, {"File": filePath});
    } on PlatformException catch (e) {
      /// ERROR WHILE CALLING NATIVE METHOD

      log("\nError while Encrypting: $e\n\n");
      throw e;
    }
  } else {
    return false;
  }
}

Future<bool> nativeDecrypt({required String filePath}) async {
  if ((!await File(filePath).exists())) {
    toast("File not found");
    return false;
  }

  if (filePath.contains('.pdf')) {
    try {
      return await platform.invokeMethod(DECRYPT, {"File": filePath});
    } on PlatformException catch (e) {
      /// Error while calling native method

      log("\nError while Decrypting: $e\n\n");
      throw e;
    }
  } else {
    return false;
  }
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.invalidURL}: $address');
  });
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'Afrikaans', languageCode: 'af', fullLanguageCode: 'af-ZA', flag: 'assets/flag/ic_af.png'),
    LanguageDataModel(id: 2, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(id: 3, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(id: 4, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(id: 5, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_fr.png'),
    LanguageDataModel(id: 6, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_de.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context, String? title, {Color? borderColor, Widget? prefixIcon, double? radiusValue}) {
  return InputDecoration(
    labelStyle: secondaryTextStyle(),
    labelText: title.validate(),
    filled: true,
    fillColor: context.cardColor,
    prefixIcon: prefixIcon,
    prefixIconColor: context.iconColor,
    suffixIconColor: context.iconColor,
    counter: Offstage(),
    counterText: '',
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.all(16),
    border: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? context.primaryColor), borderRadius: radius(radiusValue ?? defaultRadius)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? context.primaryColor), borderRadius: radius(radiusValue ?? defaultRadius)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: radius(radiusValue ?? defaultRadius)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: radius(radiusValue ?? defaultRadius)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: radius(radiusValue ?? defaultRadius)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(), borderRadius: radius(radiusValue ?? defaultRadius)),
  );
}

Future<void> downloadFileFromProvidedLink({
  required String link,
  required void Function(double percentage) progress,
  required DownloadModel locationOfStorage,
  required void Function() onSuccess,
  required void Function() onError,
}) async {
  log('$link');
  final storageIO = InternetFileStorageIO();

  ///step 1. downloading pdf or epub file
  await InternetFile.get(
    link,
    force: true,
    storage: storageIO,
    progress: (receivedLength, contentLength) {
      progress.call((receivedLength / contentLength * 100).round().toDouble());
      log('percentage of completing  download ' + (receivedLength / contentLength * 100).round().toDouble().toInt().toString());
    },
    storageAdditional: storageIO.additional(
      filename: await getBookFileName(locationOfStorage.id, locationOfStorage.file.validate()),
      location: await localPath,
    ),
  ).then((value) {
    onSuccess.call();
  }).catchError((e) {
    log(locale.lblDownloadFailed + '$e');
    onError.call();
  });
}

Color getBackGroundColor({required int index}) {
  return bookBackgroundColor[index % bookBackgroundColor.length];
}

Future<void> launchUrlCustomTab(String url) async {
  if (url.validate().isNotEmpty) {
    try {
      await custom_tabs.launchUrl(
        Uri.parse(url),
        customTabsOptions: custom_tabs.CustomTabsOptions(
          colorSchemes: custom_tabs.CustomTabsColorSchemes.defaults(toolbarColor: primaryColor),
          animations: custom_tabs.CustomTabsSystemAnimations.slideIn(),
          urlBarHidingEnabled: true,
          shareState: custom_tabs.CustomTabsShareState.on,
          browser: custom_tabs.CustomTabsBrowserConfiguration(
            fallbackCustomTabs: [
              'org.mozilla.firefox',
              'com.microsoft.emmx',
            ],
            headers: {'key': 'value'},
          ),
        ),
        safariVCOptions: custom_tabs.SafariViewControllerOptions(
            barCollapsingEnabled: true,
            dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
            entersReaderIfAvailable: false,
            preferredControlTintColor: Colors.white,
            preferredBarTintColor: primaryColor),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}

Color getRatingBarColor(int rating) {
  if (rating == 1 || rating == 2) {
    return Color(0xFFE80000);
  } else if (rating == 3) {
    return Colors.orange;
  } else if (rating == 5 || rating == 4) {
    return Color(0xFF73CB92);
  } else {
    return Color(0xFFE80000);
  }
}

void openEpubFile(BuildContext context, {required String bookID, required String filePath, bool isFromAssets = false}) {
  if (filePath.isEmpty) {
    toast('No file path is found');
    return;
  }

  if (!filePath.contains('.epub')) {
    toast('No epub file exist');
    return;
  }

  afterBuildCreated(() async {
    VocsyEpub.setConfig(
        themeColor: Theme.of(context).primaryColor, identifier: "iosBook", scrollDirection: EpubScrollDirection.ALLDIRECTIONS, allowSharing: true, enableTts: true, nightMode: appStore.isDarkMode);

    VocsyEpub.locatorStream.listen((locator) {
      log('${jsonDecode(locator)}');
      setValue("LastPage_$bookID", jsonDecode(locator));
    }).onDone(() {
      //
    });

    EpubLocator? lastLocation = getStringAsync("LastPage_$bookID").validate().isNotEmpty ? EpubLocator.fromJson(jsonDecode(getStringAsync("LastPage_$bookID").validate())) : null;
    if (isFromAssets) {
      await VocsyEpub.openAsset(filePath, lastLocation: lastLocation);
    } else {
      VocsyEpub.open(filePath, lastLocation: lastLocation);
    }
  });
}


extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkMode ? Colors.white : textSecondaryColor),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(ic_book_logo, height: size ?? 24, width: size ?? 24);
      },
    );
  }
}

extension StringExt on String {
  String getFormattedPrice() {
    return '${getStringAsync(CURRENCY_SYMBOL)}$this';
  }
}
import 'package:bookkart_flutter/locale/language_af.dart';
import 'package:bookkart_flutter/locale/language_ar.dart';
import 'package:bookkart_flutter/locale/language_hi.dart';
import 'package:bookkart_flutter/locale/languages_de.dart';
import 'package:bookkart_flutter/locale/languages_fr.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'language_en.dart';
import 'languages.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'ar':
        return LanguageAr();
      case 'hi':
        return LanguageHi();
      case 'fr':
        return LanguageFr();
      case 'de':
        return LanguageDe();
      case 'af':
        return LanguageAf();
      default:
        return LanguageAf();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}

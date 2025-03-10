import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';

class AppTheme {
  //
  AppTheme._();


  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      cardColor: cardColor,
      dividerColor: borderColor,
      hoverColor: Colors.grey,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      unselectedWidgetColor: Colors.black,
      fontFamily: GoogleFonts.jost().fontFamily,
      dialogBackgroundColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData(cursorColor: primaryColor),
      scaffoldBackgroundColor: scaffoldColor,
      cardTheme: CardTheme(color: cardColor),
      dividerTheme: DividerThemeData(color: viewLineColor),
      primaryIconTheme: IconThemeData(color: iconColorPrimaryDark),
      dialogTheme: DialogTheme(shape: dialogShape()),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Color(0xff4268cd).withOpacity(0.05),
        indicatorColor: Color(0xff4268cd).withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 12)),
      ),
      appBarTheme: AppBarTheme(
        titleSpacing: 0,
        elevation: 0,
        foregroundColor: appLayout_background,
        backgroundColor: scaffoldColor,
        iconTheme: IconThemeData(color: textPrimaryColor),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: scaffoldColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark),
      ),
      primaryTextTheme: TextTheme(titleMedium: TextStyle(color: Color(0xff404C6D), fontSize: 16)),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: createMaterialColor(screenBackgroundColor)).copyWith(surface: scaffoldColor).copyWith(error: errorColor),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      primaryColorDark: color_primary_black,
      highlightColor: appBackgroundColorDark,
      cardColor: cardBackgroundColor,
      dividerColor: dividerDarkColor,
      fontFamily: GoogleFonts.jost().fontFamily,
      hoverColor: blackColor,
      scaffoldBackgroundColor: appBackgroundColorDark,
      dialogBackgroundColor: scaffoldSecondaryDark,
      unselectedWidgetColor: Colors.white60,
      textTheme: TextTheme(titleMedium: TextStyle(color: white)),
      cardTheme: CardTheme(color: cardBackgroundBlackDark),
      iconTheme: IconThemeData(color: whiteColor),
      primaryIconTheme: IconThemeData(color: whiteColor),
      dialogTheme: DialogTheme(shape: dialogShape()),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldSecondaryDark,
        selectedItemColor: white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Color(0xff4268cd).withOpacity(0.05),
        indicatorColor: Color(0xff4268cd).withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 12)),
      ),
      appBarTheme: AppBarTheme(
        titleSpacing: 0,
        elevation: 0,
        color: appBackgroundColorDark,
        iconTheme: IconThemeData(color: whiteColor),
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: appBackgroundColorDark, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: appBackgroundColorDark,
        shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      ),
      colorScheme: ColorScheme.dark(primary: appBackgroundColorDark, onPrimary: cardBackgroundBlackDark, primaryContainer: color_primary_black)
          .copyWith(primaryContainer: createMaterialColor(scaffoldSecondaryDark), surface: appBackgroundColorDark)
          .copyWith(error: errorColor),
    );
  }
}

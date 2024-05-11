import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

const double defaultPadding = 20;
const double bottomNavigationBarBorderRadius = 40;
const double homePageUserIconSize = 30;
const double settingsPageUserIconSize = 90;

ThemeData globalTheme(BuildContext context) {
  return ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    dividerColor: dividerColor,
    secondaryHeaderColor: Colors.grey[700],
    primaryColor: Colors.cyan,
    canvasColor: Colors.white,
    cardColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: textColorDark,
      displayColor: textColorLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: textColorDark),
    ),
    inputDecorationTheme: InputDecorationTheme(
      alignLabelWithHint: false,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: primaryColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: const BorderSide(color: hintColor),
      ),
    ),
    // outlinedButtonTheme: OutlinedButtonThemeData(
    //   style: ButtonStyle(
    //     side: MaterialStateProperty.all<BorderSide>(
    //       const BorderSide(
    //         color: primaryColor,
    //       ),
    //     ),
    //     padding: MaterialStateProperty.all<EdgeInsets>(
    //       const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
    //     ),
    //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(30.0),
    //       ),
    //     ),
    //   ),
    // ),
    // textButtonTheme: TextButtonThemeData(
    //   style: ButtonStyle(
    //     overlayColor: MaterialStateColor.resolveWith(
    //         (states) => primaryColor.withOpacity(0.3)),
    //     backgroundColor: MaterialStateProperty.all(primaryColor),
    //     foregroundColor: MaterialStateProperty.all(fontColorDark),
    //     elevation: MaterialStateProperty.all(10),
    //     shadowColor: MaterialStateProperty.all(primaryColor),
    //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    //       RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(30.0),
    //       ),
    //     ),
    //   ),
    // ),
  );
}

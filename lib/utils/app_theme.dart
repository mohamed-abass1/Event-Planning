import 'package:flutter/material.dart';

import 'app_Styles.dart';
import 'app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    dividerColor: AppColors.primaryDark,
      primaryColor: AppColors.primaryLight,
cardColor: AppColors.primaryLight,
      splashColor: AppColors.whiteColor,
      hintColor: AppColors.grey,

      textTheme: TextTheme(
        bodySmall: AppStyles.bold20Black,
labelMedium: AppStyles.medium16black,
          bodyMedium: AppStyles.bold20Black
          ,headlineSmall:AppStyles.medium16Primary,
          titleSmall: AppStyles.medium16black,
      titleMedium: AppStyles.semi20Black,
      labelSmall: AppStyles.medium20White
      ),

      canvasColor: AppColors.whiteColor,

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        showUnselectedLabels: true,
        unselectedLabelStyle: AppStyles.bold12White,
        selectedLabelStyle: AppStyles.bold12White,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: StadiumBorder(
            side: BorderSide(
          color: AppColors.whiteColor,
          width: 4,
        )),
        backgroundColor: AppColors.primaryLight,
      ));



  static final ThemeData darkTheme = ThemeData(
    hintColor: AppColors.primaryLight,
    dividerColor: AppColors.whiteColor,
    splashColor: AppColors.primaryDark,
     canvasColor: AppColors.primaryLight,
    cardColor: AppColors.whiteColor,
    textTheme: TextTheme(
      labelSmall: AppStyles.semi20Black,
      bodySmall: AppStyles.bold20Black,
      displayMedium: AppStyles.medium16black,
        bodyMedium: AppStyles.medium20White,
        headlineSmall:AppStyles.medium16White,
    labelMedium: AppStyles.medium16White,
    titleSmall: AppStyles.medium20White,
        titleMedium: AppStyles.medium20White
    ),
      primaryColor: AppColors.primaryDark,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        showUnselectedLabels: true,
        unselectedLabelStyle: AppStyles.bold12White,
        selectedLabelStyle: AppStyles.bold12White,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryDark,
          shape: StadiumBorder(
              side: BorderSide(
            color: AppColors.whiteColor,
            width: 4,
          ))));
}

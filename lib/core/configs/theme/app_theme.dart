import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        fontFamily: 'CircularStd',
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xffF5F5F5),
          hintStyle: const TextStyle(
            color: Color(0xffA7A7A7),
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        brightness: Brightness.dark,
        fontFamily: 'CircularStd',
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.background,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.secondBackground,
          hintStyle: const TextStyle(
            color: Color(0xffA7A7A7),
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
}

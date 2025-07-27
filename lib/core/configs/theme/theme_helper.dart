import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeHelper {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // Background colors
  static Color getBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.background : AppColors.backgroundLight;
  }

  static Color getSecondBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.secondBackground : AppColors.secondBackgroundLight;
  }

  static Color getCardBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.cardBackground : AppColors.cardBackgroundLight;
  }

  // Text colors
  static Color getTextPrimaryColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.textPrimary : AppColors.textPrimaryLight;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.textSecondary : AppColors.textSecondaryLight;
  }

  static Color getTextHintColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.textHint : AppColors.textSecondaryLight;
  }

  // Border colors
  static Color getBorderColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.cardBorder : AppColors.cardBorderLight;
  }

  // Icon colors
  static Color getIconColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.textPrimary : AppColors.textPrimaryLight;
  }

  static Color getIconSecondaryColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.textSecondary : AppColors.textSecondaryLight;
  }

  // Status colors
  static Color getStatusColor(BuildContext context, bool isDone) {
    if (isDone) {
      return AppColors.primary;
    }
    return isDarkMode(context) ? AppColors.textSecondary : AppColors.textSecondaryLight;
  }

  static Color getStatusTextColor(BuildContext context, bool isDone) {
    if (isDone) {
      return Colors.white;
    }
    return isDarkMode(context) ? AppColors.textSecondary : AppColors.textSecondaryLight;
  }

  // Shadow
  static Color getShadowColor(BuildContext context) {
    return isDarkMode(context) ? AppColors.shadowDark : AppColors.shadowLight;
  }

  // Container decoration
  static BoxDecoration getCardDecoration(BuildContext context) {
    return BoxDecoration(
      color: getCardBackgroundColor(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: getBorderColor(context),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: getShadowColor(context),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration getContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: getSecondBackgroundColor(context),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: getBorderColor(context),
        width: 0.5,
      ),
    );
  }
} 
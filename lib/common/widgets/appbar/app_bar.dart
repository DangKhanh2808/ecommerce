import 'package:ecommerce/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final double? height;
  const BasicAppbar(
      {this.title,
      this.hideBack = false,
      this.action,
      this.backgroundColor,
      this.height,
      super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppBar(
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      toolbarHeight: height ?? 80,
      title: title ?? const Text(''),
      titleSpacing: 0,
      actions: [action ?? Container()],
      leading: hideBack
          ? null
          : IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: isDark ? theme.cardColor : AppColors.secondBackgroundLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 80);
}

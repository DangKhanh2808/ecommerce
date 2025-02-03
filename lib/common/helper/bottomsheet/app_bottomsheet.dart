import 'package:flutter/material.dart';

class AppBottomsheet {
  static Future<void> display(BuildContext context, Widget widget) async {
    // Show the bottom sheet
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) => widget,
    );
  }
}

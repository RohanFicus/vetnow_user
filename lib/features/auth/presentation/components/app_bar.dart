import 'package:flutter/material.dart';
import 'package:vetnow_user/core/theme/app_theme_colors.dart';

PreferredSizeWidget buildSimpleAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: context.appBackground,
    elevation: 0,
    centerTitle: true,
    leading: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: context.appSurface,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: context.appText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        color: context.appText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

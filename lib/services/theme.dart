import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';

class LoadTheme {
  static Future<ThemeData?> lightTheme() async {
    final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
    final themeJson = jsonDecode(themeStr);
    return ThemeDecoder.decodeThemeData(themeJson);
  }

  static Future<ThemeData?> darkTheme() async {
    final themeStr = await rootBundle.loadString('assets/appainter_theme_dark.json');
    final themeJson = jsonDecode(themeStr);
    return ThemeDecoder.decodeThemeData(themeJson);
  }
}

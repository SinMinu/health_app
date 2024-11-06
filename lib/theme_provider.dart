import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  Color _themeColor = Colors.blueAccent;

  Color get themeColor => _themeColor;

  ThemeProvider() {
    _loadThemeColor();
  }

  // 저장된 테마 색상 불러오기
  Future<void> _loadThemeColor() async {
    final prefs = await SharedPreferences.getInstance();
    final int? colorValue = prefs.getInt('themeColor');
    if (colorValue != null) {
      _themeColor = Color(colorValue);
      notifyListeners();
    }
  }

  // 테마 색상 변경 및 저장
  Future<void> setThemeColor(Color color) async {
    _themeColor = color;
    notifyListeners(); // 변경 사항 알림
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeColor', color.value);
  }
}

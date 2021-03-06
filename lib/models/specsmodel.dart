import 'dart:math';

import 'package:beautiful_snippet/constants/constants.dart';
import 'package:flutter/material.dart';

enum AppTheme { dark, light }
enum CodeTheme { monokai }

class SpecsModel extends ChangeNotifier {
  SpecsModel() {
    init();
  }

  void init() {
    final random = Random();
    final randomIndex = random.nextInt(backgroundColors.length);
    _backgroundColor = backgroundColors[randomIndex];
    _language = 'Dart';
    _codeTheme = 'Monokai';
  }

  late Color _backgroundColor;
  Color _snippetBackgroundColor = black;
  Color _snippetHeaderColor = black;
  Color _borderColor = black;
  AppTheme _theme = AppTheme.dark;
  late String _codeTheme;
  bool _hasBorder = false;
  late String _language;
  String _sourceCode = sourceTemplate;
  String get sourceCode => _sourceCode;
  set sourceCode(String code) {
    _sourceCode = code;
    // notifyListeners();
  }

  String get language => _language;
  set language(String code) {
    _language = code;
    notifyListeners();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color bgColor) {
    _backgroundColor = bgColor;
    notifyListeners();
  }

  Color get snippetBackgroundColor => _snippetBackgroundColor;
  set snippetBackgroundColor(Color bgColor) {
    _snippetBackgroundColor = bgColor;
    notifyListeners();
  }

  Color get snippetHeaderColor => _snippetHeaderColor;
  set snippetHeaderColor(Color color) {
    _snippetHeaderColor = color;
    notifyListeners();
  }

  bool get hasBorder => _hasBorder;
  set hasBorder(bool value) {
    _hasBorder = value;
    notifyListeners();
  }

  Color get borderColor => _borderColor;
  set borderColor(Color borderColor) {
    _borderColor = borderColor;
    notifyListeners();
  }

  AppTheme get theme => _theme;
  set theme(AppTheme theme) {
    _theme = theme;
    notifyListeners();
  }

  String get codeTheme => _codeTheme;
  set codeTheme(String theme) {
    _codeTheme = theme;
    notifyListeners();
  }
}

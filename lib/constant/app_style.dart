import 'package:flutter/rendering.dart';

class AppStyle {
  static TextStyle fontBold({double? fontSize}) {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ?? 16);
  }

  static TextStyle fontRegular({double? fontSize}) {
    return TextStyle(fontSize: fontSize ?? 16);
  }
}

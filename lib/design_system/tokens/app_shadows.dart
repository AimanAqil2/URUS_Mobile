import 'package:flutter/material.dart';

/// Low-contrast elevation used by cards and floating actions in URUS.
abstract final class AppShadows {
  static const card = [
    BoxShadow(color: Color(0x0D27202F), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const floating = [
    BoxShadow(color: Color(0x3384CC16), blurRadius: 20, offset: Offset(0, 8)),
  ];
}

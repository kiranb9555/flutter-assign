//"ylf89s"
import 'package:flutter/material.dart';

class AppConstants {
  static const String appTitle = 'Hacker News';

  static const double screenPadding = 16.0;

  static const double cardRadius = 12.0;

  static const Duration animationDuration =
      Duration(milliseconds: 300);
}

class AppTextStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle commentStyle = TextStyle(
    fontSize: 14,
    color: Colors.black87,
    height: 1.4,
  );
}


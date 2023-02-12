import 'package:flutter/material.dart';

class Util {
  static void logError(String message) {
    debugPrint("\x1B[31m $message \x1B[0m");
  }

  static void logInfo(String message) {
    debugPrint("\x1B[35m $message \x1B[0m");
  }

  static void logSuccess(String message) {
    debugPrint("\x1B[32m $message \x1B[0m");
  }

  static void logWarning(String message) {
    debugPrint("\x1B[33m $message \x1B[0m");
  }

  static void logFootprint(String message) {
    debugPrint("\x1B[36m $message \x1B[0m");
  }
}

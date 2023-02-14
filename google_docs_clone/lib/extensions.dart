// make an extension on string to print the string in different colors such as: red, green, yellow, blue

import 'package:flutter/foundation.dart';

extension StringExtension on dynamic {
  void logError() {
    if (kDebugMode) {
      print('\x1B[31m$this\x1B[0m');
    }
  }

  void logSuccess() {
    if (kDebugMode) {
      print('\x1B[32m$this\x1B[0m');
    }
  }

  void logWarning() {
    if (kDebugMode) {
      print('\x1B[33m$this\x1B[0m');
    }
  }

  void logInfo() {
    if (kDebugMode) {
      print('\x1B[34m$this\x1B[0m');
    }
  }
}
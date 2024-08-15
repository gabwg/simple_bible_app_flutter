import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sba/constants.dart';
import 'package:sba/main.dart';

SnackBar historySnackbar(ReaderState state) {
  final currentIndex = state.currentHistoryIndex;
  final historyLength = state.history.length;
  return SnackBar(
      content: Text("${currentIndex + 1} / $historyLength"),
      behavior: SnackBarBehavior.floating,
      showCloseIcon: false,
      width: 90.0,
      duration: const Duration(milliseconds: 200),
      animation: null);
}

SnackBar messageSnackbar(String string) {
  return SnackBar(
    content: Text(string),
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
    duration: const Duration(milliseconds: 3000),
  );
}

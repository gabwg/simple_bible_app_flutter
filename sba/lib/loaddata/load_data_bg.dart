import 'package:flutter/services.dart' show rootBundle;
import 'package:sba/constants.dart';

Future<String> loadBgAsset(bookIndex, chapter, version) async {
  return await rootBundle.loadString(
      'assets/bg_data/$version/${booknamesEn[bookIndex]}$chapter.html');
}

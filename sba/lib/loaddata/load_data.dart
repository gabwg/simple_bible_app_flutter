import 'dart:async';

import 'package:sba/constants.dart';
import 'package:sba/loaddata/load_data_bg.dart';

Future<String> loadDataAsset(bookIndex, chapter, version) async {
  if (BG_versionList.contains(version)) {
    return await loadBgAsset(bookIndex, chapter, version);
  } else {
    throw UnimplementedError("$version not implemented");
  }
}

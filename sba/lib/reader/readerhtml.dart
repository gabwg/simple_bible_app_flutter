import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sba/main.dart';
import 'package:sba/constants.dart';

class ReaderHTML extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderState>(builder: (consumer, state, child) {
      final readerHtmlStyles = getScaledHtmlFontSizes(1.0);
      print(readerHtmlStyles);
      return HtmlWidget(state.htmlstring,
          renderMode: RenderMode.listView,
          textStyle: TextStyle(fontSize: state.scale * defaultTextSize),
          customStylesBuilder: (element) {
        if (element.classes.contains('chapternum')) {
          return {
            'font-size': readerHtmlStyles['chapternum_font-size'] ?? '2em'
          };
        } else if (element.classes.contains('versenum')) {
          return {'font-size': readerHtmlStyles['sub_font-size'] ?? '0.5em'};
        } else {
          return {'font-size': readerHtmlStyles['text_font-size'] ?? '1em'};
        }
        return null;
      }
          //return Placeholder()
          );
    });
  }
}

Map<String, String> getScaledHtmlFontSizes(scale) {
  return defaultReaderHtmlFontSizes.map(
    (key, value) {
      return MapEntry(key, "${value * scale}em");
    },
  );
}

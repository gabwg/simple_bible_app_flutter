import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sba/constants.dart';
import 'package:sba/main.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.goToReaderPage});
  final void Function() goToReaderPage;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderState>(builder: (consumer, state, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text("History"),
            actions: [
              TextButton(
                  child: Text("Clear"),
                  onPressed: () {
                    state.clearHistory();
                  })
            ],
          ),
          body: Padding(
              padding: EdgeInsets.all(10.0),
              child: HistoryList(
                list: state.history,
                onTap: (p1, p2, p3) {
                  state.setBookIndexChapterNoHistory(p1, p2);
                  state.setHistoryIndex(p3);
                  goToReaderPage();
                },
              )));
    });
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.list, required this.onTap});
  final List<HistoryItem> list;
  final void Function(int, int, int) onTap;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView(children: [
          for (var (i, item) in list.indexed)
            ListTile(
                title: Text("${booknameEn(item.bookIndex)} ${item.chapter}"),
                onTap: () {
                  onTap(item.bookIndex, item.chapter, i);
                })
        ]);
      },
    );
  }
}

class HistoryItem {
  const HistoryItem({required this.bookIndex, required this.chapter});
  final int bookIndex;
  final int chapter;
/*
  convert history string "x-y" to a class 
*/
  factory HistoryItem.fromString(String historyString) {
    final splitString = historyString
        .split(historyStringDelimChar)
        .map((x) => int.parse(x))
        .toList();

    return HistoryItem(bookIndex: splitString[0], chapter: splitString[1]);
  }
  @override
  String toString() {
    return "$bookIndex$historyStringDelimChar$chapter";
  }
}

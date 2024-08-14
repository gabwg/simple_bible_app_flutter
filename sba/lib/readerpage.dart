import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:sba/constants.dart';
import 'package:sba/main.dart';
import 'package:sba/reader/readerhtml.dart';

ButtonStyle selectorButtonStyle(context) {
  return ButtonStyle(backgroundColor:
      WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.5);
    }
    return null;
  }));
}

class BookSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderState>(
      builder: (consumer, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Book Selector'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  BookSelectorBody(
                      updateFunc: (p1, p2) =>
                          state.setBookIndexChapter(p1, p2)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BookSelectorBody extends StatelessWidget {
  final void Function(int, int) updateFunc;
  const BookSelectorBody({super.key, required this.updateFunc});
  @override
  Widget build(BuildContext context) {
    final list = booknamesEn;
    return Expanded(
        child: ListView(padding: const EdgeInsets.all(12), children: <Widget>[
      for (final (index, item) in list.indexed)
        ListTile(
          title: Text(item),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => ChapterSelector(
                    bookIndex: index,
                    bookName: item,
                    updateFunc: (x) {
                      updateFunc(index, x);
                      Navigator.pop(context);
                    },
                  ),
                ));
          },
        )
    ]));
  }
}

class ChapterSelector extends StatelessWidget {
  final int bookIndex;
  final String bookName;
  final void Function(int) updateFunc;
  const ChapterSelector(
      {super.key,
      required this.bookIndex,
      required this.bookName,
      required this.updateFunc});
  @override
  Widget build(BuildContext context) {
    int chapterCount = chapters[bookIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.extent(
            maxCrossAxisExtent: chapterGridmaxCrossAxisExtent,
            children: [
              for (int i = 1; i <= chapterCount; i++)
                TextButton(
                    onPressed: () {
                      updateFunc(i);
                      Navigator.pop(context);
                    },
                    child: Text("$i"))
            ],
          ),
        ),
      ),
    );
  }
}

class ReaderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView(
          children: [
            for (var string in List<String>.generate(
                40, (i) => "the quick brown fox jumps over the lazy dog $i "))
              Row(
                children: [
                  SizedBox(
                    width: (constraints.maxWidth >= 400) ? 36 : 18,
                    child: Text("999"),
                  ),
                  Flexible(child: Text(string))
                ],
              ),
          ],
        );
      },
    );
  }
}

class ReaderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: ReaderSelectorButtons(),
          actions: <Widget>[
            ReaderVersionButton(),
            Flexible(
              child: SizedBox(width: 10.0),
            )
          ],
        ),
        body: Padding(padding: EdgeInsets.all(10.0), child: ReaderHTML()));
  }
}

class ReaderVersionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderState>(builder: (consumer, state, child) {
      return ElevatedButton(
        child: Text(
          state.version.toUpperCase(),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => VersionSelector(),
              ));
        },
      );
    });
  }
}

class VersionSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderState>(
      builder: (consumer, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Version Selector'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  VersionSelectorBody(setVersion: (p1) => state.setVersion(p1)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VersionSelectorBody extends StatelessWidget {
  const VersionSelectorBody({super.key, required this.setVersion});
  final void Function(String) setVersion;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(padding: const EdgeInsets.all(12), children: <Widget>[
        for (final item in versionList)
          ListTile(
            title: Text(item),
            onTap: () {
              setVersion(item);
              Navigator.pop(context);
            },
          )
      ]),
    );
  }
}

class ReaderSelectorButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ReaderState>(
      builder: (consumer, state, child) {
        final bookname = booknamesEn[state.bookIndex];
        return Row(children: [
          Flexible(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => BookSelector(),
                    ));
              },
              style: ButtonStyle(),
              child: Text(
                bookname,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
          SizedBox(width: 10.0),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => ChapterSelector(
                        bookIndex: state.bookIndex,
                        bookName: bookname,
                        updateFunc: (x) {
                          state.setBookIndexChapter(state.bookIndex, x);
                        },
                      ),
                    ));
              },
              style: ButtonStyle(),
              child: Text(
                "${state.chapter}",
              ))
        ]);
      },
    );
  }
}

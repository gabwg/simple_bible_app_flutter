import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sba/constants.dart';
import 'package:sba/helpers.dart';
import 'package:sba/historypage.dart';
import 'package:sba/loaddata/load_data.dart';
import 'package:sba/readerpage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ReaderState(), child: const MyApp()));
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/test.html');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class ReaderState extends ChangeNotifier {
  // bookIndex not book number (starts from 0)
  var bookIndex = 0;
  // chapter number not index (starts from 1)
  var chapter = 1;
  var version = defaultVersion;
  var htmlstring = "";
  var scale = defaultScale;
  var currentHistoryIndex = 0;
  List<HistoryItem> history = [];

  bool isLastChapter() {
    return chapter == chapters[bookIndex];
  }

  bool isFirstChapter() {
    return chapter == 1;
  }

  void goToNextChapter() {
    if (!isLastChapter()) {
      chapter += 1;
      setBookIndexChapter(bookIndex, chapter);
    }
  }

  void goToPreviousChapter() {
    if (!isFirstChapter()) {
      chapter -= 1;
      setBookIndexChapter(bookIndex, chapter);
    }
  }

  void setBookIndexChapter(newBookIndex, newChapter) async {
    setBookIndexChapterNoHistory(newBookIndex, newChapter);
    await saveToHistory(
        HistoryItem(bookIndex: newBookIndex, chapter: newChapter));
    setHistoryIndex(0);
  }

  void setBookIndexChapterNoHistory(newBookIndex, newChapter) {
    loadDataAsset(newBookIndex, newChapter, version)
        .then(
          (value) => htmlstring = value,
        )
        .then((_) => _saveBookIndexChapter(newBookIndex, newChapter))
        .then((_) => {notifyListeners()});
    bookIndex = newBookIndex;
    chapter = newChapter;
    print(bookIndex);
  }

  void setHtmlstring(string) {
    htmlstring = string;
    notifyListeners();
  }

  void setbookIndex(newBookIndex) {
    bookIndex = newBookIndex;
    notifyListeners();
  }

  Future<void> _loadBookIndexChapter() async {
    final prefs = await SharedPreferences.getInstance();

    setBookIndexChapterNoHistory(prefs.getInt(bookIndexKey) ?? defaultBookIndex,
        prefs.getInt(chapterKey) ?? defaultChapter);
  }

  Future<void> _saveBookIndexChapter(newBookIndex, newChapter) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(bookIndexKey, newBookIndex);
    prefs.setInt(chapterKey, newChapter);
  }

  Future<void> saveToHistory(HistoryItem historyItem) async {
    final prefs = await SharedPreferences.getInstance();
    history = [historyItem, ...history];
    if (history.length > historyMaxLength) {
      history = history.sublist(0, historyMaxLength);
    }
    prefs.setStringList(historyKey, history.map((i) => i.toString()).toList());
    notifyListeners();
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    history = [];
    setHistoryIndex(0);
    prefs.setStringList(historyKey, history.map((i) => i.toString()).toList());
    notifyListeners();
  }

  Future<void> loadFromHistory() async {
    final prefs = await SharedPreferences.getInstance();
    history = prefs
            .getStringList(historyKey)
            ?.map((i) => HistoryItem.fromString(i))
            .toList() ??
        defaultHistory;
  }

  Future<void> loadVersion() async {
    final prefs = await SharedPreferences.getInstance();
    version = prefs.getString(versionKey) ?? defaultVersion;
    notifyListeners();
  }

  Future<void> saveVersion() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(versionKey, version);
  }

  void setVersion(newVersion) async {
    version = newVersion;
    loadDataAsset(bookIndex, chapter, newVersion)
        .then(
          (value) => htmlstring = value,
        )
        .then((_) => saveVersion())
        .then((_) => {notifyListeners()});
  }

  Future<void> loadScale() async {
    final prefs = await SharedPreferences.getInstance();
    scale = prefs.getDouble(scaleKey) ?? defaultScale;
    notifyListeners();
  }

  Future<void> saveScale() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(scaleKey, scale);
  }

  void setScale(newScale) async {
    scale = newScale;
    saveScale();
    notifyListeners();
    print(scale);
  }

  void zoomOut() async {
    final newScale = scale - 0.25;
    if (newScale >= scaleLowerBound) {
      setScale(newScale);
    }
  }

  void zoomIn() async {
    final newScale = scale + 0.25;
    if (newScale <= scaleUpperBound) {
      setScale(newScale);
    }
  }

  HistoryItem? getHistoryItem(index) {
    if (index > history.length - 1) {
      return null;
    }
    return history[index];
  }

  bool isFirstInHistory() {
    return currentHistoryIndex == 0;
  }

  bool isLastInHistory() {
    return currentHistoryIndex == history.length - 1;
  }

  bool canGoToNextHistory() {
    return !isLastInHistory() && history.isNotEmpty;
  }

  bool canGoToPreviousHistory() {
    return !isFirstInHistory() && history.isNotEmpty;
  }

  void goToNextHistory() {
    if (canGoToNextHistory()) {
      final newHistoryIndex = currentHistoryIndex + 1;
      HistoryItem? currentHistoryItem = getHistoryItem(newHistoryIndex);
      if (currentHistoryItem != null) {
        setHistoryIndex(newHistoryIndex);
        setBookIndexChapterNoHistory(
            currentHistoryItem.bookIndex, currentHistoryItem.chapter);
      }
    }
  }

  void goToPreviousHistory() {
    if (canGoToPreviousHistory()) {
      final newHistoryIndex = currentHistoryIndex - 1;
      HistoryItem? currentHistoryItem = getHistoryItem(newHistoryIndex);
      if (currentHistoryItem != null) {
        setHistoryIndex(newHistoryIndex);
        setBookIndexChapterNoHistory(
            currentHistoryItem.bookIndex, currentHistoryItem.chapter);
      }
    }
  }

  void setHistoryIndex(index) async {
    final prefs = await SharedPreferences.getInstance();
    currentHistoryIndex = index;
    await prefs.setInt(historyIndexKey, index);
    notifyListeners();
  }

  void loadHistoryIndex() async {
    final prefs = await SharedPreferences.getInstance();
    currentHistoryIndex = prefs.getInt(historyIndexKey) ?? 0;
    notifyListeners();
  }

  ReaderState() {
    _loadBookIndexChapter();
    loadFromHistory().then((_) => notifyListeners());
    loadVersion();
    loadScale();
    loadHistoryIndex();
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: MyHomePage(title: "hello"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;

    void goToReaderPage() {
      setState(() => selectedIndex = 0);
    }

    switch (selectedIndex) {
      case 0:
        page = ReaderPage();
      case 1:
        page = HistoryPage(goToReaderPage: goToReaderPage);
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: AppBottomAppBar(),
        body: Row(
          children: [
            Expanded(
              child: SafeArea(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class AppBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReaderState>(
      builder: (context, state, child) {
        return BottomAppBar(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
              Row(
                children: [
                  IconButton(
                    tooltip: 'Zoom Out',
                    icon: const Icon(Icons.zoom_out),
                    onPressed: () {
                      state.zoomOut();
                    },
                  ),
                  IconButton(
                    tooltip: 'Zoom In',
                    icon: const Icon(Icons.zoom_in),
                    onPressed: () {
                      state.zoomIn();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                      tooltip: 'Go Back',
                      onPressed: state.canGoToNextHistory()
                          ? () {
                              state.goToNextHistory();
                            }
                          : null,
                      icon: const Icon(Icons.undo)),
                  IconButton(
                    tooltip: 'History',
                    icon: const Icon(Icons.history),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return HistoryPage(
                          goToReaderPage: () {
                            Navigator.pop(context);
                          },
                        );
                      }));
                    },
                  ),
                  IconButton(
                      tooltip: 'Go forward',
                      onPressed: state.canGoToPreviousHistory()
                          ? () {
                              state.goToPreviousHistory();
                            }
                          : null,
                      icon: const Icon(Icons.redo)),
                ],
              ),
            ]));
      },
    );
  }
}
/*
class BottomNavigationBar extends StatelessWidget {
@override
Widget build(BuildContext context){
return NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.book),
              label: 'Reader',
            ),
            NavigationDestination(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        )
}
}
*/
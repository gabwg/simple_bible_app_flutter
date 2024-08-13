import 'package:flutter/material.dart';
import 'package:sba/constants.dart';
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
  List<HistoryItem> history = [];

  void setBookIndexChapter(newBookIndex, newChapter) {
    setBookIndexChapterNoHistory(newBookIndex, newChapter);
    saveToHistory(HistoryItem(bookIndex: newBookIndex, chapter: newChapter));
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
  }

  Future<void> saveScale() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(scaleKey, scale);
  }

  void setScale(newScale) async {
    scale = newScale;
    saveScale();
  }

  ReaderState() {
    _loadBookIndexChapter();
    loadFromHistory().then((_) => notifyListeners());
    loadVersion();
    loadScale();
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        bottomNavigationBar: NavigationBar(
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
        ),
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

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(20.0),
      child: Placeholder(),
    );
  }
}

// for shared prefs
import 'package:flutter/widgets.dart';
import 'package:sba/historypage.dart';

const bookIndexKey = 'bookIndex';
const chapterKey = 'chapter';
const versionKey = 'version';
const historyKey = 'history';
const scaleKey = 'scale';
const historyIndexKey = 'historyIndex';

const defaultBookIndex = 0;
const defaultChapter = 1;
const defaultVersion = "NIV";
const defaultScale = 1.0;
const defaultTextSize = 16.0;
const scaleLowerBound = 1.0;
const scaleUpperBound = 4.0;
const scaleIncrement = 0.25;
const List<HistoryItem> defaultHistory = [];

const historyStringDelimChar = '-';
const historyMaxLength = 20;

const versionList = ["ESV", "NIV"];
const BG_versionList = ["ESV", "NIV"];

const chapterGridmaxCrossAxisExtent = 70.0;

String booknameEn(int bookIndex) {
  return booknamesEn[bookIndex];
}

// default font sizes in em
const defaultReaderHtmlFontSizes = {
  'chapternum_font-size': 2.0,
  'text_font-size': 1.0,
  'sub_font-size': 0.75
};

final booknamesEn = [
  'Genesis',
  'Exodus',
  'Leviticus',
  'Numbers',
  'Deuteronomy',
  'Joshua',
  'Judges',
  'Ruth',
  '1 Samuel',
  '2 Samuel',
  '1 Kings',
  '2 Kings',
  '1 Chronicles',
  '2 Chronicles',
  'Ezra',
  'Nehemiah',
  'Esther',
  'Job',
  'Psalm',
  'Proverbs',
  'Ecclesiastes',
  'Song of Solomon',
  'Isaiah',
  'Jeremiah',
  'Lamentations',
  'Ezekiel',
  'Daniel',
  'Hosea',
  'Joel',
  'Amos',
  'Obadiah',
  'Jonah',
  'Micah',
  'Nahum',
  'Habakkuk',
  'Zephaniah',
  'Haggai',
  'Zechariah',
  'Malachi',
  'Matthew',
  'Mark',
  'Luke',
  'John',
  'Acts',
  'Romans',
  '1 Corinthians',
  '2 Corinthians',
  'Galatians',
  'Ephesians',
  'Philippians',
  'Colossians',
  '1 Thessalonians',
  '2 Thessalonians',
  '1 Timothy',
  '2 Timothy',
  'Titus',
  'Philemon',
  'Hebrews',
  'James',
  '1 Peter',
  '2 Peter',
  '1 John',
  '2 John',
  '3 John',
  'Jude',
  'Revelation'
];
final chapters = [
  50,
  40,
  27,
  36,
  34,
  24,
  21,
  4,
  31,
  24,
  22,
  25,
  29,
  36,
  10,
  13,
  10,
  42,
  150,
  31,
  12,
  8,
  66,
  52,
  5,
  48,
  12,
  14,
  3,
  9,
  1,
  4,
  7,
  3,
  3,
  3,
  2,
  14,
  4,
  28,
  16,
  24,
  21,
  28,
  16,
  16,
  13,
  6,
  6,
  4,
  4,
  5,
  3,
  6,
  4,
  3,
  1,
  13,
  5,
  5,
  3,
  5,
  1,
  1,
  1,
  22
];

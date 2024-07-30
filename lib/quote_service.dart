import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quote.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart' show rootBundle;

class QuoteService with ChangeNotifier {
  List<Quote> _myList = [];
  bool _isDarkMode = false;
  double _volume = 0.5;
  double _speed = 1.0;
  bool _isRepeat = false;
  int _repetitions = 1;
  Quote? _randomQuote;

  List<Quote> get myList => _myList;
  bool get isDarkMode => _isDarkMode;
  double get volume => _volume;
  double get speed => _speed;
  bool get isRepeat => _isRepeat;
  int get repetitions => _repetitions;
  Quote? get randomQuote => _randomQuote;

  QuoteService() {
    _loadPreferences();
    fetchRandomQuote();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _volume = prefs.getDouble('volume') ?? 0.5;
    _speed = prefs.getDouble('speed') ?? 1.0;
    _isRepeat = prefs.getBool('isRepeat') ?? false;
    _repetitions = prefs.getInt('repetitions') ?? 1;
    _myList = (prefs.getStringList('myList') ?? [])
        .map((item) => Quote.fromJson(json.decode(item)))
        .toList();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setDouble('volume', _volume);
    await prefs.setDouble('speed', _speed);
    await prefs.setBool('isRepeat', _isRepeat);
    await prefs.setInt('repetitions', _repetitions);
    await prefs.setStringList(
      'myList',
      _myList.map((quote) => json.encode(quote.toJson())).toList(),
    );
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _savePreferences();
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value;
    _savePreferences();
    notifyListeners();
  }

  void setSpeed(double value) {
    _speed = value;
    _savePreferences();
    notifyListeners();
  }

  void toggleRepeat(bool value) {
    _isRepeat = value;
    _savePreferences();
    notifyListeners();
  }

  void setRepetitions(int value) {
    _repetitions = value;
    _savePreferences();
    notifyListeners();
  }

  void addToMyList(Quote quote) {
    _myList.add(quote);
    _savePreferences();
    notifyListeners();
  }

  void clearMyList() {
    _myList.clear();
    _savePreferences();
    notifyListeners();
  }

  Future<void> fetchRandomQuote() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/examples.json');
      final List<dynamic> jsonData = json.decode(jsonStr);
      final quotes = jsonData.map((data) => Quote.fromJson(data)).toList();
      _randomQuote = (quotes..shuffle()).first;
      notifyListeners();
    } catch (error) {
      print('Error fetching quotes: $error');
    }
  }

  // Add these variables to the class
  FlutterTts flutterTts = FlutterTts();

  // Add this method to the class
  Future<void> speak(String text) async {
    await flutterTts.setLanguage('de-DE');
    await flutterTts.setSpeechRate(speed);
    await flutterTts.setVolume(volume);
    await flutterTts.speak(text);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran_app/screens/%20home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verrouiller en mode portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialise la lecture audio en arrière-plan (contrôles sur l'écran
  // de verrouillage et dans la barre de notification pendant la
  // récitation du Coran). Protégé par un timeout : si l'initialisation
  // échoue ou ne répond pas (ex: <service>/<receiver> manquants dans
  // le manifest Android), l'app démarre quand même plutôt que de
  // rester bloquée indéfiniment derrière le splash.
  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.quran_app.audio',
      androidNotificationChannelName: 'Lecture du Coran',
      androidNotificationOngoing: true,
    ).timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('JustAudioBackground.init a échoué (app démarrée sans lui): $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
        ChangeNotifierProvider(create: (context) => ReadingStatsProvider()),
      ],
      child: const QuranApp(),
    ),
  );
}

class QuranApp extends StatelessWidget {
  const QuranApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Le Noble Coran',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.currentTheme,
          home: const HomePage(),
        );
      },
    );
  }
}

// Provider pour le thème
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = const Color(0xFF00695C);
  Color _textColor = Colors.amber[800]!;
  double _textSize = 18.0;
  bool _isBold = true;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;
  Color get textColor => _textColor;
  double get textSize => _textSize;
  bool get isBold => _isBold;

  ThemeData get currentTheme {
    return _themeMode == ThemeMode.dark
        ? ThemeData.dark().copyWith(
            primaryColor: _primaryColor,
            scaffoldBackgroundColor: Colors.grey[900],
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: _primaryColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: _textSize,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                color: _textColor,
              ),
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: _primaryColor,
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            appBarTheme: AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: _primaryColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                fontSize: _textSize,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                color: _textColor,
              ),
            ),
          );
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = color;
    notifyListeners();
  }

  void setTextSize(double size) {
    _textSize = size;
    notifyListeners();
  }

  void setBold(bool bold) {
    _isBold = bold;
    notifyListeners();
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
    _primaryColor = Color(prefs.getInt('primaryColor') ?? 0xFF00695C);
    _textColor = Color(prefs.getInt('textColor') ?? Colors.amber[800]!.value);
    _textSize = prefs.getDouble('textSize') ?? 18.0;
    _isBold = prefs.getBool('isBold') ?? true;
    notifyListeners();
  }

  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
    await prefs.setInt('primaryColor', _primaryColor.value);
    await prefs.setInt('textColor', _textColor.value);
    await prefs.setDouble('textSize', _textSize);
    await prefs.setBool('isBold', _isBold);
  }
}

// Provider pour les marque-pages
class BookmarkProvider with ChangeNotifier {
  final List<int> _bookmarks = [];

  List<int> get bookmarks => _bookmarks;

  void addBookmark(int sourateNumber, int verseNumber) {
    final bookmark = sourateNumber * 1000 + verseNumber;
    if (!_bookmarks.contains(bookmark)) {
      _bookmarks.add(bookmark);
      notifyListeners();
      _saveBookmarks();
    }
  }

  void removeBookmark(int sourateNumber, int verseNumber) {
    final bookmark = sourateNumber * 1000 + verseNumber;
    _bookmarks.remove(bookmark);
    notifyListeners();
    _saveBookmarks();
  }

  bool isBookmarked(int sourateNumber, int verseNumber) {
    final bookmark = sourateNumber * 1000 + verseNumber;
    return _bookmarks.contains(bookmark);
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarks.map((b) => b.toString()).toList());
  }

  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('bookmarks') ?? [];
    _bookmarks.clear();
    _bookmarks.addAll(bookmarks.map((b) => int.parse(b)));
    notifyListeners();
  }
}

// Provider pour les statistiques
class ReadingStatsProvider with ChangeNotifier {
  int _totalVersesRead = 0;
  int _lastSourateRead = 0;
  int _lastVerseRead = 0;
  DateTime? _lastReadingDate;

  int get totalVersesRead => _totalVersesRead;
  int get lastSourateRead => _lastSourateRead;
  int get lastVerseRead => _lastVerseRead;
  DateTime? get lastReadingDate => _lastReadingDate;

  void markVerseRead(int sourateNumber, int verseNumber) {
    _totalVersesRead++;
    _lastSourateRead = sourateNumber;
    _lastVerseRead = verseNumber;
    _lastReadingDate = DateTime.now();
    notifyListeners();
    _saveStats();
  }

  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalVersesRead', _totalVersesRead);
    await prefs.setInt('lastSourateRead', _lastSourateRead);
    await prefs.setInt('lastVerseRead', _lastVerseRead);
    await prefs.setString('lastReadingDate', _lastReadingDate?.toIso8601String() ?? '');
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    _totalVersesRead = prefs.getInt('totalVersesRead') ?? 0;
    _lastSourateRead = prefs.getInt('lastSourateRead') ?? 0;
    _lastVerseRead = prefs.getInt('lastVerseRead') ?? 0;
    final dateString = prefs.getString('lastReadingDate');
    _lastReadingDate = dateString != null ? DateTime.parse(dateString) : null;
    notifyListeners();
  }
}
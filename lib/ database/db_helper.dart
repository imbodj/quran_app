import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sourate.dart';

class DBHelper {
  static Database? _db;
  
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  Future<Database?> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quran.db");
    
    bool dbExists = await io.File(path).exists();

    if (!dbExists) {
      ByteData data = await rootBundle.load(join("assets", "quran.db"));
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      
      await io.File(path).writeAsBytes(bytes, flush: true);
      print('✅ Base de données copiée vers: $path');
    } else {
      print('📊 Base de données existe déjà: $path');
    }

    var theDb = await openDatabase(path, version: 1);
    return theDb;
  }

  // Récupérer toutes les sourates avec filtrage
  Future<List<Sourate>> getSourates({
    String? searchQuery,
    String? revelationPlace,
  }) async {
    var dbClient = await db;
    
    String query = 'SELECT * FROM tablesourates';
    List<String> whereClauses = [];
    List<dynamic> params = [];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      whereClauses.add('Field2 LIKE ?');
      params.add('%$searchQuery%');
    }

    if (revelationPlace != null && revelationPlace.isNotEmpty) {
      // Cette partie nécessite que la base de données ait une colonne pour le lieu de révélation
      // Pour l'instant, nous utilisons la logique du modèle
    }

    if (whereClauses.isNotEmpty) {
      query += ' WHERE ${whereClauses.join(' AND ')}';
    }

    query += ' ORDER BY Field1 ASC';

    List<Map<String, dynamic>> list = await dbClient!.rawQuery(query, params);
    
    List<Sourate> sourates = [];
    for (var map in list) {
      sourates.add(Sourate.fromMap(map));
    }
    
    // Filtrage par lieu de révélation
    if (revelationPlace != null && revelationPlace.isNotEmpty) {
      sourates = sourates.where((sourate) {
        return sourate.revelationLieu == revelationPlace;
      }).toList();
    }
    
    print('📖 Nombre de sourates chargées: ${sourates.length}');
    return sourates;
  }

  // Récupérer une sourate spécifique
  Future<Sourate?> getSourate(int numero) async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient!.rawQuery(
      'SELECT * FROM tablesourates WHERE Field1 = ?',
      [numero],
    );
    
    if (list.isNotEmpty) {
      return Sourate.fromMap(list[0]);
    }
    return null;
  }

  // Récupérer les versets d'une sourate
  Future<List<String>> getVerses(int sourateNumber) async {
    var dbClient = await db;
    List<Map<String, dynamic>> list = await dbClient!.rawQuery(
      'SELECT Field2 FROM tablesourates WHERE Field1 = ?',
      [sourateNumber],
    );
    
    if (list.isNotEmpty) {
      String texte = list[0]['Field2'] as String;
      return texte.split('\n').where((v) => v.trim().isNotEmpty).toList();
    }
    
    return [];
  }

  // Statistiques de la base de données
  Future<Map<String, dynamic>> getStats() async {
    var dbClient = await db;
    
    final sourateCount = await dbClient!.rawQuery(
      'SELECT COUNT(*) as count FROM tablesourates',
    );
    
    final totalVersesResult = await dbClient.rawQuery(
      'SELECT Field2 FROM tablesourates',
    );
    
    int totalVerses = 0;
    for (var row in totalVersesResult) {
      String texte = row['Field2'] as String;
      totalVerses += texte.split('\n').where((v) => v.trim().isNotEmpty).length;
    }
    
    return {
      'sourateCount': sourateCount.first['count'],
      'totalVerses': totalVerses,
    };
  }

  // Recherche avancée
  Future<List<Map<String, dynamic>>> advancedSearch(String query) async {
    var dbClient = await db;
    
    // Recherche dans le texte des sourates
    List<Map<String, dynamic>> results = await dbClient!.rawQuery(
      'SELECT Field1 as sourate, Field2 as texte FROM tablesourates WHERE Field2 LIKE ?',
      ['%$query%'],
    );
    
    // Transformer les résultats pour inclure les informations de sourate
    List<Map<String, dynamic>> formattedResults = [];
    for (var result in results) {
      final sourate = Sourate.fromMap(result);
      
      // Trouver les versets contenant la recherche
      final verses = sourate.verses
          .asMap()
          .entries
          .where((entry) => entry.value.toLowerCase().contains(query.toLowerCase()))
          .map((entry) => {
            'verseNumber': entry.key + 1,
            'verseText': entry.value,
          })
          .toList();
      
      if (verses.isNotEmpty) {
        formattedResults.add({
          'sourate': sourate,
          'verses': verses,
        });
      }
    }
    
    return formattedResults;
  }

  // Fermer la base de données
  Future<void> close() async {
    var dbClient = await db;
    await dbClient?.close();
    _db = null;
  }

  // Réinitialiser la base de données
  Future<void> resetDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "quran.db");
    
    if (await io.File(path).exists()) {
      await io.File(path).delete();
      print('🗑️ Ancienne base supprimée');
    }
    
    await close();
    
    _db = await initDb();
    print('🔄 Base de données réinitialisée');
  }
}
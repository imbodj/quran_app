import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioCacheService {
  AudioCacheService._();

  static Directory? _cacheDir;

  static Future<Directory> _getCacheDir() async {
    if (_cacheDir != null) return _cacheDir!;
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/quran_audio');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDir = dir;
    return dir;
  }

  static Future<File> _fileFor(int numero) async {
    final dir = await _getCacheDir();
    final padded = numero.toString().padLeft(3, '0');
    return File('${dir.path}/$padded.mp3');
  }

  static File? fileForSync(int numero) {
    if (_cacheDir == null) return null;
    final padded = numero.toString().padLeft(3, '0');
    return File('${_cacheDir!.path}/$padded.mp3');
  }

  static Future<void> preloadCacheDir() => _getCacheDir();

  static Future<bool> isDownloaded(int numero) async {
    final file = await _fileFor(numero);
    return file.exists();
  }

static bool isDownloadedSync(int numero) {
    final file = fileForSync(numero);
    // On vérifie ABSOLUMENT que le fichier existe ET que sa taille est supérieure à 0
    return file != null && file.existsSync() && file.lengthSync() > 1000;
  }

  static Future<void> download(
    int numero,
    String url, {
    void Function(double progress)? onProgress,
  }) async {
    final file = await _fileFor(numero);
    final tempFile = File('${file.path}.part');
    final client = http.Client();

    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Téléchargement échoué (${response.statusCode})');
      }

      final total = response.contentLength ?? 0;
      var received = 0;
      final sink = tempFile.openWrite();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (total > 0) {
          onProgress?.call(received / total);
        } else {
          onProgress?.call(-1);
        }
      }
      await sink.flush();
      await sink.close();

      if (await file.exists()) await file.delete();
      await tempFile.rename(file.path);
    } finally {
      client.close(); // Ferme proprement le socket HTTP pour libérer Android
    }
  }

  static Future<void> deleteAll() async {
    final dir = await _getCacheDir();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      _cacheDir = null;
    }
  }

  static Future<int> downloadedCount() async {
    final dir = await _getCacheDir();
    if (!await dir.exists()) return 0;
    final files = await dir.list().toList();
    return files.where((f) => f.path.endsWith('.mp3')).length;
  }
  
}
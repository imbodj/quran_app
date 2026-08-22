import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'audio_cache_service.dart';

class ReciterAudio {
  ReciterAudio._();

  static const String reciterName = 'Cheikh Mahmoud Khalil Al-Husary';
  static final AudioPlayer player = AudioPlayer();
  static int currentIndex = 0;

  static String fallbackUrlFor(int numero) {
    final padded = numero.toString().padLeft(3, '0');
    return 'https://download.quranicaudio.com/quran/mahmood_khaleel_al-husaree/$padded.mp3';
  }

  static Future<void> playIndex(int index, {bool autoStart = true}) async {
    currentIndex = index;
    final numero = index + 1;

    try {
      await player.stop();

      // Si c'est l'invocation (piste 115), lecture depuis les assets locaux
      if (numero == 115) {
        final Source source = AssetSource('audio/dua_husary.mp3');
        if (autoStart) {
          await player.play(source);
        } else {
          await player.setSource(source);
        }
        return;
      }

      // Pour les 114 sourates : vérification local/réseau habituelle
      final localFile = AudioCacheService.fileForSync(numero);
      final isLocalValid = localFile != null &&
          localFile.existsSync() &&
          localFile.lengthSync() > 10000;

      final Source source = isLocalValid
          ? DeviceFileSource(localFile.path)
          : UrlSource(fallbackUrlFor(numero));

      if (autoStart) {
        await player.play(source);
      } else {
        await player.setSource(source);
      }
    } catch (e) {
      print("Erreur ReciterAudio playIndex: $e");
    }
  }
}
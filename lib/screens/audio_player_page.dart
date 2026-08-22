import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../main.dart' show ThemeProvider;
import '../models/sourate.dart';
import '../services/reciter_audio.dart';
import '../services/audio_cache_service.dart';

enum RepeatMode { off, repeatOne, repeatAll }

class AudioPlayerPage extends StatefulWidget {
  final int initialIndex;
  final bool autoPlay;

  const AudioPlayerPage({
    super.key,
    this.initialIndex = 0,
    this.autoPlay = false,
  });

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  late final AnimationController _discController;

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Gestion du mode de répétition
  RepeatMode _repeatMode = RepeatMode.repeatAll;

  final Map<int, double> _downloadProgress = {};
  final Set<int> _downloadedNumeros = {};
  bool _isDownloadingAll = false;
  bool _cancelDownloadAll = false;

  static const List<double> _speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
  int _speedIndex = 1;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _discController = AnimationController(
      duration: const Duration(seconds: 18),
      vsync: this,
    );

    _audioPlayer = ReciterAudio.player;
    _initAudioListeners();
    _init();
  }

  void _initAudioListeners() {
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _isPlaying = state == PlayerState.playing;
        if (state == PlayerState.playing || 
            state == PlayerState.paused || 
            state == PlayerState.stopped) {
          _isLoading = false;
        }
      });
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((newDuration) {
      if (!mounted) return;
      setState(() => _duration = newDuration);
    });

    _positionSubscription = _audioPlayer.onPositionChanged.listen((newPosition) {
      if (!mounted) return;
      setState(() => _position = newPosition);
    });

    // Enchaînement automatique à la fin du son
    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;
      _handleAudioCompletion();
    });
  }

  void _handleAudioCompletion() {
    if (_repeatMode == RepeatMode.repeatOne) {
      _playIndex(_currentIndex, autoStart: true);
    } else if (_repeatMode == RepeatMode.repeatAll) {
      final nextIndex = (_currentIndex + 1) % 115;
      _playIndex(nextIndex, autoStart: true);
    } else {
      if (_currentIndex < 114) {
        _playIndex(_currentIndex + 1, autoStart: true);
      }
    }
  }

  Future<void> _init() async {
    await AudioCacheService.preloadCacheDir();
    for (var i = 1; i <= 114; i++) {
      if (AudioCacheService.isDownloadedSync(i)) _downloadedNumeros.add(i);
    }

    if (!mounted) return;

    if (_audioPlayer.state == PlayerState.playing || _audioPlayer.state == PlayerState.paused) {
      _currentIndex = ReciterAudio.currentIndex;
      _isPlaying = _audioPlayer.state == PlayerState.playing;
    } else {
      _playIndex(_currentIndex, autoStart: widget.autoPlay);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _discController.dispose();
    super.dispose();
  }

  void _cycleSpeed() {
    _speedIndex = (_speedIndex + 1) % _speeds.length;
    _audioPlayer.setPlaybackRate(_speeds[_speedIndex]);
    setState(() {});
  }

  void _toggleRepeatMode() {
    setState(() {
      if (_repeatMode == RepeatMode.off) {
        _repeatMode = RepeatMode.repeatAll;
      } else if (_repeatMode == RepeatMode.repeatAll) {
        _repeatMode = RepeatMode.repeatOne;
      } else {
        _repeatMode = RepeatMode.off;
      }
    });
  }

  Future<void> _playIndex(int index, {bool autoStart = true}) async {
    setState(() {
      _currentIndex = index;
      _isLoading = true;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await ReciterAudio.playIndex(index, autoStart: autoStart);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadSingle(int numero) async {
    if (numero == 115) return;
    if (_downloadedNumeros.contains(numero) || _downloadProgress.containsKey(numero)) return;

    setState(() => _downloadProgress[numero] = 0);
    try {
      await AudioCacheService.download(
        numero,
        ReciterAudio.fallbackUrlFor(numero),
        onProgress: (p) {
          if (!mounted) return;
          setState(() => _downloadProgress[numero] = p);
        },
      );
      if (!mounted) return;
      setState(() {
        _downloadProgress.remove(numero);
        _downloadedNumeros.add(numero);
      });
      if (_currentIndex == numero - 1) {
        _playIndex(_currentIndex, autoStart: _isPlaying);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _downloadProgress.remove(numero));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec du téléchargement de la sourate $numero')),
      );
    }
  }

  Future<void> _downloadAll() async {
    setState(() {
      _isDownloadingAll = true;
      _cancelDownloadAll = false;
    });

    for (var numero = 1; numero <= 114; numero++) {
      if (_cancelDownloadAll) break;
      if (_downloadedNumeros.contains(numero)) continue;
      await _downloadSingle(numero);
    }

    if (!mounted) return;
    setState(() => _isDownloadingAll = false);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final Color primaryColor = themeProvider.primaryColor;
    final Color primaryDark = Color.lerp(primaryColor, Colors.black, 0.28) ?? const Color(0xFF004D40);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF212121),
                    Color(0xFF1E2623),
                    Color(0xFF121212),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor.withOpacity(0.08),
                    const Color(0xFFF3EFE0),
                    const Color(0xFFE5DEC9),
                    primaryColor.withOpacity(0.12),
                  ],
                  stops: const [0.0, 0.35, 0.7, 1.0],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, primaryColor, primaryDark),
              Expanded(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNowPlaying(primaryColor, primaryDark, isDark),
                          _buildProgressBar(primaryColor, isDark),
                          _buildControls(primaryColor, isDark),
                          if (_isDownloadingAll) _buildDownloadAllProgress(primaryColor, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    Expanded(child: _buildSourateList(primaryColor, isDark)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color primaryColor, Color primaryDark) {
    final remaining = 114 - _downloadedNumeros.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, primaryDark]),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Column(
              children: [
                Text('Récitation du Coran', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text(ReciterAudio.reciterName, style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          if (_isDownloadingAll)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => setState(() => _cancelDownloadAll = true),
            )
          else
            IconButton(
              icon: Icon(remaining == 0 ? Icons.offline_pin : Icons.download_for_offline_outlined, color: Colors.white),
              onPressed: remaining == 0 ? null : _downloadAll,
            ),
        ],
      ),
    );
  }

  Widget _buildNowPlaying(Color primaryColor, Color primaryDark, bool isDark) {
    final numero = _currentIndex + 1;
    final isDua = numero == 115;
    final infos = isDua 
        ? Sourate(numero: 115, texte: '') 
        : Sourate(numero: numero, texte: '');

    final String nomFrancais = isDua ? 'Invocation de Clôture (Dua)' : infos.nomFrancais;
    final String nomArabe = isDua ? 'دعاء ختم القرآن' : infos.nomArabe;

    if (_isPlaying) {
      if (!_discController.isAnimating) _discController.repeat();
    } else {
      _discController.stop();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RotationTransition(
            turns: _discController,
            child: Container(
              width: 135,
              height: 135,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDua 
                      ? [const Color(0xFFFFB300), const Color(0xFFFF6F00)]
                      : [primaryColor.withOpacity(0.95), primaryDark],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDua ? Colors.amber.withOpacity(0.4) : primaryColor.withOpacity(0.30),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.9), width: 4),
              ),
              child: Center(
                child: Icon(
                  isDua ? Icons.star_rounded : Icons.auto_stories,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nomArabe,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDua 
                  ? (isDark ? Colors.amber[300] : Colors.amber[900])
                  : (isDark ? Colors.white : const Color(0xFF2C3E35)),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isDua ? nomFrancais : '$nomFrancais • Sourate $numero',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : const Color(0xFF5A6B62),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Color primaryColor, bool isDark) {
    final maxMs = _duration.inMilliseconds.toDouble();
    final valueMs = _position.inMilliseconds.clamp(0, maxMs.toInt()).toDouble();
    final isDua = _currentIndex == 114;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: isDua ? Colors.amber[700] : primaryColor,
              thumbColor: isDua ? Colors.amber[700] : primaryColor,
              inactiveTrackColor: (isDua ? Colors.amber[700]! : primaryColor).withOpacity(0.2),
            ),
            child: Slider(
              min: 0,
              max: maxMs > 0 ? maxMs : 1,
              value: maxMs > 0 ? valueMs : 0,
              onChanged: maxMs > 0 ? (v) => _audioPlayer.seek(Duration(milliseconds: v.round())) : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_position), style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
                Text(_formatDuration(_duration), style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(Color primaryColor, bool isDark) {
    final isDua = _currentIndex == 114;
    final Color buttonColor = isDua ? Colors.amber[800]! : primaryColor;

    IconData repeatIcon = Icons.repeat;
    Color repeatColor = isDark ? Colors.white54 : Colors.black45;

    if (_repeatMode == RepeatMode.repeatAll) {
      repeatIcon = Icons.repeat;
      repeatColor = buttonColor;
    } else if (_repeatMode == RepeatMode.repeatOne) {
      repeatIcon = Icons.repeat_one;
      repeatColor = buttonColor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: _cycleSpeed,
            child: Text('${_speeds[_speedIndex]}x', style: TextStyle(fontWeight: FontWeight.bold, color: buttonColor, fontSize: 15)),
          ),
          IconButton(
            iconSize: 34,
            icon: Icon(Icons.skip_previous, color: isDark ? Colors.white : const Color(0xFF2C3E35)),
            onPressed: _currentIndex > 0 ? () => _playIndex(_currentIndex - 1) : null,
          ),
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: buttonColor),
            child: IconButton(
              iconSize: 38,
              padding: const EdgeInsets.all(12),
              icon: _isLoading
                  ? const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                  : Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
              onPressed: () {
                if (_isPlaying) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.resume();
                }
              },
            ),
          ),
          IconButton(
            iconSize: 34,
            icon: Icon(Icons.skip_next, color: isDark ? Colors.white : const Color(0xFF2C3E35)),
            onPressed: _currentIndex < 114 ? () => _playIndex(_currentIndex + 1) : null,
          ),
          IconButton(
            iconSize: 26,
            icon: Icon(repeatIcon, color: repeatColor),
            onPressed: _toggleRepeatMode,
            tooltip: _repeatMode == RepeatMode.repeatAll
                ? 'Répéter tout (Enchaînement)'
                : (_repeatMode == RepeatMode.repeatOne ? 'Répéter cette piste' : 'Répétition désactivée'),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadAllProgress(Color primaryColor, bool isDark) {
    final done = _downloadedNumeros.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: done / 114,
              minHeight: 5,
              backgroundColor: primaryColor.withOpacity(0.15),
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text('Téléchargement hors-ligne : $done / 114 sourates', style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildSourateList(Color primaryColor, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      physics: const BouncingScrollPhysics(),
      itemCount: 115,
      itemBuilder: (context, index) {
        final numero = index + 1;
        final isDua = numero == 115;
        final infos = isDua 
            ? Sourate(numero: 115, texte: '') 
            : Sourate(numero: numero, texte: '');

        final String nomFrancais = isDua ? 'Invocation de Clôture (Dua)' : infos.nomFrancais;
        final String nomArabe = isDua ? 'دعاء ختم القرآن' : infos.nomArabe;

        final isCurrent = index == _currentIndex;
        final isDownloaded = _downloadedNumeros.contains(numero);
        final progress = _downloadProgress[numero];

        return ListTile(
          dense: true,
          onTap: () => _playIndex(index),
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: isDua 
                ? Colors.amber[700] 
                : (isCurrent ? primaryColor : primaryColor.withOpacity(0.12)),
            child: isCurrent
                ? const Icon(Icons.equalizer, color: Colors.white, size: 16)
                : (isDua 
                    ? const Icon(Icons.star, color: Colors.white, size: 16)
                    : Text('$numero', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w600))),
          ),
          title: Text(
            nomFrancais,
            style: TextStyle(
              fontWeight: (isCurrent || isDua) ? FontWeight.bold : FontWeight.normal,
              color: isDua 
                  ? (isDark ? Colors.amber[300] : Colors.amber[900])
                  : (isCurrent ? primaryColor : (isDark ? Colors.white : const Color(0xFF2C3E35))),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nomArabe,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 15,
                  color: isDua 
                      ? (isDark ? Colors.amber[300] : Colors.amber[900]) 
                      : (isDark ? Colors.white70 : Colors.black54),
                ),
              ),
              const SizedBox(width: 10),
              if (isDua)
                const Icon(Icons.offline_pin, color: Colors.amber, size: 18)
              else if (isDownloaded)
                Icon(Icons.offline_pin, color: primaryColor, size: 18)
              else if (progress != null)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, value: progress >= 0 ? progress : null, color: primaryColor),
                )
              else
                IconButton(
                  icon: const Icon(Icons.download_outlined, size: 18),
                  color: isDark ? Colors.white54 : Colors.black45,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _downloadSingle(numero),
                ),
            ],
          ),
        );
      },
    );
  }
}
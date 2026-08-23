import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart' show ThemeProvider;

/// Écran des horaires de prière.
///
/// Fusionné depuis l'application "Waxtu Julli" : mêmes calculs (adhan),
/// même design (cartes/"bulles" par prière avec effet lumineux sur la
/// prière en cours, À propos avec la méthode de calcul, bascule
/// clair/sombre, partage), mais restylé pour reprendre l'identité
/// visuelle de l'application Coran (couleurs 0xFF00695C / 0xFF004D40).
/// La sélection manuelle de localité a été retirée : seule la position
/// GPS de l'utilisateur est utilisée.
class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage>
    with SingleTickerProviderStateMixin {
  static const Map<String, IconData> _prayerIcons = {
    'Fadjr': Icons.bedtime,
    'Sobh': Icons.light_mode,
    'Tisbar': Icons.sunny,
    'Takussan': Icons.cloud,
    'Timis': Icons.dark_mode,
    'Guéwé': Icons.nightlight,
  };

  late final AnimationController _pulseController;
  Map<String, String>? _prayerTimes;
  bool _isLoading = true;
  bool _localeReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _init();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    // Il faut charger les données de locale française AVANT le tout
    // premier affichage de l'écran : sinon DateFormat('fr_FR') dans
    // l'en-tête plante avec "LocaleDataException" car Flutter essaie
    // de dessiner la date avant que les données FR soient prêtes.
    await initializeDateFormatting('fr_FR', '');
    if (!mounted) return;
    setState(() => _localeReady = true);
    await _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Activez la localisation de votre téléphone pour afficher '
              'les horaires de prière de votre position.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'La permission de localisation a été refusée.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'La permission de localisation est bloquée dans les réglages '
              'du téléphone. Autorisez-la pour afficher les horaires.';
        });
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 15),
          ),
        );
      } on TimeoutException {
        // Le GPS met parfois du temps à obtenir un premier point précis
        // (à l'intérieur, signal faible...). On retombe sur la dernière
        // position connue du téléphone plutôt que d'échouer directement.
        position = await Geolocator.getLastKnownPosition();
        if (position == null) rethrow;
      }

      final coordinates = Coordinates(position.latitude, position.longitude);
      final date = DateComponents.from(DateTime.now());
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.fajrAngle = 15.0;
      params.maghribAngle = 2.90;
      params.ishaAngle = 17.0;
      params.madhab = Madhab.shafi;

      final prayerTimes = PrayerTimes(coordinates, date, params);
      final fajrTime = prayerTimes.fajr;
      final amsak = fajrTime.subtract(const Duration(minutes: 15));
      final formatter = DateFormat.jm('fr_FR');

      final Map<String, DateTime> rawTimes = {
        'Fadjr': amsak,
        'Sobh': prayerTimes.fajr,
        'Dhuhr': prayerTimes.dhuhr,
        'Asr': prayerTimes.asr,
        'Maghrib': prayerTimes.maghrib,
        'Isha': prayerTimes.isha,
      };

      final Map<String, String> formattedTimes = {};
      for (final entry in rawTimes.entries) {
        formattedTimes[entry.key] = formatter.format(entry.value);
      }

      if (!mounted) return;
      setState(() {
        _prayerTimes = formattedTimes;
        _isLoading = false;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'La localisation prend trop de temps à répondre. '
            'Vérifiez que le GPS est activé (pas seulement la localisation '
            'réseau), idéalement à l\'extérieur ou près d\'une fenêtre, '
            'puis réessayez.';
      });
    } on LocationServiceDisabledException {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Le service de localisation est désactivé sur le téléphone.';
      });
    } catch (e) {
      if (!mounted) return;
      debugPrint('Erreur horaires de prière: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Impossible d\'obtenir votre position pour le moment. (${e.runtimeType})';
      });
    }
  }

  bool _isCurrentPrayerTime(String prayerName) {
    final currentHour = DateTime.now().hour;
    switch (prayerName) {
      case 'Fadjr':
        return currentHour >= 4 && currentHour < 6;
      case 'Subbah':
        return currentHour >= 6 && currentHour < 12;
      case 'Dhuhr':
        return currentHour >= 12 && currentHour < 16;
      case 'Asr':
        return currentHour >= 16 && currentHour < 18;
      case 'Maghrib':
        return currentHour >= 18 && currentHour < 20;
      case 'Isha':
        return currentHour >= 20 || currentHour < 4;
      default:
        return false;
    }
  }

  void _shareTimes() {
    if (_prayerTimes == null || _prayerTimes!.isEmpty) return;
    final buffer = StringBuffer('🕌 Horaires de prière du jour\n\n');
    for (final entry in _prayerTimes!.entries) {
      buffer.writeln('${entry.key} : ${entry.value}');
    }
    buffer.write('\n📖 Le Noble Coran — application complète');
    SharePlus.instance.share(ShareParams(text: buffer.toString()));
  }

  void _openInfoDialog(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        final Color textColor = isDark ? Colors.white : Colors.black87;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: isDark ? Colors.grey[850] : Colors.white,
          title: Row(
            children: [
              Icon(Icons.mosque, color: primaryColor),
              const SizedBox(width: 8),
              Text('À propos', style: TextStyle(color: textColor)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Horaires de prière',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor),
                ),
                const SizedBox(height: 12),
                Text(
                  'Méthode de calcul : Ligue Islamique Mondiale\n'
                  'Madhab : Shafi, Maliki et Hanbali\n\n'
                  'Ces horaires sont calculés localement à partir de votre '
                  'position GPS, selon les standards islamiques reconnus.',
                  style: TextStyle(color: textColor),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final Color primaryColor = themeProvider.primaryColor;
    final Color primaryDark = Color.lerp(primaryColor, Colors.black, 0.28)!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context, primaryColor, primaryDark, themeProvider),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverToBoxAdapter(
              child: _isLoading
                  ? _buildLoading(primaryColor)
                  : _errorMessage != null
                      ? _buildError(primaryColor)
                      : _buildPrayerTimesList(context, primaryColor, primaryDark, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    Color primaryColor,
    Color primaryDark,
    ThemeProvider themeProvider,
  ) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor, primaryDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned(
              top: 10,
              right: -30,
              child: Opacity(
                opacity: 0.1,
                child: Icon(Icons.mosque, size: 150, color: Colors.white),
              ),
            ),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Changer le thème',
                    icon: Icon(
                      themeProvider.themeMode == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Colors.white,
                    ),
                    onPressed: themeProvider.toggleTheme,
                  ),
                  IconButton(
                    tooltip: 'Partager les horaires',
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: _prayerTimes == null ? null : _shareTimes,
                  ),
                  IconButton(
                    tooltip: 'À propos',
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () => _openInfoDialog(context, primaryColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.mosque, size: 46, color: Colors.white70),
                  const SizedBox(height: 10),
                  const Text(
                    'Horaires de prière',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (_localeReady) ...[
                    Text(
                      DateFormat.yMMMMd('fr_FR').format(DateTime.now()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    Text(
                      HijriCalendar.now().toFormat('dd MMMM yyyy'),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(color: primaryColor),
            const SizedBox(height: 16),
            const Text(
              'Calcul des horaires de prière...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(Color primaryColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_outlined, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Une erreur est survenue',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _loadPrayerTimes,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Les "bulles" : une carte distincte par prière, avec halo lumineux
  // animé pour la prière en cours — comme dans le design original.
  Widget _buildPrayerTimesList(
    BuildContext context,
    Color primaryColor,
    Color primaryDark,
    bool isDark,
  ) {
    if (_prayerTimes == null || _prayerTimes!.isEmpty) {
      return const Center(child: Text('Aucune heure de prière disponible'));
    }

    final entries = _prayerTimes!.entries.toList();

    return Column(
      children: List.generate(entries.length, (index) {
        final entry = entries[index];
        final isCurrent = _isCurrentPrayerTime(entry.key);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 150)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(30 * (1 - value), 0),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: _PrayerBubble(
            name: entry.key,
            time: entry.value,
            icon: _prayerIcons[entry.key] ?? Icons.access_time,
            isCurrentPrayer: isCurrent,
            primaryColor: primaryColor,
            primaryDark: primaryDark,
            isDark: isDark,
            pulseController: _pulseController,
          ),
        );
      }),
    );
  }
}

/// Une "bulle" (carte) représentant une prière, avec halo lumineux
/// animé quand c'est la prière en cours.
class _PrayerBubble extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isCurrentPrayer;
  final Color primaryColor;
  final Color primaryDark;
  final bool isDark;
  final AnimationController pulseController;

  const _PrayerBubble({
    required this.name,
    required this.time,
    required this.icon,
    required this.isCurrentPrayer,
    required this.primaryColor,
    required this.primaryDark,
    required this.isDark,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: isCurrentPrayer
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3 + (pulseController.value * 0.3)),
                      blurRadius: 10 + (pulseController.value * 10),
                      spreadRadius: 1 + (pulseController.value * 2),
                    ),
                  ],
                )
              : null,
          child: child,
        );
      },
      child: Card(
        elevation: isCurrentPrayer ? 8 : 3,
        clipBehavior: Clip.antiAlias,
        color: isDark ? Colors.grey[850] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: isCurrentPrayer
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [primaryColor, primaryDark],
                  ),
                )
              : null,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCurrentPrayer ? Colors.white.withOpacity(0.2) : primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isCurrentPrayer ? Colors.white : primaryColor,
                size: 24,
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isCurrentPrayer ? FontWeight.bold : FontWeight.w500,
                color: isCurrentPrayer
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            trailing: Text(
              time,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isCurrentPrayer
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

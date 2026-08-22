// ignore: file_names
import 'package:flutter/material.dart';
import 'package:quran_app/%20database/db_helper.dart';
import 'package:quran_app/screens/%20sourate_detail_page.dart';
import 'package:quran_app/screens/about_page.dart';
import 'package:quran_app/screens/prayer_times_page.dart';
import 'package:quran_app/screens/audio_player_page.dart';
import 'package:quran_app/screens/pillars_page.dart';
import '../models/sourate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper _dbHelper = DBHelper();
  List<Sourate> _sourates = [];
  List<Sourate> _filteredSourates = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Délai pour éviter le contexte nul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSourates();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSourates() async {
    if (!mounted) return; // Vérifier si le widget est toujours monté

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final sourates = await _dbHelper.getSourates();
      if (!mounted) return;

      setState(() {
        _sourates = sourates;
        _filteredSourates = sourates;
        _isLoading = false;
      });

      if (sourates.isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = 'Aucune sourate trouvée dans la base de données';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Erreur de chargement: $e';
      });
      print('Erreur: $e');
    }
  }

  void _filterSourates(String query) {
    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredSourates = _sourates;
      } else {
        _filteredSourates = _sourates.where((sourate) {
          return sourate.nomArabe.toLowerCase().contains(query.toLowerCase()) ||
              sourate.nomFrancais.toLowerCase().contains(query.toLowerCase()) ||
              sourate.numero.toString().contains(query);
        }).toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterSourates('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildContent(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      leading: IconButton(
        icon: const Icon(Icons.refresh, color: Colors.white),
        onPressed: _loadSourates,
      ),
      actions: [
        if (_searchController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.white),
            onPressed: _clearSearch,
          ),
        // Lecteur audio — récitation complète du Coran (Al-Husary)
        IconButton(
          icon: const Icon(Icons.headphones, color: Colors.white),
          tooltip: 'Écouter le Coran',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AudioPlayerPage(),
              ),
            );
          },
        ),
        // Les 5 piliers de l'Islam
        IconButton(
          icon: const Icon(Icons.view_column, color: Colors.white),
          tooltip: 'Les 5 piliers de l\'Islam',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PillarsPage(),
              ),
            );
          },
        ),
        // Accès aux horaires de prière (fusionné depuis Waxtu Julli)
        IconButton(
          icon: const Icon(Icons.access_time, color: Colors.white),
          tooltip: 'Horaires de prière',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrayerTimesPage(),
              ),
            );
          },
        ),
        // Dans les actions de l'AppBar ou dans un menu
        IconButton(
          icon: const Icon(Icons.info, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            );
          },
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          const double expandedHeight = 200;
          final double visibleMainHeight = constraints.maxHeight;
          final double t = (expandedHeight - visibleMainHeight) /
              (expandedHeight - kToolbarHeight);

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00695C),
                  Color(0xFF004D40),
                ],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 20,
                  right: -30,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(
                      Icons.menu_book,
                      size: 150,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: 1.0 - t.clamp(0.0, 1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_stories,
                          size: 60,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Transform.translate(
                    offset: Offset(0, -t.clamp(0.0, 1.0) * 50),
                    child: Opacity(
                      opacity: (1.0 - t).clamp(0.0, 1.0),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Le Noble Coran',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(100, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          color: const Color(0xFFF5F5F5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            onChanged: _filterSourates,
            decoration: InputDecoration(
              hintText: 'Rechercher une sourate...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF00695C)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: _clearSearch,
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xFF00695C),
              ),
              SizedBox(height: 16),
              Text(
                'Chargement des sourates...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadSourates,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00695C),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredSourates.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                _searchController.text.isEmpty
                    ? 'Aucune sourate disponible'
                    : 'Aucune sourate trouvée pour "${_searchController.text}"',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              if (_searchController.text.isNotEmpty)
                TextButton(
                  onPressed: _clearSearch,
                  child: const Text(
                    'Effacer la recherche',
                    style: TextStyle(color: Color(0xFF00695C)),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final sourate = _filteredSourates[index];
            return _SourateCard(
              sourate: sourate,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SourateDetailPage(sourate: sourate),
                  ),
                );
              },
            );
          },
          childCount: _filteredSourates.length,
        ),
      ),
    );
  }
}

// Widget carte de sourate
class _SourateCard extends StatelessWidget {
  final Sourate sourate;
  final VoidCallback onTap;

  const _SourateCard({
    required this.sourate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: isDark ? Colors.grey[850] : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [Colors.grey[850]!, Colors.teal.withOpacity(0.08)]
                  : [Colors.white, Colors.teal.withOpacity(0.05)],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF004D40)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${sourate.numero}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sourate.nomArabe,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF004D40),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sourate.nomFrancais,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.article, size: 14, color: isDark ? Colors.white60 : Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${sourate.nombreVersets} versets',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          sourate.revelationLieu == "Mecque"
                              ? Icons.location_city
                              : Icons.account_balance,
                          size: 14,
                          color: isDark ? Colors.white60 : Colors.grey[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sourate.revelationLieu,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.white38 : Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/sourate.dart';
import 'audio_player_page.dart';

class SourateDetailPage extends StatefulWidget {
  final Sourate sourate;

  const SourateDetailPage({super.key, required this.sourate});

  @override
  State<SourateDetailPage> createState() => _SourateDetailPageState();
}

class _SourateDetailPageState extends State<SourateDetailPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _shareVerse() {
    const shareText = '📖 Coran en Français pour android\n\n'
        'Télécharger l’application ici :\n'
        'https://imbodj.github.io/coran-download/';

    SharePlus.instance.share(ShareParams(text: shareText));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Header expansible
          SliverToBoxAdapter(
            child: Container(
              height: 250,
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
              child: SafeArea(
                  child: Stack(
                children: [
                  // 🔥 1️⃣ Décorations EN PREMIER
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
                  Positioned(
                    top: 40,
                    right: -20,
                    child: Opacity(
                      opacity: 0.15,
                      child: Text(
                        '${widget.sourate.numero}',
                        style: const TextStyle(
                          fontSize: 180,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // 🔥 2️⃣ Contenu central
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_stories,
                          size: 50,
                          color: Colors.white70,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.sourate.nomFrancais,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.sourate.nomArabe,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sourate ${widget.sourate.numero}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔥 3️⃣ Boutons EN DERNIER (au-dessus)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 52,
                    child: IconButton(
                      icon: const Icon(Icons.headphones, color: Colors.white),
                      tooltip: 'Écouter cette sourate',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerPage(
                              initialIndex: widget.sourate.numero - 1,
                              autoPlay: true,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: _shareVerse,
                    ),
                  ),
                ],
              )),
            ),
          ),

          // Barre sticky qui reste visible
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              minHeight: 60,
              maxHeight: 60,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00695C), Color(0xFF004D40)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_stories,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            '${widget.sourate.nomFrancais} - ${widget.sourate.nomArabe}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Contenu de la sourate
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Informations sur la sourate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _InfoChip(
                        icon: Icons.article,
                        label: '${widget.sourate.nombreVersets} versets',
                      ),
                      _InfoChip(
                        icon: widget.sourate.revelationLieu == "Mecque"
                            ? Icons.location_city
                            : Icons.account_balance,
                        label: widget.sourate.revelationLieu,
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Basmala
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF00695C).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF004D40),
                        height: 1.8,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Texte de la sourate avec fond jaune ambré et texte en gras
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber[200]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.sourate.texte,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 2.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // Bouton de retour en haut
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: const Color(0xFF00695C),
        child: const Icon(Icons.arrow_upward, color: Colors.white),
      ),
    );
  }
}

// Delegate pour le header sticky
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// Widget InfoChip réutilisable
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00695C).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF00695C)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF00695C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

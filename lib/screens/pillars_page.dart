import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screens/pillar.dart';
import '../main.dart' show ThemeProvider;
import 'prayer_description_page.dart';

class PillarsPage extends StatelessWidget {
  const PillarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Les 5 piliers de l\'Islam')),
      body: Container(
        color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: fivePillars.length,
          itemBuilder: (context, index) {
            final pillar = fivePillars[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              color: isDark ? Colors.grey[850] : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PillarDetailPage(pillar: pillar)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFF00695C), Color(0xFF004D40)]),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Center(
                          child: Text(
                            '${pillar.numero}',
                            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pillar.titre,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              pillar.nomArabe,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.primary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(pillar.icon, color: colorScheme.primary.withOpacity(0.5), size: 26),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_ios, size: 15, color: isDark ? Colors.white38 : Colors.grey[400]),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PillarDetailPage extends StatelessWidget {
  final Pillar pillar;

  const PillarDetailPage({super.key, required this.pillar});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(child: _buildContent(context, isDark)),
          ),
          if (pillar.numero == 2)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PrayerDescriptionPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00695C), Color(0xFF004D40)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00695C).withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.menu_book, color: Colors.white),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Lire la description détaillée de la prière ﷺ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(height: 24 + MediaQuery.of(context).viewPadding.bottom),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00695C), Color(0xFF004D40)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Changer le thème',
                  icon: Icon(
                    themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.white,
                  ),
                  onPressed: themeProvider.toggleTheme,
                ),
              ],
            ),
            Icon(pillar.icon, size: 48, color: Colors.white70),
            const SizedBox(height: 12),
            Text(
              'Pilier ${pillar.numero} sur 5',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              pillar.titre,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              pillar.nomArabe,
              style: const TextStyle(color: Colors.white70, fontSize: 15, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, bool isDark) {
    final Color textColor = isDark ? Colors.white.withOpacity(0.9) : Colors.black87;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pillar.contenu.map((block) => _buildBlock(block, textColor, isDark)).toList(),
      ),
    );
  }

  Widget _buildBlock(ContentBlock block, Color textColor, bool isDark) {
    switch (block.type) {
      case BlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            block.text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF004D40),
            ),
          ),
        );

      case BlockType.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: (isDark ? Colors.teal : const Color(0xFF00695C)).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(color: isDark ? Colors.tealAccent : const Color(0xFF00695C), width: 4),
            ),
          ),
          child: Text(
            block.text,
            style: TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF004D40),
              height: 1.5,
            ),
          ),
        );

      case BlockType.listItem:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, size: 6, color: isDark ? Colors.tealAccent : const Color(0xFF00695C)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  block.text,
                  style: TextStyle(fontSize: 15, height: 1.5, color: textColor),
                ),
              ),
            ],
          ),
        );

      case BlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            block.text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15, height: 1.6, color: textColor),
          ),
        );
    }
  }
}
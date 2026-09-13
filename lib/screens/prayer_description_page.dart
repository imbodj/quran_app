import 'package:flutter/material.dart';
import 'package:quran_app/screens/pillar.dart';


class PrayerDescriptionPage extends StatefulWidget {
  const PrayerDescriptionPage({super.key});

  @override
  State<PrayerDescriptionPage> createState() => _PrayerDescriptionPageState();
}

class _PrayerDescriptionPageState extends State<PrayerDescriptionPage> {
  // Aucune section ouverte par défaut : le lecteur choisit ce qu'il
  // veut développer, plutôt que de tout faire défiler d'un bloc.
  final Set<int> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + MediaQuery.of(context).viewPadding.bottom),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSectionCard(index, isDark),
                childCount: prayerDescriptionSections.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              ],
            ),
            const Icon(Icons.self_improvement, size: 44, color: Colors.white70),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Abrégé de la description de la prière du Prophète ﷺ',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold, height: 1.3),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Du Takbîr au Taslîm, comme si vous la voyiez',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 13.5, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'D\'après le Sheikh Muhammad Nâsir ad-Dîn al-Albânî — touchez une section pour la développer',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 12.5, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(int index, bool isDark) {
    final section = prayerDescriptionSections[index];
    final isOpen = _expanded.contains(index);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (isOpen) {
                  _expanded.remove(index);
                } else {
                  _expanded.add(index);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      section.titre,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF004D40),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more, color: isDark ? Colors.white70 : const Color(0xFF00695C)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: isOpen ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: section.contenu.map((b) => _buildBlock(b, isDark)).toList(),
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildBlock(ContentBlock block, bool isDark) {
    final Color textColor = isDark ? Colors.white.withOpacity(0.9) : Colors.black87;

    switch (block.type) {
      case BlockType.quote:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isDark ? Colors.teal : const Color(0xFF00695C)).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border(
              left: BorderSide(color: isDark ? Colors.tealAccent : const Color(0xFF00695C), width: 3),
            ),
          ),
          child: Text(
            block.text,
            style: TextStyle(
              fontSize: 13.5,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF004D40),
              height: 1.5,
            ),
          ),
        );

      case BlockType.listItem:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Icon(Icons.circle, size: 5, color: isDark ? Colors.tealAccent : const Color(0xFF00695C)),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(block.text, style: TextStyle(fontSize: 13.5, height: 1.5, color: textColor))),
            ],
          ),
        );

      case BlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(block.text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textColor)),
        );

      case BlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            block.text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 13.5, height: 1.55, color: textColor),
          ),
        );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // Méthode pour lancer l'email - avec context en paramètre
  Future<void> _launchEmail(BuildContext context) async {
    const email = 'ismaila.mbodji@education.sn';
    const subject = 'À propos de l\'application Coran';
    const body =
        'Bonjour,\n\nJe vous contacte concernant l\'application du Coran.';

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    ).toString();

    try {
      if (await canLaunchUrl(Uri.parse(uri))) {
        await launchUrl(Uri.parse(uri));
      } else {
        // Fallback : copier l'email dans le presse-papier, sans jamais
        // l'afficher à l'écran.
        await Clipboard.setData(const ClipboardData(text: email));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adresse copiée dans le presse-papier'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Couleurs adaptées au thème : sur fond sombre, le texte gris clair
    // d'origine devenait quasi invisible. On calcule des couleurs qui
    // gardent un bon contraste dans les deux modes.
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color titleColor = Color(0xFF00695C);
    final Color bodyColor = isDark ? Colors.white70 : const Color.fromRGBO(97, 97, 97, 1);
    final Color labelColor = isDark ? Colors.white : const Color.fromRGBO(97, 97, 97, 1);
    final Color nameColor = isDark ? Colors.lightBlue[300]! : Colors.blue[700]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos'),
        backgroundColor: const Color(0xFF00695C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo/Image
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00695C),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_stories,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Titre
              const Text(
                'Le Noble Coran',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 10),

              // Description
              Text(
                'Application de lecture du Saint Coran offrant traduction rapprochée du sens des versets',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: bodyColor,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Traduction : Muhammad Hamidullah — texte vérifié via Tanzil.net',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: bodyColor.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 30),

              // Informations développeur
              Text(
                'Développeur:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.person, color: Colors.teal),
                  const SizedBox(width: 10),
                  Text(
                    'Ismaila Mbodji',
                    style: TextStyle(
                      fontSize: 16,
                      color: nameColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                'Contact:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: labelColor,
                ),
              ),

              const SizedBox(height: 8),

              // Bouton "Contactez-moi" : ouvre l'app mail sans jamais
              // afficher l'adresse en clair à l'écran.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchEmail(context),
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Contactez-moi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Version
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Bouton de retour
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Retour'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00695C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
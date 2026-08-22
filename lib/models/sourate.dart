class Sourate {
  final int numero;
  final String texte;
  final List<String> verses; // Nouveau: liste de versets séparés
  
  // Propriétés dérivées
  String get nomArabe => _getNomArabe();
  String get nomFrancais => _getNomFrancais();
  int get nombreVersets => _getNombreVersets();
  String get revelationLieu => _getRevelationLieu();
  String get revelationType => _getRevelationType();

  Sourate({
    required this.numero,
    required this.texte,
  }) : verses = texte.split('\n').where((v) => v.trim().isNotEmpty).toList();

  // Factory pour créer depuis la base de données
  factory Sourate.fromMap(Map<String, dynamic> map) {
    return Sourate(
      numero: map['Field1'] as int,
      texte: map['Field2'] as String,
    );
  }

  // Récupérer un verset spécifique
  String getVerse(int verseNumber) {
    if (verseNumber >= 1 && verseNumber <= verses.length) {
      return verses[verseNumber - 1];
    }
    return '';
  }

  // Convertir en Map
  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'texte': texte,
    };
  }

  // Méthodes pour obtenir les informations des sourates
  String _getNomArabe() {
    final noms = {
      1: "الفاتحة", 2: "البقرة", 3: "آل عمران", 4: "النساء", 5: "المائدة",
      6: "الأنعام", 7: "الأعراف", 8: "الأنفال", 9: "التوبة", 10: "يونس",
      11: "هود", 12: "يوسف", 13: "الرعد", 14: "إبراهيم", 15: "الحجر",
      16: "النحل", 17: "الإسراء", 18: "الكهف", 19: "مريم", 20: "طه",
      21: "الأنبياء", 22: "الحج", 23: "المؤمنون", 24: "النور", 25: "الفرقان",
      26: "الشعراء", 27: "النمل", 28: "القصص", 29: "العنكبوت", 30: "الروم",
      31: "لقمان", 32: "السجدة", 33: "الأحزاب", 34: "سبأ", 35: "فاطر",
      36: "يس", 37: "الصافات", 38: "ص", 39: "الزمر", 40: "غافر",
      41: "فصلت", 42: "الشورى", 43: "الزخرف", 44: "الدخان", 45: "الجاثية",
      46: "الأحقاف", 47: "محمد", 48: "الفتح", 49: "الحجرات", 50: "ق",
      51: "الذاريات", 52: "الطور", 53: "النجم", 54: "القمر", 55: "الرحمن",
      56: "الواقعة", 57: "الحديد", 58: "المجادلة", 59: "الحشر", 60: "الممتحنة",
      61: "الصف", 62: "الجمعة", 63: "المنافقون", 64: "التغابن", 65: "الطلاق",
      66: "التحريم", 67: "الملك", 68: "القلم", 69: "الحاقة", 70: "المعارج",
      71: "نوح", 72: "الجن", 73: "المزمل", 74: "المدثر", 75: "القيامة",
      76: "الإنسان", 77: "المرسلات", 78: "النبأ", 79: "النازعات", 80: "عبس",
      81: "التكوير", 82: "الإنفطار", 83: "المطففين", 84: "الإنشقاق", 85: "البروج",
      86: "الطارق", 87: "الأعلى", 88: "الغاشية", 89: "الفجر", 90: "البلد",
      91: "الشمس", 92: "الليل", 93: "الضحى", 94: "الشرح", 95: "التين",
      96: "العلق", 97: "القدر", 98: "البينة", 99: "الزلزلة", 100: "العاديات",
      101: "القارعة", 102: "التكاثر", 103: "العصر", 104: "الهمزة", 105: "الفيل",
      106: "قريش", 107: "الماعون", 108: "الكوثر", 109: "الكافرون", 110: "النصر",
      111: "المسد", 112: "الإخلاص", 113: "الفلق", 114: "الناس",
    };
    return noms[numero] ?? "سورة $numero";
  }

  String _getNomFrancais() {
    final noms = {
      1: "L'Ouverture", 2: "La Vache", 3: "La Famille d'Imran", 4: "Les Femmes",
      5: "La Table Servie", 6: "Les Bestiaux", 7: "Al-Araf", 8: "Le Butin",
      9: "Le Repentir", 10: "Jonas", 11: "Houd", 12: "Joseph", 13: "Le Tonnerre",
      14: "Abraham", 15: "Al-Hijr", 16: "Les Abeilles", 17: "Le Voyage Nocturne",
      18: "La Caverne", 19: "Marie", 20: "Ta-Ha", 21: "Les Prophètes",
      22: "Le Pèlerinage", 23: "Les Croyants", 24: "La Lumière", 25: "Le Discernement",
      26: "Les Poètes", 27: "Les Fourmis", 28: "Le Récit", 29: "L'Araignée", 30: "Les Romains",
      31: "Loukman", 32: "La Prosternation", 33: "Les Coalisés", 34: "Saba", 35: "Le Créateur",
      36: "Yâ-Sîn", 37: "Les Rangés", 38: "Sâd", 39: "Les Groupes", 40: "Le Pardonneur",
      41: "Les Versets Détaillés", 42: "La Consultation", 43: "L'Ornement", 44: "La Fumée", 45: "L'Agenouillée",
      46: "Al-Ahqaf", 47: "Mohammed", 48: "La Victoire", 49: "Les Appartements", 50: "Qâf",
      51: "Qui éparpillent", 52: "Le Mont Sinaï", 53: "L'Étoile", 54: "La Lune", 55: "Le Tout Miséricordieux",
      56: "L'Événement", 57: "Le Fer", 58: "La Discussion", 59: "Le Rassemblement", 60: "L'Éprouvée",
      61: "Le Rang", 62: "Le Vendredi", 63: "Les Hypocrites", 64: "La Grande Perte", 65: "Le Divorce",
      66: "L'Interdiction", 67: "La Royauté", 68: "La Plume", 69: "Celle qui montre la Vérité", 70: "Les Voies d'Ascension",
      71: "Noé", 72: "Les Djinns", 73: "L'Enveloppé", 74: "Le Revêtu d'un Manteau", 75: "La Résurrection",
      76: "L'Homme", 77: "Les Envoyés", 78: "La Nouvelle", 79: "Les Anges qui arrachent les âmes", 80: "Il s'est renfrogné",
      81: "L'Obscurcissement", 82: "La Rupture", 83: "Les Fraudeurs", 84: "La Déchirure", 85: "Les Constellations",
      86: "L'Astre Nocturne", 87: "Le Très-Haut", 88: "L'Enveloppante", 89: "L'Aube", 90: "La Cité",
      91: "Le Soleil", 92: "La Nuit", 93: "Le Jour Montant", 94: "L'Ouverture", 95: "Le Figuier",
      96: "L'Adhérence", 97: "La Destinée", 98: "La Preuve", 99: "La Secousse", 100: "Les Coursiers",
      101: "Le Fracas", 102: "La Course aux richesses", 103: "Le Temps", 104: "Le Calomniateur", 105: "L'Éléphant",
      106: "Quraysh", 107: "L'Utile", 108: "L'Abondance", 109: "Les Mécréants", 110: "Le Secours",
      111: "Les Fibres", 112: "Le Culte Pur", 113: "L'Aube Naissante", 114: "Les Hommes",
    };
    return noms[numero] ?? "Sourate $numero";
  }

  int _getNombreVersets() {
    final versets = {
      1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129, 10: 109,
      11: 123, 12: 111, 13: 43, 14: 52, 15: 99, 16: 128, 17: 111, 18: 110, 19: 98, 20: 135,
      21: 112, 22: 78, 23: 118, 24: 64, 25: 77, 26: 227, 27: 93, 28: 88, 29: 69, 30: 60,
      31: 34, 32: 30, 33: 73, 34: 54, 35: 45, 36: 83, 37: 182, 38: 88, 39: 75, 40: 85,
      41: 54, 42: 53, 43: 89, 44: 59, 45: 37, 46: 35, 47: 38, 48: 29, 49: 18, 50: 45,
      51: 60, 52: 49, 53: 62, 54: 55, 55: 78, 56: 96, 57: 29, 58: 22, 59: 24, 60: 13,
      61: 14, 62: 11, 63: 11, 64: 18, 65: 12, 66: 12, 67: 30, 68: 52, 69: 52, 70: 44,
      71: 28, 72: 28, 73: 20, 74: 56, 75: 40, 76: 31, 77: 50, 78: 40, 79: 46, 80: 42,
      81: 29, 82: 19, 83: 36, 84: 25, 85: 22, 86: 17, 87: 19, 88: 26, 89: 30, 90: 20,
      91: 15, 92: 21, 93: 11, 94: 8, 95: 8, 96: 19, 97: 5, 98: 8, 99: 8, 100: 11,
      101: 11, 102: 8, 103: 3, 104: 9, 105: 5, 106: 4, 107: 7, 108: 3, 109: 6, 110: 3,
      111: 5, 112: 4, 113: 5, 114: 6,
    };
    return versets[numero] ?? verses.length;
  }

  String _getRevelationLieu() {
    final lieux = {
      1: "Mecque", 2: "Médine", 3: "Médine", 4: "Médine", 5: "Médine",
      6: "Mecque", 7: "Mecque", 8: "Médine", 9: "Médine", 10: "Mecque",
      11: "Mecque", 12: "Mecque", 13: "Médine", 14: "Mecque", 15: "Mecque",
      16: "Mecque", 17: "Mecque", 18: "Mecque", 19: "Mecque", 20: "Mecque",
      21: "Mecque", 22: "Médine", 23: "Mecque", 24: "Médine", 25: "Mecque",
      26: "Mecque", 27: "Mecque", 28: "Mecque", 29: "Mecque", 30: "Mecque",
      31: "Mecque", 32: "Mecque", 33: "Médine", 34: "Mecque", 35: "Mecque",
      36: "Mecque", 37: "Mecque", 38: "Mecque", 39: "Mecque", 40: "Mecque",
      41: "Mecque", 42: "Mecque", 43: "Mecque", 44: "Mecque", 45: "Mecque",
      46: "Mecque", 47: "Médine", 48: "Médine", 49: "Médine", 50: "Mecque",
      51: "Mecque", 52: "Mecque", 53: "Mecque", 54: "Mecque", 55: "Médine",
      56: "Mecque", 57: "Médine", 58: "Médine", 59: "Médine", 60: "Médine",
      61: "Médine", 62: "Médine", 63: "Médine", 64: "Médine", 65: "Médine",
      66: "Médine", 67: "Mecque", 68: "Mecque", 69: "Mecque", 70: "Mecque",
      71: "Mecque", 72: "Mecque", 73: "Mecque", 74: "Mecque", 75: "Mecque",
      76: "Médine", 77: "Mecque", 78: "Mecque", 79: "Mecque", 80: "Mecque",
      81: "Mecque", 82: "Mecque", 83: "Mecque", 84: "Mecque", 85: "Mecque",
      86: "Mecque", 87: "Mecque", 88: "Mecque", 89: "Mecque", 90: "Mecque",
      91: "Mecque", 92: "Mecque", 93: "Mecque", 94: "Mecque", 95: "Mecque",
      96: "Mecque", 97: "Mecque", 98: "Médine", 99: "Médine", 100: "Mecque",
      101: "Mecque", 102: "Mecque", 103: "Mecque", 104: "Mecque", 105: "Mecque",
      106: "Mecque", 107: "Mecque", 108: "Mecque", 109: "Mecque", 110: "Médine",
      111: "Mecque", 112: "Mecque", 113: "Mecque", 114: "Mecque",
    };
    return lieux[numero] ?? "Mecque";
  }

  String _getRevelationType() {
    return _getRevelationLieu() == "Mecque" ? "Makki" : "Madani";
  }
}
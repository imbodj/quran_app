import 'package:flutter/material.dart';

/// Type de bloc de contenu pour l'affichage d'un pilier.
enum BlockType { paragraph, heading, listItem, quote }

class ContentBlock {
  final BlockType type;
  final String text;
  const ContentBlock(this.type, this.text);
}

class Pillar {
  final int numero;
  final String titre;
  final String nomArabe; // translittération
  final IconData icon;
  final List<ContentBlock> contenu;

  const Pillar({
    required this.numero,
    required this.titre,
    required this.nomArabe,
    required this.icon,
    required this.contenu,
  });
}

/// Une section repliable de la description détaillée de la prière.
class PrayerSection {
  final String titre;
  final List<ContentBlock> contenu;
  const PrayerSection(this.titre, this.contenu);
}

/// Les 5 piliers de l'Islam, dans leur ordre canonique.
/// Contenu repris de l'application Java originale de l'auteur
/// ("Les Cinq Piliers De L'Islam"), nettoyé et restructuré.
final List<Pillar> fivePillars = [
  Pillar(
    numero: 1,
    titre: 'La profession de foi',
    nomArabe: 'Chahada',
    icon: Icons.record_voice_over,
    contenu: const [
      ContentBlock(BlockType.paragraph,
          'La profession de foi musulmane ou chahada est le premier des « cinq piliers » de l\'islam. Le mot chahada, en arabe, signifie « attestation ». La chahada consiste en l\'attestation de deux choses :'),
      ContentBlock(BlockType.listItem, 'Que nul ne mérite d\'être adoré à part Dieu (Allah)'),
      ContentBlock(BlockType.listItem, 'Que Mohammed est le messager de Dieu (Allah).'),
      ContentBlock(BlockType.paragraph, 'La profession de foi consiste à déclarer, avec conviction :'),
      ContentBlock(BlockType.quote, '« Lâ ilâha illa-Llâh, Mohammadou-r-rasoulou-Llâh. »'),
      ContentBlock(BlockType.paragraph,
          'Cette déclaration signifie : « Il n\'y a pas d\'autre dieu qu\'Allah et Mohammed est Son messager. »'),
      ContentBlock(BlockType.paragraph,
          'Cette profession de foi est une formule toute simple qui doit être prononcée avec conviction et sans contrainte par celui ou celle qui veut se convertir à l\'islam.'),
      ContentBlock(BlockType.paragraph, 'La profession de foi est le pilier le plus important de l\'islam.'),
      ContentBlock(BlockType.paragraph,
          'Afin que la Chahada soit acceptée, elle doit être d\'abord comprise, que la sincérité de sa prononciation soit véritable et pure. Il est nécessaire de croire en ces paroles et de se soumettre complètement et de soi-même à leur sens. La Chahada doit être aimée et sa signification tenue au plus haut regard dans le cœur et l\'âme de tout croyant. Le polythéisme ou la mécréance, sous quelque forme qu\'elle soit, annulent immédiatement la Chahada.'),
      ContentBlock(BlockType.paragraph,
          'Elle est répétée cinq fois lors de chaque appel à la prière, dans chaque mosquée. Le Paradis a été promis à chaque personne dont les dernières paroles, avant de mourir, sont celles de la Chahada.'),
      ContentBlock(BlockType.paragraph,
          'Cependant, la prononciation de la Chahada n\'est pas suffisante pour se dire croyant et musulman. Le respect des quatre autres piliers de l\'Islam est une obligation canonique prescrite par le Coran et le Prophète Muhammad (SAW).'),
    ],
  ),
  Pillar(
    numero: 2,
    titre: 'La prière',
    nomArabe: 'Salat',
    icon: Icons.self_improvement,
    contenu: const [
      ContentBlock(BlockType.paragraph,
          'Le deuxième pilier de l\'islam est la prière rituelle quotidienne, ou salat en arabe. Elle est un moyen pour le croyant d\'exprimer son adoration pour Dieu l\'Unique. Elle a lieu cinq fois par jour. Le musulman doit obligatoirement se tourner vers la qibla, qui est la direction de la Mecque.'),
      ContentBlock(BlockType.paragraph,
          'Elle peut être faite à n\'importe quel endroit propre, et il est fortement recommandé de l\'accomplir à la mosquée et en groupe, notamment les prières du vendredi et des deux fêtes : Korité et Tabaski.'),
      ContentBlock(BlockType.heading, 'Les 5 prières quotidiennes'),
      ContentBlock(BlockType.listItem,
          'La prière de l\'aube — al-fajr, appelée aussi as-soubh : composée de deux rakats, elle commence peu après l\'apparition de l\'aube véritable, une lueur blanche transversale à l\'horizon Est. Son temps dure jusqu\'au début du lever du soleil.'),
      ContentBlock(BlockType.listItem,
          'La prière de la mi-journée — adh-dhouhr : débute après que le soleil a passé son zénith. Composée de quatre rakats, son temps commence lorsque le soleil s\'écarte du milieu du ciel vers le couchant.'),
      ContentBlock(BlockType.listItem,
          'La prière de l\'après-midi — al asr : comme adh-dhouhr, composée de quatre rakats. Son temps commence généralement à la fin de celui de adh-dhouhr et dure jusqu\'au coucher du soleil.'),
      ContentBlock(BlockType.listItem,
          'La prière du coucher du soleil — al-maghrib : composée de trois rakats, son temps commence après la disparition totale du disque solaire et finit à la disparition de la lueur rouge du crépuscule.'),
      ContentBlock(BlockType.listItem,
          'La prière du soir — icha : composée de quatre rakats. Son temps commence à la disparition de la lueur rouge et finit à l\'apparition de l\'aube.'),
    ],
  ),
  Pillar(
    numero: 3,
    titre: 'L\'aumône légale',
    nomArabe: 'Zakat',
    icon: Icons.volunteer_activism,
    contenu: const [
      ContentBlock(BlockType.paragraph, 'Le troisième pilier de l\'islam est la charité obligatoire, ou zakat.'),
      ContentBlock(BlockType.paragraph,
          'La charité, en islam, est non seulement recommandée, mais obligatoire pour tout musulman stable financièrement. Donner la charité à ceux qui sont dans le besoin fait partie de la nature du musulman et constitue un des cinq piliers de l\'islam. La zakat est une « charité obligatoire » : il est obligatoire, pour ceux que Dieu a comblés de richesses, de venir en aide aux membres de la communauté musulmane qui sont dans le besoin.'),
      ContentBlock(BlockType.paragraph,
          'Certaines personnes, dépourvues de tout sentiment d\'amour et de compassion envers autrui, ne savent qu\'amasser les richesses et les faire fructifier encore en les prêtant à intérêts. Les enseignements de l\'islam sont aux antipodes de ce genre d\'attitude. L\'islam encourage le partage des richesses et fait en sorte que les gens arrivent à se débrouiller et à devenir des membres productifs de la société.'),
      ContentBlock(BlockType.paragraph,
          'En arabe, cette charité obligatoire est connue sous le nom de zakat, qui signifie littéralement « purification », car elle purifie le cœur d\'une personne de toute avarice. La zakat doit être calculée selon la valeur de différentes catégories de biens — or, argent, liquidités, bétail, produits de l\'agriculture et marchandises commerciales — et acquittée une fois l\'an, lorsque les biens d\'une personne sont restés en sa possession durant une année complète. Elle équivaut à 2,5 % de la totalité des biens d\'une personne.'),
      ContentBlock(BlockType.paragraph,
          'Comme la prière, qui est une obligation à la fois individuelle et communautaire, la zakat est l\'expression de l\'adoration et de la gratitude du musulman envers Dieu, qu\'il manifeste en aidant ceux qui sont dans le besoin. En islam, c\'est à Dieu qu\'appartient toute chose, et non à l\'homme.'),
      ContentBlock(BlockType.paragraph,
          'La zakat ne doit être donnée qu\'à certaines catégories de personnes. La loi islamique stipule que ses principaux bénéficiaires sont les pauvres, les orphelins, les veuves, ceux qui sont endettés ; elle peut également servir à libérer des esclaves ou à aider d\'autres catégories mentionnées dans le Coran (9:60). Établie il y a quatorze siècles, la zakat est une forme de sécurité sociale dans les sociétés musulmanes.'),
    ],
  ),
  Pillar(
    numero: 4,
    titre: 'Le jeûne du Ramadan',
    nomArabe: 'Sawm',
    icon: Icons.nightlight_round,
    contenu: const [
      ContentBlock(BlockType.paragraph,
          'Le quatrième pilier de l\'islam est le jeûne du Ramadan, aux bienfaits spirituels qu\'il procure.'),
      ContentBlock(BlockType.paragraph,
          'Le jeûne n\'est pas exclusif aux musulmans. Il est pratiqué depuis des siècles, pour des raisons religieuses, par les chrétiens, les juifs, les confucianistes, les hindous, les taoïstes et les jaïnistes. Dieu dit, dans le Coran :'),
      ContentBlock(BlockType.quote,
          '« Ô vous qui croyez ! On vous a prescrit le jeûne comme on l\'a prescrit à ceux avant vous — peut-être deviendrez-vous pieux. » (Coran 2:183)'),
      ContentBlock(BlockType.paragraph,
          'Le jeûne du Ramadan a lieu une fois l\'an, durant le neuvième mois lunaire du calendrier islamique. C\'est aussi au cours de ce mois que :'),
      ContentBlock(BlockType.quote, '« … fut révélé le Coran comme guide pour les gens… » (Coran 2:185)'),
      ContentBlock(BlockType.paragraph,
          'Dans Son infinie miséricorde, Dieu a exempté de jeûne les malades, les voyageurs, ainsi que d\'autres catégories de personnes incapables de supporter une telle privation.'),
      ContentBlock(BlockType.paragraph,
          'Jeûner aide à développer le contrôle de soi, à mieux comprendre les bienfaits dont Dieu comble chacun chaque jour, et à avoir une plus grande compassion envers les démunis. Le jeûne, en islam, est l\'abstinence de tous les plaisirs physiques entre l\'aube et le crépuscule — nourriture, boissons, mais aussi activités sexuelles. Tout ce qui est normalement considéré comme péché l\'est encore plus durant ce mois, à cause de son caractère sacré.'),
      ContentBlock(BlockType.paragraph,
          'Après tout, pourquoi une personne se soucierait-elle de la faim des autres si elle n\'en a jamais connu elle-même les douleurs ? C\'est pourquoi le mois de Ramadan est aussi un mois de charité et de dons.'),
      ContentBlock(BlockType.paragraph,
          'Au crépuscule vient le moment de rompre le jeûne avec un repas léger que les musulmans appellent iftar. Plusieurs vont à la mosquée pour participer à la prière du soir, suivie d\'autres prières exclusives aux soirées du mois de Ramadan. Durant ce mois, certains musulmans récitent le Coran en entier comme acte d\'adoration.'),
      ContentBlock(BlockType.paragraph,
          'Durant les derniers jours du Ramadan, les musulmans commémorent la « nuit du destin », au cours de laquelle le Coran a été révélé. Le mois se termine par l\'Aïd al-Fitr : les musulmans fêtent l\'accomplissement du jeûne, distribuent des cadeaux aux enfants, et acquittent la zakat-al-fitr pour permettre aux pauvres de partager la joie de cette journée.'),
    ],
  ),
  Pillar(
    numero: 5,
    titre: 'Le pèlerinage',
    nomArabe: 'Hajj',
    icon: Icons.location_city,
    contenu: const [
      ContentBlock(BlockType.paragraph,
          'Le Hajj (pèlerinage à la Mecque) est le cinquième des cinq piliers obligatoires de l\'islam. En islam, le pèlerinage ne se fait pas aux tombeaux de saints pour demander de l\'aide, même si l\'on voit certains musulmans s\'adonner à ces actes répréhensibles.'),
      ContentBlock(BlockType.paragraph,
          'L\'unique pèlerinage se fait à la Ka\'aba (ou « Maison de Dieu ») située dans la ville sacrée de la Mecque, en Arabie Saoudite. Son caractère saint vient du fait qu\'elle a été construite par le prophète Abraham et son fils Ismaël pour servir de lieu d\'adoration du Dieu unique.'),
      ContentBlock(BlockType.paragraph,
          'Le pèlerinage est considéré comme un acte particulièrement méritoire, un moment de dévotion et de spiritualité intense, un moment pour faire pénitence et demander pardon.'),
      ContentBlock(BlockType.paragraph,
          'Il est obligatoire pour tous les musulmans qui en ont les capacités physique et financière, au moins une fois dans leur vie. Le pèlerinage débute le 8ᵉ jour du dernier mois du calendrier islamique, Dhoul-Hijjah, et prend fin le 13ᵉ jour.'),
      ContentBlock(BlockType.paragraph,
          'Il s\'agit d\'un immense rassemblement qui fait prendre conscience aux pèlerins que tous les musulmans sont égaux et méritent leur amour et leur sympathie, quelles que soient leur race ou leur origine ethnique.'),
    ],
  ),
];

/// Description détaillée de la prière du Prophète ﷺ, du Takbîr au Taslîm.
/// D'après le Sheikh Muhammad Nâsir ad-Dîn al-Albânî (qu'Allah lui fasse
/// miséricorde). Organisée en sections repliables (accordéon) pour un
/// écran dédié, accessible depuis le pilier « Prière ».
final List<PrayerSection> prayerDescriptionSections = [
  PrayerSection('1 — S\'orienter vers la Ka\'bah', const [
    ContentBlock(BlockType.paragraph,
        'Lorsque tu te lèves pour accomplir la prière, oriente-toi vers la Ka\'bah où que tu sois, qu\'il s\'agisse d\'une prière obligatoire ou surérogatoire. C\'est un pilier de la prière sans lequel celle-ci n\'est pas valide.'),
    ContentBlock(BlockType.paragraph, 'Cette obligation tombe dans certains cas :'),
    ContentBlock(BlockType.listItem, 'Pour le combattant lors de la prière de peur ou d\'un combat intense.'),
    ContentBlock(BlockType.listItem,
        'Pour la personne incapable de le faire, comme le malade, ou celle qui se trouve dans un bateau, une voiture ou un avion, si elle craint de laisser sortir la prière de son temps prescrit.'),
    ContentBlock(BlockType.listItem,
        'Pour celui qui prie une prière surérogatoire ou le Witr tout en se déplaçant à monture.'),
    ContentBlock(BlockType.paragraph,
        'Celui qui aperçoit la Ka\'bah doit s\'orienter exactement vers sa structure ; celui qui ne la voit pas s\'oriente vers sa direction générale. Si une personne prie dans une autre direction après un effort sincère d\'appréciation (temps couvert, etc.), sa prière reste valide.'),
  ]),
  PrayerSection('2 — La station debout (Al-Qiyâm)', const [
    ContentBlock(BlockType.paragraph, 'Il est obligatoire de prier debout, car c\'est un pilier de la prière, sauf :'),
    ContentBlock(BlockType.listItem, 'Pour celui qui prie la prière de peur : il lui est permis de prier chevauchant.'),
    ContentBlock(BlockType.listItem,
        'Pour le malade incapable de rester debout : il prie assis s\'il le peut, sinon couché sur le côté.'),
    ContentBlock(BlockType.listItem,
        'Pour celui qui accomplit une prière surérogatoire : il peut prier assis ou sur sa monture, en s\'inclinant et se prosternant par des gestes de la tête.'),
    ContentBlock(BlockType.paragraph,
        'Il est permis de prier pieds nus ou chaussé. Il est permis à l\'imam de prier sur un endroit surélevé (comme le minbar) dans un but pédagogique.'),
  ]),
  PrayerSection('3 — Prier vers une Sutrah (obstacle)', const [
    ContentBlock(BlockType.paragraph,
        'Il est obligatoire de prier vers une sutrah, en mosquée ou ailleurs, et de s\'en approcher suffisamment. Sa hauteur doit être d\'environ un empan ou deux.'),
    ContentBlock(BlockType.listItem, 'Il est absolument interdit de prier en direction des tombes.'),
    ContentBlock(BlockType.listItem,
        'Il est interdit de passer immédiatement devant une personne en train de prier si elle dispose d\'une sutrah.'),
    ContentBlock(BlockType.listItem,
        'Celui qui prie vers une sutrah doit empêcher quiconque de passer devant lui ; il peut faire un pas en avant pour repousser un animal ou un enfant.'),
    ContentBlock(BlockType.paragraph,
        'L\'importance de la sutrah tient notamment au fait qu\'elle empêche l\'annulation de la prière si une femme pubère, un âne ou un chien noir passent devant le prieur.'),
  ]),
  PrayerSection('4 — L\'intention (An-Niyyah)', const [
    ContentBlock(BlockType.paragraph,
        'Le prieur doit avoir l\'intention de la prière pour laquelle il s\'est levé. Son emplacement est le cœur — la prononcer à voix haute avec la langue est une innovation contraire à la Sunnah, car ni le Prophète ﷺ ni ses compagnons ne l\'ont fait.'),
  ]),
  PrayerSection('5 — Le Takbîr', const [
    ContentBlock(BlockType.paragraph,
        'Il débute la prière en disant « Allâhu Akbar » (Allah est le plus Grand) — c\'est un pilier. Il n\'élève la voix avec le Takbîr que s\'il est imam ; le fidèle guidé ne le prononce qu\'une fois que l\'imam a terminé le sien.'),
    ContentBlock(BlockType.paragraph,
        'Il lève les mains, doigts étendus sans les serrer ni les écarter, à hauteur des épaules (parfois jusqu\'au bas des oreilles), puis place sa main droite sur sa main gauche, sur la poitrine uniquement. Il fixe son regard sur son lieu de prosternation, sans lever les yeux vers le ciel.'),
  ]),
  PrayerSection('6 — L\'invocation d\'ouverture (Du\'â\' al-Istiftâh)', const [
    ContentBlock(BlockType.paragraph, 'Il débute la récitation par l\'une des invocations établies, la plus célèbre étant :'),
    ContentBlock(BlockType.quote,
        '« Allâhumma bâ\'id baynî wa bayna khatâyâya kamâ bâ\'adta bayna al-mashriqi wa al-maghrib, Allâhumma naqqinî min khatâyâya kamâ yunaqqâ ath-thawbu al-abyadu mina ad-danas, Allâhumma-ghsilnî min khatâyâya bi-th-thalji wa al-mâ\'i wa al-barad » (Ô Allah, éloigne de moi mes péchés comme Tu as éloigné l\'Orient de l\'Occident. Ô Allah, purifie-moi de mes péchés comme on purifie le vêtement blanc de sa saleté. Ô Allah, lave-moi de mes péchés avec la neige, l\'eau et la grêle.)'),
    ContentBlock(BlockType.paragraph, 'Ou bien :'),
    ContentBlock(BlockType.quote,
        '« Subhânaka Allâhumma wa bi-hamdika wa tabâraka-smuka wa ta\'âlâ jadduka wa lâ ilâha ghayruk » (Gloire et pureté à Toi ô Allah, et à Toi la louange, que Ton nom soit béni, que Ta majesté soit élevée, et il n\'y a d\'autre divinité digne d\'adoration en dehors de Toi.)'),
  ]),
  PrayerSection('7 — La récitation (Al-Qirâ\'ah)', const [
    ContentBlock(BlockType.paragraph, 'Il cherche ensuite refuge auprès d\'Allah :'),
    ContentBlock(BlockType.quote,
        '« A\'ûdhu bi-Llâhi mina ash-shaytâni ar-rajîmi min hamzihi wa nafkhihi wa nafthihi » (Je cherche refuge auprès d\'Allah contre le diable banni, contre ses incitations, son orgueil et sa poésie.)'),
    ContentBlock(BlockType.paragraph, 'Puis, à voix basse dans toutes les prières :'),
    ContentBlock(BlockType.quote, '« Bismi-Llâhi ar-Rahmâni ar-Rahîm » (Au nom d\'Allah, le Tout Miséricordieux, le Très Miséricordieux.)'),
    ContentBlock(BlockType.paragraph,
        'Il récite ensuite la sourate Al-Fâtihah en entier — un pilier sans lequel la prière n\'est pas valide — en marquant une pause à la fin de chaque verset. Elle est également obligatoire pour le fidèle guidé dans les prières à voix basse. À la fin, il dit « Âmîn ». Il récite ensuite une autre sourate ou quelques versets dans les deux premières rak\'ah.'),
    ContentBlock(BlockType.listItem,
        'Récitation à voix haute : Fajr, Vendredi, les deux Aïds, la demande de pluie, l\'éclipse, et les deux premières rak\'ah du Maghrib et de l\'Isha.'),
    ContentBlock(BlockType.listItem,
        'Récitation à voix basse : Dhuhr, Asr, la troisième rak\'ah du Maghrib et les deux dernières rak\'ah de l\'Isha.'),
  ]),
  PrayerSection('8 — L\'inclination (Ar-Rukû\')', const [
    ContentBlock(BlockType.paragraph,
        'Après une légère pause, il lève les mains et prononce le Takbîr en s\'inclinant. Il pose ses paumes sur ses genoux en écartant les doigts, étend son dos bien droit, ne relève ni ne baisse trop la tête, écarte ses coudes des flancs, et observe un temps d\'immobilité (Tumaniyyah) — un pilier de la prière.'),
    ContentBlock(BlockType.paragraph, 'Il dit, trois fois ou plus :'),
    ContentBlock(BlockType.quote, '« Subhâna Rabbî al-\'Adhîm » (Gloire à mon Seigneur le Très Grand.)'),
    ContentBlock(BlockType.paragraph, 'Ou :'),
    ContentBlock(BlockType.quote,
        '« Subhânaka Allâhumma Rabbanâ wa bi-hamdika Allâhumma-ghfirlî » (Gloire et pureté à Toi, ô Allah notre Seigneur, et à Toi la louange. Ô Allah, pardonne-moi.)'),
  ]),
  PrayerSection('9 — Le redressement de l\'inclination (Al-I\'tidâl)', const [
    ContentBlock(BlockType.paragraph, 'Il se redresse en disant :'),
    ContentBlock(BlockType.quote, '« Sami\'a Allâhu li-man hamidah » (Allah écoute celui qui Le loue.)'),
    ContentBlock(BlockType.paragraph, 'Puis, une fois debout et apaisé :'),
    ContentBlock(BlockType.quote,
        '« Rabbanâ wa laka al-hamd, hamdan kathîran tayyiban mubârakan fîh » (Notre Seigneur, à Toi la louange, une louange abondante, pure et bénie.)'),
    ContentBlock(BlockType.paragraph, 'Il prolonge cette station debout, d\'une durée proche de son inclination.'),
  ]),
  PrayerSection('10 — La prosternation (As-Sujûd)', const [
    ContentBlock(BlockType.paragraph,
        'Il prononce le Takbîr et descend se prosterner, mains posées au sol avant les genoux. Il prend appui sur ses paumes étendues orientées vers la Qiblah, à hauteur des épaules, décolle ses avant-bras du sol, applique fermement front, nez, genoux et orteils au sol, dresse ses pieds orientés vers la Qiblah, talons collés l\'un à l\'autre, et observe la quiétude — un pilier.'),
    ContentBlock(BlockType.paragraph, 'Il dit, trois fois ou plus :'),
    ContentBlock(BlockType.quote, '« Subhâna Rabbî al-A\'lâ » (Gloire à mon Seigneur le Très-Haut.)'),
    ContentBlock(BlockType.paragraph,
        'Il est recommandé de multiplier les invocations pendant la prosternation, le moment où le serviteur est le plus proche de son Seigneur.'),
  ]),
  PrayerSection('11 — L\'assise entre les deux prosternations', const [
    ContentBlock(BlockType.paragraph,
        'Il relève la tête en prononçant le Takbîr, replie le pied gauche et s\'assoit dessus (pied droit dressé), demeure paisible jusqu\'à ce que chaque os reprenne sa place, et dit :'),
    ContentBlock(BlockType.quote,
        '« Allâhumma-ghfirlî, wa-rhamnî, wa-jburnî, wa-rfa\'nî, wa-\'âfinî, wa-rzuqnî » (Ô Allah, pardonne-moi, fais-moi miséricorde, panse mes blessures, élève-moi, accorde-moi le salut et attribue-moi ma subsistance.)'),
    ContentBlock(BlockType.paragraph, 'Ou plus simplement : « Rabbi-ghfirlî, Rabbi-ghfirlî » (Seigneur, pardonne-moi, Seigneur, pardonne-moi).'),
  ]),
  PrayerSection('12 — La seconde prosternation et l\'assise de repos', const [
    ContentBlock(BlockType.paragraph,
        'Il accomplit la seconde prosternation de la même manière. En relevant la tête, il s\'assoit un court instant, bien droit (assise de repos), puis se relève pour la deuxième rak\'ah en prenant appui sur ses mains fermées — sans y réciter l\'invocation d\'ouverture cette fois.'),
  ]),
  PrayerSection('13 — Le premier Tashahhud', const [
    ContentBlock(BlockType.paragraph,
        'Il s\'assoit en position d\'Iftirâsh (pied gauche couché sous soi, pied droit dressé), paumes posées sur les cuisses. Il replie les doigts de sa main droite, pointe l\'index vers la Qiblah en le bougeant durant toute l\'invocation, et récite :'),
    ContentBlock(BlockType.quote,
        '« At-Tahiyyâtu li-Llâhi wa ass-Salawâtu wa at-Tayyibât. As-Salâmu \'alayka ayyuhâ an-Nabiyyu wa rahmatu-Llâhi wa barakâtuh. As-Salâmu \'alaynâ wa \'alâ \'ibâdi-Llâhi as-sâlihîn. Ash-hadu an lâ ilâha illâ-Llâhu wa ash-hadu anna Muhammadan \'abduhu wa rasûluh » (Les salutations sont pour Allah, ainsi que les prières et les bonnes œuvres. Que le salut soit sur toi, ô Prophète, ainsi que la miséricorde d\'Allah et Ses bénédictions. Que le salut soit sur nous et sur les pieux serviteurs d\'Allah. J\'atteste qu\'il n\'y a pas de divinité digne d\'adoration en dehors d\'Allah, et j\'atteste que Muhammad est Son serviteur et Son messager.)'),
    ContentBlock(BlockType.paragraph, 'Puis il prie sur le Prophète ﷺ :'),
    ContentBlock(BlockType.quote,
        '« Allâhumma salli \'alâ Muhammadin wa \'alâ âli Muhammad, kamâ sallayta \'alâ Ibrâhîma wa \'alâ âli Ibrâhîm, innaka Hamîdun Majîd. Allâhumma bârik \'alâ Muhammadin wa \'alâ âli Muhammad, kamâ bârakta \'alâ Ibrâhîma wa \'alâ âli Ibrâhîm, innaka Hamîdun Majîd. » (Ô Allah, prie sur Muhammad et sur la famille de Muhammad, comme Tu as prié sur Ibrahim et sur la famille d\'Ibrahim, Tu es certes digne de louange et de gloire. Ô Allah, bénis Muhammad et la famille de Muhammad, comme Tu as béni Ibrahim et la famille d\'Ibrahim, Tu es certes digne de louange et de gloire.)'),
  ]),
  PrayerSection('14 — Les deux dernières rak\'ah', const [
    ContentBlock(BlockType.paragraph,
        'Il accomplit les deux dernières rak\'ah de la même manière, en n\'y récitant que la Fâtihah — parfois complétée de quelques versets au Dhuhr.'),
  ]),
  PrayerSection('15 — Le dernier Tashahhud et le Tawarruk', const [
    ContentBlock(BlockType.paragraph,
        'Pour le dernier Tashahhud d\'une prière de trois ou quatre rak\'ah, il s\'assoit en position de Tawarruk : les deux pieds sortis du même côté, fesse gauche posée au sol. Il récite la prière sur le Prophète ﷺ et le Tashahhud comme précédemment, puis cherche obligatoirement refuge auprès d\'Allah contre quatre choses :'),
    ContentBlock(BlockType.quote,
        '« Allâhumma innî a\'ûdhu bika min \'adhâbi jahannam, wa min \'adhâbi al-qabr, wa min fitnati al-mahya wa al-mamât, wa min sharri fitnati al-masîhi ad-dajjâl » (Ô Allah, je cherche refuge auprès de Toi contre le châtiment de l\'Enfer, contre le châtiment de la tombe, contre l\'épreuve de la vie et de la mort, et contre le mal de l\'épreuve de l\'Antéchrist.)'),
    ContentBlock(BlockType.paragraph, 'Il invoque ensuite pour lui-même avec les formules rapportées dans le Coran et la Sunnah.'),
  ]),
  PrayerSection('16 — La salutation finale (At-Taslîm)', const [
    ContentBlock(BlockType.paragraph, 'Il salue sur sa droite, jusqu\'à voir la blancheur de sa joue droite :'),
    ContentBlock(BlockType.quote, '« As-Salâmu \'alaykum wa rahmatu-Llâhi wa barakâtuh » (Que la paix, la miséricorde et les bénédictions d\'Allah soient sur vous.)'),
    ContentBlock(BlockType.paragraph, 'Puis sur sa gauche :'),
    ContentBlock(BlockType.quote, '« As-Salâmu \'alaykum wa rahmatu-Llâh » (Que la paix et la miséricorde d\'Allah soient sur vous.)'),
  ]),
];

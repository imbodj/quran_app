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

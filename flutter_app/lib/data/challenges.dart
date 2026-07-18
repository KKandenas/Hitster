import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/challenge_glyphs.dart';

/// One of the five randomizable Hitster challenge types.
class Challenge {
  final String titel;
  final String info;
  final Color farg;
  final ChallengeGlyph glyph;

  const Challenge({
    required this.titel,
    required this.info,
    required this.farg,
    required this.glyph,
  });
}

const List<Challenge> challenges = [
  Challenge(
    titel: 'Årtal ± 2 år',
    info:
        'Gissa vilket år låten släpptes. Du vinner poäng/kortet om du är max 2 år ifrån det rätta svaret.',
    farg: AppColors.cAr2,
    glyph: ChallengeGlyph.yearTight,
  ),
  Challenge(
    titel: 'Årtal ± 4 år',
    info:
        'Gissa vilket år låten släpptes. Du får en generös felmarginal på upp till 4 år åt båda hållen!',
    farg: AppColors.cAr4,
    glyph: ChallengeGlyph.yearWide,
  ),
  Challenge(
    titel: 'Årtionde',
    info:
        'Du behöver inte pricka exakt år. Det räcker att du gissar rätt årtionde (t.ex. 80-talet, 90-talet).',
    farg: AppColors.cArtionde,
    glyph: ChallengeGlyph.decade,
  ),
  Challenge(
    titel: 'Före eller efter 2000?',
    info:
        'Det enklaste valet! Gissa bara om låten släpptes före år 2000, eller år 2000 och senare.',
    farg: AppColors.cSekel,
    glyph: ChallengeGlyph.millennium,
  ),
  Challenge(
    titel: 'Artist',
    info:
        'Glöm årtalet! För att ta poäng på den här låten måste du kunna namnet på artisten eller gruppen.',
    farg: AppColors.cArtist,
    glyph: ChallengeGlyph.artist,
  ),
];

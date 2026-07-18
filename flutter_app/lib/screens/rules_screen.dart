import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppNavBar(
                    maxWidth: 500,
                    actions: [
                      NavBarAction(
                        label: 'Tillbaka till hem',
                        icon: Icons.home_rounded,
                        onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GlassCard(
                    maxWidth: 500,
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                    child: const _RulesContent(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RulesContent extends StatelessWidget {
  const _RulesContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(child: GradientText('Så spelar du Hitster Bingo', fontSize: 24)),
        const SizedBox(height: 18),
        const _Paragraph(
          'Välkommen till en spännande variant av Hitster där musiksmak, tidskänsla och '
          'bingostrategi möts! Det här spelet spelas tillsammans med det fysiska kortspelet '
          'Hitster (eller valfri musikstreamingtjänst).',
        ),
        const _SectionTitle(icon: Icons.assignment_rounded, label: 'Förberedelser'),
        const _StepList([
          _RichStep([
            _T('Alla spelare öppnar '),
            _T('Bingobrickan', bold: true),
            _T(' i sina egna telefoner och trycker på "Generera ny bricka". Alla får då en '
                'unik men balanserad bricka med 5 rutor av varje färg.'),
          ]),
          _RichStep([
            _T('En gemensam telefon placeras i mitten av bordet med '),
            _T('Slumpgeneratorn', bold: true),
            _T(' igång. Denna sköter spelets utmaningar.'),
          ]),
        ]),
        const _SectionTitle(icon: Icons.format_list_numbered_rounded, label: 'Spelregler - Steg för steg'),
        _StepList([
          const _RichStep([
            _T('Spela en låt: ', bold: true),
            _T('Turas om att skanna ett Hitster-kort (eller starta en hemlig låt).'),
          ]),
          const _RichStep([
            _T('Slumpa utmaningen: ', bold: true),
            _T('Innan spelarna gissar, trycker ni på "Slumpa Utmaning!" i den gemensamma '
                'telefonen. Appen visar vilken typ av gissning som krävs för låten.'),
          ]),
          const _RichStep([
            _T('Gör gissningen: ', bold: true),
            _T('Spelaren gör sin gissning baserat på vad appen kräver.'),
          ]),
          _RichStep(
            const [
              _T('Rätta och markera:', bold: true),
            ],
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 4),
                child: _BulletList([
                  [
                    _T('Om spelaren '),
                    _T('gissar rätt', bold: true),
                    _T(' enligt utmaningens kriterier får denne leta upp en valfri ruta med '),
                    _T('samma färg', bold: true),
                    _T(' på sin personliga bingobricka och trycka på den för att markera den '
                        'med ett '),
                    _T('X', bold: true),
                    _T('.'),
                  ],
                  [
                    _T('Om spelaren gissar fel händer ingenting, och turen går vidare till '
                        'nästa person.'),
                  ],
                ]),
              ),
              const SizedBox(height: 10),
              const _BonusBox(),
            ],
          ),
        ]),
        const _SectionTitle(icon: Icons.local_offer_rounded, label: 'De 5 utmaningarna'),
        const _ColorItem(
          color: AppColors.cAr2,
          title: 'Röd (Årtal ± 2 år):',
          text: 'Gissa år, med en felmarginal på +/- 2 år. (Träffar du exakt? Aktivera bonusen!)',
        ),
        const _ColorItem(
          color: AppColors.cAr4,
          title: 'Blå (Årtal ± 4 år):',
          text: 'Gissa år, med en generös felmarginal på +/- 4 år. (Träffar du exakt? Aktivera bonusen!)',
        ),
        const _ColorItem(
          color: AppColors.cArtionde,
          title: 'Lila (Årtionde):',
          text: 'Gissa rätt årtionde (t.ex. 80-talet). (Om du gissar på exakt år och har rätt aktiveras bonusen!)',
        ),
        const _ColorItem(
          color: AppColors.cSekel,
          title: 'Grön (Före/Efter 2000):',
          text: 'Gissa om låten släpptes före år 2000, eller år 2000 och senare.',
        ),
        const _ColorItem(
          color: AppColors.cArtist,
          title: 'Gul (Artist):',
          text: 'Glöm årtalen – du måste pricka artistens/gruppens namn.',
        ),
        const _SectionTitle(icon: Icons.emoji_events_rounded, label: 'Hur man vinner'),
        const _Paragraph(
          'Den spelare som först lyckas få 5 markerade rutor i en rad (vågrätt, lodrätt eller '
          'diagonalt) ropar BINGO! och vinner spelet.',
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent2, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.accent2, fontSize: 17, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: AppColors.textMuted, fontSize: 15, height: 1.6),
    );
  }
}

class _T {
  final String text;
  final bool bold;
  const _T(this.text, {this.bold = false});
}

class _StepList extends StatelessWidget {
  final List<Widget> steps;
  const _StepList(this.steps);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Color(0xFF1A0B14),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: steps[i]),
              ],
            ),
          ),
      ],
    );
  }
}

class _RichStep extends StatelessWidget {
  final List<_T> spans;
  final List<Widget> children;
  const _RichStep(this.spans, {this.children = const []});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              for (final s in spans)
                TextSpan(
                  text: s.text,
                  style: TextStyle(
                    color: s.bold ? AppColors.textPrimary : AppColors.textMuted,
                    fontWeight: s.bold ? FontWeight.w700 : FontWeight.w400,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<List<_T>> items;
  const _BulletList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  ', style: TextStyle(color: AppColors.textMuted, fontSize: 15)),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        for (final s in item)
                          TextSpan(
                            text: s.text,
                            style: TextStyle(
                              color: s.bold ? AppColors.textPrimary : AppColors.textMuted,
                              fontWeight: s.bold ? FontWeight.w700 : FontWeight.w400,
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _BonusBox extends StatelessWidget {
  const _BonusBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradientSoft,
        border: Border.all(color: AppColors.accent1.withValues(alpha: 0.5), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.accent1, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'EXAKT ÅRTAL-BONUS: ',
                    style: TextStyle(color: AppColors.accent1, fontWeight: FontWeight.w700, fontSize: 13.5),
                  ),
                  TextSpan(
                    text: 'Om du lyckas gissa på exakt rätt år (gäller vid röd eller blå utmaning) får '
                        'du markera din ruta, men du får dessutom sudda ut en valfri ikryssad ruta från '
                        'valfri motspelares bricka! Motspelaren trycker då bara på sin ruta igen så '
                        'försvinner krysset.',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorItem extends StatelessWidget {
  final Color color;
  final String title;
  final String text;

  const _ColorItem({required this.color, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.surfaceHairline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 15,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 10)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title ',
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  TextSpan(
                    text: text,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

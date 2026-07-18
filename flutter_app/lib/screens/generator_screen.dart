import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/challenges.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_text.dart';
import '../widgets/vinyl_logo.dart';
import 'bingo_screen.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  Timer? _rollTimer;
  bool _rolling = false;
  Challenge? _shown;

  late final AnimationController _revealController;
  late final Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: const Cubic(0.2, 0.7, 0.3, 1.0),
    );
  }

  @override
  void dispose() {
    _rollTimer?.cancel();
    _revealController.dispose();
    super.dispose();
  }

  void _slumpaUtmaning() {
    if (_rolling) return;
    setState(() {
      _rolling = true;
      _revealController.value = 0;
    });

    var ticks = 0;
    const maxTicks = 10;
    _rollTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      setState(() {
        _shown = challenges[_random.nextInt(challenges.length)];
      });
      ticks++;
      if (ticks >= maxTicks) {
        timer.cancel();
        setState(() {
          _shown = challenges[_random.nextInt(challenges.length)];
          _rolling = false;
        });
        _revealController.forward(from: 0);
      }
    });
  }

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
                children: [
                  AppNavBar(
                    actions: [
                      NavBarAction(
                        label: 'Hem',
                        icon: Icons.home_rounded,
                        onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      ),
                      NavBarAction(
                        label: 'Visa Bingo',
                        icon: Icons.grid_view_rounded,
                        accent: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BingoScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const EyebrowChip(label: 'Gemensam telefon'),
                        const SizedBox(height: 14),
                        const GradientText('Hitster Slumpare', fontSize: 26),
                        const SizedBox(height: 26),
                        GradientButton(
                          onPressed: _slumpaUtmaning,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VinylLogo(
                                size: 26,
                                spin: _rolling,
                                spinDuration: const Duration(milliseconds: 500),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Slumpa Utmaning!',
                                style: TextStyle(
                                  color: GradientButton.onDark,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_shown != null) ...[
                          const SizedBox(height: 24),
                          ScaleTransition(
                            scale: Tween(begin: 0.94, end: 1.0).animate(_revealAnimation),
                            child: FadeTransition(
                              opacity: _revealAnimation,
                              child: _ResultCard(challenge: _shown!, rolling: _rolling),
                            ),
                          ),
                        ],
                      ],
                    ),
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

class _ResultCard extends StatelessWidget {
  final Challenge challenge;
  final bool rolling;

  const _ResultCard({required this.challenge, required this.rolling});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceSolid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: challenge.farg, width: 2),
        boxShadow: rolling
            ? []
            : [
                BoxShadow(
                  color: challenge.farg.withValues(alpha: 0.35),
                  blurRadius: 24,
                ),
              ],
      ),
      child: Column(
        children: [
          Icon(challenge.ikon, color: challenge.farg, size: 40),
          const SizedBox(height: 12),
          Text(
            challenge.titel,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: challenge.farg,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!rolling) ...[
            const SizedBox(height: 10),
            Text(
              challenge.info,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

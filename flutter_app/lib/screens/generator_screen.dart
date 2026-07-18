import 'dart:math';
import 'package:flutter/material.dart';
import '../data/challenges.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_text.dart';
import '../widgets/spin_wheel.dart';
import 'bingo_screen.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen>
    with TickerProviderStateMixin {
  final _random = Random();
  bool _spinning = false;
  Challenge? _shown;
  double _wheelRotation = 0;

  late final AnimationController _wheelController;
  Animation<double> _wheelAnimation = const AlwaysStoppedAnimation(0);

  late final AnimationController _revealController;
  late final Animation<double> _revealAnimation;

  @override
  void initState() {
    super.initState();
    _wheelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
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
    _wheelController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  void _slumpaUtmaning() {
    if (_spinning) return;

    final index = _random.nextInt(challenges.length);
    final targetMod = SpinWheel.targetRotationFor(index);
    final currentMod = _wheelRotation % (2 * pi);
    var delta = targetMod - currentMod;
    if (delta <= 0) delta += 2 * pi;
    final extraTurns = 4 + _random.nextInt(3); // 4-6 full spins for effect
    delta += extraTurns * 2 * pi;
    final newRotation = _wheelRotation + delta;

    setState(() {
      _spinning = true;
      _shown = null;
      _wheelAnimation = Tween<double>(begin: _wheelRotation, end: newRotation).animate(
        CurvedAnimation(parent: _wheelController, curve: Curves.easeOutCubic),
      );
    });

    _wheelController.forward(from: 0).whenComplete(() {
      if (!mounted) return;
      setState(() {
        _wheelRotation = newRotation;
        _shown = challenges[index];
        _spinning = false;
      });
      _revealController.forward(from: 0);
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
                        const SizedBox(height: 22),
                        AnimatedBuilder(
                          animation: _wheelAnimation,
                          builder: (context, _) => SpinWheel(
                            rotation: _wheelAnimation.value,
                            size: 220,
                          ),
                        ),
                        const SizedBox(height: 22),
                        GradientButton(
                          onPressed: _slumpaUtmaning,
                          child: Text(
                            _spinning ? 'Snurrar…' : 'Slumpa Utmaning!',
                            style: const TextStyle(
                              color: GradientButton.onDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (_shown != null) ...[
                          const SizedBox(height: 24),
                          ScaleTransition(
                            scale: Tween(begin: 0.94, end: 1.0).animate(_revealAnimation),
                            child: FadeTransition(
                              opacity: _revealAnimation,
                              child: _ResultCard(challenge: _shown!),
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

  const _ResultCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.surfaceSolid,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: challenge.farg, width: 2),
        boxShadow: [
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
      ),
    );
  }
}

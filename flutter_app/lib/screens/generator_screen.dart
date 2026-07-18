import 'dart:math';
import 'package:flutter/material.dart';
import '../data/challenges.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/challenge_glyphs.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_text.dart';
import '../widgets/sfx_pool.dart';
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

  late final AnimationController _landController;
  late final Animation<double> _bounceAnimation;
  late final Animation<double> _glowAnimation;

  final _tickSound = SfxPool('assets/assets/sounds/tick.wav');
  final _chimeSound = SfxPool('assets/assets/sounds/land_chime.wav', poolSize: 2);
  int _lastTickIndex = 0;

  @override
  void initState() {
    super.initState();
    _wheelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..addListener(_onWheelTick);
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: const Cubic(0.2, 0.7, 0.3, 1.0),
    );
    _landController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 0.97).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.97, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
    ]).animate(_landController);
    _glowAnimation = CurvedAnimation(parent: _landController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    _revealController.dispose();
    _landController.dispose();
    super.dispose();
  }

  /// Fires a tick sound every time the wheel's rotation crosses a slice
  /// boundary. Since rotation is driven by an easeOutCubic curve, this
  /// naturally produces fast ticks while the wheel is spinning quickly
  /// and progressively slower, spaced-out ticks as it decelerates — like
  /// a real ratchet wheel — without needing a separate timer.
  void _onWheelTick() {
    final tickIndex = (_wheelAnimation.value / SpinWheel.sliceAngle).floor();
    if (tickIndex != _lastTickIndex) {
      _lastTickIndex = tickIndex;
      _tickSound.play();
    }
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

    _lastTickIndex = (_wheelRotation / SpinWheel.sliceAngle).floor();

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
      _landController.forward(from: 0);
      _chimeSound.play();
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
              padding: const EdgeInsets.all(12),
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
                  const SizedBox(height: 14),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const GradientText('Hitster Slumpare', fontSize: 22),
                        const SizedBox(height: 14),
                        AnimatedBuilder(
                          animation: Listenable.merge([_wheelAnimation, _landController]),
                          builder: (context, _) {
                            final glowColor = _shown?.farg ?? AppColors.accent1;
                            final glowOpacity = (1 - _glowAnimation.value).clamp(0.0, 1.0) * 0.55;
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: glowOpacity > 0.01
                                    ? [
                                        BoxShadow(
                                          color: glowColor.withValues(alpha: glowOpacity),
                                          blurRadius: 46,
                                          spreadRadius: 6,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Transform.scale(
                                scale: _bounceAnimation.value,
                                child: SpinWheel(
                                  rotation: _wheelAnimation.value,
                                  size: 168,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        GradientButton(
                          onPressed: _slumpaUtmaning,
                          child: Text(
                            _spinning ? 'Snurrar…' : 'Slumpa Utmaning!',
                            style: const TextStyle(
                              color: GradientButton.onDark,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (_shown != null) ...[
                          const SizedBox(height: 14),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          ChallengeGlyphIcon(glyph: challenge.glyph, color: challenge.farg, size: 34),
          const SizedBox(height: 8),
          Text(
            challenge.titel,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: challenge.farg,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            challenge.info,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

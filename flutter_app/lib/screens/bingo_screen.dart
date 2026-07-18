import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/gradient_text.dart';
import 'generator_screen.dart';

const _kLayoutKey = 'hitster_bingo_layout';
const _kCheckedKey = 'hitster_bingo_checked';

const List<Color> _basFarger = [
  AppColors.cAr2,
  AppColors.cAr4,
  AppColors.cArtionde,
  AppColors.cSekel,
  AppColors.cArtist,
];

class _LegendEntry {
  final Color color;
  final String label;
  const _LegendEntry(this.color, this.label);
}

const _legend = [
  _LegendEntry(AppColors.cAr2, 'Årtal ± 2 år (Röd)'),
  _LegendEntry(AppColors.cAr4, 'Årtal ± 4 år (Blå)'),
  _LegendEntry(AppColors.cArtionde, 'Årtionde (Lila)'),
  _LegendEntry(AppColors.cSekel, 'Före/Efter 2000 (Grön)'),
  _LegendEntry(AppColors.cArtist, 'Artist (Gul)'),
];

class BingoScreen extends StatefulWidget {
  const BingoScreen({super.key});

  @override
  State<BingoScreen> createState() => _BingoScreenState();
}

class _BingoScreenState extends State<BingoScreen> {
  List<int> _layout = [];
  Set<int> _checked = {};
  bool _loaded = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLayout = _prefs.getString(_kLayoutKey);
    final savedChecked = _prefs.getString(_kCheckedKey);

    setState(() {
      _layout = savedLayout != null && savedLayout.isNotEmpty
          ? savedLayout.split(',').map(int.parse).toList()
          : _skapaBricka();
      _checked = savedChecked != null && savedChecked.isNotEmpty
          ? savedChecked.split(',').map(int.parse).toSet()
          : {};
      _loaded = true;
    });

    if (savedLayout == null) {
      await _prefs.setString(_kLayoutKey, _layout.join(','));
    }
  }

  List<int> _skapaBricka() {
    final pool = <int>[];
    for (var i = 0; i < _basFarger.length; i++) {
      for (var j = 0; j < 5; j++) {
        pool.add(i);
      }
    }
    pool.shuffle(Random());
    return pool;
  }

  Future<void> _toggleCell(int index) async {
    setState(() {
      if (_checked.contains(index)) {
        _checked.remove(index);
      } else {
        _checked.add(index);
      }
    });
    await _prefs.setString(_kCheckedKey, _checked.join(','));
  }

  Future<void> _genereraNyBricka() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceSolid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Nytt spel?', style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Vill du verkligen starta ett nytt spel och rensa brickan?',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Avbryt'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ja, starta om'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _prefs.remove(_kLayoutKey);
      await _prefs.remove(_kCheckedKey);
      setState(() {
        _layout = _skapaBricka();
        _checked = {};
      });
      await _prefs.setString(_kLayoutKey, _layout.join(','));
    }
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
                        label: 'Slumpa utmaning',
                        icon: Icons.casino_rounded,
                        accent: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GeneratorScreen()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  GlassCard(
                    maxWidth: 420,
                    child: !_loaded
                        ? const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const GradientText('Hitster Bingo', fontSize: 24),
                              const SizedBox(height: 15),
                              _buildLegend(),
                              const SizedBox(height: 22),
                              _buildGrid(),
                              const SizedBox(height: 22),
                              GradientButton(
                                onPressed: _genereraNyBricka,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.refresh_rounded, color: GradientButton.onDark),
                                    SizedBox(width: 10),
                                    Text(
                                      'Generera ny bricka',
                                      style: TextStyle(
                                        color: GradientButton.onDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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

  Widget _buildLegend() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.5,
      children: [
        for (final entry in _legend.sublist(0, 4)) _legendChip(entry),
        SizedBox(
          width: double.infinity,
          child: _legendChip(_legend[4]),
        ),
      ],
    );
  }

  Widget _legendChip(_LegendEntry entry) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.surfaceHairline),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: entry.color,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(color: entry.color.withValues(alpha: 0.6), blurRadius: 8)],
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              entry.label,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 11.5, height: 1.15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 25,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 7,
          crossAxisSpacing: 7,
        ),
        itemBuilder: (context, index) {
          final color = _basFarger[_layout[index]];
          final checked = _checked.contains(index);
          return _BingoCell(
            color: color,
            checked: checked,
            onTap: () => _toggleCell(index),
          );
        },
      ),
    );
  }
}

class _BingoCell extends StatelessWidget {
  final Color color;
  final bool checked;
  final VoidCallback onTap;

  const _BingoCell({required this.color, required this.checked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.5),
            radius: 1.1,
            colors: [
              Color.lerp(color, Colors.white, 0.35)!,
              color,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: checked ? 0.55 : 1,
          child: Center(
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              scale: checked ? 1 : 0.4,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: checked ? 1 : 0,
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 26),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

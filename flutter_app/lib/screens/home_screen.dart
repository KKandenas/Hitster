import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';
import '../widgets/menu_link_tile.dart';
import '../widgets/staggered_entrance.dart';
import '../widgets/vinyl_logo.dart';
import 'generator_screen.dart';
import 'bingo_screen.dart';
import 'rules_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: GlassCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VinylLogo(size: 108),
                    const SizedBox(height: 18),
                    const EyebrowChip(label: 'Party edition'),
                    const SizedBox(height: 14),
                    const GradientText('Hitsterbingo', fontSize: 30),
                    const SizedBox(height: 8),
                    const Text(
                      'Välkommen! Välj ett verktyg nedan för att starta spelkvällen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14.5, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    StaggeredEntrance(
                      delay: const Duration(milliseconds: 50),
                      child: MenuLinkTile(
                        icon: Icons.casino_rounded,
                        label: 'Slumpgenerator',
                        description: 'Slumpa nästa musikutmaning till bordet.',
                        primary: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GeneratorScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    StaggeredEntrance(
                      delay: const Duration(milliseconds: 150),
                      child: MenuLinkTile(
                        icon: Icons.grid_view_rounded,
                        label: 'Bingobricka',
                        description: 'Öppna din personliga 5x5 bingobricka',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BingoScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    StaggeredEntrance(
                      delay: const Duration(milliseconds: 250),
                      child: MenuLinkTile(
                        icon: Icons.menu_book_rounded,
                        label: 'Spelinstruktioner',
                        description: 'Hur man spelar, rättar och vinner.',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const RulesScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

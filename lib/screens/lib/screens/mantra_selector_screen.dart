import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class MantraSelectorScreen extends ConsumerStatefulWidget {
  const MantraSelectorScreen({super.key});

  @override
  ConsumerState<MantraSelectorScreen> createState() =>
      _MantraSelectorScreenState();
}

class _MantraSelectorScreenState
    extends ConsumerState<MantraSelectorScreen> {
  String? _expandedMantraId;

  @override
  Widget build(BuildContext context, ) {
    final mantras = ref.watch(mantrasProvider);
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : null,
          color: isDark ? null : AppColors.lightBg,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.gold, size: 16),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('Select Mantra',
                        style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 18, letterSpacing: 1)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  itemCount: mantras.length,
                  itemBuilder: (ctx, i) {
                    final mantra = mantras[i];
                    final isSelected = mantra.id == settings.selectedMantraId;
                    final isExpanded = _expandedMantraId == mantra.id;

                    return GestureDetector(
                      onTap: () {
                        ref.read(settingsProvider.notifier).setMantra(mantra.id);
                        Navigator.pop(context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected
                              ? AppColors.gold.withOpacity(0.12)
                              : (isDark ? AppColors.darkCard : AppColors.lightCard),
                          border: Border.all(
                            color: isSelected ? AppColors.gold.withOpacity(0.6) : AppColors.gold.withOpacity(0.15),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.gold.withOpacity(0.1),
                                      border: Border.all(color: AppColors.gold.withOpacity(0.2)),
                                    ),
                                    child: Center(child: Text(_deityEmoji(mantra.deity), style: const TextStyle(fontSize: 22))),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          Flexible(child: Text(mantra.name,
                                              style: TextStyle(
                                                color: isSelected ? AppColors.gold : (isDark ? AppColors.textCream : AppColors.textDark),
                                                fontFamily: 'Cinzel', fontSize: 13,
                                              ))),
                                          if (isSelected) ...[
                                            const SizedBox(width: 6),
                                            const Icon(Icons.check_circle, color: AppColors.gold, size: 16),
                                          ],
                                        ]),
                                        const SizedBox(height: 4),
                                        Text(mantra.deity, style: const TextStyle(color: AppColors.saffron, fontSize: 11)),
                                        const SizedBox(height: 4),
                                        Text(
                                          mantra.sanskritText.split('\n').first,
                                          style: const TextStyle(fontSize: 13, color: AppColors.gold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _expandedMantraId = isExpanded ? null : mantra.id;
                                    }),
                                    child: Icon(
                                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.gold.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isExpanded)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(color: AppColors.gold.withOpacity(0.1)),
                                    const SizedBox(height: 8),
                                    const Text('Meaning', style: TextStyle(color: AppColors.saffron, fontSize: 10, letterSpacing: 1)),
                                    const SizedBox(height: 4),
                                    Text(mantra.meaning,
                                        style: TextStyle(color: isDark ? AppColors.textCream : AppColors.textDark, fontSize: 12, height: 1.6)),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ref.read(settingsProvider.notifier).setMantra(mantra.id);
                                          Navigator.pop(context);
                                        },
                                        child: Text(isSelected ? 'Selected ✓' : 'Select This Mantra'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: 50 * i), duration: 300.ms);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _deityEmoji(String deity) {
    switch (deity.toLowerCase()) {
      case 'krishna': return '🦚';
      case 'shiva': return '🔱';
      case 'surya': return '☀️';
      case 'radha': return '🌸';
      case 'universal': return '🕉️';
      case 'ganesha': return '🐘';
      default: return '🙏';
    }
  }
}

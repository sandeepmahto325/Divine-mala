import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  static const List<Map<String, dynamic>> presets = [
    {'count': 108, 'label': '108', 'subtitle': 'One Mala', 'emoji': '📿'},
    {'count': 216, 'label': '216', 'subtitle': 'Two Malas', 'emoji': '📿📿'},
    {'count': 1008, 'label': '1008', 'subtitle': 'Sahasra Jap', 'emoji': '🙏'},
    {'count': 10008, 'label': '10,008', 'subtitle': 'Dasha Sahasra', 'emoji': '⭐'},
    {'count': 100000, 'label': '1 Lakh', 'subtitle': 'Maha Jap', 'emoji': '🕉️'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(japSessionProvider);
    final isDark = ref.watch(settingsProvider).isDarkMode;
    final progress = session.progress.clamp(0.0, 1.0);

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
                    const Text('Set Goal',
                        style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 18)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                        ),
                        child: Column(
                          children: [
                            CircularPercentIndicator(
                              radius: 90,
                              lineWidth: 12,
                              percent: progress,
                              center: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${session.count}',
                                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.gold, fontFamily: 'Cinzel')),
                                  Text('of ${session.targetCount}',
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                                ],
                              ),
                              progressColor: AppColors.gold,
                              backgroundColor: AppColors.gold.withOpacity(0.12),
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                            ),
                            const SizedBox(height: 16),
                            Text('${(progress * 100).toStringAsFixed(1)}% Complete',
                                style: const TextStyle(color: AppColors.saffron, fontFamily: 'Cinzel', fontSize: 16)),
                            const SizedBox(height: 6),
                            Text('${(session.targetCount - session.count).clamp(0, session.targetCount)} chants remaining',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Quick Presets',
                            style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 16)),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.6,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: presets.length + 1,
                        itemBuilder: (ctx, i) {
                          if (i == presets.length) {
                            return GestureDetector(
                              onTap: () {
                                final ctrl = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    title: const Text('Custom Goal',
                                        style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel')),
                                    content: TextField(
                                      controller: ctrl,
                                      keyboardType: TextInputType.number,
                                      autofocus: true,
                                      style: TextStyle(color: isDark ? AppColors.textCream : AppColors.textDark),
                                      decoration: InputDecoration(
                                        hintText: 'Enter count...',
                                        hintStyle: const TextStyle(color: AppColors.textMuted),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: AppColors.gold.withOpacity(0.3)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: AppColors.gold),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final val = int.tryParse(ctrl.text);
                                          if (val != null && val > 0) {
                                            ref.read(japSessionProvider.notifier).setTarget(val);
                                            Navigator.pop(ctx);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text('Set'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                                  border: Border.all(color: AppColors.gold.withOpacity(0.15)),
                                ),
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add_circle_outline, color: AppColors.gold, size: 28),
                                      SizedBox(height: 6),
                                      Text('Custom',
                                          style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 13)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          final p = presets[i];
                          final isActive = session.targetCount == p['count'];
                          return GestureDetector(
                            onTap: () {
                              ref.read(japSessionProvider.notifier).setTarget(p['count']);
                              Navigator.pop(context);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: isActive
                                    ? AppColors.gold.withOpacity(0.15)
                                    : (isDark ? AppColors.darkCard : AppColors.lightCard),
                                border: Border.all(
                                  color: isActive ? AppColors.gold : AppColors.gold.withOpacity(0.15),
                                  width: isActive ? 1.5 : 1,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(p['emoji'], style: const TextStyle(fontSize: 22)),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(p['label'],
                                                style: TextStyle(
                                                  color: isActive ? AppColors.gold : (isDark ? AppColors.textCream : AppColors.textDark),
                                                  fontFamily: 'Cinzel', fontSize: 15, fontWeight: FontWeight.bold,
                                                )),
                                            Text(p['subtitle'],
                                                style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isActive)
                                    const Positioned(
                                      top: 10, right: 10,
                                      child: Icon(Icons.check_circle, color: AppColors.gold, size: 18),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final stats = ref.watch(statsProvider);
    final isDark = ref.watch(settingsProvider).isDarkMode;
    final unlocked = achievements.where((a) => a.isUnlocked).length;

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
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Achievements',
                        style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 20)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.gold.withOpacity(0.12),
                        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                      ),
                      child: Text('$unlocked/${achievements.length}',
                          style: const TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 13)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: unlocked / achievements.length,
                    backgroundColor: AppColors.gold.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: achievements.length,
                  itemBuilder: (ctx, i) {
                    final a = achievements[i];
                    final current = a.type == AchievementType.totalChants
                        ? stats.totalChants
                        : stats.currentStreak;
                    final pct = (current / a.requiredCount).clamp(0.0, 1.0);
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: a.isUnlocked
                                ? AppColors.gold.withOpacity(0.1)
                                : (isDark ? AppColors.darkCard : AppColors.lightCard),
                            border: Border.all(
                              color: a.isUnlocked
                                  ? AppColors.gold.withOpacity(0.5)
                                  : AppColors.gold.withOpacity(0.1),
                              width: a.isUnlocked ? 1.5 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60, height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: a.isUnlocked
                                        ? AppColors.gold.withOpacity(0.15)
                                        : AppColors.darkElevated,
                                    border: Border.all(
                                      color: a.isUnlocked
                                          ? AppColors.gold.withOpacity(0.4)
                                          : AppColors.gold.withOpacity(0.08),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(a.emoji, style: const TextStyle(fontSize: 28))),
                                ),
                                const SizedBox(height: 10),
                                Text(a.title,
                                    style: TextStyle(
                                      color: a.isUnlocked ? AppColors.gold : AppColors.textMuted,
                                      fontFamily: 'Cinzel', fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center),
                                const SizedBox(height: 4),
                                Text(a.description,
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 10),
                                if (!a.isUnlocked) ...[
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      backgroundColor: AppColors.gold.withOpacity(0.08),
                                      valueColor: AlwaysStoppedAnimation(
                                          AppColors.gold.withOpacity(0.5)),
                                      minHeight: 4,
                                    ),
                                  ),
                               

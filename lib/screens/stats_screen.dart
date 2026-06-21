import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statsProvider);
    final isDark = ref.watch(settingsProvider).isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBgGradient : null,
          color: isDark ? null : AppColors.lightBg,
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                title: Text('Statistics', style: Theme.of(context).textTheme.titleLarge),
                centerTitle: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Hero stats
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: _cardDeco(isDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [
                            Icon(Icons.auto_awesome, color: AppColors.gold, size: 18),
                            SizedBox(width: 8),
                            Text('Overview', style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 14)),
                          ]),
                          const SizedBox(height: 20),
                          Row(children: [
                            Expanded(child: _BigStat(label: 'Total', value: _fmt(stats.totalChants), color: AppColors.gold)),
                            const SizedBox(width: 12),
                            Expanded(child: _BigStat(label: 'Today', value: '${stats.todayCount}', color: AppColors.saffron)),
                          ]),
                          const SizedBox(height: 12),
                          Row(children: [
                            Expanded(child: _BigStat(label: 'This Week', value: _fmt(stats.weekCount), color: AppColors.chakra)),
                            const SizedBox(width: 12),
                            Expanded(child: _BigStat(label: 'This Month', value: _fmt(stats.monthCount), color: AppColors.lotus)),
                          ]),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 20),

                    // Weekly chart
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: _cardDeco(isDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [
                            Icon(Icons.bar_chart_rounded, color: AppColors.gold, size: 18),
                            SizedBox(width: 8),
                            Text('Last 7 Days', style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 14)),
                          ]),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 180,
                            child: _buildChart(stats),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                    const SizedBox(height: 20),

                    // Streak
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: _cardDeco(isDark),
                      child: Column(
                        children: [
                          const Row(children: [
                            Icon(Icons.local_fire_department, color: AppColors.saffron, size: 18),
                            SizedBox(width: 8),
                            Text('Streak', style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 14)),
                          ]),
                          const SizedBox(height: 20),
                          Row(children: [
                            Expanded(child: Column(children: [
                              Text('${stats.currentStreak}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.saffron, fontFamily: 'Cinzel')),
                              const Text('Current', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              const Text('🔥', style: TextStyle(fontSize: 20)),
                            ])),
                            Container(width: 1, height: 80, color: AppColors.gold.withOpacity(0.2)),
                            Expanded(child: Column(children: [
                              Text('${stats.bestStreak}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.gold, fontFamily: 'Cinzel')),
                              const Text('Best', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              const Text('👑', style: TextStyle(fontSize: 20)),
                            ])),
                          ]),
                          const SizedBox(height: 16),
                          _buildStreakCalendar(stats, isDark),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: 20),

                    // Time stats
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: _cardDeco(isDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [
                            Icon(Icons.access_time_rounded, color: AppColors.gold, size: 18),
                            SizedBox(width: 8),
                            Text('Time', style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 14)),
                          ]),
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(child: _InfoTile(label: 'Total Time', value: '${stats.totalSessionMinutes ~/ 60}h ${stats.totalSessionMinutes % 60}m', icon: '⏱️')),
                            const SizedBox(width: 12),
                            Expanded(child: _InfoTile(label: 'Daily Avg', value: stats.averageDailyChants.toStringAsFixed(0), icon: '📊')),
                          ]),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(stats) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return (stats.dailyCounts[key] ?? 0).toDouble();
    });
    final maxY = days.reduce((a, b) => a > b ? a : b);
    final chartMax = maxY <= 0 ? 200.0 : maxY * 1.3;
    const dayLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
    final now2 = DateTime.now();

    return BarChart(BarChartData(
      maxY: chartMax,
      gridData: FlGridData(
        show: true,
        horizontalInterval: chartMax / 4,
        getDrawingHorizontalLine: (_) => FlLine(color: AppColors.gold.withOpacity(0.1), strokeWidth: 1),
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final idx = value.toInt();
            if (idx < 0 || idx >= 7) return const SizedBox();
            final date = now2.subtract(Duration(days: 6 - idx));
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(dayLabels[date.weekday % 7], style: const TextStyle(color: AppColors.textMuted, fontSize: 10, fontFamily: 'Cinzel')),
            );
          },
        )),
        leftTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 36,
          getTitlesWidget: (value, meta) => Text(_fmt(value.toInt()), style: const TextStyle(color: AppColors.textMuted, fontSize: 9)),
        )),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(7, (i) => BarChartGroupData(
        x: i,
        barRods: [BarChartRodData(
          toY: days[i],
          gradient: const LinearGradient(colors: [AppColors.saffron, AppColors.gold], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(show: true, toY: chartMax, color: AppColors.gold.withOpacity(0.06)),
        )],
      )),
    ));
  }

  Widget _buildStreakCalendar(stats, bool isDark) {
    final now = DateTime.now();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(28, (i) {
        final date = now.subtract(Duration(days: 27 - i));
        final key = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final hasChants = (stats.dailyCounts[key] ?? 0) > 0;
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: hasChants ? AppColors.gold.withOpacity(0.7) : (isDark ? AppColors.darkElevated : AppColors.lightElevated),
            border: Border.all(color: hasChants ? AppColors.gold : AppColors.gold.withOpacity(0.1)),
          ),
          child: hasChants ? const Center(child: Text('🙏', style: TextStyle(fontSize: 12))) : null,
        );
      }),
    );
  }

  BoxDecoration _cardDeco(bool isDark) => BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    color: isDark ? AppColors.darkCard : AppColors.lightCard,
    border: Border.all(color: AppColors.gold.withOpacity(0.15)),
  );

  static String _fmt(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _BigStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _BigStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Cinzel')),
      ]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _InfoTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.gold.withOpacity(0.07),
        border: Border.all(color: AppColors.gold.withOpacity(0.15)),
      ),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 26)),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 14, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        ]),
      ]),
    );
  }
}

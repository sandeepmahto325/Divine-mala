import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'mantra_selector_screen.dart';
import 'goal_achievement_screens.dart';

class CounterScreen extends ConsumerStatefulWidget {
  const CounterScreen({super.key});

  @override
  ConsumerState<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends ConsumerState<CounterScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late ConfettiController _confettiController;
  int _lastTappedBead = -1;
  bool _showGoalComplete = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      if (settings.keepScreenAwake) WakelockPlus.enable();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _confettiController.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _onTap() {
    final session = ref.read(japSessionProvider);
    if (session.isCompleted) return;
    ref.read(japSessionProvider.notifier).increment();
    _pulseController.forward().then((_) => _pulseController.reverse());
    final newSession = ref.read(japSessionProvider);
    setState(() {
      _lastTappedBead = newSession.currentBeadIndex > 0
          ? newSession.currentBeadIndex - 1
          : 107;
    });
    if (newSession.isCompleted && !_showGoalComplete) {
      setState(() => _showGoalComplete = true);
      _confettiController.play();
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [AppColors.darkCard, AppColors.darkElevated],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🙏', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('Jai Shri!',
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'You completed ${ref.read(japSessionProvider).count} chants',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.saffron),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(japSessionProvider.notifier).reset();
                        setState(() => _showGoalComplete = false);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.gold),
                        foregroundColor: AppColors.gold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ref.read(japSessionProvider.notifier).reset();
                        setState(() => _showGoalComplete = false);
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(japSessionProvider);
    final settings = ref.watch(settingsProvider);
    final mantra = ref.watch(selectedMantraProvider);
    final isDark = settings.isDarkMode;

    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF0A0700), Color(0xFF150F02), Color(0xFF0A0700)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFFFFF8E7), Color(0xFFFFF3CC), Color(0xFFFFF8E7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [AppColors.gold, AppColors.saffron, Colors.white],
                numberOfParticles: 30,
                gravity: 0.2,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _GlassChip(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, color: AppColors.gold, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                _formatDuration(session.elapsed),
                                style: const TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Text('Divine Mala',
                            style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 16, letterSpacing: 3)),
                        _GlassChip(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('📿', style: TextStyle(fontSize: 12)),
                              const SizedBox(width: 4),
                              Text('×${session.malaCount}',
                                  style: const TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Mantra display
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MantraSelectorScreen())),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                        color: isDark
                            ? AppColors.darkCard.withOpacity(0.6)
                            : AppColors.lightCard.withOpacity(0.8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            mantra.sanskritText.split('\n').first,
                            style: const TextStyle(fontSize: 16, color: AppColors.gold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(mantra.name,
                                  style: const TextStyle(color: AppColors.saffron, fontSize: 12)),
                              const Icon(Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.saffron, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mala circle
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = math.min(constraints.maxWidth, constraints.maxHeight);
                        return Center(
                          child: SizedBox(
                            width: size,
                            height: size,
                            child: CustomPaint(
                              painter: MalaPainter(
                                beadsFilled: session.beadsFilled,
                                currentBeadIndex: session.currentBeadIndex,
                                lastTappedBead: _lastTappedBead,
                                isDark: isDark,
                                beadStyle: settings.beadStyle,
                              ),
                              child: Center(
                                child: ScaleTransition(
                                  scale: Tween<double>(begin: 1.0, end: 1.05).animate(
                                    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${session.count}',
                                        style: TextStyle(
                                          fontSize: size * 0.18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.gold,
                                          fontFamily: 'Cinzel',
                                        ),
                                      ),
                                      Text(
                                        'of ${session.targetCount}',
                                        style: TextStyle(
                                          fontSize: size * 0.045,
                                          color: AppColors.textMuted,
                                          fontFamily: 'Cinzel',
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: size * 0.2,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: session.progress.clamp(0.0, 1.0),
                                            backgroundColor: AppColors.gold.withOpacity(0.15),
                                            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                                            minHeight: 3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${(session.progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                                        style: TextStyle(fontSize: size * 0.03, color: AppColors.saffron, fontFamily: 'Cinzel'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Mini stats
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      children: [
                        Expanded(child: _StatMiniCard(label: 'Today', value: '${ref.watch(statsProvider).todayCount}', icon: Icons.wb_sunny_outlined, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatMiniCard(label: 'Streak', value: '${ref.watch(statsProvider).currentStreak}d', icon: Icons.local_fire_department_outlined, isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(child: _StatMiniCard(label: 'Total', value: '${ref.watch(statsProvider).totalChants}', icon: Icons.stars_outlined, isDark: isDark)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _CircleButton(
                          icon: Icons.refresh_rounded,
                          onTap: () => showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.darkCard,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              title: Text('Reset?', style: Theme.of(context).textTheme.titleMedium),
                              content: const Text('Current session will be saved.'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ref.read(japSessionProvider.notifier).reset();
                                  },
                                  child: const Text('Reset'),
                                ),
                              ],
                            ),
                          ),
                          isDark: isDark,
                        ),
                        GestureDetector(
                          onTap: _onTap,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.saffron, AppColors.gold],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(color: AppColors.gold.withOpacity(0.4), blurRadius: 20, spreadRadius: 4),
                              ],
                            ),
                            child: const Icon(Icons.touch_app_rounded, color: Colors.white, size: 36),
                          ),
                        ).animate(onPlay: (c) => c.repeat(reverse: true))
                            .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 1500.ms),
                        _CircleButton(
                          icon: Icons.flag_outlined,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const GoalScreen())),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class MalaPainter extends CustomPainter {
  final List<bool> beadsFilled;
  final int currentBeadIndex;
  final int lastTappedBead;
  final bool isDark;
  final String beadStyle;
  static const int beadCount = 108;

  MalaPainter({
    required this.beadsFilled,
    required this.currentBeadIndex,
    required this.lastTappedBead,
    required this.isDark,
    required this.beadStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    final beadRadius = size.width * 0.025;

    for (int i = 0; i < beadCount; i++) {
      final angle = (i / beadCount) * 2 * math.pi - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final beadCenter = Offset(x, y);

      if (i > 0) {
        final prevAngle = ((i - 1) / beadCount) * 2 * math.pi - math.pi / 2;
        canvas.drawLine(
          Offset(center.dx + radius * math.cos(prevAngle), center.dy + radius * math.sin(prevAngle)),
          beadCenter,
          Paint()..color = AppColors.gold.withOpacity(0.2)..strokeWidth = 1,
        );
      }

      final isFilled = beadsFilled[i];
      final isLastTapped = i == lastTappedBead;

      if (isLastTapped) {
        canvas.drawCircle(beadCenter, beadRadius * 2.5,
            Paint()..color = AppColors.gold.withOpacity(0.15)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      }

      canvas.drawCircle(
        beadCenter,
        beadRadius,
        isFilled
            ? (Paint()..shader = RadialGradient(
                colors: [AppColors.goldLight, AppColors.gold],
              ).createShader(Rect.fromCircle(center: beadCenter, radius: beadRadius)))
            : (Paint()..color = isDark ? AppColors.darkElevated : AppColors.lightElevated),
      );

      canvas.drawCircle(beadCenter, beadRadius,
      

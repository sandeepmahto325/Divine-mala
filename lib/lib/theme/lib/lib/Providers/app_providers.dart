import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/audio_service.dart';
import '../services/haptic_service.dart';

// ─── Settings Provider ────────────────────────────────────────────────────────
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      isDarkMode: prefs.getBool('isDarkMode') ?? true,
      vibrationEnabled: prefs.getBool('vibrationEnabled') ?? true,
      soundEnabled: prefs.getBool('soundEnabled') ?? true,
      soundType: prefs.getString('soundType') ?? 'bell',
      selectedMantraId: prefs.getString('selectedMantraId') ?? 'hare_krishna',
      defaultTarget: prefs.getInt('defaultTarget') ?? 108,
      keepScreenAwake: prefs.getBool('keepScreenAwake') ?? true,
      beadStyle: prefs.getString('beadStyle') ?? 'rudraksha',
      accentColor: prefs.getString('accentColor') ?? '#D4AF37',
      backgroundMusicEnabled: prefs.getBool('backgroundMusicEnabled') ?? false,
      backgroundTheme: prefs.getString('backgroundTheme') ?? 'dark_gold',
      isPremium: prefs.getBool('isPremium') ?? false,
    );
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state.isDarkMode);
    await prefs.setBool('vibrationEnabled', state.vibrationEnabled);
    await prefs.setBool('soundEnabled', state.soundEnabled);
    await prefs.setString('soundType', state.soundType);
    await prefs.setString('selectedMantraId', state.selectedMantraId);
    await prefs.setInt('defaultTarget', state.defaultTarget);
    await prefs.setBool('keepScreenAwake', state.keepScreenAwake);
    await prefs.setString('beadStyle', state.beadStyle);
    await prefs.setString('accentColor', state.accentColor);
    await prefs.setBool('backgroundMusicEnabled', state.backgroundMusicEnabled);
    await prefs.setString('backgroundTheme', state.backgroundTheme);
    await prefs.setBool('isPremium', state.isPremium);
  }

  void toggleDarkMode() {
    state = AppSettings(
      isDarkMode: !state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void setMantra(String mantraId) {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: mantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void setTarget(int target) {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: target,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void toggleVibration() {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: !state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void toggleSound() {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: !state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void setSoundType(String type) {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: type,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void setBeadStyle(String style) {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: style,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void setBackgroundTheme(String theme) {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: theme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void toggleBackgroundMusic() {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: !state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: state.isPremium,
    );
    _save();
  }

  void setPremium(bool value) {
    state = AppSettings(
      isDarkMode: state.isDarkMode,
      vibrationEnabled: state.vibrationEnabled,
      soundEnabled: state.soundEnabled,
      soundType: state.soundType,
      selectedMantraId: state.selectedMantraId,
      defaultTarget: state.defaultTarget,
      keepScreenAwake: state.keepScreenAwake,
      beadStyle: state.beadStyle,
      accentColor: state.accentColor,
      backgroundMusicEnabled: state.backgroundMusicEnabled,
      backgroundTheme: state.backgroundTheme,
      isPremium: value,
    );
    _save();
  }
}

// ─── Jap Session Provider ─────────────────────────────────────────────────────
class JapSessionState {
  final int count;
  final int targetCount;
  final bool isActive;
  final DateTime? startTime;
  final int currentBeadIndex;
  final int malaCount;
  final List<bool> beadsFilled;
  final bool isCompleted;

  JapSessionState({
    this.count = 0,
    this.targetCount = 108,
    this.isActive = false,
    this.startTime,
    this.currentBeadIndex = 0,
    this.malaCount = 0,
    List<bool>? beadsFilled,
    this.isCompleted = false,
  }) : beadsFilled = beadsFilled ?? List.filled(108, false);

  double get progress => count / targetCount;
  Duration get elapsed =>
      startTime != null ? DateTime.now().difference(startTime!) : Duration.zero;

  JapSessionState copyWith({
    int? count,
    int? targetCount,
    bool? isActive,
    DateTime? startTime,
    int? currentBeadIndex,
    int? malaCount,
    List<bool>? beadsFilled,
    bool? isCompleted,
  }) {
    return JapSessionState(
      count: count ?? this.count,
      targetCount: targetCount ?? this.targetCount,
      isActive: isActive ?? this.isActive,
      startTime: startTime ?? this.startTime,
      currentBeadIndex: currentBeadIndex ?? this.currentBeadIndex,
      malaCount: malaCount ?? this.malaCount,
      beadsFilled: beadsFilled ?? List.from(this.beadsFilled),
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

final japSessionProvider =
    StateNotifierProvider<JapSessionNotifier, JapSessionState>((ref) {
  return JapSessionNotifier(ref);
});

class JapSessionNotifier extends StateNotifier<JapSessionState> {
  final Ref _ref;
  Timer? _elapsedTimer;

  JapSessionNotifier(this._ref) : super(JapSessionState());

  void increment() {
    final settings = _ref.read(settingsProvider);

    if (settings.vibrationEnabled) HapticService.lightImpact();
    if (settings.soundEnabled) AudioService.playTap(settings.soundType);

    final newCount = state.count + 1;
    final beadIndex = newCount % 108;
    final malaCount = newCount ~/ 108;

    final newBeads = List<bool>.filled(108, false);
    final filledCount = beadIndex == 0 ? 108 : beadIndex;
    for (int i = 0; i < filledCount; i++) {
      newBeads[i] = true;
    }

    final isCompleted = newCount >= state.targetCount;

    if (beadIndex == 0 && newCount > 0) {
      HapticService.mediumImpact();
      AudioService.playMalaComplete();
    }

    if (isCompleted) {
      HapticService.heavyImpact();
      AudioService.playGoalComplete();
      _ref.read(statsProvider.notifier).addChants(newCount, settings.selectedMantraId);
    }

    state = state.copyWith(
      count: newCount,
      currentBeadIndex: beadIndex,
      malaCount: malaCount,
      beadsFilled: newBeads,
      isCompleted: isCompleted,
      isActive: true,
      startTime: state.startTime ?? DateTime.now(),
    );

    _saveSession();
  }

  void reset() {
    _elapsedTimer?.cancel();
    state = JapSessionState(targetCount: state.targetCount);
    _saveSession();
  }

  void setTarget(int target) {
    state = state.copyWith(targetCount: target);
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('session_count', state.count);
    await prefs.setInt('session_target', state.targetCount);
  }

  @override
  void dispose() {
    _elapsedTimer?.cancel();
    super.dispose();
  }
}

// ─── Stats Provider ───────────────────────────────────────────────────────────
final statsProvider =
    StateNotifierProvider<StatsNotifier, UserStats>((ref) {
  return StatsNotifier();
});

class StatsNotifier extends StateNotifier<UserStats> {
  StatsNotifier() : super(UserStats());

  void addChants(int count, String mantraId) {
    state.addChants(count, mantraId);
    state = UserStats(
      totalChants: state.totalChants,
      currentStreak: state.currentStreak,
      bestStreak: state.bestStreak,
      totalSessionMinutes: state.totalSessionMinutes,
      lastChantDate: state.lastChantDate,
      dailyCounts: state.dailyCounts,
      mantraCounts: state.mantraCounts,
    );
  }
}

// ─── Mantras Provider ─────────────────────────────────────────────────────────
final mantrasProvider = Provider<List<Mantra>>((ref) {
  return PreloadedMantras.all;
});

final selectedMantraProvider = Provider<Mantra>((ref) {
  final settings = ref.watch(settingsProvider);
  final mantras = ref.watch(mantrasProvider);
  return mantras.firstWhere(
    (m) => m.id == settings.selectedMantraId,
    orElse: () => mantras.first,
  );
});

// ─── Achievements Provider ────────────────────────────────────────────────────
final achievementsProvider =
    StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  return AchievementsNotifier(ref);
});

class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final Ref _ref;

  AchievementsNotifier(this._ref) : super(Achievement.defaults);

  void refreshAchievements() {
    final stats = _ref.read(statsProvider);
    final updated = state.map((a) {
      if (!a.isUnlocked) {
        bool shouldUnlock = false;
        if (a.type == AchievementType.totalChants &&
            stats.totalChants >= a.requiredCount) {
          shouldUnlock = true;
        } else if (a.type == AchievementType.streak &&
            stats.currentStreak >= a.requiredCount) {
          shouldUnlock = true;
        }
        if (shouldUnlock) {
          return Achievement(
            id: a.id,
            title: a.title,
            description: a.description,
            emoji: a.emoji,
            requiredCount: a.requiredCount,
            type: a.type,
            isUnlocked: true,
            unlockedAt: DateTime.now(),
          );
        }
      }
      return a;
    }).toList();
    state = updated;
  }
}

final authProvider = StateProvider<String?>((ref) => null);

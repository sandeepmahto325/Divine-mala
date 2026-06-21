import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isDark = settings.isDarkMode;
    final notifier = ref.read(settingsProvider.notifier);

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
                title: const Text('Settings',
                    style: TextStyle(color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 20)),
                centerTitle: true,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _SectionHeader(title: 'APPEARANCE', emoji: '🎨'),
                    _Card(isDark: isDark, children: [
                      _SwitchTile(
                        title: 'Dark Mode',
                        subtitle: 'Easier on eyes at night',
                        icon: Icons.dark_mode_outlined,
                        value: settings.isDarkMode,
                        onChanged: (_) => notifier.toggleDarkMode(),
                      ),
                      _Divider(),
                      _OptionTile(
                        title: 'Bead Style',
                        icon: Icons.circle_outlined,
                        isDark: isDark,
                        options: const ['rudraksha', 'crystal', 'lotus', 'gold'],
                        labels: const ['Rudraksha', 'Crystal', 'Lotus', 'Gold'],
                        selected: settings.beadStyle,
                        onSelect: notifier.setBeadStyle,
                      ),
                    ]),
                    _SectionHeader(title: 'SOUND & HAPTICS', emoji: '🔔'),
                    _Card(isDark: isDark, children: [
                      _SwitchTile(
                        title: 'Vibration',
                        subtitle: 'Gentle vibration on each chant',
                        icon: Icons.vibration_outlined,
                        value: settings.vibrationEnabled,
                        onChanged: (_) => notifier.toggleVibration(),
                      ),
                      _Divider(),
                      _SwitchTile(
                        title: 'Sound Effects',
                        subtitle: 'Play sound on each count',
                        icon: Icons.music_note_outlined,
                        value: settings.soundEnabled,
                        onChanged: (_) => notifier.toggleSound(),
                      ),
                      if (settings.soundEnabled) ...[
                        _Divider(),
                        _OptionTile(
                          title: 'Sound Type',
                          icon: Icons.hearing_outlined,
                          isDark: isDark,
                          options: const ['bell', 'om', 'beads', 'silent'],
                          labels: const ['Temple Bell 🔔', 'Om Chant 🕉️', 'Beads 📿', 'Silent 🤫'],
                          selected: settings.soundType,
                          onSelect: notifier.setSoundType,
                        ),
                      ],
                      _Divider(),
                      _SwitchTile(
                        title: 'Background Music',
                        subtitle: 'Soft meditation music',
                        icon: Icons.headphones_outlined,
                        value: settings.backgroundMusicEnabled,
                        onChanged: (_) => notifier.toggleBackgroundMusic(),
                        isPremiumLocked: !settings.isPremium,
                      ),
                    ]),
                    _SectionHeader(title: 'SESSION', emoji: '⚙️'),
                    _Card(isDark: isDark, children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold.withOpacity(0.1)),
                          child: const Icon(Icons.flag_outlined,
                              color: AppColors.gold, size: 18),
                        ),
                        title: Text('Default Target',
                            style: TextStyle(
                                color: isDark ? AppColors.textCream : AppColors.textDark)),
                        subtitle: Text('${settings.defaultTarget} chants',
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12)),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textMuted),
                        onTap: () => _showTargetPicker(
                            context, settings.defaultTarget, notifier.setTarget, isDark),
                      ),
                    ]),
                    _SectionHeader(title: 'REMINDERS', emoji: '🔔'),
                    _Card(isDark: isDark, children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold.withOpacity(0.1)),
                          child: const Icon(Icons.alarm_outlined,
                              color: AppColors.gold, size: 18),
                        ),
                        title: Text('Daily Reminder',
                            style: TextStyle(
                                color: isDark ? AppColors.textCream : AppColors.textDark)),
                        subtitle: const Text('Set time for chanting reminder',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        trailing: const Icon(Icons.chevron_right,
                            color: AppColors.textMuted),
                        onTap: () => _setReminder(context),
                      ),
                    ]),
                    if (!settings.isPremium) ...[
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A1F00), Color(0xFF3D2D00)],
                          ),
                          border: Border.all(
                              color: AppColors.gold.withOpacity(0.4), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Text('👑', style: TextStyle(fontSize: 36)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Upgrade to Premium',
                                      style: TextStyle(
                                          color: AppColors.gold,
                                          fontFamily: 'Cinzel',
                                          fontSize: 14)),
                                  SizedBox(height: 4),
                                  Text('Unlock all themes & cloud backup',
                                      style: TextStyle(
                                          color: AppColors.textMuted,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('₹299/yr',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                    _SectionHeader(title: 'ABOUT', emoji: 'ℹ️'),
                    _Card(isDark: isDark, children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold.withOpacity(0.1)),
                          child: const Icon(Icons.info_outline,
                              color: AppColors.gold, size: 18),
                        ),
                        title: Text('Version',
                            style: TextStyle(
                                color: isDark ? AppColors.textCream : AppColors.textDark)),
                        trailing: const Text('1.0.0',
                            style: TextStyle(color: AppColors.textMuted)),
                      ),
                      _Divider(),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.gold.withOpacity(0.1)),
                          child: const Icon(Icons.star_outline,
                              color: AppColors.gold, size: 18),
                        ),
                        title: Text('Rate Us',
                            style: TextStyle(
                                color: isDark ? AppColors.textCream : AppColors.textDark)),
                        subtitle: const Text('Spread the divine word 🙏',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        trailing: const Icon(Icons.open_in_new,
                            color: AppColors.textMuted, size: 16),
                        onTap: () {},
                      ),
                    ]),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        '🕉️  Divine Mala  🕉️\nMay your chanting bring peace & liberation',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textMuted,
                            height: 1.8,
                            letterSpacing: 0.5,
                            fontSize: 12),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTargetPicker(BuildContext context, int current,
      Function(int) onSet, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Default Target',
                style: TextStyle(
                    color: AppColors.gold, fontFamily: 'Cinzel', fontSize: 16)),
            const SizedBox(height: 16),
            for (final t in [108, 216, 1008, 10008])
              ListTile(
                title: Text('$t chants',
                    style: TextStyle(
                        color: isDark ? AppColors.textCream : AppColors.textDark)),
                trailing: t == current
                    ? const Icon(Icons.check, color: AppColors.gold)
                    : null,
                onTap: () {
                  onSet(t);
                  Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _setReminder(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 7, minute: 0),
    );
    if (picked != null && context.mounted) {
      await NotificationService.scheduleDailyReminder(
        hour: picked.hour,
        minute: picked.minute,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder set for ${picked.format(context)} 🙏'),
          backgroundColor: AppColors.darkCard,
        ),
      );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String emoji;
  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 0, 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(title,
              style: const TextStyle(
                  color: AppColors.saffron,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                  fontSize: 11)),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;
  const _Card({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        border: Border.all(color: AppColors.gold.withOpacity(0.12)),
      ),
      child: Column(children: children),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;
  final bool isPremiumLocked;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.isPremiumLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppColors.gold.withOpacity(0.1)),
        child: Icon(icon, color: AppColors.gold, size: 18),
      ),
      title: Row(children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        if (isPremiumLocked) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.gold.withOpacity(0.15)),
            child: const Text('PRO',
                style: TextStyle(
                    fontSize: 8,
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ]),
      subtitle: Text(subtitle,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
      trailing: Switch(
        value: isPremiumLocked ? false : value,
        onChanged: isPremiumLocked ? null : onChanged,
        activeColor: AppColors.gold,
        activeTrackColor: AppColors.gold.withOpacity(0.3),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;
  final List<String> options;
  final List<String> labels;
  final String selected;
  final Function(String) onSelect;

  const _OptionTile({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final selectedLabel =
        labels[options.indexOf(selected).clamp(0, labels.length - 1)];
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppColors.gold.withOpacity(0.1)),
        child: Icon(icon, color: AppColors.gold, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(selectedLabel,
            style: const TextStyle(color: AppColors.gold, fontSize: 11)),
        const SizedBox(width: 4),
        const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
      ]),
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: AppColors.gold,
                      fontFamily: 'Cinzel',
                      fontSize: 16)),
              const SizedBox(height: 12),
              ...List.generate(
                options.length,
                (i) => ListTile(
                  title: Text(labels[i],
                      style: TextStyle(
                          color: isDark
                              ? AppColors.textCream
                              : AppColors.textDark)),
                  trailing: options[i] == selected
                      ? const Icon(Icons.check, color: AppColors.gold)
                      : null,
                  onTap: () {
                    onSelect(options[i]);
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 1,
        color: AppColors.gold.withOpacity(0.08),
        indent: 20,
        endIndent: 20);
  }
}

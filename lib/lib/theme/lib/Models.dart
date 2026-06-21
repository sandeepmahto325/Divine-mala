class Mantra {
  final String id;
  final String name;
  final String sanskritText;
  final String transliteration;
  final String meaning;
  final String deity;
  final bool isCustom;
  final String? audioAsset;

  Mantra({
    required this.id,
    required this.name,
    required this.sanskritText,
    required this.transliteration,
    required this.meaning,
    required this.deity,
    this.isCustom = false,
    this.audioAsset,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sanskritText': sanskritText,
        'transliteration': transliteration,
        'meaning': meaning,
        'deity': deity,
        'isCustom': isCustom,
        'audioAsset': audioAsset,
      };

  factory Mantra.fromJson(Map<String, dynamic> json) => Mantra(
        id: json['id'],
        name: json['name'],
        sanskritText: json['sanskritText'],
        transliteration: json['transliteration'],
        meaning: json['meaning'],
        deity: json['deity'],
        isCustom: json['isCustom'] ?? false,
        audioAsset: json['audioAsset'],
      );
}

class JapSession {
  final String id;
  final String mantraId;
  final DateTime startTime;
  DateTime? endTime;
  int count;
  int targetCount;
  bool isCompleted;

  JapSession({
    required this.id,
    required this.mantraId,
    required this.startTime,
    this.endTime,
    this.count = 0,
    this.targetCount = 108,
    this.isCompleted = false,
  });

  Duration get duration =>
      (endTime ?? DateTime.now()).difference(startTime);

  double get progress => count / targetCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'mantraId': mantraId,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime?.toIso8601String(),
        'count': count,
        'targetCount': targetCount,
        'isCompleted': isCompleted,
      };

  factory JapSession.fromJson(Map<String, dynamic> json) => JapSession(
        id: json['id'],
        mantraId: json['mantraId'],
        startTime: DateTime.parse(json['startTime']),
        endTime: json['endTime'] != null
            ? DateTime.parse(json['endTime'])
            : null,
        count: json['count'] ?? 0,
        targetCount: json['targetCount'] ?? 108,
        isCompleted: json['isCompleted'] ?? false,
      );
}

class UserStats {
  int totalChants;
  int currentStreak;
  int bestStreak;
  int totalSessionMinutes;
  DateTime? lastChantDate;
  Map<String, int> dailyCounts;
  Map<String, int> mantraCounts;

  UserStats({
    this.totalChants = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.totalSessionMinutes = 0,
    this.lastChantDate,
    Map<String, int>? dailyCounts,
    Map<String, int>? mantraCounts,
  })  : dailyCounts = dailyCounts ?? {},
        mantraCounts = mantraCounts ?? {};

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  int get todayCount => dailyCounts[_dateKey(DateTime.now())] ?? 0;

  int get weekCount {
    int total = 0;
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      total += dailyCounts[_dateKey(now.subtract(Duration(days: i)))] ?? 0;
    }
    return total;
  }

  int get monthCount {
    int total = 0;
    final now = DateTime.now();
    for (int i = 0; i < 30; i++) {
      total += dailyCounts[_dateKey(now.subtract(Duration(days: i)))] ?? 0;
    }
    return total;
  }

  double get averageDailyChants {
    if (dailyCounts.isEmpty) return 0;
    final sum = dailyCounts.values.fold(0, (a, b) => a + b);
    return sum / dailyCounts.length;
  }

  void addChants(int count, String mantraId) {
    totalChants += count;
    final key = _dateKey(DateTime.now());
    dailyCounts[key] = (dailyCounts[key] ?? 0) + count;
    mantraCounts[mantraId] = (mantraCounts[mantraId] ?? 0) + count;
    lastChantDate = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        'totalChants': totalChants,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'totalSessionMinutes': totalSessionMinutes,
        'lastChantDate': lastChantDate?.toIso8601String(),
        'dailyCounts': dailyCounts,
        'mantraCounts': mantraCounts,
      };

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
        totalChants: json['totalChants'] ?? 0,
        currentStreak: json['currentStreak'] ?? 0,
        bestStreak: json['bestStreak'] ?? 0,
        totalSessionMinutes: json['totalSessionMinutes'] ?? 0,
        lastChantDate: json['lastChantDate'] != null
            ? DateTime.parse(json['lastChantDate'])
            : null,
        dailyCounts: Map<String, int>.from(json['dailyCounts'] ?? {}),
        mantraCounts: Map<String, int>.from(json['mantraCounts'] ?? {}),
      );
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int requiredCount;
  final AchievementType type;
  bool isUnlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.requiredCount,
    required this.type,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  static List<Achievement> get defaults => [
        Achievement(id: 'first_108', title: 'First Mala', description: 'Complete your first 108 chants', emoji: '📿', requiredCount: 108, type: AchievementType.totalChants),
        Achievement(id: 'chants_1000', title: 'Sadhak', description: 'Complete 1,000 chants', emoji: '🪔', requiredCount: 1000, type: AchievementType.totalChants),
        Achievement(id: 'chants_10000', title: 'Devotee', description: 'Complete 10,000 chants', emoji: '🙏', requiredCount: 10000, type: AchievementType.totalChants),
        Achievement(id: 'chants_100000', title: 'Bhakt', description: 'Complete 1 Lakh chants', emoji: '⭐', requiredCount: 100000, type: AchievementType.totalChants),
        Achievement(id: 'streak_7', title: 'Week Warrior', description: '7-day streak', emoji: '🔥', requiredCount: 7, type: AchievementType.streak),
        Achievement(id: 'streak_30', title: 'Dedicated Soul', description: '30-day streak', emoji: '🌟', requiredCount: 30, type: AchievementType.streak),
        Achievement(id: 'streak_108', title: 'Divine Path', description: '108-day streak', emoji: '🕉️', requiredCount: 108, type: AchievementType.streak),
      ];
}

enum AchievementType { totalChants, streak, sessionsCompleted }

class AppSettings {
  bool isDarkMode;
  bool vibrationEnabled;
  bool soundEnabled;
  String soundType;
  String selectedMantraId;
  int defaultTarget;
  bool keepScreenAwake;
  String beadStyle;
  String accentColor;
  bool backgroundMusicEnabled;
  String backgroundTheme;
  bool isPremium;

  AppSettings({
    this.isDarkMode = true,
    this.vibrationEnabled = true,
    this.soundEnabled = true,
    this.soundType = 'bell',
    this.selectedMantraId = 'hare_krishna',
    this.defaultTarget = 108,
    this.keepScreenAwake = true,
    this.beadStyle = 'rudraksha',
    this.accentColor = '#D4AF37',
    this.backgroundMusicEnabled = false,
    this.backgroundTheme = 'dark_gold',
    this.isPremium = false,
  });
}

class PreloadedMantras {
  static List<Mantra> get all => [
        Mantra(id: 'hare_krishna', name: 'Hare Krishna Maha Mantra', sanskritText: 'हरे कृष्ण हरे कृष्ण कृष्ण कृष्ण हरे हरे\nहरे राम हरे राम राम राम हरे हरे', transliteration: 'Hare Krishna Hare Krishna Krishna Krishna Hare Hare\nHare Rama Hare Rama Rama Rama Hare Hare', meaning: 'O Lord, O Energy of the Lord, please engage me in your devotional service', deity: 'Krishna'),
        Mantra(id: 'om_namah_shivaya', name: 'Om Namah Shivaya', sanskritText: 'ॐ नमः शिवाय', transliteration: 'Om Namah Shivaya', meaning: 'I bow to Shiva, the auspicious one', deity: 'Shiva'),
        Mantra(id: 'gayatri', name: 'Gayatri Mantra', sanskritText: 'ॐ भूर् भुवः स्वः\nतत् सवितुर् वरेण्यं\nभर्गो देवस्य धीमहि\nधियो यो नः प्रचोदयात्', transliteration: 'Om Bhur Bhuva Swah\nTat Savitur Varenyam\nBhargo Devasya Dheemahi\nDhiyo Yo Nah Prachodayat', meaning: 'We meditate on the glory of the Creator', deity: 'Surya'),
        Mantra(id: 'radhe_radhe', name: 'Radhe Radhe', sanskritText: 'राधे राधे', transliteration: 'Radhe Radhe', meaning: 'Calling upon Radha, the divine feminine energy', deity: 'Radha'),
        Mantra(id: 'om', name: 'Om', sanskritText: 'ॐ', transliteration: 'Om', meaning: 'The primordial sound of the universe', deity: 'Universal'),
        Mantra(id: 'ganesh', name: 'Ganesh Mantra', sanskritText: 'ॐ गं गणपतये नमः', transliteration: 'Om Gam Ganapataye Namah', meaning: 'I bow to Lord Ganesha, the remover of obstacles', deity: 'Ganesha'),
      ];
}

class SpiritualQuotes {
  static List<Map<String, String>> get all => [
        {'quote': 'The mind is everything. What you think you become.', 'author': 'Buddha'},
        {'quote': 'You have the right to perform your actions, but you are not entitled to the fruits.', 'author': 'Bhagavad Gita 2.47'},
        {'quote': 'When you chant with love, the Lord listens.', 'author': 'Swami Prabhupada'},
        {'quote': 'Naam Jap is the boat that takes you across the ocean of existence.', 'author': 'Guru Granth Sahib'},
        {'quote': 'God dwells within you as you.', 'author': 'Swami Muktananda'},
      ];

  static Map<String, String> get random {
    all.shuffle();
    return all.first;
  }
}

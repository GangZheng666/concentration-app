import 'dart:convert';

enum AchievementType {
  focusTime,
  streak,
  sessions,
  level,
  special,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int requirement;
  final int rewardXp;
  bool isUnlocked;
  DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.requirement,
    this.rewardXp = 50,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'type': type.index,
    'requirement': requirement,
    'rewardXp': rewardXp,
    'isUnlocked': isUnlocked ? 1 : 0,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    icon: json['icon'],
    type: AchievementType.values[json['type']],
    requirement: json['requirement'],
    rewardXp: json['rewardXp'] ?? 50,
    isUnlocked: json['isUnlocked'] == 1,
    unlockedAt: json['unlockedAt'] != null 
        ? DateTime.parse(json['unlockedAt']) 
        : null,
  );

  String toJsonString() => jsonEncode(toJson());

  factory Achievement.fromJsonString(String jsonString) => 
      Achievement.fromJson(jsonDecode(jsonString));

  static List<Achievement> getAllAchievements() {
    return [
      Achievement(
        id: 'first_focus',
        name: '初次专注',
        description: '完成第一次专注',
        icon: '🌱',
        type: AchievementType.sessions,
        requirement: 1,
        rewardXp: 20,
      ),
      Achievement(
        id: 'ten_sessions',
        name: '专注达人',
        description: '完成10次专注',
        icon: '🎯',
        type: AchievementType.sessions,
        requirement: 10,
        rewardXp: 50,
      ),
      Achievement(
        id: 'fifty_sessions',
        name: '专注王者',
        description: '完成50次专注',
        icon: '👑',
        type: AchievementType.sessions,
        requirement: 50,
        rewardXp: 100,
      ),
      Achievement(
        id: 'hundred_sessions',
        name: '专注传奇',
        description: '完成100次专注',
        icon: '🏆',
        type: AchievementType.sessions,
        requirement: 100,
        rewardXp: 200,
      ),
      Achievement(
        id: 'one_hour',
        name: '一小时战士',
        description: '累计专注1小时',
        icon: '⏰',
        type: AchievementType.focusTime,
        requirement: 60,
        rewardXp: 30,
      ),
      Achievement(
        id: 'ten_hours',
        name: '十小时大师',
        description: '累计专注10小时',
        icon: '⌛',
        type: AchievementType.focusTime,
        requirement: 600,
        rewardXp: 100,
      ),
      Achievement(
        id: 'fifty_hours',
        name: '五十小时传奇',
        description: '累计专注50小时',
        icon: '🌟',
        type: AchievementType.focusTime,
        requirement: 3000,
        rewardXp: 300,
      ),
      Achievement(
        id: 'hundred_hours',
        name: '百小时神话',
        description: '累计专注100小时',
        icon: '💫',
        type: AchievementType.focusTime,
        requirement: 6000,
        rewardXp: 500,
      ),
      Achievement(
        id: 'streak_3',
        name: '三天连续',
        description: '连续专注3天',
        icon: '🔥',
        type: AchievementType.streak,
        requirement: 3,
        rewardXp: 40,
      ),
      Achievement(
        id: 'streak_7',
        name: '一周坚持',
        description: '连续专注7天',
        icon: '📅',
        type: AchievementType.streak,
        requirement: 7,
        rewardXp: 80,
      ),
      Achievement(
        id: 'streak_30',
        name: '月度坚持',
        description: '连续专注30天',
        icon: '🗓️',
        type: AchievementType.streak,
        requirement: 30,
        rewardXp: 200,
      ),
      Achievement(
        id: 'level_5',
        name: '初露锋芒',
        description: '达到5级',
        icon: '⭐',
        type: AchievementType.level,
        requirement: 5,
        rewardXp: 50,
      ),
      Achievement(
        id: 'level_10',
        name: '小有所成',
        description: '达到10级',
        icon: '🌙',
        type: AchievementType.level,
        requirement: 10,
        rewardXp: 100,
      ),
      Achievement(
        id: 'level_25',
        name: '高手风范',
        description: '达到25级',
        icon: '🌈',
        type: AchievementType.level,
        requirement: 25,
        rewardXp: 250,
      ),
      Achievement(
        id: 'level_50',
        name: '巅峰之作',
        description: '达到50级',
        icon: '🚀',
        type: AchievementType.level,
        requirement: 50,
        rewardXp: 500,
      ),
      Achievement(
        id: 'marathon',
        name: '专注马拉松',
        description: '单次专注90分钟',
        icon: '🏃',
        type: AchievementType.special,
        requirement: 90,
        rewardXp: 100,
      ),
      Achievement(
        id: 'early_bird',
        name: '早起鸟',
        description: '早上6-8点完成专注',
        icon: '🌅',
        type: AchievementType.special,
        requirement: 1,
        rewardXp: 30,
      ),
      Achievement(
        id: 'night_owl',
        name: '深夜加班',
        description: '晚上11点后完成专注',
        icon: '🦉',
        type: AchievementType.special,
        requirement: 1,
        rewardXp: 30,
      ),
    ];
  }
}

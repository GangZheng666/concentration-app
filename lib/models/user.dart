import 'dart:convert';

class User {
  final String id;
  final String name;
  final String avatar;
  int totalFocusMinutes;
  int level;
  int experience;
  int streak;
  DateTime? lastFocusDate;

  User({
    required this.id,
    required this.name,
    this.avatar = '🎯',
    this.totalFocusMinutes = 0,
    this.level = 1,
    this.experience = 0,
    this.streak = 0,
    this.lastFocusDate,
  });

  int get hours => totalFocusMinutes ~/ 60;
  int get minutes => totalFocusMinutes % 60;
  
  int get experienceToNextLevel => level * 100;
  
  double get levelProgress => experience / experienceToNextLevel;

  void addFocusTime(int minutes) {
    totalFocusMinutes += minutes;
    experience += minutes;
    
    while (experience >= experienceToNextLevel) {
      experience -= experienceToNextLevel;
      level++;
    }
    
    _updateStreak();
  }

  void _updateStreak() {
    final now = DateTime.now();
    if (lastFocusDate != null) {
      final difference = now.difference(lastFocusDate!).inDays;
      if (difference == 1) {
        streak++;
      } else if (difference > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }
    lastFocusDate = now;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'totalFocusMinutes': totalFocusMinutes,
    'level': level,
    'experience': experience,
    'streak': streak,
    'lastFocusDate': lastFocusDate?.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    avatar: json['avatar'] ?? '🎯',
    totalFocusMinutes: json['totalFocusMinutes'] ?? 0,
    level: json['level'] ?? 1,
    experience: json['experience'] ?? 0,
    streak: json['streak'] ?? 0,
    lastFocusDate: json['lastFocusDate'] != null 
        ? DateTime.parse(json['lastFocusDate']) 
        : null,
  );

  String toJsonString() => jsonEncode(toJson());

  factory User.fromJsonString(String jsonString) => 
      User.fromJson(jsonDecode(jsonString));
}

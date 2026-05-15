import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/focus_session.dart';
import '../models/achievement.dart';

class DatabaseService {
  final SharedPreferences? _prefs;
  bool _initialized = false;

  DatabaseService() : _prefs = null;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_${user.id}', user.toJsonString());
    await prefs.setString('current_user_id', user.id);
  }

  Future<User?> getUser(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_${id}');
    if (userJson != null) {
      return User.fromJsonString(userJson);
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString('current_user_id');
    if (currentUserId != null) {
      final userJson = prefs.getString('user_${currentUserId}');
      if (userJson != null) {
        return [User.fromJsonString(userJson)];
      }
    }
    return [];
  }

  Future<void> saveSession(FocusSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getSessions(session.userId);
    sessions.add(session);
    final sessionsJson = sessions.map((s) => s.toJsonString()).toList();
    await prefs.setStringList('sessions_${session.userId}', sessionsJson);
  }

  Future<List<FocusSession>> getSessions(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsJson = prefs.getStringList('sessions_${userId}') ?? [];
    return sessionsJson.map((s) => FocusSession.fromJsonString(s)).toList();
  }

  Future<void> saveAchievement(String userId, Achievement achievement) async {
    final prefs = await SharedPreferences.getInstance();
    final achievements = await getAchievements(userId);
    final index = achievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      achievements[index] = achievement;
    } else {
      achievements.add(achievement);
    }
    final achievementsJson = achievements.map((a) => a.toJsonString()).toList();
    await prefs.setStringList('achievements_${userId}', achievementsJson);
  }

  Future<List<Achievement>> getAchievements(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final allAchievements = Achievement.getAllAchievements();
    final savedJson = prefs.getStringList('achievements_${userId}') ?? [];
    
    final savedMap = <String, Achievement>{};
    for (final json in savedJson) {
      final achievement = Achievement.fromJsonString(json);
      savedMap[achievement.id] = achievement;
    }

    for (final achievement in allAchievements) {
      if (savedMap.containsKey(achievement.id)) {
        final saved = savedMap[achievement.id]!;
        achievement.isUnlocked = saved.isUnlocked;
        achievement.unlockedAt = saved.unlockedAt;
      }
    }

    return allAchievements;
  }

  Future<void> updateLeaderboard(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboard = await getLeaderboard();
    
    final index = leaderboard.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      leaderboard[index] = user;
    } else {
      leaderboard.add(user);
    }
    
    leaderboard.sort((a, b) => b.totalFocusMinutes.compareTo(a.totalFocusMinutes));
    
    final leaderboardJson = leaderboard.map((u) => u.toJsonString()).toList();
    await prefs.setStringList('leaderboard', leaderboardJson);
  }

  Future<List<User>> getLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardJson = prefs.getStringList('leaderboard') ?? [];
    
    if (leaderboardJson.isEmpty) {
      return _getDefaultLeaderboard();
    }
    
    return leaderboardJson.map((u) => User.fromJsonString(u)).toList();
  }

  List<User> _getDefaultLeaderboard() {
    return [
      User(id: 'demo1', name: '专注达人', avatar: '🧘', totalFocusMinutes: 1250),
      User(id: 'demo2', name: '学习王者', avatar: '📚', totalFocusMinutes: 980),
      User(id: 'demo3', name: '效率专家', avatar: '⚡', totalFocusMinutes: 756),
      User(id: 'demo4', name: '时间管理师', avatar: '⏰', totalFocusMinutes: 542),
      User(id: 'demo5', name: '早起鸟', avatar: '🌅', totalFocusMinutes: 423),
    ];
  }

  Future<void> close() async {}
}

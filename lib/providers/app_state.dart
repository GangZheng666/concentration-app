import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/focus_session.dart';
import '../models/achievement.dart';
import '../services/database_service.dart';
import '../services/achievement_checker.dart';

enum FocusState { idle, running, paused, completed }

class AppState extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  User? _currentUser;
  List<User> _leaderboard = [];
  List<FocusSession> _sessions = [];
  List<Achievement> _achievements = [];
  List<Achievement> _newlyUnlockedAchievements = [];
  
  FocusState _focusState = FocusState.idle;
  int _focusDuration = 25;
  int _remainingSeconds = 25 * 60;
  Timer? _timer;
  DateTime? _sessionStartTime;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  List<User> get leaderboard => _leaderboard;
  List<FocusSession> get sessions => _sessions;
  List<Achievement> get achievements => _achievements;
  List<Achievement> get newlyUnlockedAchievements => _newlyUnlockedAchievements;
  List<Achievement> get unlockedAchievements => 
      _achievements.where((a) => a.isUnlocked).toList();
  List<Achievement> get lockedAchievements => 
      _achievements.where((a) => !a.isUnlocked).toList();
  
  int get totalAchievementXp => 
      unlockedAchievements.fold(0, (sum, a) => sum + a.rewardXp);
  double get achievementProgress => 
      _achievements.isEmpty ? 0 : unlockedAchievements.length / _achievements.length;

  FocusState get focusState => _focusState;
  int get focusDuration => _focusDuration;
  int get remainingSeconds => _remainingSeconds;
  
  int get remainingMinutes => _remainingSeconds ~/ 60;
  int get remainingSecondsPart => _remainingSeconds % 60;
  double get progress => 1 - (_remainingSeconds / (_focusDuration * 60));

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;
    
    final users = await _databaseService.getAllUsers();
    if (users.isNotEmpty) {
      _currentUser = users.first;
      _sessions = await _databaseService.getSessions(_currentUser!.id);
      _achievements = await _databaseService.getAchievements(_currentUser!.id);
    }
    
    _leaderboard = await _databaseService.getLeaderboard();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> createUser(String name, String avatar) async {
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      avatar: avatar,
    );
    
    await _databaseService.saveUser(_currentUser!);
    await _databaseService.updateLeaderboard(_currentUser!);
    _achievements = await _databaseService.getAchievements(_currentUser!.id);
    _leaderboard = await _databaseService.getLeaderboard();
    
    notifyListeners();
  }

  void setFocusDuration(int minutes) {
    if (_focusState == FocusState.idle) {
      _focusDuration = minutes;
      _remainingSeconds = minutes * 60;
      notifyListeners();
    }
  }

  void startFocus() {
    if (_focusState == FocusState.idle || _focusState == FocusState.paused) {
      _focusState = FocusState.running;
      _sessionStartTime ??= DateTime.now();
      _startTimer();
      notifyListeners();
    }
  }

  void pauseFocus() {
    if (_focusState == FocusState.running) {
      _focusState = FocusState.paused;
      _timer?.cancel();
      notifyListeners();
    }
  }

  void resetFocus() {
    _focusState = FocusState.idle;
    _remainingSeconds = _focusDuration * 60;
    _sessionStartTime = null;
    _timer?.cancel();
    notifyListeners();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _completeFocus();
      }
    });
  }

  Future<void> _completeFocus() async {
    _timer?.cancel();
    _focusState = FocusState.completed;
    
    if (_currentUser != null && _sessionStartTime != null) {
      final session = FocusSession(
        id: 'session_${DateTime.now().millisecondsSinceEpoch}',
        userId: _currentUser!.id,
        startTime: _sessionStartTime!,
        endTime: DateTime.now(),
        durationMinutes: _focusDuration,
      );
      
      _currentUser!.addFocusTime(_focusDuration);
      _sessions.add(session);
      
      await _databaseService.saveUser(_currentUser!);
      await _databaseService.saveSession(session);
      await _databaseService.updateLeaderboard(_currentUser!);
      
      _newlyUnlockedAchievements = AchievementChecker.checkAchievements(
        _currentUser!,
        _sessions,
        session,
      );
      
      for (final achievement in _newlyUnlockedAchievements) {
        await _databaseService.saveAchievement(_currentUser!.id, achievement);
        _currentUser!.experience += achievement.rewardXp;
        while (_currentUser!.experience >= _currentUser!.experienceToNextLevel) {
          _currentUser!.experience -= _currentUser!.experienceToNextLevel;
          _currentUser!.level++;
        }
      }
      
      await _databaseService.saveUser(_currentUser!);
      
      _achievements = await _databaseService.getAchievements(_currentUser!.id);
      _leaderboard = await _databaseService.getLeaderboard();
    }
    
    notifyListeners();
  }

  void dismissCompletion() {
    _focusState = FocusState.idle;
    _remainingSeconds = _focusDuration * 60;
    _sessionStartTime = null;
    _newlyUnlockedAchievements = [];
    notifyListeners();
  }

  void clearNewAchievements() {
    _newlyUnlockedAchievements = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

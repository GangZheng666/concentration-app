import '../models/user.dart';
import '../models/focus_session.dart';
import '../models/achievement.dart';

class AchievementChecker {
  static List<Achievement> checkAchievements(
    User user,
    List<FocusSession> sessions,
    FocusSession? currentSession,
  ) {
    final newlyUnlocked = <Achievement>[];
    final allAchievements = Achievement.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.isUnlocked) continue;

      bool unlocked = false;

      switch (achievement.type) {
        case AchievementType.sessions:
          unlocked = _checkSessionAchievement(
            achievement,
            sessions.length,
          );
          break;

        case AchievementType.focusTime:
          unlocked = _checkFocusTimeAchievement(
            achievement,
            user.totalFocusMinutes,
          );
          break;

        case AchievementType.streak:
          unlocked = _checkStreakAchievement(
            achievement,
            user.streak,
          );
          break;

        case AchievementType.level:
          unlocked = _checkLevelAchievement(
            achievement,
            user.level,
          );
          break;

        case AchievementType.special:
          unlocked = _checkSpecialAchievement(
            achievement,
            currentSession,
          );
          break;
      }

      if (unlocked) {
        achievement.isUnlocked = true;
        achievement.unlockedAt = DateTime.now();
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  static bool _checkSessionAchievement(
    Achievement achievement,
    int sessionCount,
  ) {
    return sessionCount >= achievement.requirement;
  }

  static bool _checkFocusTimeAchievement(
    Achievement achievement,
    int totalMinutes,
  ) {
    return totalMinutes >= achievement.requirement;
  }

  static bool _checkStreakAchievement(
    Achievement achievement,
    int streak,
  ) {
    return streak >= achievement.requirement;
  }

  static bool _checkLevelAchievement(
    Achievement achievement,
    int level,
  ) {
    return level >= achievement.requirement;
  }

  static bool _checkSpecialAchievement(
    Achievement achievement,
    FocusSession? session,
  ) {
    if (session == null) return false;

    switch (achievement.id) {
      case 'marathon':
        return session.durationMinutes >= 90;

      case 'early_bird':
        final hour = session.endTime.hour;
        return hour >= 6 && hour < 8;

      case 'night_owl':
        final hour = session.endTime.hour;
        return hour >= 23 || hour < 5;

      default:
        return false;
    }
  }

  static int calculateTotalRewardXp(List<Achievement> achievements) {
    return achievements.fold(0, (sum, a) => sum + a.rewardXp);
  }
}

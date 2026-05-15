import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/achievement.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final List<int> _durationOptions = [15, 25, 45, 60, 90];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (appState.focusState == FocusState.completed &&
              appState.newlyUnlockedAchievements.isNotEmpty) {
            _showAchievementUnlockedDialog(context, appState);
          }
        });

        return Scaffold(
          body: SafeArea(
            child: _buildBody(context, appState),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppState appState) {
    switch (appState.focusState) {
      case FocusState.completed:
        return _buildCompletedView(context, appState);
      default:
        return _buildTimerView(context, appState);
    }
  }

  Widget _buildTimerView(BuildContext context, AppState appState) {
    final isIdle = appState.focusState == FocusState.idle;
    final isRunning = appState.focusState == FocusState.running;
    final isPaused = appState.focusState == FocusState.paused;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimerCircle(context, appState),
            const SizedBox(height: 48),
            if (isIdle) ...[
              const Text(
                '选择专注时长',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: _durationOptions.map((duration) {
                  final isSelected = appState.focusDuration == duration;
                  return ChoiceChip(
                    label: Text('$duration 分钟'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        appState.setFocusDuration(duration);
                      }
                    },
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRunning || isPaused) ...[
                  FloatingActionButton(
                    heroTag: 'reset',
                    onPressed: () => _showResetDialog(context, appState),
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(width: 24),
                ],
                FloatingActionButton.large(
                  heroTag: 'main',
                  onPressed: () {
                    if (isRunning) {
                      appState.pauseFocus();
                    } else {
                      appState.startFocus();
                    }
                  },
                  child: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    size: 48,
                  ),
                ),
              ],
            ),
            if (isRunning || isPaused) ...[
              const SizedBox(height: 24),
              Text(
                isPaused ? '已暂停' : '专注中...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCircle(BuildContext context, AppState appState) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: appState.progress,
              strokeWidth: 12,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${appState.remainingMinutes.toString().padLeft(2, '0')}:${appState.remainingSecondsPart.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getStatusText(appState.focusState),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(FocusState state) {
    switch (state) {
      case FocusState.idle:
        return '准备开始';
      case FocusState.running:
        return '专注中';
      case FocusState.paused:
        return '已暂停';
      case FocusState.completed:
        return '完成';
    }
  }

  Widget _buildCompletedView(BuildContext context, AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎉',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              '专注完成！',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '+${appState.focusDuration} 分钟',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '总专注: ${appState.currentUser?.totalFocusMinutes ?? 0} 分钟',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => appState.dismissCompletion(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: const Text('继续专注'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置计时'),
        content: const Text('确定要放弃当前的专注时间吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              appState.resetFocus();
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showAchievementUnlockedDialog(
    BuildContext context,
    AppState appState,
  ) {
    final achievements = appState.newlyUnlockedAchievements;
    if (achievements.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AchievementUnlockedDialog(
        achievements: achievements,
        onDismiss: () {
          Navigator.pop(context);
          appState.clearNewAchievements();
        },
      ),
    );
  }
}

class _AchievementUnlockedDialog extends StatelessWidget {
  final List<Achievement> achievements;
  final VoidCallback onDismiss;

  const _AchievementUnlockedDialog({
    required this.achievements,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎊',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),
          Text(
            achievements.length == 1 ? '成就解锁！' : '成就批量解锁！',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...achievements.map((a) => _buildAchievementItem(context, a)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('太棒了！'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(BuildContext context, Achievement achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Text(
            achievement.icon,
            style: const TextStyle(fontSize: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  achievement.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.amber.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${achievement.rewardXp}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

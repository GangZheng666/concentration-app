import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/user_rank_card.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        final leaderboard = appState.leaderboard;
        final currentUserId = appState.currentUser?.id;

        return Scaffold(
          appBar: AppBar(
            title: const Text('排行榜'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            children: [
              _buildTopThree(context, leaderboard),
              Expanded(
                child: leaderboard.isEmpty
                    ? const Center(child: Text('暂无数据'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        itemCount: leaderboard.length,
                        itemBuilder: (context, index) {
                          final user = leaderboard[index];
                          return UserRankCard(
                            user: user,
                            rank: index + 1,
                            isCurrentUser: user.id == currentUserId,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopThree(BuildContext context, List<dynamic> leaderboard) {
    if (leaderboard.length < 3) return const SizedBox.shrink();

    final top3 = leaderboard.take(3).toList();
    final orderedTop3 = [top3[1], top3[0], top3[2]];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: orderedTop3.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          final actualRank = [2, 1, 3][index];
          
          return _buildPodiumItem(context, user, actualRank, index == 1);
        }).toList(),
      ),
    );
  }

  Widget _buildPodiumItem(
    BuildContext context, 
    dynamic user, 
    int rank, 
    bool isCenter,
  ) {
    final heights = [80.0, 120.0, 60.0];
    final colors = [
      const Color(0xFFC0C0C0),
      const Color(0xFFFFD700),
      const Color(0xFFCD7F32),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            user.avatar,
            style: TextStyle(fontSize: isCenter ? 48 : 36),
          ),
          const SizedBox(height: 4),
          Text(
            user.name,
            style: TextStyle(
              fontSize: isCenter ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${user.totalFocusMinutes}分钟',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: isCenter ? 80 : 60,
            height: heights[rank - 1],
            decoration: BoxDecoration(
              color: colors[rank - 1],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isCenter ? 24 : 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/leaderboard.dart';

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.place,
    required this.title,
    required this.points,
  });

  final int place;
  final String title;
  final int points;
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({
    super.key,
    required this.entries,
    required this.activeTab,
    required this.changePage,
    required this.withAvatar,
    required this.currentUserPlace,
    required this.currentUserPoints,
    required this.currentPlaceLabel,
    this.body,
  });

  final List<LeaderboardEntry> entries;
  final LeaderboardPageStatus activeTab;
  final void Function(LeaderboardPageStatus status) changePage;
  final bool withAvatar;
  final int currentUserPlace;
  final int currentUserPoints;
  final String currentPlaceLabel;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            children: [
              Text(
                'Рейтинг',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 18),
              _LeaderboardTabs(activeTab: activeTab, changePage: changePage),
              const SizedBox(height: 26),
              if (currentUserPlace > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '$currentPlaceLabel: $currentUserPlace ($currentUserPoints очков)',
                    style: textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF2F5C73),
                    ),
                  ),
                ),
              if (currentUserPlace > 0) const SizedBox(height: 22),
              Expanded(
                child: body ??
                    ListView.separated(
                      padding: const EdgeInsets.only(right: 2),
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return _LeaderboardRow(
                          place: entry.place,
                          title: entry.title,
                          points: entry.points,
                          withAvatar: withAvatar,
                          isCurrentUser: false,
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardTabs extends StatelessWidget {
  const _LeaderboardTabs({required this.activeTab, required this.changePage});

  final LeaderboardPageStatus activeTab;
  final void Function(LeaderboardPageStatus status) changePage;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = cs.outlineVariant;
    final activeColor = const Color(0xFFD6E4F2);

    Widget tabButton({
      required String title,
      required bool isActive,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: Material(
          color: isActive ? activeColor : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(28),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Row(
          children: [
            tabButton(
              title: 'Личный',
              isActive: activeTab == LeaderboardPageStatus.personal,
              onTap: () => changePage(LeaderboardPageStatus.personal),
            ),
            Container(width: 1, color: borderColor),
            tabButton(
              title: 'Командный',
              isActive: activeTab == LeaderboardPageStatus.command,
              onTap: () => changePage(LeaderboardPageStatus.command),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.place,
    required this.title,
    required this.points,
    required this.withAvatar,
    required this.isCurrentUser,
  });

  final int place;
  final String title;
  final int points;
  final bool withAvatar;
  final bool isCurrentUser;

  Color? _placeColor(int value) {
    if (value == 1) return const Color(0xFFEAF25B);
    if (value == 2) return const Color(0xFFE9E9E9);
    if (value == 3) return const Color(0xFFF0D5BB);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: _placeColor(place),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$place',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4F5C73),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        if (withAvatar) ...[
          const CircleAvatar(
            radius: 11,
            backgroundColor: Color(0xFFE2E7FB),
            child: Icon(
              Icons.person_outline_rounded,
              size: 14,
              color: Color(0xFF6478A9),
            ),
          ),
          const SizedBox(width: 10),
        ],
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF63769D),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '$points',
          style: const TextStyle(
            color: Color(0xFF2F5C73),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

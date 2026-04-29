import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/screens/achievements_screen/screen.dart';
import 'package:techarrow_2026_app/screens/edit_user_screen/screen.dart';
import 'package:techarrow_2026_app/screens/quest_history_screen/screen.dart';
import 'package:techarrow_2026_app/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 58,
                backgroundColor: colorScheme.surfaceContainerLow,
                child: Icon(
                  Icons.person_outline_rounded,
                  size: 82,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                StreamAuthScope.of(context).currentUser?.username ??
                    "Алексей Базин",
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AchievementsScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Достижения',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(
                      color: colorScheme.outlineVariant,
                      thickness: 1,
                      height: 1,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditUserScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Редактировать профиль',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(
                      color: colorScheme.outlineVariant,
                      thickness: 1,
                      height: 1,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const QuestHistoryScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: colorScheme.onSurface,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'История квестов',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Divider(
                      color: colorScheme.outlineVariant,
                      thickness: 1,
                      height: 1,
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () {
                        StreamAuthScope.of(context).signOut();
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Icon(Icons.logout_rounded, color: colorScheme.error),
                          const SizedBox(width: 16),
                          Text(
                            'Выйти',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

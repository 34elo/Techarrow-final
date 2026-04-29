import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/main.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/team.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/leaderboard.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/favourite.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/profile.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  int _currentIndex = 0;
  final List<int> _refreshNonce = List<int>.filled(5, 0);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          MainPage(key: ValueKey('main-${_refreshNonce[0]}')),
          TeamPage(key: ValueKey('team-${_refreshNonce[1]}')),
          LeaderboardPage(key: ValueKey('leaderboard-${_refreshNonce[2]}')),
          FavouritePage(key: ValueKey('favourite-${_refreshNonce[3]}')),
          ProfilePage(key: ValueKey('profile-${_refreshNonce[4]}')),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Material(
            color: cs.surfaceContainerHigh,
            elevation: 3,
            shadowColor: cs.shadow.withValues(alpha: 0.18),
            surfaceTintColor: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            clipBehavior: Clip.antiAlias,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: cs.primary,
              unselectedItemColor: cs.onSurfaceVariant,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                  _refreshNonce[value]++;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: "Главная",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined),
                  label: "Команда",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard_outlined),
                  label: "Рейтинг",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_books_outlined),
                  label: "Моё",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: "Профиль",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

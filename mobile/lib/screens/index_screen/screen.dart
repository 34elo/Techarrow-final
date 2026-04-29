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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
                _refreshNonce[value]++;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
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
                icon: Icon(Icons.favorite_outline),
                label: "Избранное",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: "Профиль",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

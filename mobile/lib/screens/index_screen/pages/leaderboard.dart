import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/screens/index_screen/leaderboard_pages/command.dart';
import 'package:techarrow_2026_app/screens/index_screen/leaderboard_pages/personal.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  LeaderboardPageStatus status = LeaderboardPageStatus.personal;

  void changePage(LeaderboardPageStatus newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LeaderboardPageStatus.personal:
        return PersonalLeaderboardPage(changePage: changePage);
      case LeaderboardPageStatus.command:
        return CommandLeaderboardPage(changePage: changePage);
    }
  }
}

enum LeaderboardPageStatus { personal, command }

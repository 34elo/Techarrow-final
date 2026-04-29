import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/screens/index_screen/leaderboard_pages/common.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/leaderboard.dart';
import 'package:techarrow_2026_app/services/api.dart';

class PersonalLeaderboardPage extends StatefulWidget {
  const PersonalLeaderboardPage({super.key, required this.changePage});

  final void Function(LeaderboardPageStatus status) changePage;

  @override
  State<PersonalLeaderboardPage> createState() => _PersonalLeaderboardPageState();
}

class _PersonalLeaderboardPageState extends State<PersonalLeaderboardPage> {
  late Future<UserRatingPageResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<UserRatingPageResponse> _load() async {
    final res = await ApiService.instance.client.apiRatingUsersGet(limit: 50);
    final body = res.body;
    if (body == null) {
      throw Exception('Failed to load user rating');
    }
    return body;
  }

  Future<void> _reload() async {
    final f = _load();
    setState(() {
      _future = f;
    });
    await f;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserRatingPageResponse>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LeaderboardView(
            activeTab: LeaderboardPageStatus.personal,
            changePage: widget.changePage,
            withAvatar: true,
            currentUserPlace: -1,
            currentUserPoints: 0,
            currentPlaceLabel: 'Ваше место',
            entries: const [],
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return LeaderboardView(
            activeTab: LeaderboardPageStatus.personal,
            changePage: widget.changePage,
            withAvatar: true,
            currentUserPlace: -1,
            currentUserPoints: 0,
            currentPlaceLabel: 'Ваше место',
            entries: const [],
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Не удалось загрузить рейтинг'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _future = _load();
                      });
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final entries = data.items
            .map(
              (e) => LeaderboardEntry(
                place: e.place,
                title: e.name,
                points: e.points,
              ),
            )
            .toList();

        return LeaderboardView(
          activeTab: LeaderboardPageStatus.personal,
          changePage: widget.changePage,
          withAvatar: true,
          currentUserPlace: data.currentUser.place,
          currentUserPoints: data.currentUser.points,
          currentPlaceLabel: 'Ваше место',
          entries: entries,
          onRefresh: _reload,
        );
      },
    );
  }
}

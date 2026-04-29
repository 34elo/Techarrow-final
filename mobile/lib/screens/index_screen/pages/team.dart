import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/screens/index_screen/team_pages/creation.dart';
import 'package:techarrow_2026_app/screens/index_screen/team_pages/join.dart';
import 'package:techarrow_2026_app/screens/index_screen/team_pages/team.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  TeamPageStatus status = TeamPageStatus.join;
  bool _loadingInitial = true;

  void changePage(TeamPageStatus newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    _resolveInitialStatus();
  }

  Future<void> _resolveInitialStatus() async {
    try {
      final res = await ApiService.instance.client.apiTeamsMeGet();
      if (!mounted) return;
      setState(() {
        status = (res.isSuccessful && res.body != null)
            ? TeamPageStatus.info
            : TeamPageStatus.join;
        _loadingInitial = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        status = TeamPageStatus.join;
        _loadingInitial = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingInitial) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    switch (status) {
      case TeamPageStatus.join:
        return TeamJoinPage(changePage: changePage);
      case TeamPageStatus.create:
        return TeamCreationPage(changePage: changePage);
      case TeamPageStatus.info:
        return TeamInfoPage(changePage: changePage);
    }
  }
}

enum TeamPageStatus { info, create, join }

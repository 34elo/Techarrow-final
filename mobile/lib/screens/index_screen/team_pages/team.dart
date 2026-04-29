import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/screens/index_screen/pages/team.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class TeamInfoPage extends StatefulWidget {
  const TeamInfoPage({super.key, required this.changePage});
  final void Function(TeamPageStatus status) changePage;

  @override
  State<TeamInfoPage> createState() => _TeamInfoPageState();
}

class _TeamInfoPageState extends State<TeamInfoPage> {
  late String _teamId;
  late String _teamName;
  late Future<TeamResponse?> _teamFuture;

  @override
  void initState() {
    super.initState();
    _teamFuture = _loadTeam();
  }

  Future<TeamResponse?> _loadTeam() async {
    try {
      final res = await ApiService.instance.client.apiTeamsMeGet();
      if (res.isSuccessful && res.body != null) {
        return res.body!;
      }
    } catch (_) {}
    return null;
  }

  void _openTeamQrPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TeamQrPage(teamId: _teamId, teamName: _teamName),
      ),
    );
  }

  Future<void> onLogout(BuildContext context) async {
    final team = await _loadTeam();
    if (team == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Вы хотите выйти из ${team.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Нет'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Да'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    await ApiService.instance.client.apiTeamsLeavePost();
    if (!mounted) return;

    widget.changePage(TeamPageStatus.join);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeamResponse?>(
      future: _teamFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final team = snapshot.data;
        if (team == null) {
          return const Center(child: Text('Команда не найдена'));
        }
        _teamId = team.code;
        _teamName = team.name;
        final members = team.members;

        return Scaffold(
          floatingActionButton: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _openTeamQrPage,
              icon: const Icon(Icons.qr_code_2_rounded, size: 30),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _teamName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: _teamId));
                              AppSnackBar.success(context, 'Скопировано');
                            },
                            child: Text(
                              'ID: $_teamId',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onLogout(context);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFFB7352B),
                        size: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  team.description,
                  style: const TextStyle(
                    height: 1.2,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 28),
                ...members.map(
                  (member) => Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0xFFD5DDF5),
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: Color(0xFF42527D),
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.username,
                              style: const TextStyle(
                                color: Color(0xFF415584),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TeamQrPage extends StatelessWidget {
  const TeamQrPage({super.key, required this.teamId, required this.teamName});

  final String teamId;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teamName, style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: teamId,
                version: QrVersions.auto,
                size: 240,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'ID: $teamId',
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

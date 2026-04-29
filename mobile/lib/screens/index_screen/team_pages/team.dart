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

  void _openTeamQrPage(String code, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TeamQrPage(teamId: code, teamName: name),
      ),
    );
  }

  Future<void> onLogout() async {
    final team = await _loadTeam();
    if (!mounted || team == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final cs = Theme.of(dialogContext).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('Выйти из «${team.name}»?'),
          content: Text(
            'Вы сможете снова присоединиться по коду команды.',
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Остаться'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Выйти'),
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
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return FutureBuilder<TeamResponse?>(
      future: _teamFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: cs.primary,
              ),
            ),
          );
        }
        final team = snapshot.data;
        if (team == null) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      size: 56,
                      color: cs.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Команда не найдена',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final members = team.members;

        return Scaffold(
          backgroundColor: cs.surface,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openTeamQrPage(team.code, team.name),
            icon: const Icon(Icons.qr_code_2_rounded),
            label: const Text('QR-код'),
            elevation: 2,
            backgroundColor: cs.primaryContainer,
            foregroundColor: cs.onPrimaryContainer,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _teamFuture = _loadTeam();
                });
                await _teamFuture;
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverToBoxAdapter(
                    child: _TeamHeroCard(
                      name: team.name,
                      code: team.code,
                      description: team.description,
                      memberCount: members.length,
                      onCopyCode: () {
                        Clipboard.setData(ClipboardData(text: team.code));
                        AppSnackBar.success(context, 'Код скопирован');
                      },
                      onLeave: onLogout,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 28, 16, 12),
                    child: Row(
                      children: [
                        Icon(Icons.people_alt_rounded, size: 22, color: cs.primary),
                        const SizedBox(width: 10),
                        Text(
                          'Участники',
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '${members.length} / 6',
                            style: tt.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList.separated(
                    itemCount: members.length,
                    separatorBuilder: (context, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      return Material(
                        color: cs.surfaceContainerLow,
                        elevation: 0,
                        borderRadius: BorderRadius.circular(20),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: cs.primaryContainer,
                            foregroundColor: cs.onPrimaryContainer,
                            child: Text(
                              _initials(member.username),
                              style: tt.labelLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          title: Text(
                            member.username,
                            style: tt.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
              ),
            ),
          ),
        );
      },
    );
  }

  static String _initials(String username) {
    final t = username.trim();
    if (t.isEmpty) return '?';
    if (t.length >= 2) {
      return t.substring(0, 2).toUpperCase();
    }
    return t.toUpperCase();
  }
}

class _TeamHeroCard extends StatelessWidget {
  const _TeamHeroCard({
    required this.name,
    required this.code,
    required this.description,
    required this.memberCount,
    required this.onCopyCode,
    required this.onLeave,
  });

  final String name;
  final String code;
  final String description;
  final int memberCount;
  final VoidCallback onCopyCode;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primaryContainer.withValues(alpha: 0.92),
            cs.tertiaryContainer.withValues(alpha: 0.35),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Material(
                        color: cs.surface.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: onCopyCode,
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tag_rounded,
                                  size: 18,
                                  color: cs.onSurface,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    code,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: tt.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: cs.onSurface,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.copy_rounded,
                                  size: 18,
                                  color: cs.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Выйти из команды',
                  onPressed: onLeave,
                  style: IconButton.styleFrom(
                    foregroundColor: cs.error,
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 26),
                ),
              ],
            ),
            if (description.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                description,
                style: tt.bodyMedium?.copyWith(
                  color: cs.onPrimaryContainer.withValues(alpha: 0.88),
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.groups_rounded,
                  size: 18,
                  color: cs.onPrimaryContainer.withValues(alpha: 0.75),
                ),
                const SizedBox(width: 8),
                Text(
                  '$memberCount участник${memberCount == 1 ? '' : memberCount < 5 ? 'а' : 'ов'}',
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TeamQrPage extends StatelessWidget {
  const TeamQrPage({super.key, required this.teamId, required this.teamName});

  final String teamId;
  final String teamName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          teamName,
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Покажите QR другим игрокам — они смогут ввести код и присоединиться.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    QrImageView(
                      data: teamId,
                      version: QrVersions.auto,
                      size: 220,
                      eyeStyle: QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: cs.onSurface,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: cs.onSurface,
                      ),
                      backgroundColor: cs.surfaceContainerLow,
                    ),
                    const SizedBox(height: 20),
                    SelectableText(
                      teamId,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        fontFeatures: const [FontFeature.tabularFigures()],
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

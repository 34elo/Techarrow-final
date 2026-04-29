import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/screens/current_quest_screen/screen.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/auth.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';
import 'dart:async';

class TeamWaitingRoomSheet extends StatefulWidget {
  const TeamWaitingRoomSheet({
    super.key,
    required this.questId,
    required this.quest,
    this.questTitle,
  });

  final int questId;
  final Quest quest;
  final String? questTitle;

  @override
  State<TeamWaitingRoomSheet> createState() => _TeamWaitingRoomSheetState();
}

class _TeamWaitingRoomSheetState extends State<TeamWaitingRoomSheet> {
  bool _isReady = false;
  bool _isUpdating = false;
  TeamQuestRunProgressResponse? _progress;
  TeamResponse? _team;
  Timer? _pollTimer;
  bool _navigatedToRun = false;

  @override
  void initState() {
    super.initState();
    _loadTeam();
    _refreshProgress();
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refreshProgress();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTeam() async {
    try {
      final res = await ApiService.instance.client.apiTeamsMeGet();
      if (!mounted) return;
      if (res.isSuccessful && res.body != null) {
        setState(() {
          _team = res.body;
        });
      }
    } catch (_) {}
  }

  Future<void> _refreshProgress() async {
    try {
      final res = await ApiService.instance.client.apiTeamQuestRunsActiveGet();
      if (!mounted) return;
      if (res.isSuccessful && res.body != null) {
        final me = StreamAuthScope.of(context).currentUser;
        setState(() {
          _progress = res.body;
          _isReady = me != null
              ? res.body!.readyMemberIds.contains(me.id)
              : _isReady;
        });
        if (!_navigatedToRun &&
            res.body!.status.value == 'in_progress' &&
            mounted) {
          _navigatedToRun = true;
          _pollTimer?.cancel();
          Navigator.of(context).pop();
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CurrentQuestScreen()));
        }
      }
    } catch (_) {}
  }

  Future<void> _setReady(bool value) async {
    if (_isUpdating) return;
    setState(() {
      _isUpdating = true;
    });
    try {
      final res = await ApiService.instance.client.apiTeamQuestRunsPatch(
        body: TeamQuestRunReadinessRequest(
          questId: widget.questId,
          isReady: value,
        ),
      );
      if (!mounted) return;
      if (res.isSuccessful && res.body != null) {
        setState(() {
          _isReady = value;
          _progress = res.body;
        });
      } else {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось обновить статус',
          response: res,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось обновить статус',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final team = _team;
    final me = StreamAuthScope.of(context).currentUser;
    final members = team?.members ?? const <TeamMemberResponse>[];
    final readyIds = _progress?.readyMemberIds ?? const <int>[];
    final startsAt = _progress?.startsAt;
    final now = DateTime.now();
    final countdownSec = startsAt?.difference(now).inSeconds.clamp(0, 9999);
    final statusLabel = switch (_progress?.status.value) {
      'waiting_for_team' => 'Ожидаем готовность всех участников',
      'starting' =>
        countdownSec == null ? 'Запуск...' : 'Запуск через $countdownSec сек',
      'in_progress' => 'Квест уже запущен',
      'completed' => 'Квест завершен',
      _ => 'Ожидание',
    };

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: MediaQuery.paddingOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
              ],
            ),
            Text(
              team?.name ?? 'Команда',
              style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${team?.code ?? '—'}',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Text(
              statusLabel,
              style: tt.bodyMedium?.copyWith(color: cs.primary),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: members.length,
                separatorBuilder: (_, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final m = members[index];
                  final isReadyMember =
                      readyIds.contains(m.id) || (me?.id == m.id && _isReady);
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: cs.primaryContainer,
                        child: Icon(
                          Icons.person_outline,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.username,
                              style: tt.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              me != null && me.id == m.id ? me.email : '',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isReadyMember)
                        Icon(Icons.check_circle, color: cs.primary)
                      else
                        Icon(Icons.radio_button_unchecked, color: cs.outline),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline, color: cs.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Готово: ${readyIds.length}/${_progress?.totalMembers ?? members.length}',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: cs.secondaryContainer,
                  foregroundColor: cs.onSecondaryContainer,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: _isUpdating ? null : () => _setReady(!_isReady),
                child: Text(
                  _isReady ? 'Не готов' : 'Готов',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _fallbackQuestListImage =
    'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQRZRfRJNfPiR_PG_fa6JHQw3AEYUt0c-oCRwt07bUQRZfdGHhK';

/// Loads quest by id and opens [TeamWaitingRoomSheet] (готовность / отсчёт до старта).
Future<void> openTeamQuestWaitingRoom(BuildContext context, int questId) async {
  try {
    final res =
        await ApiService.instance.client.apiQuestsQuestIdGet(questId: questId);
    if (!context.mounted) return;
    if (!res.isSuccessful || res.body == null) {
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось загрузить квест',
        response: res,
      );
      return;
    }
    final item = res.body!;
    final quest = Quest(
      id: item.id,
      isFavorite: item.isFavourite ?? false,
      isCompleted: item.isCompleted ?? false,
      name: item.title,
      duration: '${item.durationMinutes} мин',
      area: item.location,
      difficulty: item.difficulty.toString(),
      imageSrc: item.imageFileId != null
          ? '${ApiService.baseUrl.toString()}/api/file/${item.imageFileId}'
          : _fallbackQuestListImage,
      status: item.status.value,
    );
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => TeamWaitingRoomSheet(
        questId: quest.id,
        questTitle: quest.name,
        quest: quest,
      ),
    );
  } catch (e) {
    if (context.mounted) {
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось открыть ожидание команды',
        error: e,
      );
    }
  }
}

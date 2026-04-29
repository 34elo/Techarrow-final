import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/screens/quest_data/team_waiting_room_sheet.dart';
import 'package:techarrow_2026_app/screens/quest_result_screen/screen.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/quest.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class CurrentQuestScreen extends StatefulWidget {
  const CurrentQuestScreen({super.key});

  @override
  State<CurrentQuestScreen> createState() => _CurrentQuestScreenState();
}

class _CurrentQuestScreenState extends State<CurrentQuestScreen> {
  static const LatLng _fallbackCenter = LatLng(56.3269, 44.0065);
  static const double _initialCheckpointZoom = 15;
  static const double _sheetMinChildFraction = 0.18;
  static const double _sheetMaxCapFraction = 0.88;

  /// Pushes the focused checkpoint above the map center so the pin stays visible when
  /// the bottom sheet is expanded ([MapController.move]: negative `dy` moves the point up).
  static Offset _checkpointFocusOffsetAboveSheet(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final dy = (h * 0.17).clamp(72.0, 200.0);
    return Offset(0, -dy);
  }

  late final MapController _mapController;
  late final TextEditingController _codeController;
  Timer? _teamProgressPoller;
  bool _isSubmittingCode = false;
  bool _isAbandoning = false;
  int? _lastShownRunResultId;
  int? _lastMapFocusCheckpointId;
  /// In team mode, any incomplete checkpoint can be answered; user picks via map.
  int? _selectedTeamCheckpointId;
  Map<int, String> _teamMemberNames = {};
  final GlobalKey _questSheetColumnKey = GlobalKey();
  /// Upper drag limit as a fraction of screen height (from measured content).
  double _sheetMaxChildFraction = 0.48;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _codeController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final questState = StreamQuestScope.of(context);
      questState.refreshActiveRunProgress(maxAttempts: 5);
      questState.refreshActiveTeamRunProgress();
      unawaited(_loadTeamMemberNames());
      _teamProgressPoller?.cancel();
      _teamProgressPoller = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        final state = StreamQuestScope.of(context);
        if (state.activeSession == null &&
            state.activeTeamRunProgress != null) {
          state.refreshActiveTeamRunProgress();
        }
      });
    });
  }

  Future<void> _loadTeamMemberNames() async {
    try {
      final res = await ApiService.instance.client.apiTeamsMeGet();
      if (!mounted || !res.isSuccessful || res.body == null) return;
      final map = <int, String>{};
      for (final m in res.body!.members) {
        map[m.id] = m.username;
      }
      setState(() {
        _teamMemberNames = map;
      });
    } catch (_) {}
  }

  String _teamCompleterLabel(int? userId) {
    if (userId == null) return '';
    final name = _teamMemberNames[userId];
    if (name != null && name.isNotEmpty) return name;
    return 'участник #$userId';
  }

  TeamQuestRunCheckpointView? _displayedTeamCheckpoint(
    TeamQuestRunProgressResponse? teamProgress,
  ) {
    if (teamProgress == null) return null;
    final sid = _selectedTeamCheckpointId;
    if (sid != null) {
      for (final c in teamProgress.checkpoints) {
        if (c.id == sid) return c;
      }
    }
    for (final c in teamProgress.checkpoints) {
      if (!c.isCompleted) return c;
    }
    return teamProgress.checkpoints.isEmpty
        ? null
        : teamProgress.checkpoints.last;
  }

  TeamQuestRunCheckpointView? _targetTeamCheckpointForAnswer(
    TeamQuestRunProgressResponse teamProgress,
  ) {
    final sid = _selectedTeamCheckpointId;
    if (sid != null) {
      for (final c in teamProgress.checkpoints) {
        if (c.id == sid) {
          if (c.isCompleted) return null;
          return c;
        }
      }
    }
    for (final c in teamProgress.checkpoints) {
      if (!c.isCompleted) return c;
    }
    return null;
  }

  @override
  void dispose() {
    _teamProgressPoller?.cancel();
    _mapController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// Map center = checkpoint the user should answer next (solo: API current; team: [ _targetTeamCheckpointForAnswer ]).
  LatLng? _mapFocusTargetLatLng({
    required bool isTeamMode,
    required QuestRunProgressResponse? point,
    required TeamQuestRunProgressResponse? teamProgress,
  }) {
    final id = _mapFocusTargetCheckpointId(
      isTeamMode: isTeamMode,
      point: point,
      teamProgress: teamProgress,
    );
    if (id == null) return null;
    if (isTeamMode && teamProgress != null) {
      for (final c in teamProgress.checkpoints) {
        if (c.id == id) {
          return LatLng(c.latitude, c.longitude);
        }
      }
      return switch (teamProgress.checkpoints) {
        [] => null,
        final cs => LatLng(cs.last.latitude, cs.last.longitude),
      };
    }
    final cur = point?.currentCheckpoint;
    if (cur != null && cur.id == id) {
      return LatLng(cur.latitude, cur.longitude);
    }
    final prev = point?.previousCheckpoints;
    if (prev != null) {
      for (final p in prev) {
        if (p.id == id) {
          return LatLng(p.latitude, p.longitude);
        }
      }
    }
    return null;
  }

  int? _mapFocusTargetCheckpointId({
    required bool isTeamMode,
    required QuestRunProgressResponse? point,
    required TeamQuestRunProgressResponse? teamProgress,
  }) {
    if (isTeamMode) {
      if (teamProgress == null || teamProgress.checkpoints.isEmpty) {
        return null;
      }
      final target = _targetTeamCheckpointForAnswer(teamProgress);
      if (target != null) return target.id;
      return teamProgress.checkpoints.last.id;
    }
    final cur = point?.currentCheckpoint;
    if (cur != null) return cur.id;
    final prev = point?.previousCheckpoints;
    if (prev != null && prev.isNotEmpty) {
      return prev.last.id;
    }
    return null;
  }

  List<Marker> _buildCheckpointMarkers({
    required bool isTeamMode,
    required QuestRunProgressResponse? point,
    required TeamQuestRunProgressResponse? teamProgress,
    required ColorScheme colorScheme,
    required Offset mapFocusOffset,
  }) {
    final activeColor = colorScheme.error;
    final markers = <Marker>[];

    if (isTeamMode && teamProgress != null) {
      final list = teamProgress.checkpoints;
      for (var i = 0; i < list.length; i++) {
        final cp = list[i];
        final n = i + 1;
        final isDone = cp.isCompleted;
        final isSelected = cp.id == _selectedTeamCheckpointId;
        final Color pinColor;
        if (isDone) {
          pinColor = Colors.green.shade600;
        } else if (isSelected) {
          pinColor = colorScheme.primary;
        } else {
          pinColor = activeColor;
        }
        markers.add(
          Marker(
            key: ValueKey<int>(cp.id),
            point: LatLng(cp.latitude, cp.longitude),
            width: 48,
            height: 48,
            rotate: true,
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _selectedTeamCheckpointId = cp.id;
                });
                _mapController.move(
                  LatLng(cp.latitude, cp.longitude),
                  _mapController.camera.zoom,
                  offset: mapFocusOffset,
                );
              },
              child: _NumberedCheckpointMarker(
                number: n,
                color: pinColor,
                ringHighlight: !isDone && isSelected,
                highlightColor: colorScheme.primary,
              ),
            ),
          ),
        );
      }
      return markers;
    }

    final prev = point?.previousCheckpoints ?? const [];
    for (var i = 0; i < prev.length; i++) {
      final cp = prev[i];
      markers.add(
        Marker(
          key: ValueKey<String>('solo-pass-${cp.id}'),
          point: LatLng(cp.latitude, cp.longitude),
          width: 48,
          height: 48,
          rotate: true,
          alignment: Alignment.bottomCenter,
          child: _NumberedCheckpointMarker(
            number: i + 1,
            color: Colors.green.shade600,
          ),
        ),
      );
    }
    final current = point?.currentCheckpoint;
    if (current != null) {
      markers.add(
        Marker(
          key: ValueKey<int>(current.id),
          point: LatLng(current.latitude, current.longitude),
          width: 48,
          height: 48,
          rotate: true,
          alignment: Alignment.bottomCenter,
          child: _NumberedCheckpointMarker(
            number: prev.length + 1,
            color: activeColor,
          ),
        ),
      );
    }
    return markers;
  }

  InputDecoration _fieldDecoration(BuildContext context, {String? hint}) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary),
      ),
    );
  }

  /// Read-only текст с той же подложкой, что у полей; высота по содержимому.
  Widget _readOnlyMultilineTask(
    BuildContext context,
    String? task,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final display = (task == null || task.trim().isEmpty) ? 'Н/Д' : task;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        display,
        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }

  Widget _label(BuildContext context, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
        ),
      ),
    );
  }

  void _scheduleQuestSheetExtentMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _measureQuestSheetExtent();
    });
  }

  void _measureQuestSheetExtent() {
    final box = _questSheetColumnKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final contentH = box.size.height;
    if (contentH < 24) return;
    final media = MediaQuery.of(context);
    final screenH = media.size.height;
    if (screenH <= 0) return;
    final bottomInset = media.padding.bottom + 16;
    const scrollTopPad = 12.0;
    final totalH = contentH + scrollTopPad + bottomInset;
    final fraction =
        (totalH / screenH).clamp(_sheetMinChildFraction + 0.04, _sheetMaxCapFraction);
    if ((fraction - _sheetMaxChildFraction).abs() > 0.006) {
      setState(() => _sheetMaxChildFraction = fraction);
    }
  }

  void _scanQr() {
    Navigator.of(context)
        .push<String>(
          MaterialPageRoute(builder: (_) => const _QuestCodeScannerPage()),
        )
        .then((scanned) {
          final val = scanned?.trim();
          if (val == null || val.isEmpty) return;
          _codeController.text = val;
        });
  }

  Future<void> _endQuestEarly() async {
    if (_isAbandoning) return;
    setState(() {
      _isAbandoning = true;
    });
    try {
      await ApiService.instance.client.apiQuestRunsActiveAbandonPost();
      if (!mounted) return;
      final questState = StreamQuestScope.of(context);
      final questId = questState.activeSession?.questId;
      questState.stopSession();
      await questState.fetchLatestRunResult(questId: questId, maxAttempts: 5);
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось завершить квест',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAbandoning = false;
        });
      }
    }
  }

  Future<void> _submitCode() async {
    if (_isSubmittingCode) return;
    final answer = _codeController.text.trim();
    if (answer.isEmpty) {
      AppSnackBar.error(context, 'Введите код');
      return;
    }

    setState(() {
      _isSubmittingCode = true;
    });
    try {
      final questState = StreamQuestScope.of(context);
      final isTeamMode =
          questState.activeSession == null &&
          questState.activeTeamRunProgress != null;
      if (isTeamMode) {
        final teamProgress = questState.activeTeamRunProgress!;
        final target = _targetTeamCheckpointForAnswer(teamProgress);
        if (target == null) {
          if (_selectedTeamCheckpointId != null) {
            AppSnackBar.info(
              context,
              'Этот чекпоинт уже пройден. Выберите другой на карте.',
            );
          } else {
            AppSnackBar.info(context, 'Все чекпоинты уже пройдены');
          }
          return;
        }
        final teamRes = await ApiService.instance.client
            .apiTeamQuestRunsActiveCheckpointsCheckpointIdAnswerPost(
              checkpointId: target.id,
              body: TeamQuestRunCheckpointAnswerRequest(answer: answer),
            );
        if (!mounted) return;
        final teamBody = teamRes.body;
        if (teamRes.isSuccessful && teamBody != null) {
          if (teamBody.correct) {
            questState.setActiveTeamRunProgress(teamBody.progress);
            _codeController.clear();
            if (_selectedTeamCheckpointId == target.id) {
              setState(() {
                _selectedTeamCheckpointId = null;
              });
            }
            if (teamBody.progress.status.value == 'completed') {
              final pts =
                  teamBody.pointsEarned ?? teamBody.progress.pointsAwarded;
              if (pts != null && pts > 0) {
                AppSnackBar.success(context, 'Квест завершён. Очки: $pts');
              } else {
                AppSnackBar.info(context, 'Квест завершён');
              }
              await questState.refreshActiveTeamRunProgress();
              if (!mounted) return;
              Navigator.of(context).maybePop();
            } else {
              AppSnackBar.success(context, 'Ответ принят');
            }
          } else {
            AppSnackBar.error(context, 'Неверный код');
          }
        } else {
          AppSnackBar.serverError(
            context,
            fallback: 'Не удалось отправить код',
            response: teamRes,
          );
        }
        return;
      }

      final res = await ApiService.instance.client.apiQuestRunsActiveAnswerPost(
        body: QuestRunAnswerRequest(answer: answer),
      );
      if (!mounted) return;
      final body = res.body;
      if (res.isSuccessful && body != null) {
        if (body.correct) {
          questState.setActiveRunProgress(body.progress);
          _codeController.clear();
          AppSnackBar.success(context, 'Ответ принят');
          final statusValue = body.progress.status.value;
          if (statusValue == 'completed' || statusValue == 'abandoned') {
            questState.stopSession();
            await questState.fetchLatestRunResult(
              questId: body.progress.questId,
              maxAttempts: 5,
            );
            if (!mounted) return;
          }
        } else {
          AppSnackBar.error(context, 'Неверный код');
        }
      } else {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось отправить код',
          response: res,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось отправить код',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingCode = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final questStream = StreamQuestScope.of(context);
    final session = questStream.activeSession;
    final point = questStream.activeRunProgress;
    final teamProgress = questStream.activeTeamRunProgress;
    final teamDisplayedCheckpoint = _displayedTeamCheckpoint(teamProgress);
    final isTeamMode = session == null && teamProgress != null;
    final teamCanEnterCode = isTeamMode &&
        teamDisplayedCheckpoint != null &&
        !teamDisplayedCheckpoint.isCompleted;
    final runResult = questStream.lastRunResult;
    if (runResult != null && _lastShownRunResultId != runResult.runId) {
      _lastShownRunResultId = runResult.runId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => QuestResultScreen(result: runResult),
          ),
        );
      });
    }

    if (isTeamMode && teamProgress.status.value != 'in_progress') {
      final st = teamProgress.status.value;
      final message = switch (st) {
        'starting' =>
          'Все участники готовы. Квест скоро начнётся — откройте экран готовности, чтобы видеть отсчёт.',
        'completed' => 'Этот командный квест уже завершён.',
        _ =>
          'Пока команда не подтвердит готовность всех участников, квест не начнётся.',
      };
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          centerTitle: true,
          title: Text('Квест', style: Theme.of(context).textTheme.titleMedium),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge,
                ),
                const SizedBox(height: 24),
                if (st != 'completed')
                  FilledButton(
                    onPressed: () =>
                        openTeamQuestWaitingRoom(context, teamProgress.questId),
                    child: const Text('К готовности команды'),
                  ),
                const Spacer(),
              ],
            ),
          ),
        ),
      );
    }

    if (session == null && !isTeamMode) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          centerTitle: true,
          title: Text('Квест', style: Theme.of(context).textTheme.titleMedium),
        ),
        body: const Center(child: Text('Нет активного квеста')),
      );
    }

    final mapFocusOffset = _checkpointFocusOffsetAboveSheet(context);
    final markers = _buildCheckpointMarkers(
      isTeamMode: isTeamMode,
      point: point,
      teamProgress: teamProgress,
      colorScheme: colorScheme,
      mapFocusOffset: mapFocusOffset,
    );
    final focusLatLng = _mapFocusTargetLatLng(
      isTeamMode: isTeamMode,
      point: point,
      teamProgress: teamProgress,
    );
    final focusCheckpointId = _mapFocusTargetCheckpointId(
      isTeamMode: isTeamMode,
      point: point,
      teamProgress: teamProgress,
    );
    if (focusLatLng != null &&
        focusCheckpointId != null &&
        focusCheckpointId != _lastMapFocusCheckpointId) {
      _lastMapFocusCheckpointId = focusCheckpointId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _mapController.move(
          focusLatLng,
          _initialCheckpointZoom,
          offset: mapFocusOffset,
        );
      });
    }

    _scheduleQuestSheetExtentMeasure();

    final sheetMax = _sheetMaxChildFraction.clamp(
      _sheetMinChildFraction + 0.04,
      _sheetMaxCapFraction,
    );
    final sheetInitial =
        math.min(0.42, sheetMax).clamp(_sheetMinChildFraction, sheetMax);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: focusLatLng ?? _fallbackCenter,
              initialZoom: focusLatLng != null ? _initialCheckpointZoom : 6,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
                cursorKeyboardRotationOptions:
                    CursorKeyboardRotationOptions.disabled(),
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.techarrow_2026_app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              isTeamMode ? 'Командный квест' : 'Квест',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ],
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: sheetInitial,
            minChildSize: _sheetMinChildFraction,
            maxChildSize: sheetMax,
            snap: true,
            snapSizes: [_sheetMinChildFraction, sheetMax],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: MediaQuery.paddingOf(context).bottom + 16,
                  ),
                  child: Column(
                    key: _questSheetColumnKey,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (isTeamMode) ...[
                        Text(
                          'Нажмите на метку на карте, чтобы выбрать чекпоинт. Ответить может любой участник, порядок не важен.',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      _label(context, 'Текущая точка'),
                      TextField(
                        readOnly: true,
                        decoration: _fieldDecoration(
                          context,
                          hint: isTeamMode
                              ? (teamDisplayedCheckpoint?.title ?? 'Н/Д')
                              : (point?.currentCheckpoint?.title ?? "Н/Д"),
                        ),
                      ),
                      if (isTeamMode) ...[
                        Builder(
                          builder: (_) {
                            final byId =
                                teamDisplayedCheckpoint?.completedByUserId;
                            if (byId == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Прошёл: ${_teamCompleterLabel(byId)}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 12),

                      _label(context, 'Задание'),
                      _readOnlyMultilineTask(
                        context,
                        isTeamMode
                            ? teamDisplayedCheckpoint?.task
                            : point?.currentCheckpoint?.task,
                      ),
                      const SizedBox(height: 16),

                      _label(context, 'Код'),
                      TextField(
                        controller: _codeController,
                        readOnly: isTeamMode && !teamCanEnterCode,
                        decoration: _fieldDecoration(
                          context,
                          hint: isTeamMode && !teamCanEnterCode
                              ? 'Выберите непройденный чекпоинт'
                              : 'Введите код',
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.secondaryContainer,
                                foregroundColor:
                                    colorScheme.onSecondaryContainer,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              onPressed: (_isSubmittingCode ||
                                      (isTeamMode && !teamCanEnterCode))
                                  ? null
                                  : _submitCode,
                              child: Text(
                                _isSubmittingCode ? 'Отправка...' : 'Отправить',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: (isTeamMode && !teamCanEnterCode)
                                ? null
                                : _scanQr,
                            padding: EdgeInsets.zero,
                            icon: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: colorScheme.secondaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.qr_code_scanner),
                            ),
                          ),
                        ],
                      ),

                      if (!isTeamMode) ...[
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: _isAbandoning ? null : _endQuestEarly,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            side: BorderSide(color: colorScheme.outline),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isAbandoning
                                ? 'Завершение...'
                                : 'Досрочно завершить квест',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Numbered marker; [rotate:true] on [Marker] keeps the pin upright when the map rotates.
class _NumberedCheckpointMarker extends StatelessWidget {
  const _NumberedCheckpointMarker({
    required this.number,
    required this.color,
    this.ringHighlight = false,
    this.highlightColor,
  });

  final int number;
  final Color color;
  final bool ringHighlight;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final label = number.toString();
    final ringColor = highlightColor ?? color;
    final icon = Icon(Icons.location_on, size: 46, color: color);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        if (ringHighlight)
          Icon(Icons.location_on, size: 52, color: ringColor.withValues(alpha: 0.35)),
        icon,
        Positioned(
          top: 5,
          child: Container(
            width: label.length > 1 ? 26 : 20,
            height: 18,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestCodeScannerPage extends StatefulWidget {
  const _QuestCodeScannerPage();

  @override
  State<_QuestCodeScannerPage> createState() => _QuestCodeScannerPageState();
}

class _QuestCodeScannerPageState extends State<_QuestCodeScannerPage> {
  bool _isHandlingScan = false;

  void _handleScan(String code) {
    if (_isHandlingScan) return;
    _isHandlingScan = true;
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Сканирование QR',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (capture.barcodes.isEmpty) return;
          final raw = capture.barcodes.first.rawValue?.trim();
          if (raw == null || raw.isEmpty) return;
          _handleScan(raw);
        },
      ),
    );
  }
}

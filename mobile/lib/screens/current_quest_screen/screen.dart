import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
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

  late final MapController _mapController;
  late final TextEditingController _codeController;
  Timer? _teamProgressPoller;
  bool _isSubmittingCode = false;
  bool _isAbandoning = false;
  int? _lastShownRunResultId;
  bool _didFitInitialCheckpoint = false;

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
      _teamProgressPoller?.cancel();
      _teamProgressPoller = Timer.periodic(const Duration(seconds: 2), (_) {
        if (!mounted) return;
        final state = StreamQuestScope.of(context);
        if (state.activeSession == null &&
            state.activeTeamRunProgress != null) {
          state.refreshActiveTeamRunProgress();
        }
      });
    });
  }

  @override
  void dispose() {
    _teamProgressPoller?.cancel();
    _mapController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// First checkpoint the user should tackle (solo: current or last passed if oddly empty).
  LatLng? _firstActiveCheckpointLatLng({
    required bool isTeamMode,
    required QuestRunProgressResponse? point,
    required TeamQuestRunProgressResponse? teamProgress,
  }) {
    if (isTeamMode) {
      if (teamProgress == null || teamProgress.checkpoints.isEmpty) {
        return null;
      }
      for (final cp in teamProgress.checkpoints) {
        if (!cp.isCompleted) {
          return LatLng(cp.latitude, cp.longitude);
        }
      }
      final last = teamProgress.checkpoints.last;
      return LatLng(last.latitude, last.longitude);
    }
    final cur = point?.currentCheckpoint;
    if (cur != null) {
      return LatLng(cur.latitude, cur.longitude);
    }
    final prev = point?.previousCheckpoints;
    if (prev != null && prev.isNotEmpty) {
      final p = prev.last;
      return LatLng(p.latitude, p.longitude);
    }
    return null;
  }

  List<Marker> _buildCheckpointMarkers({
    required bool isTeamMode,
    required QuestRunProgressResponse? point,
    required TeamQuestRunProgressResponse? teamProgress,
    required ColorScheme colorScheme,
  }) {
    final activeColor = colorScheme.error;
    final markers = <Marker>[];

    if (isTeamMode && teamProgress != null) {
      final list = teamProgress.checkpoints;
      for (var i = 0; i < list.length; i++) {
        final cp = list[i];
        final n = i + 1;
        final isDone = cp.isCompleted;
        markers.add(
          Marker(
            key: ValueKey<int>(cp.id),
            point: LatLng(cp.latitude, cp.longitude),
            width: 48,
            height: 48,
            rotate: true,
            alignment: Alignment.bottomCenter,
            child: _NumberedCheckpointMarker(
              number: n,
              color: isDone ? Colors.green.shade600 : activeColor,
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
        TeamQuestRunCheckpointView? target;
        for (final checkpoint in teamProgress.checkpoints) {
          if (!checkpoint.isCompleted) {
            target = checkpoint;
            break;
          }
        }
        if (target == null) {
          AppSnackBar.info(context, 'Все чекпоинты уже пройдены');
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
            AppSnackBar.success(context, 'Ответ принят');
            if (teamBody.progress.status.value == 'completed') {
              Navigator.of(context).maybePop();
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
    TeamQuestRunCheckpointView? teamCurrentCheckpoint;
    if (teamProgress != null) {
      for (final checkpoint in teamProgress.checkpoints) {
        if (!checkpoint.isCompleted) {
          teamCurrentCheckpoint = checkpoint;
          break;
        }
      }
    }
    final isTeamMode = session == null && teamProgress != null;
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

    final markers = _buildCheckpointMarkers(
      isTeamMode: isTeamMode,
      point: point,
      teamProgress: teamProgress,
      colorScheme: colorScheme,
    );
    final focusLatLng = _firstActiveCheckpointLatLng(
      isTeamMode: isTeamMode,
      point: point,
      teamProgress: teamProgress,
    );
    if (!_didFitInitialCheckpoint && focusLatLng != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _didFitInitialCheckpoint) return;
        _mapController.move(focusLatLng, _initialCheckpointZoom);
        _didFitInitialCheckpoint = true;
      });
    }

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
            initialChildSize: 0.42,
            minChildSize: 0.18,
            maxChildSize: 0.8,
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

                      _label(context, 'Текущая точка'),
                      TextField(
                        readOnly: true,
                        decoration: _fieldDecoration(
                          context,
                          hint: isTeamMode
                              ? (teamCurrentCheckpoint?.title ?? 'Н/Д')
                              : (point?.currentCheckpoint?.title ?? "Н/Д"),
                        ),
                      ),
                      const SizedBox(height: 12),

                      _label(context, 'Задание'),
                      TextField(
                        readOnly: true,
                        maxLines: 10,
                        decoration: _fieldDecoration(
                          context,
                          hint: isTeamMode
                              ? (teamCurrentCheckpoint?.task ?? 'Н/Д')
                              : (point?.currentCheckpoint?.task ?? "Н/Д"),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _label(context, 'Код'),
                      TextField(
                        controller: _codeController,
                        decoration: _fieldDecoration(
                          context,
                          hint: 'Введите код',
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
                              onPressed: _isSubmittingCode ? null : _submitCode,
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
                            onPressed: _scanQr,
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
  const _NumberedCheckpointMarker({required this.number, required this.color});

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final label = number.toString();
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Icon(Icons.location_on, size: 46, color: color),
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

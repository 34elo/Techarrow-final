import 'dart:async';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/models/streaming_quest_session.dart';
import 'package:techarrow_2026_app/services/api.dart';

/// Provides [StreamQuest] to the widget tree (same pattern as [StreamAuthScope]).
class StreamQuestScope extends InheritedNotifier<StreamQuestNotifier> {
  StreamQuestScope({super.key, required super.child})
    : super(notifier: StreamQuestNotifier());

  static StreamQuest of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StreamQuestScope>()!
        .notifier!
        .streamQuest;
  }
}

class StreamQuestNotifier extends ChangeNotifier {
  StreamQuestNotifier() : streamQuest = StreamQuest() {
    streamQuest.onActiveSessionChanged.listen((_) => notifyListeners());
    streamQuest.onActiveRunProgressChanged.listen((_) => notifyListeners());
    streamQuest.onActiveTeamRunProgressChanged.listen((_) => notifyListeners());
    streamQuest.onLastRunResultChanged.listen((_) => notifyListeners());
  }

  final StreamQuest streamQuest;

  @override
  void dispose() {
    streamQuest.dispose();
    super.dispose();
  }
}

/// Tracks the active quest run: physical steps + elapsed time from session start.
class StreamQuest with WidgetsBindingObserver {
  StreamQuest()
    : _controller = StreamController<StreamingQuestSession?>.broadcast() {
    _controller.stream.listen((StreamingQuestSession? next) {
      _session = next;
    });
    // Note: this controller was added later; keep it nullable so hot-reload
    // doesn't crash on older in-memory instances.
    _progressController =
        StreamController<QuestRunProgressResponse?>.broadcast();
    _progressController?.stream.listen((QuestRunProgressResponse? next) {
      _activeRunProgress = next;
    });
    _lastRunResultController =
        StreamController<QuestRunHistoryItem?>.broadcast();
    _lastRunResultController?.stream.listen((QuestRunHistoryItem? next) {
      _lastRunResult = next;
    });
    _teamProgressController =
        StreamController<TeamQuestRunProgressResponse?>.broadcast();
    _teamProgressController?.stream.listen((TeamQuestRunProgressResponse? next) {
      _activeTeamRunProgress = next;
    });
    WidgetsBinding.instance.addObserver(this);
    unawaited(_restoreActiveRunOnInit());
  }

  StreamingQuestSession? _session;
  StreamingQuestSession? get activeSession => _session;

  Stream<StreamingQuestSession?> get onActiveSessionChanged =>
      _controller.stream;

  final StreamController<StreamingQuestSession?> _controller;

  QuestRunProgressResponse? _activeRunProgress;
  QuestRunProgressResponse? get activeRunProgress => _activeRunProgress;
  QuestRunProgressResponse? _lastFinishedRunProgress;
  QuestRunProgressResponse? get lastFinishedRunProgress =>
      _lastFinishedRunProgress;

  Stream<QuestRunProgressResponse?> get onActiveRunProgressChanged =>
      _progressController?.stream ?? const Stream.empty();

  StreamController<QuestRunProgressResponse?>? _progressController;

  TeamQuestRunProgressResponse? _activeTeamRunProgress;
  TeamQuestRunProgressResponse? get activeTeamRunProgress =>
      _activeTeamRunProgress;

  Stream<TeamQuestRunProgressResponse?> get onActiveTeamRunProgressChanged =>
      _teamProgressController?.stream ?? const Stream.empty();

  StreamController<TeamQuestRunProgressResponse?>? _teamProgressController;

  QuestRunHistoryItem? _lastRunResult;
  QuestRunHistoryItem? get lastRunResult => _lastRunResult;

  Stream<QuestRunHistoryItem?> get onLastRunResultChanged =>
      _lastRunResultController?.stream ?? const Stream.empty();

  StreamController<QuestRunHistoryItem?>? _lastRunResultController;

  StreamSubscription<StepCount>? _stepSubscription;
  Timer? _elapsedTicker;
  int? _baselineTotalSteps;
  DateTime? _startedAt;
  int? _activeQuestId;
  String? _activeQuestName;

  /// Starts tracking [catalogQuest]: pedometer steps since now and wall time from [startedAt].
  ///
  /// Returns `false` if activity recognition permission was denied (Android) or tracking failed.
  Future<bool> startSession(Quest catalogQuest) async {
    stopSession();
    clearLastRunResult();
    _lastFinishedRunProgress = null;

    if (kIsWeb) {
      return false;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final status = await Permission.activityRecognition.request();
      if (!status.isGranted) {
        return false;
      }
    }

    _startedAt = DateTime.now();
    _activeQuestId = catalogQuest.id;
    _activeQuestName = catalogQuest.name;
    _baselineTotalSteps = null;

    try {
      _stepSubscription = Pedometer.stepCountStream.listen(
        (StepCount stepCount) {
          final totalSteps = stepCount.steps;
          _baselineTotalSteps ??= totalSteps;
          final delta = (totalSteps - _baselineTotalSteps!)
              .clamp(0, 1 << 30)
              .toInt();
          if (_startedAt == null ||
              _activeQuestId == null ||
              _activeQuestName == null) {
            return;
          }
          _emit(
            StreamingQuestSession(
              questId: _activeQuestId!,
              name: _activeQuestName!,
              startedAt: _startedAt!,
              steps: delta,
            ),
          );
        },
        onError: _onStepStreamError,
        cancelOnError: false,
      );
    } catch (_) {
      stopSession();
      return false;
    }

    _emit(
      StreamingQuestSession(
        questId: catalogQuest.id,
        name: catalogQuest.name,
        startedAt: _startedAt!,
        steps: 0,
      ),
    );

    _startElapsedTicker();
    await refreshActiveRunProgress(maxAttempts: 5);

    return true;
  }

  void _startElapsedTicker() {
    _elapsedTicker?.cancel();
    _elapsedTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      final s = _session;
      if (s == null) return;
      _emit(s.copyWith());
    });
  }

  Future<void> refreshActiveRunProgress({
    int maxAttempts = 1,
    Duration retryDelay = const Duration(milliseconds: 400),
  }) async {
    // _session can still be null briefly right after start/restore because
    // stream delivery is async; use active quest id as the real guard.
    if (_activeQuestId == null) return;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final res = await ApiService.instance.client.apiQuestRunsActiveGet();
        final body = res.body;
        if (res.isSuccessful && body != null) {
          _progressController?.add(body);
          return;
        }
      } catch (_) {
        // ignore and retry below
      }
      if (attempt < maxAttempts - 1) {
        await Future.delayed(retryDelay);
      }
    }
  }

  Future<void> refreshActiveTeamRunProgress() async {
    // While solo run is active, ignore team progress updates.
    if (_activeQuestId != null) return;
    try {
      final res = await ApiService.instance.client.apiTeamQuestRunsActiveGet();
      final body = res.body;
      if (res.isSuccessful && body != null) {
        _teamProgressController?.add(body);
      } else {
        _teamProgressController?.add(null);
      }
    } catch (_) {
      // keep previous value on transient failures
    }
  }

  void setActiveRunProgress(QuestRunProgressResponse progress) {
    _progressController?.add(progress);
  }

  void setActiveTeamRunProgress(TeamQuestRunProgressResponse progress) {
    _teamProgressController?.add(progress);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final s = _session;
    if (s == null) return;

    if (state == AppLifecycleState.resumed) {
      // Trigger an immediate refresh so elapsed time/steps update right away.
      _emit(s.copyWith());
      _startElapsedTicker();
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      // Keep the latest snapshot for listeners before app loses focus.
      _emit(s.copyWith());
    }
  }

  /// Step count unavailable (e.g. simulator, unsupported device): stop counting, keep session at 0 steps.
  void _onStepStreamError(Object error, StackTrace _) {
    if (!_isStepCountUnavailableError(error)) {
      return;
    }
    _cancelStepSubscriptionSilently();
    if (_startedAt != null &&
        _activeQuestId != null &&
        _activeQuestName != null) {
      _emit(
        StreamingQuestSession(
          questId: _activeQuestId!,
          name: _activeQuestName!,
          startedAt: _startedAt!,
          steps: 0,
        ),
      );
    }
  }

  bool _isStepCountUnavailableError(Object error) {
    if (error is PlatformException) {
      if (error.code == '3') return true;
      final msg = error.message ?? '';
      if (msg.contains('not available') ||
          msg.contains('Step Count is not available')) {
        return true;
      }
    }
    return false;
  }

  void _cancelStepSubscriptionSilently() {
    try {
      _stepSubscription?.cancel();
    } catch (_) {}
    _stepSubscription = null;
  }

  void _emit(StreamingQuestSession next) {
    _controller.add(next);
  }

  Future<void> fetchLatestRunResult({
    int? questId,
    int maxAttempts = 1,
    Duration retryDelay = const Duration(milliseconds: 300),
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final res = await ApiService.instance.client.apiQuestRunsHistoryGet();
        final history = res.body ?? const <QuestRunHistoryItem>[];
        if (history.isNotEmpty) {
          QuestRunHistoryItem? latest;
          for (final item in history) {
            if (questId != null && item.questId != questId) {
              continue;
            }
            if (latest == null || item.startedAt.isAfter(latest.startedAt)) {
              latest = item;
            }
          }
          if (latest != null) {
            _lastRunResultController?.add(latest);
            return;
          }
        }
      } catch (_) {
        // ignore and retry if requested
      }
      if (attempt < maxAttempts - 1) {
        await Future.delayed(retryDelay);
      }
    }
  }

  Future<void> _restoreActiveRunOnInit() async {
    try {
      final res = await ApiService.instance.client.apiQuestRunsActiveGet();
      final progress = res.body;
      if (!res.isSuccessful || progress == null) {
        return;
      }

      String questName = 'Квест';
      try {
        final questRes = await ApiService.instance.client.apiQuestsQuestIdGet(
          questId: progress.questId,
        );
        final quest = questRes.body;
        if (quest != null && quest.title.isNotEmpty) {
          questName = quest.title;
        }
      } catch (_) {
        // keep fallback name
      }

      _activeQuestId = progress.questId;
      _activeQuestName = questName;
      _startedAt = progress.startedAt;
      _progressController?.add(progress);
      _emit(
        StreamingQuestSession(
          questId: progress.questId,
          name: questName,
          startedAt: progress.startedAt,
          steps: 0,
        ),
      );
      _startElapsedTicker();
    } catch (_) {
      // no active run or request failure: leave service in empty state
    }
  }

  /// Stops step tracking and clears the active session.
  void stopSession() {
    _lastFinishedRunProgress = _activeRunProgress;
    _cancelStepSubscriptionSilently();
    _elapsedTicker?.cancel();
    _elapsedTicker = null;
    _activeRunProgress = null;
    _progressController?.add(null);
    _baselineTotalSteps = null;
    _startedAt = null;
    _activeQuestId = null;
    _activeQuestName = null;
    _controller.add(null);
  }

  void clearLastRunResult() {
    _lastRunResult = null;
    _lastRunResultController?.add(null);
    _lastFinishedRunProgress = null;
  }

  void dispose() {
    stopSession();
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
    _progressController?.close();
    _teamProgressController?.close();
    _lastRunResultController?.close();
  }
}

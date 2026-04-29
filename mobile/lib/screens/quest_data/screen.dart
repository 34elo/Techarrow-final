import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:techarrow_2026_app/gen/swagger.enums.swagger.dart' as enums;
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/screens/current_quest_screen/screen.dart';
import 'package:techarrow_2026_app/screens/quest_data/team_waiting_room_sheet.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/auth.dart';
import 'package:techarrow_2026_app/services/quest.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class QuestDataScreen extends StatefulWidget {
  const QuestDataScreen({super.key, required this.quest});

  final Quest quest;

  @override
  State<QuestDataScreen> createState() => _QuestDataScreenState();
}

enum _OwnerQuestAction { publish, archive, delete }

/// Inserts Unicode U+200B so long unbroken strings can wrap in narrow layouts.
String _injectWordBreakHints(String input, {int maxRunWithoutBreak = 36}) {
  if (maxRunWithoutBreak <= 0 || input.isEmpty) return input;
  final buf = StringBuffer();
  var runLen = 0;
  for (final r in input.runes) {
    final ch = String.fromCharCode(r);
    if (RegExp(r'\s').hasMatch(ch)) {
      runLen = 0;
      buf.write(ch);
      continue;
    }
    buf.write(ch);
    runLen++;
    if (runLen >= maxRunWithoutBreak) {
      buf.write('\u200B');
      runLen = 0;
    }
  }
  return buf.toString();
}

class _QuestDataScreenState extends State<QuestDataScreen> {
  late Quest _quest;
  bool _isTogglingFavorite = false;
  String? _description;
  String? _rulesAndWarnings;
  bool _isLoadingDetail = false;
  int? _creatorId;
  bool _isSendingComplaint = false;
  bool _isExportingPdf = false;
  bool _isUpdatingQuest = false;

  bool get _canStartQuest {
    final questState = StreamQuestScope.of(context);
    final hasActiveRun =
        questState.activeSession != null ||
        questState.activeTeamRunProgress != null;
    return _isPublished && !hasActiveRun;
  }

  bool get _isPublished {
    final status = _quest.status?.toLowerCase();
    return status == null || status == 'approved' || status == 'published';
  }

  bool get _canReport {
    final me = StreamAuthScope.of(context).currentUser;
    if (me == null || _creatorId == null) return false;
    return _creatorId != me.id;
  }

  bool get _isOwnQuest {
    final me = StreamAuthScope.of(context).currentUser;
    return me != null && _creatorId == me.id;
  }

  bool get _isArchived => _quest.status?.toLowerCase() == 'archived';

  @override
  void initState() {
    super.initState();
    _quest = widget.quest;
    _loadQuestDetail();
  }

  Future<void> _loadQuestDetail() async {
    setState(() {
      _isLoadingDetail = true;
    });
    try {
      final res = await ApiService.instance.client.apiQuestsQuestIdGet(
        questId: _quest.id,
      );
      final detail = res.body;
      if (!mounted || detail == null) return;
      setState(() {
        _description = detail.description;
        _rulesAndWarnings = detail.rulesAndWarnings;
        _creatorId = detail.creator.id;
        _quest = _quest.copyWith(
          checkpointsCount: detail.points.length,
          status: detail.status.value,
          isCompleted: detail.isCompleted ?? false,
          rejectionReason: detail.rejectionReason,
          imageSrc: detail.imageFileId != null
              ? "${ApiService.baseUrl.toString()}/api/file/${detail.imageFileId}"
              : _quest.imageSrc,
        );
      });
    } catch (_) {
      // keep fallback placeholders when detail loading fails
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDetail = false;
        });
      }
    }
  }

  Future<void> _updateArchiveStatus(
    enums.QuestArchiveStatusSchema status,
  ) async {
    if (_isUpdatingQuest) return;

    setState(() {
      _isUpdatingQuest = true;
    });

    try {
      final res = await ApiService.instance.client.apiQuestsQuestIdStatusPatch(
        questId: _quest.id,
        body: QuestArchiveStatusUpdateRequest(status: status),
      );
      if (!mounted) return;

      final body = res.body;
      if (res.isSuccessful && body != null) {
        setState(() {
          _quest = _quest.copyWith(status: body.status.value);
        });
        AppSnackBar.success(
          context,
          status == enums.QuestArchiveStatusSchema.archived
              ? 'Квест архивирован'
              : 'Квест опубликован',
        );
      } else {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось обновить статус квеста',
          response: res,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось обновить статус квеста',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingQuest = false;
        });
      }
    }
  }

  Future<void> _deleteQuest() async {
    if (_isUpdatingQuest) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Удалить квест?'),
          content: const Text('Это действие нельзя отменить.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    setState(() {
      _isUpdatingQuest = true;
    });

    try {
      final res = await ApiService.instance.client.apiQuestsQuestIdDelete(
        questId: _quest.id,
      );
      if (!mounted) return;

      if (res.isSuccessful) {
        AppSnackBar.success(context, 'Квест удален');
        Navigator.of(context).pop(true);
      } else {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось удалить квест',
          response: res,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось удалить квест',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingQuest = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isTogglingFavorite) return;
    final prev = _quest.isFavorite;

    setState(() {
      _isTogglingFavorite = true;
      _quest = _quest.copyWith(isFavorite: !prev);
    });

    try {
      if (!prev) {
        await ApiService.instance.client.apiQuestsQuestIdFavoritePost(
          questId: _quest.id,
        );
      } else {
        await ApiService.instance.client.apiQuestsQuestIdFavoriteDelete(
          questId: _quest.id,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _quest = _quest.copyWith(isFavorite: prev);
      });
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось обновить избранное',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTogglingFavorite = false;
        });
      }
    }
  }

  void _showStartQuestSheet(BuildContext context) {
    var soloMode = true;
    var isStartingRun = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        final cs = Theme.of(sheetContext).colorScheme;
        final tt = Theme.of(sheetContext).textTheme;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.paddingOf(sheetContext).bottom + 16,
            left: 16,
            right: 16,
            top: 12,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return Column(
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
                  const SizedBox(height: 16),
                  Text(
                    'Начни квест в одиночку или с командой',
                    textAlign: TextAlign.center,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: cs.outline),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: soloMode
                                ? cs.primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => setModalState(() => soloMode = true),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  'Один',
                                  textAlign: TextAlign.center,
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: soloMode
                                        ? cs.onPrimaryContainer
                                        : cs.onSurface,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: !soloMode
                                ? cs.primaryContainer
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () =>
                                  setModalState(() => soloMode = false),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  'С командой',
                                  textAlign: TextAlign.center,
                                  style: tt.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: soloMode
                                        ? cs.onSurface
                                        : cs.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (isStartingRun) return;
                      setModalState(() {
                        isStartingRun = true;
                      });

                      final navigator = Navigator.of(context);
                      final surface = Theme.of(context).colorScheme.surface;
                      if (soloMode) {
                        final startRes = await ApiService.instance.client
                            .apiQuestRunsPost(
                              body: QuestRunStartRequest(
                                questId: widget.quest.id,
                              ),
                            );

                        if (!context.mounted) return;
                        if (!startRes.isSuccessful || startRes.body == null) {
                          setModalState(() {
                            isStartingRun = false;
                          });
                          AppSnackBar.serverError(
                            context,
                            fallback: 'Не удалось запустить квест',
                            response: startRes,
                          );
                          return;
                        }
                        final initialProgress = startRes.body!;
                        final started = await StreamQuestScope.of(
                          context,
                        ).startSession(_quest);
                        if (!context.mounted) return;
                        if (!started) {
                          setModalState(() {
                            isStartingRun = false;
                          });
                          AppSnackBar.error(
                            context,
                            'Не удалось включить локальный трекинг',
                          );
                          return;
                        }
                        StreamQuestScope.of(
                          context,
                        ).setActiveRunProgress(initialProgress);
                        navigator.pop(); // close bottom sheet
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => const CurrentQuestScreen(),
                          ),
                        );
                        return;
                      } else {
                        navigator.pop(); // close bottom sheet
                        if (!context.mounted) return;
                        setModalState(() {
                          isStartingRun = false;
                        });
                        await showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: surface,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (_) => TeamWaitingRoomSheet(
                            questId: _quest.id,
                            questTitle: _quest.name,
                            quest: _quest,
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(sheetContext).primaryColorLight,
                      ),
                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        isStartingRun ? 'Запуск...' : 'Начать',
                        style: Theme.of(sheetContext).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _reportQuest() async {
    if (_isSendingComplaint) return;
    final reasonCtrl = TextEditingController();
    try {
      final reason = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (sheetContext) {
          final cs = Theme.of(sheetContext).colorScheme;
          final tt = Theme.of(sheetContext).textTheme;
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.viewInsetsOf(sheetContext).bottom + 16,
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
                const SizedBox(height: 14),
                Text(
                  'Пожаловаться на квест',
                  textAlign: TextAlign.center,
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: reasonCtrl,
                  maxLines: 4,
                  style: tt.bodyLarge?.copyWith(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: 'Опишите причину жалобы',
                    hintStyle: tt.bodyLarge?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor: cs.surfaceContainerHigh,
                    contentPadding: const EdgeInsets.all(14),
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
                      borderSide: BorderSide(color: cs.outline),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.secondaryContainer,
                      foregroundColor: cs.onSecondaryContainer,
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(sheetContext).pop(reasonCtrl.text.trim()),
                    child: Text(
                      'Отправить',
                      style: tt.titleMedium?.copyWith(
                        color: cs.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
      if (!mounted || reason == null) return;
      if (reason.isEmpty) {
        AppSnackBar.error(context, 'Укажите причину жалобы');
        return;
      }
      setState(() {
        _isSendingComplaint = true;
      });
      final res = await ApiService.instance.client
          .apiQuestsQuestIdComplaintsPost(
            questId: _quest.id,
            body: QuestComplaintCreateRequest(reason: reason),
          );
      if (!mounted) return;
      if (res.isSuccessful) {
        AppSnackBar.success(context, 'Жалоба отправлена');
      } else {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось отправить жалобу',
          response: res,
        );
      }
    } finally {
      reasonCtrl.dispose();
      if (mounted) {
        setState(() {
          _isSendingComplaint = false;
        });
      }
    }
  }

  Future<void> _downloadQuestPdf() async {
    if (_isExportingPdf) return;
    if (kIsWeb) {
      if (!mounted) return;
      AppSnackBar.info(context, 'Скачивание PDF на web не поддерживается');
      return;
    }
    setState(() {
      _isExportingPdf = true;
    });
    try {
      final res = await ApiService.instance.client.apiQuestsQuestIdExportGet(
        questId: _quest.id,
      );
      final bytes = res.bodyBytes;
      if (!mounted) return;
      if (!res.isSuccessful || bytes.isEmpty) {
        AppSnackBar.serverError(
          context,
          fallback: 'Не удалось скачать PDF',
          response: res,
        );
        return;
      }

      final dir = await getApplicationDocumentsDirectory();
      final safeName = _quest.name
          .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
          .replaceAll(' ', '_');
      final file = File('${dir.path}/quest_${_quest.id}_$safeName.pdf');
      await file.writeAsBytes(bytes, flush: true);

      if (!mounted) return;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'Экспорт квеста',
          text: 'Экспорт квеста "${_quest.name}"',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось скачать PDF',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isExportingPdf = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          _injectWordBreakHints(_quest.name, maxRunWithoutBreak: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: tt.titleMedium?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Скачать PDF',
            onPressed: _isExportingPdf ? null : _downloadQuestPdf,
            icon: _isExportingPdf
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf_outlined),
          ),
          if (_canReport)
            IconButton(
              tooltip: 'Пожаловаться',
              onPressed: _isSendingComplaint ? null : _reportQuest,
              icon: const Icon(Icons.flag_outlined),
            ),
          if (_isOwnQuest)
            PopupMenuButton<_OwnerQuestAction>(
              enabled: !_isUpdatingQuest,
              tooltip: 'Действия с квестом',
              onSelected: (action) {
                switch (action) {
                  case _OwnerQuestAction.publish:
                    _updateArchiveStatus(
                      enums.QuestArchiveStatusSchema.published,
                    );
                  case _OwnerQuestAction.archive:
                    _updateArchiveStatus(
                      enums.QuestArchiveStatusSchema.archived,
                    );
                  case _OwnerQuestAction.delete:
                    _deleteQuest();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _isArchived
                      ? _OwnerQuestAction.publish
                      : _OwnerQuestAction.archive,
                  child: Row(
                    children: [
                      Icon(
                        _isArchived
                            ? Icons.unarchive_outlined
                            : Icons.archive_outlined,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isArchived ? 'Опубликовать' : 'Архивировать',
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: _OwnerQuestAction.delete,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline),
                      SizedBox(width: 12),
                      Expanded(child: Text('Удалить')),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 48,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryCard(
                    colorScheme: cs,
                    textTheme: tt,
                    quest: _quest,
                    isOwnQuest: _isOwnQuest,
                    canFavorite: _isPublished,
                    isTogglingFavorite: _isTogglingFavorite,
                    onToggleFavorite: _toggleFavorite,
                  ),
                  const SizedBox(height: 20),
                  _InfoSection(
                    title: 'Описание',
                    icon: Icons.description_outlined,
                    isLoading: _isLoadingDetail,
                    text: (_description != null && _description!.isNotEmpty)
                        ? _description!
                        : 'Описание отсутствует',
                  ),
                  const SizedBox(height: 20),
                  _InfoSection(
                    title: 'Правила и предупреждения',
                    icon: Icons.warning_amber_rounded,
                    isLoading: _isLoadingDetail,
                    text:
                        (_rulesAndWarnings != null &&
                            _rulesAndWarnings!.isNotEmpty)
                        ? _rulesAndWarnings!
                        : 'Правила и предупреждения отсутствуют',
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          if (_canStartQuest)
            Column(
              children: [
                const Spacer(),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showStartQuestSheet(context),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColorLight,
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                              shadowColor: const WidgetStatePropertyAll(
                                Colors.transparent,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                'Начать',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.colorScheme,
    required this.textTheme,
    required this.quest,
    required this.isOwnQuest,
    required this.canFavorite,
    required this.isTogglingFavorite,
    required this.onToggleFavorite,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final Quest quest;
  final bool isOwnQuest;
  final bool canFavorite;
  final bool isTogglingFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final checkpoints = quest.checkpointsCount != null
        ? '${quest.checkpointsCount}'
        : '—';
    final status = _statusLabel(quest.status);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    quest.imageSrc,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colorScheme.surfaceContainerHigh,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: colorScheme.outline,
                        size: 44,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: _QuestBadge(
                  icon: Icons.flag_outlined,
                  label: _injectWordBreakHints(status),
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                ),
              ),
              if (isOwnQuest)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _QuestBadge(
                    icon: Icons.person_outline_rounded,
                    label: 'Мой квест',
                    backgroundColor: colorScheme.tertiaryContainer,
                    foregroundColor: colorScheme.onTertiaryContainer,
                  ),
                ),
              if (quest.isCompleted)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: _QuestBadge(
                    icon: Icons.check_circle_outline_rounded,
                    label: 'Пройден',
                    backgroundColor: colorScheme.primaryContainer,
                    foregroundColor: colorScheme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _injectWordBreakHints(quest.name),
                        softWrap: true,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (canFavorite)
                      IconButton.filledTonal(
                        icon: Icon(
                          quest.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: quest.isFavorite ? colorScheme.error : null,
                        ),
                        onPressed: isTogglingFavorite ? null : onToggleFavorite,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _QuestBadge(
                      icon: Icons.star_outline_rounded,
                      label:
                          _injectWordBreakHints('Сложность ${quest.difficulty}'),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    _QuestBadge(
                      icon: Icons.schedule_rounded,
                      label: _injectWordBreakHints(quest.duration),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    _QuestBadge(
                      icon: Icons.location_city_outlined,
                      label: _injectWordBreakHints(quest.area),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    _QuestBadge(
                      icon: Icons.route_outlined,
                      label: _injectWordBreakHints('$checkpoints чекпоинтов'),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String? status) {
    return switch (status) {
      'published' => 'Опубликован',
      'archived' => 'В архиве',
      'on_moderation' => 'На модерации',
      'rejected' => 'Отклонен',
      _ => status ?? 'Статус неизвестен',
    };
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.text,
    required this.isLoading,
  });

  final String title;
  final IconData icon;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: cs.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _injectWordBreakHints(title, maxRunWithoutBreak: 16),
                  style: tt.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            SelectableText(
              _injectWordBreakHints(text),
              style: tt.bodyLarge?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.35,
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestBadge extends StatelessWidget {
  const _QuestBadge({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.sizeOf(context).width;
    final cap = (screenW - 48).clamp(80.0, 600.0);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : cap;
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: foregroundColor),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: foregroundColor,
                      fontWeight: FontWeight.w700,
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

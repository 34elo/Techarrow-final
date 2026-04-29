import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest_draft.dart';
import 'package:techarrow_2026_app/screens/quest_creation/pages/step_one.dart';
import 'package:techarrow_2026_app/screens/quest_creation/pages/step_three.dart';
import 'package:techarrow_2026_app/screens/quest_creation/pages/step_two.dart';
import 'package:techarrow_2026_app/screens/quest_creation/pages/step_four.dart';
import 'package:techarrow_2026_app/screens/quest_creation/pages/step_five.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/quest_drafts.dart';
import 'package:techarrow_2026_app/util/quest_cover_upload.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class QuestCreationScreen extends StatefulWidget {
  const QuestCreationScreen({
    super.key,
    this.initialDraft,
    this.draftMode = false,
  });

  final QuestDraft? initialDraft;
  final bool draftMode;

  @override
  State<QuestCreationScreen> createState() => _QuestCreationScreenState();
}

class _QuestCreationScreenState extends State<QuestCreationScreen> {
  static const int _minTitleLength = 5;
  static const int _minDescriptionLength = 30;
  static const int _minCheckpointsCount = 3;
  static const int _minCheckpointTaskLength = 20;

  QuestCreationPageStatus status = QuestCreationPageStatus.stepOne;
  int checkpointsCount = 0;
  final List<QuestDraftCheckpoint> _checkpoints = [];
  int? _editingCheckpointIndex;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _difficultyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rulesController = TextEditingController();
  final TextEditingController _pointTitleController = TextEditingController();
  final TextEditingController _pointTaskController = TextEditingController();
  final TextEditingController _pointCodeWordController =
      TextEditingController();
  final TextEditingController _pointHintController = TextEditingController();
  final TextEditingController _pointRulesController = TextEditingController();
  LatLng? _selectedPoint;
  Uint8List? _coverImageBytes;
  bool _isSubmitting = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _hydrateFromDraft();
  }

  void _hydrateFromDraft() {
    final draft = widget.initialDraft;
    if (draft == null) return;
    _titleController.text = draft.title;
    _locationController.text = draft.location;
    _difficultyController.text = draft.difficulty.toString();
    _durationController.text = draft.durationMinutes.toString();
    _descriptionController.text = draft.description;
    _rulesController.text = draft.rulesAndWarnings;
    if (draft.imageBase64 != null && draft.imageBase64!.isNotEmpty) {
      _coverImageBytes = base64Decode(draft.imageBase64!);
    }
    _checkpoints.clear();
    _checkpoints.addAll(
      draft.points.map(
        (point) => QuestDraftCheckpoint(
          title: point.title,
          task: point.task,
          correctAnswer: point.correctAnswer,
          hint: point.hint,
          pointRules: point.pointRules,
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      ),
    );
    checkpointsCount = _checkpoints.length;
  }

  void changePage(QuestCreationPageStatus newStatus) {
    setState(() {
      status = newStatus;
    });
  }

  void onCheckpointSaved() {
    if (_selectedPoint == null) return;
    if (_pointTitleController.text.trim().isEmpty ||
        _pointTaskController.text.trim().length < _minCheckpointTaskLength ||
        _pointCodeWordController.text.trim().isEmpty ||
        _pointRulesController.text.trim().isEmpty) {
      return;
    }

    final next = QuestDraftCheckpoint(
      title: _pointTitleController.text.trim(),
      task: _pointTaskController.text.trim(),
      correctAnswer: _pointCodeWordController.text.trim(),
      hint: _pointHintController.text.trim(),
      pointRules: _pointRulesController.text.trim(),
      latitude: _selectedPoint!.latitude,
      longitude: _selectedPoint!.longitude,
    );

    if (_editingCheckpointIndex != null) {
      _checkpoints[_editingCheckpointIndex!] = next;
    } else {
      _checkpoints.add(next);
    }

    _pointTitleController.clear();
    _pointTaskController.clear();
    _pointCodeWordController.clear();
    _pointHintController.clear();
    _pointRulesController.clear();
    _selectedPoint = null;
    _editingCheckpointIndex = null;

    setState(() {
      checkpointsCount = _checkpoints.length;
      status = QuestCreationPageStatus.stepFour;
    });
  }

  void _editCheckpoint(int index) {
    final checkpoint = _checkpoints[index];
    _pointTitleController.text = checkpoint.title;
    _pointTaskController.text = checkpoint.task;
    _pointCodeWordController.text = checkpoint.correctAnswer;
    _pointHintController.text = checkpoint.hint;
    _pointRulesController.text = checkpoint.pointRules;
    _selectedPoint = LatLng(checkpoint.latitude, checkpoint.longitude);
    _editingCheckpointIndex = index;
    setState(() {
      status = QuestCreationPageStatus.stepThree;
    });
  }

  void _startCheckpointAt(LatLng point) {
    _pointTitleController.clear();
    _pointTaskController.clear();
    _pointCodeWordController.clear();
    _pointHintController.clear();
    _pointRulesController.clear();
    _selectedPoint = point;
    _editingCheckpointIndex = null;

    setState(() {
      status = QuestCreationPageStatus.stepThree;
    });
  }

  void _dismissCheckpointForm() {
    _pointTitleController.clear();
    _pointTaskController.clear();
    _pointCodeWordController.clear();
    _pointHintController.clear();
    _pointRulesController.clear();
    _selectedPoint = null;
    _editingCheckpointIndex = null;

    setState(() {
      status = QuestCreationPageStatus.stepFour;
    });
  }

  Future<void> _pickCoverImage() async {
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      final prepared = await prepareQuestCoverForUpload(bytes);
      if (!mounted) return;
      setState(() {
        _coverImageBytes = prepared;
      });
    } catch (e, st) {
      assert(() {
        debugPrint('_pickCoverImage: $e\n$st');
        return true;
      }());
      if (!mounted) return;
      AppSnackBar.error(
        context,
        'Не удалось выбрать или обработать изображение',
      );
    }
  }

  void _removeCoverImage() {
    setState(() {
      _coverImageBytes = null;
    });
  }

  Future<void> _submitQuest() async {
    if (_isSubmitting) return;
    if (!_validateBeforeSubmit()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: const Text('Вы точно хотите отправить квест на модерацию?'),
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

    setState(() {
      _isSubmitting = true;
    });
    try {
      final points = _checkpoints
          .map(
            (point) => <String, dynamic>{
              'title': point.title,
              'task': point.task,
              'correct_answer': point.correctAnswer,
              'hint': point.hint.isEmpty ? null : point.hint,
              'point_rules': point.pointRules,
              'latitude': point.latitude,
              'longitude': point.longitude,
            },
          )
          .toList();
      final body = BodyCreateQuestApiQuestsPost(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        difficulty: int.tryParse(_difficultyController.text.trim()) ?? 1,
        durationMinutes: int.tryParse(_durationController.text.trim()) ?? 0,
        rulesAndWarnings: _rulesController.text.trim().isEmpty
            ? null
            : _rulesController.text.trim(),
        points: jsonEncode(points),
      );
      final response = await ApiService.instance.createQuest(
        body: body,
        imageBytes: _coverImageBytes,
      );
      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (widget.draftMode && widget.initialDraft != null) {
          await QuestDraftsService.instance.delete(widget.initialDraft!.id);
        }
        if (!mounted) return;
        Navigator.of(context).pop(true);
        return;
      }

      AppSnackBar.serverError(
        context,
        fallback: 'Не удалось создать квест',
        response: response,
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.serverError(
        context,
        fallback: 'Ошибка при отправке квеста',
        error: e,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _validateBeforeSubmit() {
    final title = _titleController.text.trim();
    if (title.length < _minTitleLength) {
      _showValidationError(
        'Название должно быть не менее $_minTitleLength символов',
        QuestCreationPageStatus.stepOne,
      );
      return false;
    }

    if (_locationController.text.trim().isEmpty) {
      _showValidationError(
        'Укажите район или город',
        QuestCreationPageStatus.stepOne,
      );
      return false;
    }

    final difficulty = int.tryParse(_difficultyController.text.trim());
    if (difficulty == null || difficulty < 1 || difficulty > 5) {
      _showValidationError(
        'Выберите сложность',
        QuestCreationPageStatus.stepOne,
      );
      return false;
    }

    final duration = int.tryParse(_durationController.text.trim());
    if (duration == null || duration <= 0) {
      _showValidationError(
        'Введите длительность больше 0',
        QuestCreationPageStatus.stepOne,
      );
      return false;
    }

    final description = _descriptionController.text.trim();
    if (description.length < _minDescriptionLength) {
      _showValidationError(
        'Описание должно быть не менее $_minDescriptionLength символов',
        QuestCreationPageStatus.stepTwo,
      );
      return false;
    }

    if (_checkpoints.length < _minCheckpointsCount) {
      _showValidationError(
        'Добавьте не менее $_minCheckpointsCount чекпоинтов',
        QuestCreationPageStatus.stepFour,
      );
      return false;
    }

    final hasInvalidCheckpoint = _checkpoints.any(
      (point) =>
          point.title.trim().isEmpty ||
          point.task.trim().length < _minCheckpointTaskLength ||
          point.correctAnswer.trim().isEmpty ||
          point.pointRules.trim().isEmpty,
    );
    if (hasInvalidCheckpoint) {
      _showValidationError(
        'Заполните название, задание от $_minCheckpointTaskLength символов, кодовое слово и правила у каждого чекпоинта',
        QuestCreationPageStatus.stepFour,
      );
      return false;
    }

    return true;
  }

  void _showValidationError(
    String message,
    QuestCreationPageStatus targetStep,
  ) {
    setState(() {
      status = targetStep;
    });
    AppSnackBar.error(context, message);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _difficultyController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    _pointTitleController.dispose();
    _pointTaskController.dispose();
    _pointCodeWordController.dispose();
    _pointHintController.dispose();
    _pointRulesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget currentPage;
    switch (status) {
      case QuestCreationPageStatus.stepOne:
        currentPage = QuestCreationStepOnePage(
          key: ValueKey(status),
          changePage: changePage,
          titleController: _titleController,
          locationController: _locationController,
          difficultyController: _difficultyController,
          durationController: _durationController,
        );
      case QuestCreationPageStatus.stepTwo:
        currentPage = QuestCreationStepTwoPage(
          key: ValueKey(status),
          changePage: changePage,
          descriptionController: _descriptionController,
          rulesController: _rulesController,
          coverImageBytes: _coverImageBytes,
          onPickCoverImage: _pickCoverImage,
          onRemoveCoverImage: _removeCoverImage,
        );
      case QuestCreationPageStatus.stepThree:
        currentPage = QuestCreationStepThreePage(
          key: ValueKey(status),
          changePage: changePage,
          onCheckpointSaved: onCheckpointSaved,
          pointTitleController: _pointTitleController,
          taskController: _pointTaskController,
          codeWordController: _pointCodeWordController,
          hintController: _pointHintController,
          pointRulesController: _pointRulesController,
          selectedPoint: _selectedPoint,
          onPointChanged: (point) {
            setState(() {
              _selectedPoint = point;
            });
          },
          onSheetDismissed: _dismissCheckpointForm,
          isEditing: _editingCheckpointIndex != null,
        );
      case QuestCreationPageStatus.stepFour:
        currentPage = QuestCreationStepFourPage(
          key: ValueKey(status),
          changePage: changePage,
          checkpointsCount: checkpointsCount,
          checkpoints: _checkpoints,
          onCheckpointTap: _editCheckpoint,
          onMapTap: _startCheckpointAt,
        );
      case QuestCreationPageStatus.stepFive:
        currentPage = QuestCreationStepFivePage(
          key: ValueKey(status),
          changePage: changePage,
          title: _titleController.text.trim(),
          location: _locationController.text.trim(),
          difficulty: _difficultyController.text.trim(),
          durationMinutes: _durationController.text.trim(),
          description: _descriptionController.text.trim(),
          rulesAndWarnings: _rulesController.text.trim(),
          checkpointsCount: checkpointsCount,
          isSubmitting: _isSubmitting,
          onSaveDraft: _saveDraftWithFeedback,
          onSubmit: _submitQuest,
        );
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop || !widget.draftMode) return;
        await _saveDraft();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.02),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: currentPage,
      ),
    );
  }

  Future<void> _saveDraft() async {
    final hasAnyData =
        _titleController.text.trim().isNotEmpty ||
        _locationController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty ||
        _rulesController.text.trim().isNotEmpty ||
        _checkpoints.isNotEmpty ||
        _coverImageBytes != null;
    if (!hasAnyData) return;

    final id =
        widget.initialDraft?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final draft = QuestDraft(
      id: id,
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      difficulty: int.tryParse(_difficultyController.text.trim()) ?? 1,
      durationMinutes: int.tryParse(_durationController.text.trim()) ?? 0,
      description: _descriptionController.text.trim(),
      rulesAndWarnings: _rulesController.text.trim(),
      checkpointsCount: _checkpoints.length,
      updatedAtIso: DateTime.now().toIso8601String(),
      points: _checkpoints
          .map(
            (point) => QuestDraftPoint(
              title: point.title,
              task: point.task,
              correctAnswer: point.correctAnswer,
              hint: point.hint,
              pointRules: point.pointRules,
              latitude: point.latitude,
              longitude: point.longitude,
            ),
          )
          .toList(),
      imageBase64: _coverImageBytes == null
          ? null
          : base64Encode(_coverImageBytes!),
    );
    await QuestDraftsService.instance.upsert(draft);
  }

  Future<void> _saveDraftWithFeedback() async {
    await _saveDraft();
    if (!mounted) return;
    AppSnackBar.success(context, 'Черновик сохранен');
  }
}

enum QuestCreationPageStatus { stepOne, stepTwo, stepThree, stepFour, stepFive }

class QuestDraftCheckpoint {
  const QuestDraftCheckpoint({
    required this.title,
    required this.task,
    required this.correctAnswer,
    required this.hint,
    required this.pointRules,
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String task;
  final String correctAnswer;
  final String hint;
  final String pointRules;
  final double latitude;
  final double longitude;
}

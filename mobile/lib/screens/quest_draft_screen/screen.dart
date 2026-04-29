import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:techarrow_2026_app/models/quest_draft.dart';
import 'package:techarrow_2026_app/services/quest_drafts.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';

class QuestDraftScreen extends StatefulWidget {
  const QuestDraftScreen({super.key, this.initialDraft});

  final QuestDraft? initialDraft;

  @override
  State<QuestDraftScreen> createState() => _QuestDraftScreenState();
}

class _QuestDraftScreenState extends State<QuestDraftScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _difficultyController = TextEditingController();
  final _durationController = TextEditingController();
  final _checkpointsController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rulesController = TextEditingController();
  final _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    final draft = widget.initialDraft;
    if (draft == null) {
      _difficultyController.text = '1';
      _durationController.text = '0';
      _checkpointsController.text = '0';
      return;
    }
    _titleController.text = draft.title;
    _locationController.text = draft.location;
    _difficultyController.text = draft.difficulty.toString();
    _durationController.text = draft.durationMinutes.toString();
    _checkpointsController.text = draft.checkpointsCount.toString();
    _descriptionController.text = draft.description;
    _rulesController.text = draft.rulesAndWarnings;
    if (draft.imageBase64 != null && draft.imageBase64!.isNotEmpty) {
      _imageBytes = base64Decode(draft.imageBase64!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _difficultyController.dispose();
    _durationController.dispose();
    _checkpointsController.dispose();
    _descriptionController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
    });
  }

  Future<void> _saveDraft() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      AppSnackBar.error(context, 'Введите название квеста');
      return;
    }
    final now = DateTime.now().toIso8601String();
    final id =
        widget.initialDraft?.id ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final draft = QuestDraft(
      id: id,
      title: title,
      location: _locationController.text.trim(),
      difficulty: int.tryParse(_difficultyController.text.trim()) ?? 1,
      durationMinutes: int.tryParse(_durationController.text.trim()) ?? 0,
      checkpointsCount: int.tryParse(_checkpointsController.text.trim()) ?? 0,
      description: _descriptionController.text.trim(),
      rulesAndWarnings: _rulesController.text.trim(),
      updatedAtIso: now,
      imageBase64: _imageBytes == null ? null : base64Encode(_imageBytes!),
    );
    await QuestDraftsService.instance.upsert(draft);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialDraft == null
              ? 'Новый черновик'
              : 'Редактирование черновика',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickCover,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _imageBytes == null
                        ? Container(
                            color: cs.surfaceContainerHigh,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add_a_photo_outlined,
                              size: 32,
                            ),
                          )
                        : Image.memory(_imageBytes!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _field('Название', _titleController),
              _field('Город', _locationController),
              Row(
                children: [
                  Expanded(
                    child: _field(
                      'Сложность',
                      _difficultyController,
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _field(
                      'Длительность (мин)',
                      _durationController,
                      isNumber: true,
                    ),
                  ),
                ],
              ),
              _field(
                'Кол-во чекпоинтов',
                _checkpointsController,
                isNumber: true,
              ),
              const SizedBox(height: 8),
              _sectionTitle('Описание'),
              _multiline(
                _descriptionController,
                hint: 'Добавьте описание квеста',
              ),
              const SizedBox(height: 16),
              _sectionTitle('Правила и предупреждения'),
              _multiline(
                _rulesController,
                hint: 'Добавьте правила и предупреждения',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: ElevatedButton(
            onPressed: _saveDraft,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColorLight,
              foregroundColor: cs.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Сохранить черновик'),
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  Widget _multiline(TextEditingController controller, {required String hint}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        minLines: 5,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}

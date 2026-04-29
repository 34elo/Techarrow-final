import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:techarrow_2026_app/screens/quest_creation/screen.dart';

class QuestCreationStepTwoPage extends StatefulWidget {
  const QuestCreationStepTwoPage({
    super.key,
    required this.changePage,
    required this.descriptionController,
    required this.rulesController,
    required this.coverImageBytes,
    required this.onPickCoverImage,
    required this.onRemoveCoverImage,
  });

  final void Function(QuestCreationPageStatus status) changePage;
  final TextEditingController descriptionController;
  final TextEditingController rulesController;
  final Uint8List? coverImageBytes;
  final Future<void> Function() onPickCoverImage;
  final VoidCallback onRemoveCoverImage;

  @override
  State<QuestCreationStepTwoPage> createState() =>
      _QuestCreationStepTwoPageState();
}

class _QuestCreationStepTwoPageState extends State<QuestCreationStepTwoPage> {
  static const int _minDescriptionLength = 30;

  bool get _canProceed =>
      widget.descriptionController.text.trim().length >= _minDescriptionLength;

  String? get _descriptionError {
    final description = widget.descriptionController.text.trim();
    if (description.isEmpty || description.length >= _minDescriptionLength) {
      return null;
    }
    return 'Описание должно быть не менее $_minDescriptionLength символов';
  }

  @override
  void initState() {
    super.initState();
    widget.descriptionController.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.descriptionController.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? hint,
    String? errorText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      hintText: hint,
      errorText: errorText,
      filled: true,
      fillColor: colorScheme.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Создание квеста',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 28,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      _label(context, 'Обложка'),
                      InkWell(
                        onTap: widget.onPickCoverImage,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: widget.coverImageBytes == null
                              ? Text(
                                  'Загрузите обложку 1:1',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    widget.coverImageBytes!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                      if (widget.coverImageBytes != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: widget.onRemoveCoverImage,
                            child: const Text('Удалить обложку'),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      _label(context, 'Описание'),
                      TextField(
                        controller: widget.descriptionController,
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          context,
                          hint: 'Введите описание квеста',
                          errorText: _descriptionError,
                        ),
                      ),
                      const SizedBox(height: 14),
                      _label(context, 'Правила и предупреждения'),
                      TextField(
                        controller: widget.rulesController,
                        maxLines: 3,
                        decoration: _fieldDecoration(
                          context,
                          hint: 'Укажите правила и предупреждения',
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colorScheme.secondaryContainer,
                            foregroundColor: colorScheme.onSecondaryContainer,
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          onPressed: _canProceed
                              ? () => widget.changePage(
                                  QuestCreationPageStatus.stepFour,
                                )
                              : null,
                          child: Text(
                            'Далее',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

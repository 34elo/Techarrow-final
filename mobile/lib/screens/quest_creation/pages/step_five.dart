import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/screens/quest_creation/screen.dart';

class QuestCreationStepFivePage extends StatelessWidget {
  const QuestCreationStepFivePage({
    super.key,
    required this.changePage,
    required this.title,
    required this.location,
    required this.difficulty,
    required this.durationMinutes,
    required this.description,
    required this.rulesAndWarnings,
    required this.checkpointsCount,
    required this.isSubmitting,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  final void Function(QuestCreationPageStatus status) changePage;
  final String title;
  final String location;
  final String difficulty;
  final String durationMinutes;
  final String description;
  final String rulesAndWarnings;
  final int checkpointsCount;
  final bool isSubmitting;
  final Future<void> Function() onSaveDraft;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget previewRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value.isEmpty ? 'Не заполнено' : value,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => changePage(QuestCreationPageStatus.stepFour),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Проверка квеста',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      previewRow('Название', title),
                      previewRow('Район/город', location),
                      previewRow('Сложность', difficulty),
                      previewRow('Длительность, мин', durationMinutes),
                      previewRow('Описание', description),
                      previewRow('Правила', rulesAndWarnings),
                      previewRow('Чекпоинты', checkpointsCount.toString()),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: isSubmitting ? null : onSaveDraft,
                      child: const Text('Сохранить черновик'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.secondaryContainer,
                        foregroundColor: colorScheme.onSecondaryContainer,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: isSubmitting ? null : onSubmit,
                      child: isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Отправить на модерацию',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

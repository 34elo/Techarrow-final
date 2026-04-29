import 'dart:async';

import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/screens/quest_data/screen.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.quest,
    required this.onFavorite,
    this.onReturn,
    this.showFavourite = true,
    this.showCompletedBadge = true,
  });

  final Quest quest;
  final bool showFavourite;
  /// When false, hides the "Пройден" overlay (e.g. history uses run status instead).
  final bool showCompletedBadge;
  final void Function(bool value) onFavorite;
  final FutureOr<dynamic> Function()? onReturn;

  void _openPreview(BuildContext context) {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => QuestDataScreen(quest: quest),
          ),
        )
        .then((_) {
          if (onReturn != null) {
            onReturn!();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canFavorite = showFavourite && _isPublished(quest.status);

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openPreview(context),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    quest.imageSrc,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colorScheme.surfaceContainerHighest,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.05),
                          Colors.black.withValues(alpha: 0.48),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    bottom: 10,
                    right: canFavorite ? 54 : 10,
                    child: Text(
                      quest.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (canFavorite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.88),
                        shape: const CircleBorder(),
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () => onFavorite(!quest.isFavorite),
                          icon: Icon(
                            quest.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: quest.isFavorite
                                ? colorScheme.error
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  if (quest.status != null && !_isPublished(quest.status))
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _QuestStatusChip(
                        status: quest.status!,
                        rejectionReason: quest.rejectionReason,
                      ),
                    ),
                  if (showCompletedBadge && quest.isCompleted)
                    Positioned(
                      left: 10,
                      top: quest.status != null && !_isPublished(quest.status)
                          ? 44
                          : 10,
                      child: const _CompletedChip(),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _MetaRow(
                            icon: Icons.star_outline_rounded,
                            label: 'Сложность ${quest.difficulty}',
                          ),
                          const SizedBox(height: 2),
                          _MetaRow(
                            icon: Icons.schedule_rounded,
                            label: quest.duration,
                          ),
                          const SizedBox(height: 2),
                          _MetaRow(
                            icon: Icons.location_city_outlined,
                            label: quest.area,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 28,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Подробнее',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isPublished(String? status) {
    final value = status?.toLowerCase();
    return value == null || value == 'published' || value == 'approved';
  }
}

class _CompletedChip extends StatelessWidget {
  const _CompletedChip();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 14,
            color: colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'Пройден',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuestStatusChip extends StatelessWidget {
  const _QuestStatusChip({required this.status, this.rejectionReason});

  final String status;
  final String? rejectionReason;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lower = status.toLowerCase();
    final rejected = lower == 'rejected';

    final chip = Container(
      constraints: const BoxConstraints(maxWidth: 136),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              _label(status),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onErrorContainer,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (rejected) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.info_outline_rounded,
              size: 14,
              color: colorScheme.onErrorContainer,
            ),
          ],
        ],
      ),
    );

    if (!rejected) return chip;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showRejectedReasonDialog(context, rejectionReason),
        borderRadius: BorderRadius.circular(999),
        child: Tooltip(
          message: 'Нажми, чтобы увидеть причину отклонения',
          child: chip,
        ),
      ),
    );
  }

  String _label(String status) {
    return switch (status.toLowerCase()) {
      'archived' => 'Архив',
      'on_moderation' => 'Модерация',
      'rejected' => 'Отклонен',
      _ => status,
    };
  }
}

void _showRejectedReasonDialog(BuildContext context, String? reason) {
  final raw = reason?.trim();
  final displayed = (raw != null && raw.isNotEmpty)
      ? raw
      : 'Модератор не указал комментарий к отклонению.';
  final cs = Theme.of(context).colorScheme;
  final tt = Theme.of(context).textTheme;
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: Icon(Icons.rate_review_outlined, color: cs.error),
      title: Text('Причина отклонения', style: tt.titleLarge),
      content: SingleChildScrollView(
        child: SelectableText(
          displayed,
          style: tt.bodyLarge?.copyWith(color: cs.onSurface),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Закрыть')),
      ],
    ),
  );
}

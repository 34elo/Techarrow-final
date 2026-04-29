import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.enums.swagger.dart' as enums;
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/services/quest.dart';

class QuestResultScreen extends StatelessWidget {
  const QuestResultScreen({super.key, required this.result});

  final QuestRunHistoryItem result;

  ButtonStyle _primaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.surfaceContainerHighest;
        }
        return theme.primaryColorLight;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurfaceVariant;
        }
        return colorScheme.onPrimary;
      }),
      shadowColor: WidgetStateProperty.all(Colors.transparent),
    );
  }

  String _formatDuration() {
    final d = result.completedAt.difference(result.startedAt).abs();
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (h == 0) return '$m:$s';
    return '${h.toString().padLeft(2, '0')}:$m:$s';
  }

  String _headlineForStatus(enums.QuestRunStatusSchema status) {
    return switch (status) {
      enums.QuestRunStatusSchema.completed => 'Квест пройден',
      enums.QuestRunStatusSchema.abandoned => 'Квест остановлен',
      _ => 'Итог квеста',
    };
  }

  IconData _iconForStatus(enums.QuestRunStatusSchema status) {
    return switch (status) {
      enums.QuestRunStatusSchema.completed => Icons.emoji_events_rounded,
      enums.QuestRunStatusSchema.abandoned => Icons.flag_rounded,
      _ => Icons.assignment_turned_in_rounded,
    };
  }

  void _close(BuildContext context) {
    StreamQuestScope.of(context).clearLastRunResult();
    final nav = Navigator.of(context, rootNavigator: true);
    nav.popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final status = result.status;
    final headline = _headlineForStatus(status);
    final icon = _iconForStatus(status);
    final accent = status == enums.QuestRunStatusSchema.completed
        ? cs.tertiary
        : cs.primary;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.lerp(cs.primaryContainer, cs.surface, 0.35)!,
                cs.surface,
                cs.surface,
              ],
              stops: const [0.0, 0.42, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent.withValues(alpha: 0.18),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.22),
                            blurRadius: 28,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 52, color: accent),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    headline,
                    textAlign: TextAlign.center,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.questTitle,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: tt.titleMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Material(
                    elevation: 0,
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(24),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                      child: Column(
                        children: [
                          _StatRow(
                            icon: Icons.stars_rounded,
                            iconColor: cs.tertiary,
                            label: 'Очки',
                            value: '${result.pointsAwarded}',
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Divider(
                              height: 1,
                              color: cs.outlineVariant.withValues(alpha: 0.6),
                            ),
                          ),
                          _StatRow(
                            icon: Icons.schedule_rounded,
                            iconColor: cs.primary,
                            label: 'Время в квесте',
                            value: _formatDuration(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: _primaryButtonStyle(context),
                          onPressed: () => _close(context),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Закрыть',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
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
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: tt.titleSmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

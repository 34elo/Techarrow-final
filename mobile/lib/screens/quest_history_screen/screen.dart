import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.enums.swagger.dart' as enums;
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/widgets/event_card.dart';

class QuestHistoryScreen extends StatefulWidget {
  const QuestHistoryScreen({super.key});

  @override
  State<QuestHistoryScreen> createState() => _QuestHistoryScreenState();
}

class _QuestHistoryScreenState extends State<QuestHistoryScreen> {
  static const String _sampleQuestImage =
      'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQRZRfRJNfPiR_PG_fa6JHQw3AEYUt0c-oCRwt07bUQRZfdGHhK';

  late final Future<List<_QuestHistoryEntry>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  Future<List<_QuestHistoryEntry>> _loadHistory() async {
    final res = await ApiService.instance.client.apiQuestRunsHistoryGet();
    final history = res.body ?? <QuestRunHistoryItem>[];

    final futures = history.map((h) async {
      final isCompleted = h.status == enums.QuestRunStatusSchema.completed;
      final detailRes = await ApiService.instance.client.apiQuestsQuestIdGet(
        questId: h.questId,
      );
      final item = detailRes.body;

      if (item == null) {
        return _QuestHistoryEntry(
          isCompleted: isCompleted,
          quest: Quest(
            id: h.questId,
            isFavorite: false,
            isCompleted: isCompleted,
            name: h.questTitle,
            duration: '',
            area: '',
            difficulty: '',
            imageSrc: _sampleQuestImage,
          ),
        );
      }

      return _QuestHistoryEntry(
        isCompleted: isCompleted,
        quest: Quest(
          id: item.id,
          isFavorite: item.isFavourite ?? false,
          isCompleted: item.isCompleted ?? isCompleted,
          name: item.title,
          duration: '${item.durationMinutes} мин',
          area: item.location,
          difficulty: item.difficulty.toString(),
          imageSrc: item.imageFileId != null
              ? "${ApiService.baseUrl.toString()}/api/file/${item.imageFileId}"
              : _sampleQuestImage,
        ),
      );
    });

    return Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'История квестов',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<_QuestHistoryEntry>>(
          future: _historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final entries = snapshot.data ?? <_QuestHistoryEntry>[];
            if (entries.isEmpty) {
              return const Center(child: Text('История пуста'));
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.79,
              ),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Stack(
                  children: [
                    QuestCard(
                      quest: entry.quest,
                      showFavourite: false,
                      showCompletedBadge: false,
                      onFavorite: (_) {},
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _QuestHistoryStatusBadge(
                        isCompleted: entry.isCompleted,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _QuestHistoryEntry {
  const _QuestHistoryEntry({required this.quest, required this.isCompleted});

  final Quest quest;
  final bool isCompleted;
}

class _QuestHistoryStatusBadge extends StatelessWidget {
  const _QuestHistoryStatusBadge({required this.isCompleted});

  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isCompleted
        ? colorScheme.primaryContainer
        : colorScheme.errorContainer;
    final foregroundColor = isCompleted
        ? colorScheme.onPrimaryContainer
        : colorScheme.onErrorContainer;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              size: 15,
              color: foregroundColor,
            ),
            const SizedBox(width: 4),
            Text(
              isCompleted ? 'Завершён' : 'Не завершён',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

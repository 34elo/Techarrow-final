import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest_draft.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/screens/quest_creation/screen.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/quest_drafts.dart';
import 'package:techarrow_2026_app/widgets/event_card.dart';
import 'package:techarrow_2026_app/gen/swagger.enums.swagger.dart' as enums;

enum _MyQuestsTab { favourites, created }

class _CreatedQuestItem {
  const _CreatedQuestItem({required this.quest, required this.status});

  final Quest quest;
  final enums.QuestStatusSchema status;
}

class _CreatedTabData {
  const _CreatedTabData({required this.remote, required this.drafts});

  final List<_CreatedQuestItem> remote;
  final List<QuestDraft> drafts;
}

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  static const String _sampleQuestImage =
      'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQRZRfRJNfPiR_PG_fa6JHQw3AEYUt0c-oCRwt07bUQRZfdGHhK';

  late Future<List<Quest>> _favoritesFuture;
  late Future<List<_CreatedQuestItem>> _createdFuture;
  late Future<List<QuestDraft>> _draftsFuture;
  _MyQuestsTab _tab = _MyQuestsTab.favourites;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _loadFavorites();
    _createdFuture = _loadCreated();
    _draftsFuture = _loadDrafts();
  }

  Future<List<Quest>> _loadFavorites() async {
    final res = await ApiService.instance.client.apiQuestsFavoritesGet();
    final items = res.body?.items ?? <QuestResponse>[];

    return items
        .map(
          (item) => Quest(
            id: item.id,
            isFavorite: item.isFavourite ?? true,
            isCompleted: item.isCompleted ?? false,
            name: item.title,
            duration: '${item.durationMinutes} мин',
            area: item.location,
            difficulty: item.difficulty.toString(),
            imageSrc: item.imageFileId != null
                ? "${ApiService.baseUrl.toString()}/api/file/${item.imageFileId}"
                : _sampleQuestImage,
            status: item.status.value,
          ),
        )
        .toList();
  }

  Future<List<_CreatedQuestItem>> _loadCreated() async {
    final res = await ApiService.instance.client.apiQuestsMyGet();
    final items = res.body?.items ?? <QuestResponse>[];

    return items
        .map(
          (item) => _CreatedQuestItem(
            quest: Quest(
              id: item.id,
              isFavorite: item.isFavourite ?? false,
              isCompleted: item.isCompleted ?? false,
              name: item.title,
              duration: '${item.durationMinutes} мин',
              area: item.location,
              difficulty: item.difficulty.toString(),
              imageSrc: item.imageFileId != null
                  ? "${ApiService.baseUrl.toString()}/api/file/${item.imageFileId}"
                  : _sampleQuestImage,
              status: item.status.value,
              rejectionReason: item.rejectionReason,
            ),
            status: item.status,
          ),
        )
        .toList();
  }

  Future<List<QuestDraft>> _loadDrafts() {
    return QuestDraftsService.instance.getAll();
  }

  Future<_CreatedTabData> _loadCreatedTabData() async {
    final remote = await _createdFuture;
    final drafts = await _draftsFuture;
    return _CreatedTabData(remote: remote, drafts: drafts);
  }

  void _setTab(_MyQuestsTab tab) {
    if (_tab == tab) return;
    setState(() {
      _tab = tab;
    });
  }

  Future<void> _toggleFavorite(Quest quest, bool value) async {
    if (value) {
      await ApiService.instance.client.apiQuestsQuestIdFavoritePost(
        questId: quest.id,
      );
    } else {
      await ApiService.instance.client.apiQuestsQuestIdFavoriteDelete(
        questId: quest.id,
      );
    }

    setState(() {
      _favoritesFuture = _loadFavorites();
      _createdFuture = _loadCreated();
      _draftsFuture = _loadDrafts();
    });
  }

  Future<void> _openDraftEditor({QuestDraft? draft}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            QuestCreationScreen(draftMode: true, initialDraft: draft),
      ),
    );
    if (!mounted) return;
    setState(() {
      _createdFuture = _loadCreated();
      _draftsFuture = _loadDrafts();
    });
  }

  Future<void> _deleteDraft(QuestDraft draft) async {
    await QuestDraftsService.instance.delete(draft.id);
    if (!mounted) return;
    setState(() {
      _draftsFuture = _loadDrafts();
    });
  }

  Future<void> _refreshAllTabData() async {
    setState(() {
      _favoritesFuture = _loadFavorites();
      _createdFuture = _loadCreated();
      _draftsFuture = _loadDrafts();
    });
    await Future.wait([
      _favoritesFuture,
      _createdFuture,
      _draftsFuture,
    ]);
  }

  Widget _pullToRefreshEmpty(String message) {
    return RefreshIndicator(
      onRefresh: _refreshAllTabData,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: Text(message)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Мои квесты',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      floatingActionButton: _tab == _MyQuestsTab.created
          ? FloatingActionButton(
              heroTag: 'favourite-create-draft-fab',
              onPressed: () => _openDraftEditor(),
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: _TabSlider(active: _tab, onChanged: _setTab),
            ),
            Expanded(
              child: _tab == _MyQuestsTab.favourites
                  ? FutureBuilder<List<Quest>>(
                      future: _favoritesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final quests = snapshot.data ?? <Quest>[];
                        if (quests.isEmpty) {
                          return _pullToRefreshEmpty('Нет избранных квестов');
                        }

                        return RefreshIndicator(
                          onRefresh: _refreshAllTabData,
                          child: GridView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: quests.length,
                          itemBuilder: (context, index) {
                            final quest = quests[index];
                            return QuestCard(
                              quest: quest,
                              onFavorite: (value) async {
                                await _toggleFavorite(quest, value);
                              },
                              onReturn: () async {
                                setState(() {
                                  _favoritesFuture = _loadFavorites();
                                  _createdFuture = _loadCreated();
                                });
                              },
                            );
                          },
                        ),
                        );
                      },
                    )
                  : FutureBuilder<_CreatedTabData>(
                      future: _loadCreatedTabData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final remoteItems =
                            snapshot.data?.remote ?? <_CreatedQuestItem>[];
                        final draftItems =
                            snapshot.data?.drafts ?? <QuestDraft>[];
                        if (remoteItems.isEmpty && draftItems.isEmpty) {
                          return _pullToRefreshEmpty(
                            'Нет созданных квестов и черновиков',
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: _refreshAllTabData,
                          child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                          slivers: [
                            if (draftItems.isNotEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    8,
                                    12,
                                    8,
                                  ),
                                  child: Text(
                                    'Черновики',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                              ),
                            if (draftItems.isNotEmpty)
                              SliverList.builder(
                                itemCount: draftItems.length,
                                itemBuilder: (context, index) {
                                  final draft = draftItems[index];
                                  return _DraftCard(
                                    draft: draft,
                                    onEdit: () =>
                                        _openDraftEditor(draft: draft),
                                    onDelete: () => _deleteDraft(draft),
                                  );
                                },
                              ),
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                12,
                                draftItems.isEmpty ? 0 : 8,
                                12,
                                0,
                              ),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                      childAspectRatio: 0.7,
                                    ),
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final item = remoteItems[index];
                                  return QuestCard(
                                    quest: item.quest,
                                    onFavorite: (value) async {
                                      await _toggleFavorite(item.quest, value);
                                    },
                                    onReturn: () async {
                                      setState(() {
                                        _favoritesFuture = _loadFavorites();
                                        _createdFuture = _loadCreated();
                                      });
                                    },
                                  );
                                }, childCount: remoteItems.length),
                              ),
                            ),
                          ],
                        ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  const _DraftCard({
    required this.draft,
    required this.onEdit,
    required this.onDelete,
  });

  final QuestDraft draft;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: cs.primaryContainer,
              child: Icon(Icons.edit_note, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.title.isEmpty ? 'Без названия' : draft.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Черновик • ${draft.location.isEmpty ? 'Город не указан' : draft.location}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline, color: cs.error),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabSlider extends StatelessWidget {
  const _TabSlider({required this.active, required this.onChanged});

  final _MyQuestsTab active;
  final void Function(_MyQuestsTab tab) onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final borderColor = cs.outlineVariant;
    final activeColor = const Color(0xFFD6E4F2);

    Widget tabButton({
      required String title,
      required bool isActive,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: Material(
          color: isActive ? activeColor : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(28),
          color: cs.surface,
        ),
        child: Row(
          children: [
            tabButton(
              title: 'Избранное',
              isActive: active == _MyQuestsTab.favourites,
              onTap: () => onChanged(_MyQuestsTab.favourites),
            ),
            Container(width: 1, color: borderColor),
            tabButton(
              title: 'Созданное',
              isActive: active == _MyQuestsTab.created,
              onTap: () => onChanged(_MyQuestsTab.created),
            ),
          ],
        ),
      ),
    );
  }
}

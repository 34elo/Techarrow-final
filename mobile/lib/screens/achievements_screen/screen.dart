import 'package:flutter/material.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/services/api.dart';

enum _AchievementsTab { mine, all }

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  static const int _pageSize = 20;

  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  final List<_AchievementItem> _items = <_AchievementItem>[];
  final Map<int, DateTime> _awardedDatesById = <int, DateTime>{};
  _AchievementsTab _activeTab = _AchievementsTab.mine;
  int _offset = 0;
  int _total = 0;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  String? _loadError;

  bool get _hasMore => _items.length < _total;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_maybeLoadMore);
    _refresh();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_maybeLoadMore);
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    final nextTab = _tabController.index == 0
        ? _AchievementsTab.mine
        : _AchievementsTab.all;
    if (nextTab == _activeTab) return;

    setState(() {
      _activeTab = nextTab;
    });
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _offset = 0;
      _total = 0;
      _loadError = null;
      _isInitialLoading = true;
      _isLoadingMore = false;
    });

    await _loadMore();
  }

  void _maybeLoadMore() {
    if (!_scrollController.hasClients) return;
    if (_isInitialLoading || _isLoadingMore || !_hasMore) return;
    if (_scrollController.position.extentAfter > 500) return;
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _loadError = null;
    });

    try {
      final page = await _fetchPage();
      if (!mounted) return;

      setState(() {
        _items.addAll(page.items);
        _total = page.total;
        _offset = page.offset + page.items.length;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isInitialLoading = false;
        _isLoadingMore = false;
        _loadError = 'Не удалось загрузить достижения';
      });
    }
  }

  Future<_AchievementPage> _fetchPage() async {
    switch (_activeTab) {
      case _AchievementsTab.mine:
        final response = await ApiService.instance.client.apiAchievementsMeGet(
          limit: _pageSize,
          offset: _offset,
        );
        final body = response.body;
        if (!response.isSuccessful || body == null) {
          throw Exception('Failed to load user achievements');
        }

        for (final item in body.items) {
          _awardedDatesById[item.id] = item.awardedAt;
        }

        return _AchievementPage(
          items: body.items
              .map(
                (item) => _AchievementItem(
                  id: item.id,
                  title: item.title,
                  description: item.description,
                  imageFileId: item.imageFileId,
                  awardedAt: item.awardedAt,
                ),
              )
              .toList(),
          total: body.total,
          offset: body.offset,
        );
      case _AchievementsTab.all:
        final response = await ApiService.instance.client.apiAchievementsGet(
          limit: _pageSize,
          offset: _offset,
        );
        final body = response.body;
        if (!response.isSuccessful || body == null) {
          throw Exception('Failed to load achievements');
        }
        final awardedDatesById = await _loadAwardedAchievementDates();

        return _AchievementPage(
          items: body.items
              .map(
                (item) => _AchievementItem.fromResponse(
                  item,
                  awardedAt: awardedDatesById[item.id],
                ),
              )
              .toList(),
          total: body.total,
          offset: body.offset,
        );
    }
  }

  Future<Map<int, DateTime>> _loadAwardedAchievementDates() async {
    const limit = 100;
    var offset = 0;

    do {
      final response = await ApiService.instance.client.apiAchievementsMeGet(
        limit: limit,
        offset: offset,
      );
      final body = response.body;
      if (!response.isSuccessful || body == null) {
        throw Exception('Failed to load user achievements');
      }

      for (final item in body.items) {
        _awardedDatesById[item.id] = item.awardedAt;
      }

      offset = body.offset + body.items.length;
      if (offset >= body.total || body.items.isEmpty) break;
    } while (true);

    return _awardedDatesById;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Достижения',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: colorScheme.onPrimaryContainer,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: 'Мои'),
                Tab(text: 'Все'),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_loadError != null && _items.isEmpty) {
      return _AchievementStateMessage(
        icon: Icons.error_outline_rounded,
        title: _loadError!,
        actionLabel: 'Повторить',
        onAction: _refresh,
      );
    }

    if (_items.isEmpty) {
      return _AchievementStateMessage(
        icon: Icons.emoji_events_outlined,
        title: _activeTab == _AchievementsTab.mine
            ? 'У вас пока нет достижений'
            : 'Достижения пока не добавлены',
        subtitle: _activeTab == _AchievementsTab.mine
            ? 'Проходите квесты, чтобы открыть первые награды.'
            : null,
        actionLabel: 'Обновить',
        onAction: _refresh,
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _items.length + (_isLoadingMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= _items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return _AchievementCard(
            item: _items[index],
            isMineTab: _activeTab == _AchievementsTab.mine,
          );
        },
      ),
    );
  }
}

class _AchievementPage {
  const _AchievementPage({
    required this.items,
    required this.total,
    required this.offset,
  });

  final List<_AchievementItem> items;
  final int total;
  final int offset;
}

class _AchievementItem {
  const _AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageFileId,
    required this.awardedAt,
  });

  factory _AchievementItem.fromResponse(
    AchievementResponse response, {
    DateTime? awardedAt,
  }) {
    return _AchievementItem(
      id: response.id,
      title: response.title,
      description: response.description,
      imageFileId: response.imageFileId,
      awardedAt: awardedAt,
    );
  }

  final int id;
  final String title;
  final String description;
  final String? imageFileId;
  final DateTime? awardedAt;

  String? get imageUrl {
    final fileId = imageFileId;
    if (fileId == null || fileId.isEmpty) return null;
    return '${ApiService.baseUrl}/api/file/$fileId';
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.item, required this.isMineTab});

  final _AchievementItem item;
  final bool isMineTab;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final awardedAt = item.awardedAt;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AchievementImage(imageUrl: item.imageUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isMineTab)
                      Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                _AchievementBadge(
                  icon: awardedAt == null
                      ? Icons.lock_open_rounded
                      : Icons.calendar_month_outlined,
                  label: awardedAt == null
                      ? 'Доступно к получению'
                      : 'Получено ${_formatDate(awardedAt)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${_twoDigits(local.day)}.${_twoDigits(local.month)}.${local.year}';
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class _AchievementImage extends StatelessWidget {
  const _AchievementImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 76,
        height: 76,
        color: colorScheme.primaryContainer,
        child: imageUrl == null
            ? Icon(
                Icons.emoji_events_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 38,
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.emoji_events_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 38,
                ),
              ),
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  const _AchievementBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementStateMessage extends StatelessWidget {
  const _AchievementStateMessage({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

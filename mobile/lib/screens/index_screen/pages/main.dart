import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:techarrow_2026_app/gen/swagger.swagger.dart';
import 'package:techarrow_2026_app/models/quest.dart';
import 'package:techarrow_2026_app/screens/current_quest_screen/screen.dart';
import 'package:techarrow_2026_app/screens/quest_creation/screen.dart';
import 'package:techarrow_2026_app/screens/quest_data/team_waiting_room_sheet.dart';
import 'package:techarrow_2026_app/services/api.dart';
import 'package:techarrow_2026_app/services/quest.dart';
import 'package:techarrow_2026_app/widgets/app_snackbar.dart';
import 'package:techarrow_2026_app/widgets/event_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isScrolled = false;
  bool _hasSearchText = false;

  final ScrollController _scrollController = ScrollController();

  static const String _sampleQuestImage =
      'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQRZRfRJNfPiR_PG_fa6JHQw3AEYUt0c-oCRwt07bUQRZfdGHhK';

  static const int _pageSize = 20;
  final List<Quest> _quests = <Quest>[];
  _QuestFilters? _activeFilters;
  int _offset = 0;
  int _total = 0;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  String? _loadError;
  Timer? _searchDebounce;
  StreamSubscription<TeamQuestRunProgressResponse?>? _teamProgressSub;
  int? _lastNotifiedTeamRunId;
  bool _questScopeSubscribed = false;

  @override
  void initState() {
    super.initState();
    _refreshQuests();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 0;
      if (scrolled != _isScrolled) {
        setState(() {
          _isScrolled = scrolled;
        });
      }
      _maybeLoadMore();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_questScopeSubscribed) return;
    _questScopeSubscribed = true;
    final questState = StreamQuestScope.of(context);
    _teamProgressSub = questState.onActiveTeamRunProgressChanged.listen((
      progress,
    ) {
      if (!mounted || progress == null) return;
      if (progress.status.value != 'in_progress') return;
      if (_lastNotifiedTeamRunId == progress.runId) return;
      _lastNotifiedTeamRunId = progress.runId;
    });
    unawaited(questState.refreshActiveTeamRunProgress());
  }

  Quest _mapQuest(QuestResponse item) {
    return Quest(
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
    );
  }

  Future<void> _refreshQuests() async {
    setState(() {
      _isInitialLoading = true;
      _isLoadingMore = false;
      _loadError = null;
      _offset = 0;
      _total = 0;
      _quests.clear();
    });
    await _loadMore();
  }

  Future<void> _pullRefreshQuests() async {
    final f = _activeFilters;
    final hasNear = f?.nearLatitude != null && f?.nearLongitude != null;
    try {
      final response = await ApiService.instance.getQuests(
        limit: _pageSize,
        offset: 0,
        minDurationMinutes: f?.minDurationMinutes,
        maxDurationMinutes: f?.maxDurationMinutes,
        difficulties: f?.difficulties,
        nearLatitude: hasNear ? f!.nearLatitude : null,
        nearLongitude: hasNear ? f!.nearLongitude : null,
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      );
      if (!mounted) return;
      final items = response.items.map(_mapQuest).toList();
      setState(() {
        _total = response.total;
        _offset = response.offset + response.items.length;
        _quests
          ..clear()
          ..addAll(items);
        _isInitialLoading = false;
        _isLoadingMore = false;
        _loadError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _isLoadingMore = false;
      });
    }
  }

  bool get _hasMore => _quests.length < _total;
  bool get _hasActiveFilters => _activeFilters?.hasAny ?? false;

  void _maybeLoadMore() {
    if (!_scrollController.hasClients) return;
    if (_isInitialLoading || _isLoadingMore) return;
    if (!_hasMore) return;
    if (_scrollController.position.extentAfter > 800) return;
    _loadMore();
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
      _loadError = null;
    });

    try {
      final f = _activeFilters;
      final hasNear =
          f?.nearLatitude != null && f?.nearLongitude != null;

      final response = await ApiService.instance.getQuests(
        limit: _pageSize,
        offset: _offset,
        minDurationMinutes: f?.minDurationMinutes,
        maxDurationMinutes: f?.maxDurationMinutes,
        difficulties: f?.difficulties,
        nearLatitude: hasNear ? f!.nearLatitude : null,
        nearLongitude: hasNear ? f!.nearLongitude : null,
        search: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
      );
      final body = response;

      final items = body.items.map(_mapQuest).toList();
      setState(() {
        _total = body.total;
        _offset = body.offset + body.items.length;
        _quests.addAll(items);
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isInitialLoading = false;
        _isLoadingMore = false;
        _loadError = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _teamProgressSub?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchClose() {
    _searchDebounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.clear();
    _searchController.addListener(_onSearchChanged);
    setState(() {
      _hasSearchText = false;
    });
    _refreshQuests();
  }

  void _onSearchChanged() {
    final hasText = _searchController.text.isNotEmpty;
    if (hasText != _hasSearchText) {
      setState(() {
        _hasSearchText = hasText;
      });
    }
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), _refreshQuests);
  }

  Future<void> _openFiltersSheet() async {
    final filters = await showModalBottomSheet<_QuestFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => _MainFiltersSheet(initialFilters: _activeFilters),
    );

    if (!mounted || filters == null) return;
    setState(() {
      _activeFilters = filters;
    });
    await _refreshQuests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'main-create-quest-fab',
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (_) => const QuestCreationScreen()),
              )
              .then((val) {
                _refreshQuests();
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(child: buildSearchBar()),
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefreshQuests,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          if (StreamQuestScope.of(context).activeSession != null ||
              StreamQuestScope.of(context).activeTeamRunProgress != null)
            SliverToBoxAdapter(child: buildHeaderCard(context)),
          const SliverToBoxAdapter(child: SizedBox(height: 6)),
          if (_isInitialLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_loadError != null && _quests.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Не удалось загрузить квесты'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _refreshQuests,
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            )
          else if (_quests.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Квесты не найдены')),
            )
          else ...[
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  return QuestCard(
                    quest: _quests[index],
                    onFavorite: (val) async {
                      if (val) {
                        await ApiService.instance.client
                            .apiQuestsQuestIdFavoritePost(
                              questId: _quests[index].id,
                            );
                      } else {
                        await ApiService.instance.client
                            .apiQuestsQuestIdFavoriteDelete(
                              questId: _quests[index].id,
                            );
                      }
                      await _refreshQuests();
                    },
                    onReturn: () async {
                      await _refreshQuests();
                    },
                  );
                }, childCount: _quests.length),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                child: Column(
                  children: [
                    if (_loadError != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Не удалось загрузить ещё'),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: _loadMore,
                            child: const Text('Повторить'),
                          ),
                        ],
                      )
                    else if (_isLoadingMore)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircularProgressIndicator(),
                      )
                    else if (_hasMore)
                      TextButton(
                        onPressed: _loadMore,
                        child: const Text('Загрузить ещё'),
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SearchBar(
        controller: _searchController,
        onSubmitted: (_) {
          _searchDebounce?.cancel();
          _refreshQuests();
        },
        hintText: "Поиск квестов",
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        leading: IconButton(
          icon: const Icon(Icons.tune),
          color: Colors.grey[700],
          onPressed: _openFiltersSheet,
        ),
        trailing: [
          IconButton(
            icon: Icon(
              (_hasSearchText || _hasActiveFilters)
                  ? Icons.close
                  : Icons.search,
              color: Colors.grey[700],
            ),
            onPressed: (_hasSearchText || _hasActiveFilters)
                ? _onSearchClose
                : null,
          ),
        ],
      ),
    );
  }

  String formatDurationHms(Duration duration) {
    final d = duration.abs();
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h == 0) {
      return '$mm:$ss';
    }
    final hh = h.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  Widget buildHeaderCard(BuildContext context) {
    final questState = StreamQuestScope.of(context);
    final quest = questState.activeSession;
    final progress = questState.activeRunProgress;
    final teamProgress = questState.activeTeamRunProgress;
    final isTeam = quest == null && teamProgress != null;
    final totalSegments = isTeam
        ? teamProgress.totalCheckpoints
        : (progress?.totalCheckpoints ?? 4);
    final completedSegments = isTeam
        ? teamProgress.completedCheckpoints
        : (progress?.currentStepIndex ?? 1);
    final safeTotalSegments = totalSegments <= 0 ? 1 : totalSegments;
    final safeCurrentSegment = completedSegments.clamp(0, safeTotalSegments);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (isTeam &&
            teamProgress.status.value != 'in_progress') {
          await openTeamQuestWaitingRoom(context, teamProgress.questId);
          return;
        }
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CurrentQuestScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(offset: Offset(0, 4), blurRadius: 2, color: Colors.grey),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  bottomRight: Radius.circular(16),
                ),
                child: Image.asset("assets/abstract.png"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTeam ? 'Командный квест' : (quest?.name ?? 'Квест'),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _buildSegmentedProgressBar(
                    totalSegments: safeTotalSegments,
                    currentSegment: safeCurrentSegment,
                  ),
                  SizedBox(height: 8),
                  if (isTeam) ...[
                    Text(
                      "Готово чекпоинтов: ${teamProgress.completedCheckpoints}/${teamProgress.totalCheckpoints}",
                    ),
                    Text(
                      'Квест #${teamProgress.questId} · в команде отвечайте на любые точки в любом порядке',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ] else ...[
                    Text("Количество шагов: ${quest?.steps ?? 0}"),
                    Text(
                      "Пройденное время: ${formatDurationHms(quest?.elapsed ?? Duration.zero)}",
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedProgressBar({
    required int totalSegments,
    required int currentSegment,
  }) {
    return Row(
      children: List.generate(totalSegments, (index) {
        final isCompleted = index < currentSegment;
        final isCurrent = index == currentSegment;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.blue
                        : isCurrent
                        ? Colors.blue.withValues(alpha: 0.5)
                        : Colors.grey[400],
                    borderRadius: BorderRadius.horizontal(
                      left: index == 0 ? Radius.circular(2) : Radius.zero,
                      right: index == totalSegments - 1
                          ? Radius.circular(2)
                          : Radius.zero,
                    ),
                  ),
                ),
              ),
              if (index < totalSegments - 1) SizedBox(width: 2),
            ],
          ),
        );
      }),
    );
  }
}

class _MainFiltersSheet extends StatefulWidget {
  const _MainFiltersSheet({this.initialFilters});

  final _QuestFilters? initialFilters;

  @override
  State<_MainFiltersSheet> createState() => _MainFiltersSheetState();
}

class _MainFiltersSheetState extends State<_MainFiltersSheet> {
  final TextEditingController _minDurationController = TextEditingController();
  final TextEditingController _maxDurationController = TextEditingController();
  int? _difficulty;
  bool _nearMe = false;
  double? _nearLatitude;
  double? _nearLongitude;
  bool _nearMeBusy = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialFilters;
    if (initial != null) {
      _minDurationController.text =
          initial.minDurationMinutes?.toString() ?? '';
      _maxDurationController.text =
          initial.maxDurationMinutes?.toString() ?? '';
      _difficulty = initial.singleDifficulty;
      _nearMe = initial.nearLatitude != null && initial.nearLongitude != null;
      _nearLatitude = initial.nearLatitude;
      _nearLongitude = initial.nearLongitude;
    }
  }

  @override
  void dispose() {
    _minDurationController.dispose();
    _maxDurationController.dispose();
    super.dispose();
  }

  String _difficultyLabel(int value) {
    return switch (value) {
      1 => 'Очень легко',
      2 => 'Легко',
      3 => 'Средне',
      4 => 'Сложно',
      5 => 'Очень сложно',
      _ => '',
    };
  }

  Future<void> _requestNearMeLocation() async {
    setState(() {
      _nearMeBusy = true;
      _nearMe = false;
      _nearLatitude = null;
      _nearLongitude = null;
    });

    Future<void> fail(String message) async {
      if (!mounted) return;
      AppSnackBar.error(context, message);
      setState(() {
        _nearMeBusy = false;
        _nearMe = false;
        _nearLatitude = null;
        _nearLongitude = null;
      });
    }

    try {
      var serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await Geolocator.openLocationSettings();
        if (!mounted) return;
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await fail('Включите геолокацию в настройках системы');
          return;
        }
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        await fail(
          'Разрешите доступ к геолокации в настройках приложения',
        );
        return;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        await fail('Нужно разрешение на геолокацию');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        await fail(
          'Разрешите доступ к геолокации в настройках приложения',
        );
        return;
      }
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        await fail('Нет доступа к геолокации');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      if (!mounted) return;
      setState(() {
        _nearMe = true;
        _nearLatitude = position.latitude;
        _nearLongitude = position.longitude;
        _nearMeBusy = false;
      });
    } catch (_) {
      await fail('Не удалось получить геопозицию');
    }
  }

  void _onNearMeToggle(bool? value) {
    if (value != true) {
      setState(() {
        _nearMe = false;
        _nearLatitude = null;
        _nearLongitude = null;
      });
      return;
    }
    unawaited(_requestNearMeLocation());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    InputDecoration fieldDecoration({String? hint}) {
      return InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
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
          borderSide: BorderSide(color: colorScheme.primary),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.86,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Фильтры',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        'Сложность',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (_difficulty != null)
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => _difficulty = null),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  key: ValueKey(_difficulty),
                  initialValue: _difficulty,
                  decoration: fieldDecoration(hint: 'Выберите сложность'),
                  dropdownColor: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: colorScheme.primary,
                  ),
                  items: List.generate(5, (index) {
                    final value = index + 1;
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              value.toString(),
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(_difficultyLabel(value)),
                        ],
                      ),
                    );
                  }),
                  onChanged: (value) => setState(() => _difficulty = value),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Длительность, мин',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _minDurationController,
                        builder: (context, value, _) {
                          return TextField(
                            controller: _minDurationController,
                            keyboardType: TextInputType.number,
                            decoration: fieldDecoration(hint: 'От').copyWith(
                              suffixIcon: value.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          _minDurationController.clear(),
                                    ),
                            ),
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _maxDurationController,
                        builder: (context, value, _) {
                          return TextField(
                            controller: _maxDurationController,
                            keyboardType: TextInputType.number,
                            decoration: fieldDecoration(hint: 'До').copyWith(
                              suffixIcon: value.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          _maxDurationController.clear(),
                                    ),
                            ),
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                CheckboxListTile(
                  value: _nearMe,
                  onChanged: _nearMeBusy ? null : _onNearMeToggle,
                  title: Text(
                    'Квесты около меня',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'По координатам при поиске квестов',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  secondary: _nearMeBusy
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: colorScheme.primary,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      minimumSize: const Size.fromHeight(64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      final minDuration = int.tryParse(
                        _minDurationController.text,
                      );
                      final maxDuration = int.tryParse(
                        _maxDurationController.text,
                      );

                      Navigator.of(context).pop(
                        _QuestFilters(
                          difficulties: _difficulty != null
                              ? [_difficulty]
                              : null,
                          nearMe: _nearMe,
                          nearLatitude: _nearMe ? _nearLatitude : null,
                          nearLongitude: _nearMe ? _nearLongitude : null,
                          minDurationMinutes: minDuration,
                          maxDurationMinutes: maxDuration,
                        ),
                      );
                    },
                    child: Text(
                      'Применить',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestFilters {
  const _QuestFilters({
    this.minDurationMinutes,
    this.maxDurationMinutes,
    this.difficulties,
    this.nearMe = false,
    this.nearLatitude,
    this.nearLongitude,
  });

  final int? minDurationMinutes;
  final int? maxDurationMinutes;
  final List<dynamic>? difficulties;
  final bool nearMe;
  final double? nearLatitude;
  final double? nearLongitude;

  int? get singleDifficulty =>
      difficulties?.isNotEmpty == true ? difficulties!.first as int? : null;

  bool get hasAny =>
      minDurationMinutes != null ||
      maxDurationMinutes != null ||
      (difficulties?.isNotEmpty ?? false) ||
      (nearLatitude != null && nearLongitude != null);
}

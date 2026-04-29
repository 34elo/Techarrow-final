import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:techarrow_2026_app/screens/quest_creation/screen.dart';

class QuestCreationStepThreePage extends StatefulWidget {
  const QuestCreationStepThreePage({
    super.key,
    required this.changePage,
    required this.onCheckpointSaved,
    required this.pointTitleController,
    required this.taskController,
    required this.codeWordController,
    required this.hintController,
    required this.pointRulesController,
    required this.selectedPoint,
    required this.onPointChanged,
    required this.onSheetDismissed,
    required this.isEditing,
  });

  final void Function(QuestCreationPageStatus status) changePage;
  final VoidCallback onCheckpointSaved;
  final TextEditingController pointTitleController;
  final TextEditingController taskController;
  final TextEditingController codeWordController;
  final TextEditingController hintController;
  final TextEditingController pointRulesController;
  final LatLng? selectedPoint;
  final ValueChanged<LatLng> onPointChanged;
  final VoidCallback onSheetDismissed;
  final bool isEditing;

  @override
  State<QuestCreationStepThreePage> createState() =>
      _QuestCreationStepThreePageState();
}

class _QuestCreationStepThreePageState
    extends State<QuestCreationStepThreePage> {
  static const LatLng _cityCenter = LatLng(56.3269, 44.0065);
  static const double _sheetContentHeight = 600;
  static const int _minTaskLength = 20;
  bool _didDismissSheet = false;

  bool get _canSave =>
      widget.selectedPoint != null &&
      widget.pointTitleController.text.trim().isNotEmpty &&
      widget.taskController.text.trim().length >= _minTaskLength &&
      widget.codeWordController.text.trim().isNotEmpty &&
      widget.pointRulesController.text.trim().isNotEmpty;

  String? get _taskError {
    final task = widget.taskController.text.trim();
    if (task.isEmpty || task.length >= _minTaskLength) return null;
    return 'Задание должно быть не менее $_minTaskLength символов';
  }

  @override
  void initState() {
    super.initState();
    widget.pointTitleController.addListener(_refresh);
    widget.taskController.addListener(_refresh);
    widget.codeWordController.addListener(_refresh);
    widget.pointRulesController.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.pointTitleController.removeListener(_refresh);
    widget.taskController.removeListener(_refresh);
    widget.codeWordController.removeListener(_refresh);
    widget.pointRulesController.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  double _sheetMaxSize(double availableHeight) {
    if (availableHeight <= 0) return 0.8;
    return (_sheetContentHeight / availableHeight).clamp(0.28, 0.8);
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
    final bool hasSelectedPoint = widget.selectedPoint != null;

    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _cityCenter,
              initialZoom: 12.5,
              onTap: (_, point) {
                widget.onPointChanged(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.techarrow_2026_app',
              ),
              if (hasSelectedPoint)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.selectedPoint!,
                      width: 36,
                      height: 36,
                      rotate: true,
                      alignment: Alignment.bottomCenter,
                      child: Icon(
                        Icons.location_on,
                        size: 36,
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          LayoutBuilder(
            builder: (context, constraints) {
              final maxSheetSize = _sheetMaxSize(constraints.maxHeight);
              final initialSheetSize = (widget.isEditing ? 0.68 : 0.22).clamp(
                0.0,
                maxSheetSize,
              );

              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (!_didDismissSheet && notification.extent <= 0.02) {
                    _didDismissSheet = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        widget.onSheetDismissed();
                      }
                    });
                  }
                  return false;
                },
                child: DraggableScrollableSheet(
                  initialChildSize: initialSheetSize,
                  minChildSize: 0,
                  maxChildSize: maxSheetSize,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        primary: false,
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                        child: Column(
                          children: [
                            Container(
                              width: 42,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 10),
                            _label(context, 'Название'),
                            TextField(
                              controller: widget.pointTitleController,
                              decoration: _fieldDecoration(
                                context,
                                hint: 'Введите название точки',
                              ),
                            ),
                            const SizedBox(height: 12),
                            _label(context, 'Задание'),
                            TextField(
                              controller: widget.taskController,
                              maxLines: 2,
                              decoration: _fieldDecoration(
                                context,
                                hint: 'Введите задание для точки',
                                errorText: _taskError,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _label(context, 'Код слово'),
                            TextField(
                              controller: widget.codeWordController,
                              decoration: _fieldDecoration(
                                context,
                                hint: 'Введите кодовое слово',
                              ),
                            ),
                            const SizedBox(height: 12),
                            _label(context, 'Подсказка'),
                            TextField(
                              controller: widget.hintController,
                              decoration: _fieldDecoration(
                                context,
                                hint: 'Введите подсказку (необязательно)',
                              ),
                            ),
                            const SizedBox(height: 12),
                            _label(context, 'Правила точки'),
                            TextField(
                              controller: widget.pointRulesController,
                              decoration: _fieldDecoration(
                                context,
                                hint: 'Введите правила для точки',
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      colorScheme.secondaryContainer,
                                  foregroundColor:
                                      colorScheme.onSecondaryContainer,
                                  minimumSize: const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(26),
                                  ),
                                ),
                                onPressed: _canSave
                                    ? widget.onCheckpointSaved
                                    : null,
                                child: Text(
                                  widget.isEditing
                                      ? 'Сохранить изменения'
                                      : 'Сохранить',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onSheetDismissed,
                      icon: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            'Создание чекпоинтов',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:techarrow_2026_app/screens/quest_creation/screen.dart';

class QuestCreationStepFourPage extends StatefulWidget {
  const QuestCreationStepFourPage({
    super.key,
    required this.changePage,
    required this.checkpointsCount,
    required this.checkpoints,
    required this.onCheckpointTap,
    required this.onMapTap,
  });

  final void Function(QuestCreationPageStatus status) changePage;
  final int checkpointsCount;
  final List<QuestDraftCheckpoint> checkpoints;
  final ValueChanged<int> onCheckpointTap;
  final ValueChanged<LatLng> onMapTap;

  @override
  State<QuestCreationStepFourPage> createState() =>
      _QuestCreationStepFourPageState();
}

class _QuestCreationStepFourPageState extends State<QuestCreationStepFourPage> {
  static const LatLng _cityCenter = LatLng(56.3269, 44.0065);
  static const double _pointPickZoom = 14;
  static const double _sheetContentHeight = 174;

  late final MapController _mapController;

  double _sheetMaxSize(double availableHeight) {
    if (availableHeight <= 0) return 0.35;
    return (_sheetContentHeight / availableHeight).clamp(0.17, 0.35);
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_centerMapOnUserIfPossible());
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _centerMapOnUserIfPossible() async {
    if (!mounted) return;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) return;
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      if (!mounted) return;
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        _pointPickZoom,
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bool isReady = widget.checkpointsCount >= 3;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _cityCenter,
              initialZoom: 12.5,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
                cursorKeyboardRotationOptions:
                    CursorKeyboardRotationOptions.disabled(),
              ),
              onTap: (_, point) {
                _mapController.move(point, _pointPickZoom);
                widget.onMapTap(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.techarrow_2026_app',
              ),
              MarkerLayer(
                markers: List.generate(widget.checkpoints.length, (index) {
                  final point = widget.checkpoints[index];
                  return Marker(
                    point: LatLng(point.latitude, point.longitude),
                    width: 44,
                    height: 44,
                    rotate: true,
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        _mapController.move(
                          LatLng(point.latitude, point.longitude),
                          _pointPickZoom,
                        );
                        widget.onCheckpointTap(index);
                      },
                      child: _NumberedCheckpointMarker(
                        number: index + 1,
                        color: colorScheme.error,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            widget.changePage(QuestCreationPageStatus.stepTwo),
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
                ),
              ),
              Spacer(),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxSheetSize = _sheetMaxSize(constraints.maxHeight);
              final initialSheetSize = 0.2.clamp(0.17, maxSheetSize);

              return DraggableScrollableSheet(
                initialChildSize: initialSheetSize,
                minChildSize: 0.17,
                maxChildSize: maxSheetSize,
                builder: (context, scrollController) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 42,
                              height: 4,
                              decoration: BoxDecoration(
                                color: colorScheme.outlineVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Добавлено ${widget.checkpointsCount} чекпоинта',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'минимум 3 чекпоинта',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: isReady
                                    ? colorScheme.secondaryContainer
                                    : colorScheme.surfaceContainerHighest,
                                foregroundColor: isReady
                                    ? colorScheme.onSecondaryContainer
                                    : colorScheme.onSurfaceVariant,
                                minimumSize: const Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: isReady
                                  ? () => widget.changePage(
                                      QuestCreationPageStatus.stepFive,
                                    )
                                  : null,
                              child: Text(
                                'Продолжить',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NumberedCheckpointMarker extends StatelessWidget {
  const _NumberedCheckpointMarker({required this.number, required this.color});

  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Icon(Icons.location_on, size: 44, color: color),
        Positioned(
          top: 6,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

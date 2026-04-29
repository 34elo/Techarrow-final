/// Active quest run for [StreamQuest] / [StreamQuestScope] only.
///
/// Does not replace the catalog [Quest] model; [questId] and [name] come from it.
/// [steps] are **physical** pedometer steps since the session started.
class StreamingQuestSession {
  const StreamingQuestSession({
    required this.questId,
    required this.name,
    required this.startedAt,
    required this.steps,
  });

  final int questId;
  final String name;
  final DateTime startedAt;

  /// Pedometer steps since [startedAt] (delta from the session baseline).
  final int steps;

  /// Wall-clock time since the session was started.
  Duration get elapsed => DateTime.now().difference(startedAt);

  StreamingQuestSession copyWith({
    int? questId,
    String? name,
    DateTime? startedAt,
    int? steps,
  }) {
    return StreamingQuestSession(
      questId: questId ?? this.questId,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      steps: steps ?? this.steps,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreamingQuestSession &&
          other.questId == questId &&
          other.name == name &&
          other.startedAt == startedAt &&
          other.steps == steps;

  @override
  int get hashCode => Object.hash(questId, name, startedAt, steps);
}

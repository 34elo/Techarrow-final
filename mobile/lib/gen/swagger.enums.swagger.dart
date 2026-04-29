// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

enum QuestArchiveStatusSchema {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('published')
  published('published'),
  @JsonValue('archived')
  archived('archived');

  final String? value;

  const QuestArchiveStatusSchema(this.value);
}

enum QuestRunStatusSchema {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('in_progress')
  inProgress('in_progress'),
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('abandoned')
  abandoned('abandoned');

  final String? value;

  const QuestRunStatusSchema(this.value);
}

enum QuestStatusSchema {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('on_moderation')
  onModeration('on_moderation'),
  @JsonValue('published')
  published('published'),
  @JsonValue('archived')
  archived('archived'),
  @JsonValue('rejected')
  rejected('rejected');

  final String? value;

  const QuestStatusSchema(this.value);
}

enum TeamQuestRunStatusSchema {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('waiting_for_team')
  waitingForTeam('waiting_for_team'),
  @JsonValue('starting')
  starting('starting'),
  @JsonValue('in_progress')
  inProgress('in_progress'),
  @JsonValue('completed')
  completed('completed');

  final String? value;

  const TeamQuestRunStatusSchema(this.value);
}

enum UserRoleSchema {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('user')
  user('user'),
  @JsonValue('moderator')
  moderator('moderator');

  final String? value;

  const UserRoleSchema(this.value);
}

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:techarrow_2026_app/models/quest_draft.dart';

class QuestDraftsService {
  QuestDraftsService._();

  static final QuestDraftsService instance = QuestDraftsService._();
  static const _storage = FlutterSecureStorage();
  static const _key = 'quest_drafts_v1';

  Future<List<QuestDraft>> getAll() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return <QuestDraft>[];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return <QuestDraft>[];
    final items = decoded
        .whereType<Map>()
        .map((item) => QuestDraft.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    items.sort((a, b) => b.updatedAtIso.compareTo(a.updatedAtIso));
    return items;
  }

  Future<void> upsert(QuestDraft draft) async {
    final all = await getAll();
    final index = all.indexWhere((item) => item.id == draft.id);
    if (index >= 0) {
      all[index] = draft;
    } else {
      all.add(draft);
    }
    await _save(all);
  }

  Future<void> delete(String id) async {
    final all = await getAll();
    all.removeWhere((item) => item.id == id);
    await _save(all);
  }

  Future<void> _save(List<QuestDraft> drafts) async {
    await _storage.write(
      key: _key,
      value: jsonEncode(drafts.map((item) => item.toJson()).toList()),
    );
  }
}

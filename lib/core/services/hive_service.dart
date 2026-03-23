import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/core/constants/app_constants.dart';

part 'hive_service.g.dart';

/// Provides typed access to Hive boxes for offline-first storage.
///
/// All models are stored as JSON strings (no Hive type adapters needed).
class HiveService {
  HiveService._();

  static final instance = HiveService._();

  late final Box<String> _invoicesBox;
  late final Box<String> _clientsBox;
  late final Box<String> _profileBox;
  late final Box<String> _settingsBox;
  late final Box<String> _syncQueueBox;

  Future<void> init() async {
    _invoicesBox = await Hive.openBox(AppConstants.hiveInvoicesBox);
    _clientsBox = await Hive.openBox(AppConstants.hiveClientsBox);
    _profileBox = await Hive.openBox(AppConstants.hiveProfileBox);
    _settingsBox = await Hive.openBox(AppConstants.hiveSettingsBox);
    _syncQueueBox = await Hive.openBox(AppConstants.hiveSyncQueueBox);
  }

  Box<String> get invoicesBox => _invoicesBox;
  Box<String> get clientsBox => _clientsBox;
  Box<String> get profileBox => _profileBox;
  Box<String> get settingsBox => _settingsBox;
  Box<String> get syncQueueBox => _syncQueueBox;

  /// Store a JSON-serializable model by key.
  Future<void> put(Box<String> box, String key, Map<String, dynamic> json) {
    return box.put(key, jsonEncode(json));
  }

  /// Retrieve a stored model by key.
  Map<String, dynamic>? get(Box<String> box, String key) {
    final raw = box.get(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Get all items in a box.
  List<Map<String, dynamic>> getAll(Box<String> box) {
    return box.values
        .map((raw) => jsonDecode(raw) as Map<String, dynamic>)
        .toList();
  }

  /// Delete a stored item by key.
  Future<void> delete(Box<String> box, String key) {
    return box.delete(key);
  }

  /// Clear all items in a box.
  Future<int> clear(Box<String> box) {
    return box.clear();
  }
}

@Riverpod(keepAlive: true)
HiveService hiveService(Ref ref) {
  return HiveService.instance;
}

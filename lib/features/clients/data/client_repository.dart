import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/models/client_model.dart';

part 'client_repository.g.dart';

class ClientRepository {
  ClientRepository(this._hive, this._supabase);

  final HiveService _hive;
  final SupabaseClient _supabase;

  /// Fetch all clients for the current user.
  /// Tries Supabase first, falls back to Hive cache.
  Future<List<Client>> getClients() async {
    try {
      final response =
          await _supabase.from('clients').select().order('name');
      final clients = (response as List)
          .map((json) => Client.fromJson(json))
          .toList();

      // Cache locally
      for (final client in clients) {
        await _hive.put(_hive.clientsBox, client.id, client.toJson());
      }
      return clients;
    } catch (_) {
      // Offline fallback
      return _hive
          .getAll(_hive.clientsBox)
          .map((json) => Client.fromJson(json))
          .toList();
    }
  }

  /// Create a new client.
  Future<Client> createClient(Client client) async {
    // Save to Hive immediately
    await _hive.put(_hive.clientsBox, client.id, client.toJson());

    try {
      await _supabase.from('clients').insert(client.toJson());
    } catch (_) {
      // Queue for sync when back online
      await _hive.put(_hive.syncQueueBox, 'client_create_${client.id}', {
        'table': 'clients',
        'operation': 'insert',
        'data': client.toJson(),
      });
    }
    return client;
  }

  /// Update an existing client.
  Future<void> updateClient(Client client) async {
    await _hive.put(_hive.clientsBox, client.id, client.toJson());
    try {
      await _supabase
          .from('clients')
          .update(client.toJson())
          .eq('id', client.id);
    } catch (_) {
      await _hive.put(_hive.syncQueueBox, 'client_update_${client.id}', {
        'table': 'clients',
        'operation': 'update',
        'data': client.toJson(),
      });
    }
  }

  /// Delete a client.
  Future<void> deleteClient(String id) async {
    await _hive.delete(_hive.clientsBox, id);
    try {
      await _supabase.from('clients').delete().eq('id', id);
    } catch (_) {
      await _hive.put(_hive.syncQueueBox, 'client_delete_$id', {
        'table': 'clients',
        'operation': 'delete',
        'data': {'id': id},
      });
    }
  }
}

@Riverpod(keepAlive: true)
ClientRepository clientRepository(Ref ref) {
  return ClientRepository(
    ref.watch(hiveServiceProvider),
    ref.watch(supabaseClientProvider),
  );
}

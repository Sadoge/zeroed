import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/features/clients/data/client_repository.dart';
import 'package:zeroed/models/client_model.dart';

part 'client_list_view_model.g.dart';

@riverpod
Future<List<Client>> clientList(Ref ref) {
  return ref.watch(clientRepositoryProvider).getClients();
}

@riverpod
class ClientListViewModel extends _$ClientListViewModel {
  @override
  FutureOr<void> build() {}

  Future<void> createClient(Client client) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientRepositoryProvider).createClient(client);
      ref.invalidate(clientListProvider);
    });
  }

  Future<void> deleteClient(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientRepositoryProvider).deleteClient(id);
      ref.invalidate(clientListProvider);
    });
  }
}

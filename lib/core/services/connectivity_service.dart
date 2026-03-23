import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> connectivityStream(Ref ref) {
  return Connectivity().onConnectivityChanged.map(
        (results) => results.any((r) => r != ConnectivityResult.none),
      );
}

@Riverpod(keepAlive: true)
class IsOnline extends _$IsOnline {
  @override
  bool build() {
    ref.listen(connectivityStreamProvider, (_, next) {
      next.whenData((online) => state = online);
    });
    return true; // optimistic default
  }
}

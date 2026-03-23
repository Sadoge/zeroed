import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class Client with _$Client {
  const factory Client({
    required String id,
    required String userId,
    required String name,
    required String email,
    String? phone,
    String? company,
    String? notes,
    required DateTime createdAt,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);
}

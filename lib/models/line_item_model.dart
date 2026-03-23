import 'package:freezed_annotation/freezed_annotation.dart';

part 'line_item_model.freezed.dart';
part 'line_item_model.g.dart';

@freezed
class LineItem with _$LineItem {
  const LineItem._();

  const factory LineItem({
    required String id,
    required String description,
    @Default(1) double quantity,
    required double unitPrice,
    @Default(0) int sortOrder,
  }) = _LineItem;

  double get amount => quantity * unitPrice;

  factory LineItem.fromJson(Map<String, dynamic> json) =>
      _$LineItemFromJson(json);
}

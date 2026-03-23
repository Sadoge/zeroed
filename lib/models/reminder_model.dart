import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_model.freezed.dart';
part 'reminder_model.g.dart';

@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    @JsonKey(name: 'invoice_id') required String invoiceId,
    @JsonKey(name: 'scheduled_at') required DateTime scheduledAt,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    required String type, // '3day', '7day', '14day'
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
}

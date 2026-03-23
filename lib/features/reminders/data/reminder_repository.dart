import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/models/reminder_model.dart';

part 'reminder_repository.g.dart';

const _uuid = Uuid();

class ReminderRepository {
  ReminderRepository(this._hive, this._supabase);

  final HiveService _hive;
  final SupabaseClient _supabase;

  /// Schedule default reminders (3, 7, 14 days) after an invoice is sent.
  Future<List<Reminder>> scheduleReminders({
    required String invoiceId,
    required DateTime sentAt,
  }) async {
    final intervals = [3, 7, 14];
    final reminders = intervals.map((days) {
      return Reminder(
        id: _uuid.v4(),
        invoiceId: invoiceId,
        scheduledAt: sentAt.add(Duration(days: days)),
        type: '${days}day',
      );
    }).toList();

    for (final reminder in reminders) {
      await _hive.put(
          _hive.settingsBox, 'reminder_${reminder.id}', reminder.toJson());
    }

    try {
      await _supabase
          .from('reminders')
          .insert(reminders.map((r) => r.toJson()).toList());
    } catch (_) {
      for (final reminder in reminders) {
        await _hive
            .put(_hive.syncQueueBox, 'reminder_create_${reminder.id}', {
          'table': 'reminders',
          'operation': 'insert',
          'data': reminder.toJson(),
        });
      }
    }

    return reminders;
  }

  /// Get all reminders for an invoice.
  Future<List<Reminder>> getReminders(String invoiceId) async {
    try {
      final response = await _supabase
          .from('reminders')
          .select()
          .eq('invoice_id', invoiceId)
          .order('scheduled_at');
      return (response as List)
          .map((json) => Reminder.fromJson(json))
          .toList();
    } catch (_) {
      // Fallback: filter locally cached reminders
      return _hive
          .getAll(_hive.settingsBox)
          .where((json) => json['invoice_id'] == invoiceId)
          .map((json) => Reminder.fromJson(json))
          .toList();
    }
  }

  /// Mark a reminder as sent.
  Future<void> markSent(String reminderId) async {
    try {
      await _supabase
          .from('reminders')
          .update({'sent_at': DateTime.now().toIso8601String()})
          .eq('id', reminderId);
    } catch (_) {
      await _hive.put(_hive.syncQueueBox, 'reminder_sent_$reminderId', {
        'table': 'reminders',
        'operation': 'update',
        'data': {
          'id': reminderId,
          'sent_at': DateTime.now().toIso8601String(),
        },
      });
    }
  }

  /// Send a one-off reminder email via Edge Function.
  Future<void> sendReminderEmail({
    required String invoiceId,
    required String invoiceNumber,
    required String clientName,
    required String clientEmail,
    required double amount,
    required String currency,
  }) async {
    await _supabase.functions.invoke(
      'send-invoice-email',
      body: {
        'type': 'reminder',
        'invoice_id': invoiceId,
        'invoice_number': invoiceNumber,
        'client_name': clientName,
        'client_email': clientEmail,
        'amount': amount,
        'currency': currency,
      },
    );
  }

  /// Send the initial invoice email via Edge Function.
  Future<void> sendInvoiceEmail({
    required String invoiceId,
    required String invoiceNumber,
    required String clientName,
    required String clientEmail,
    required double amount,
    required String currency,
    String? paymentLink,
  }) async {
    await _supabase.functions.invoke(
      'send-invoice-email',
      body: {
        'type': 'invoice',
        'invoice_id': invoiceId,
        'invoice_number': invoiceNumber,
        'client_name': clientName,
        'client_email': clientEmail,
        'amount': amount,
        'currency': currency,
        if (paymentLink != null) 'payment_link': paymentLink,
      },
    );
  }
}

@Riverpod(keepAlive: true)
ReminderRepository reminderRepository(Ref ref) {
  return ReminderRepository(
    ref.watch(hiveServiceProvider),
    ref.watch(supabaseClientProvider),
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/models/invoice_model.dart';

part 'stripe_service.g.dart';

class StripeService {
  StripeService(this._supabase);

  final dynamic _supabase;

  /// Generate a Stripe payment link for an invoice via Edge Function.
  /// Returns the payment URL string.
  Future<String> createPaymentLink({
    required Invoice invoice,
    required String clientName,
    required String clientEmail,
  }) async {
    final response = await _supabase.functions.invoke(
      'create-payment-link',
      body: {
        'invoice_id': invoice.id,
        'invoice_number': invoice.invoiceNumber,
        'amount_cents': (invoice.total * 100).round(),
        'currency': invoice.currency.toLowerCase(),
        'client_name': clientName,
        'client_email': clientEmail,
        'description':
            'Invoice ${invoice.invoiceNumber} — $clientName',
      },
    );

    final data = response.data as Map<String, dynamic>;
    if (data['error'] != null) {
      throw Exception(data['error']);
    }
    return data['payment_link'] as String;
  }

  /// Start Stripe Connect onboarding for the business.
  /// Returns the onboarding URL to open in a browser.
  Future<String> createConnectOnboardingLink() async {
    final response = await _supabase.functions.invoke(
      'stripe-connect-onboarding',
      body: {},
    );

    final data = response.data as Map<String, dynamic>;
    if (data['error'] != null) {
      throw Exception(data['error']);
    }
    return data['onboarding_url'] as String;
  }

  /// Check the current Stripe Connect status for the user.
  Future<bool> checkConnectStatus() async {
    final response = await _supabase.functions.invoke(
      'stripe-connect-status',
      body: {},
    );

    final data = response.data as Map<String, dynamic>;
    return data['connected'] as bool? ?? false;
  }
}

@Riverpod(keepAlive: true)
StripeService stripeService(Ref ref) {
  return StripeService(ref.watch(supabaseClientProvider));
}

abstract final class AppConstants {
  /// Invoice number prefix
  static const invoicePrefix = 'INV-';

  /// Invoice number padding (e.g. INV-0001)
  static const invoiceNumberPadding = 4;

  /// Default currency code
  static const defaultCurrency = 'USD';

  /// Default payment terms in days
  static const defaultPaymentTermsDays = 30;

  /// Maximum invoices per month on the free plan
  static const freeInvoiceLimit = 5;

  /// Hive box names
  static const hiveInvoicesBox = 'invoices';
  static const hiveClientsBox = 'clients';
  static const hiveProfileBox = 'profile';
  static const hiveSettingsBox = 'settings';
  static const hiveSyncQueueBox = 'sync_queue';
}

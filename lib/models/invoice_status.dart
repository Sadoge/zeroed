import 'dart:ui';

import 'package:zeroed/core/theme/app_colors.dart';

enum InvoiceStatus {
  draft,
  sent,
  viewed,
  paid,
  overdue;

  String get label => switch (this) {
        draft => 'Draft',
        sent => 'Sent',
        viewed => 'Viewed',
        paid => 'Paid',
        overdue => 'Overdue',
      };

  Color get color => switch (this) {
        draft => AppColors.statusDraft,
        sent => AppColors.statusSent,
        viewed => AppColors.statusViewed,
        paid => AppColors.statusPaid,
        overdue => AppColors.statusOverdue,
      };

  Color get backgroundColor => switch (this) {
        draft => AppColors.statusDraftBg,
        sent => AppColors.statusSentBg,
        viewed => AppColors.statusViewedBg,
        paid => AppColors.statusPaidBg,
        overdue => AppColors.statusOverdueBg,
      };
}

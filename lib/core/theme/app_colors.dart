import 'dart:ui';

/// Design tokens derived from design/zeroed.pen
abstract final class AppColors {
  // ─── Primary palette ───
  static const accent = Color(0xFF22D3EE);
  static const accentDim = Color(0xFF0E7490);

  // ─── Backgrounds ───
  static const bgPrimary = Color(0xFF0A0F1C);
  static const bgInset = Color(0xFF0F172A);
  static const bgCard = Color(0xFF1E293B);

  // ─── Borders ───
  static const border = Color(0xFF1E293B);
  static const borderSubtle = Color(0xFF0F172A);

  // ─── Text ───
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF94A3B8);
  static const textTertiary = Color(0xFF64748B);
  static const textMuted = Color(0xFF475569);
  static const textInverted = Color(0xFF0A0F1C);

  // ─── Status ───
  static const statusDraft = Color(0xFF64748B);
  static const statusDraftBg = Color(0x2064748B);
  static const statusSent = Color(0xFF60A5FA);
  static const statusSentBg = Color(0x2060A5FA);
  static const statusViewed = Color(0xFFA78BFA);
  static const statusViewedBg = Color(0x20A78BFA);
  static const statusOverdue = Color(0xFFFB923C);
  static const statusOverdueBg = Color(0x20FB923C);
  static const statusPaid = Color(0xFF34D399);
  static const statusPaidBg = Color(0x2034D399);
}

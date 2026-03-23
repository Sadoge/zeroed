import 'package:flutter/material.dart';

/// Spacing and sizing tokens derived from design/zeroed.pen.
///
/// Based on a 4px base grid. Every value maps to a repeated
/// measurement found across the design components and screens.
abstract final class AppSpacing {
  // ─── Base grid ───
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;

  // ─── Screen content padding ───
  /// Standard screen content: no top padding, 20 sides, 24 bottom.
  /// Used by Dashboard, Create Invoice, Invoice Detail, Settings, etc.
  static const screenPadding = EdgeInsets.fromLTRB(xl, 0, xl, xxl);

  /// Onboarding / auth content padding: 0 top, 24 sides, 40 bottom.
  static const authPadding = EdgeInsets.fromLTRB(xxl, 0, xxl, huge);

  // ─── Section gaps ───
  /// Gap between major screen sections (e.g. header → cards → list).
  static const double sectionGap = xxl; // 24

  /// Gap between items in a list (summary cards, line items, options).
  static const double listGap = md; // 12

  /// Gap between tightly packed items (invoice rows).
  static const double tightListGap = sm; // 8
}

/// Border radius tokens derived from design/zeroed.pen.
abstract final class AppRadius {
  // ─── Radii ───
  /// Full pill (status badges).
  static const double pill = 100;

  /// Bottom nav outer pill.
  static const double navPill = 36;

  /// Bottom nav inner tabs.
  static const double navTab = 26;

  /// Circular icon buttons (back button, notification button — 40x40).
  static const double iconButton = 20;

  /// FAB and paywall upgrade button.
  static const double fab = 16;

  /// Cards (summary, invoice row, totals, settings sections, amount card).
  static const double card = 12;

  /// Inputs, search bars, line items, option rows.
  static const double input = 10;

  /// Small elements (toggle pills, small tags).
  static const double small = 8;

  // ─── BorderRadius helpers ───
  static final BorderRadius pillBorder = BorderRadius.circular(pill);
  static final BorderRadius cardBorder = BorderRadius.circular(card);
  static final BorderRadius inputBorder = BorderRadius.circular(input);
  static final BorderRadius iconButtonBorder = BorderRadius.circular(iconButton);
  static final BorderRadius fabBorder = BorderRadius.circular(fab);
}

/// Fixed sizing tokens derived from design/zeroed.pen.
abstract final class AppSizing {
  // ─── Heights ───
  /// Bottom nav pill container height.
  static const double navBarHeight = 62;

  /// FAB size (width & height).
  static const double fabSize = 56;

  /// Primary action buttons (Preview Invoice, Send Invoice, Upgrade).
  static const double buttonHeight = 52;

  /// Auth input fields (email, password on sign in/up).
  static const double inputHeightLg = 50;

  /// Input fields, option rows, secondary buttons.
  static const double inputHeight = 48;

  /// Search bars (client list), add-line-item buttons.
  static const double searchHeight = 44;

  /// Circular icon buttons (back, notification, more).
  static const double iconButtonSize = 40;

  // ─── Icon sizes ───
  /// Large icons (FAB plus).
  static const double iconLg = 24;

  /// Standard icons (back arrow, notification bell, send, etc.).
  static const double iconMd = 18;

  /// Small icons (search, add-line, status bar indicators).
  static const double iconSm = 16;
}

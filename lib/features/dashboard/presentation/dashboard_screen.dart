import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/models/invoice_summary.dart';
import 'package:zeroed/shared/widgets/invoice_row.dart';
import 'package:zeroed/shared/widgets/section_header.dart';
import 'package:zeroed/shared/widgets/summary_card.dart';

final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

@RoutePage()
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(dashboardSummaryProvider);
    final invoices = ref.watch(recentInvoicesProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildHeader(),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildSummaryCards(summary),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildRecentHeader(),
              const SizedBox(height: AppSpacing.md),
              _buildInvoiceList(context, invoices),
              // Extra padding so content doesn't hide behind FAB/nav
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text('Zeroed', style: AppTextStyles.heading1),
          ],
        ),
        Container(
          width: AppSizing.iconButtonSize,
          height: AppSizing.iconButtonSize,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.iconButtonBorder,
          ),
          child: Center(
            child: Icon(
              LucideIcons.bell,
              size: AppSizing.iconMd,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(InvoiceSummary summary) {
    return Column(
      children: [
        SummaryCard(
          label: 'OUTSTANDING',
          amount: _currencyFormat.format(summary.totalOutstanding),
          subtitle: '${summary.invoiceCount} invoices',
        ),
        const SizedBox(height: AppSpacing.listGap),
        SummaryCard(
          label: 'OVERDUE',
          amount: _currencyFormat.format(summary.totalOverdue),
          subtitle:
              '${summary.overdueCount} invoice${summary.overdueCount != 1 ? 's' : ''}',
          amountColor: AppColors.statusOverdue,
        ),
        const SizedBox(height: AppSpacing.listGap),
        SummaryCard(
          label: 'PAID THIS MONTH',
          amount: _currencyFormat.format(summary.paidThisMonth),
          subtitle: '8 invoices',
          amountColor: AppColors.statusPaid,
        ),
      ],
    );
  }

  Widget _buildRecentHeader() {
    return SectionHeader(
      title: 'RECENT INVOICES',
      trailing: Text(
        'See All',
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.accent,
        ),
      ),
    );
  }

  Widget _buildInvoiceList(BuildContext context, List<Invoice> invoices) {
    return Column(
      children: invoices.map((invoice) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.tightListGap),
          child: InvoiceRow(
            clientName: clientNameForId(invoice.clientId),
            invoiceNumber: invoice.invoiceNumber,
            dateLabel: _formatDateLabel(invoice),
            amount: _currencyFormat.format(invoice.total),
            status: invoice.status,
            onTap: () {
              context.router.push(InvoiceDetailRoute(invoiceId: invoice.id));
            },
          ),
        );
      }).toList(),
    );
  }

  String _formatDateLabel(Invoice invoice) {
    final df = DateFormat('MMM d');
    if (invoice.status == InvoiceStatus.paid && invoice.paidAt != null) {
      return 'Paid ${df.format(invoice.paidAt!)}';
    }
    return 'Due ${df.format(invoice.dueDate)}';
  }
}

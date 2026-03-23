import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/clients/presentation/client_list_view_model.dart';
import 'package:zeroed/features/invoices/presentation/create_invoice_view_model.dart';
import 'package:zeroed/models/client_model.dart';
import 'package:zeroed/models/line_item_model.dart';
import 'package:zeroed/shared/widgets/app_back_button.dart';
import 'package:zeroed/shared/widgets/app_button.dart';
import 'package:zeroed/shared/widgets/section_header.dart';

import 'package:zeroed/core/utils/currency_utils.dart';

@RoutePage()
class CreateInvoiceScreen extends ConsumerStatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  ConsumerState<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends ConsumerState<CreateInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createInvoiceViewModelProvider);
    final vm = ref.read(createInvoiceViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    _buildHeader(),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _buildClientSection(state, vm),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _buildLineItemsSection(state, vm),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _buildTotalsCard(vm),
                    const SizedBox(height: AppSpacing.sectionGap),
                    _buildOptionsSection(state, vm),
                    const SizedBox(height: AppSpacing.sectionGap),
                    AppButton(
                      label: 'Preview Invoice',
                      icon: LucideIcons.eye,
                      onPressed: state.lineItems.isEmpty
                          ? null
                          : () => _handlePreview(vm),
                      isLoading: state.isSaving,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBackButton(onTap: () => context.router.maybePop()),
        Text('New Invoice', style: AppTextStyles.heading2),
        const SizedBox(width: AppSizing.iconButtonSize),
      ],
    );
  }

  // ─── Client Section ─────────────────────────────────────────

  Widget _buildClientSection(
      CreateInvoiceState state, CreateInvoiceViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'CLIENT'),
        const SizedBox(height: AppSpacing.md),
        _buildClientSearch(state),
        const SizedBox(height: AppSpacing.sm),
        _buildRecentClients(vm),
      ],
    );
  }

  Widget _buildClientSearch(CreateInvoiceState state) {
    return GestureDetector(
      onTap: () => _showClientPickerSheet(),
      child: Container(
        height: AppSizing.inputHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.inputBorder,
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.search,
              size: AppSizing.iconSm,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                state.selectedClient?.name ?? 'Search clients...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: state.selectedClient != null
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.selectedClient != null)
              GestureDetector(
                onTap: () => ref
                    .read(createInvoiceViewModelProvider.notifier)
                    .clearClient(),
                child: Icon(
                  LucideIcons.x,
                  size: AppSizing.iconSm,
                  color: AppColors.textMuted,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentClients(CreateInvoiceViewModel vm) {
    final clientsAsync = ref.watch(clientListProvider);
    return clientsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (clients) {
        final recent = clients.take(3).toList();
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...recent.map((c) => _ClientChip(
                  label: c.name,
                  onTap: () => vm.selectClient(c),
                )),
          ],
        );
      },
    );
  }

  void _showClientPickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollController) => _ClientPickerBody(
          scrollController: scrollController,
          onSelect: (client) {
            ref
                .read(createInvoiceViewModelProvider.notifier)
                .selectClient(client);
            Navigator.of(ctx).pop();
          },
        ),
      ),
    );
  }

  // ─── Line Items Section ─────────────────────────────────────

  Widget _buildLineItemsSection(
      CreateInvoiceState state, CreateInvoiceViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'LINE ITEMS'),
        const SizedBox(height: AppSpacing.md),
        ...state.lineItems.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.listGap),
                child: _LineItemCard(
                  item: e.value,
                  onDelete: () => vm.removeLineItem(e.key),
                  currency: state.currency,
                ),
              ),
            ),
        AppButton(
          label: 'Add Line Item',
          icon: LucideIcons.plus,
          variant: AppButtonVariant.ghost,
          onPressed: () => _showAddLineItemSheet(),
        ),
      ],
    );
  }

  void _showAddLineItemSheet() {
    final descController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final rateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
      ),
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Line Item', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            _SheetField(
              label: 'Description',
              controller: descController,
              hint: 'e.g. Website Design',
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _SheetField(
                    label: 'Quantity',
                    controller: qtyController,
                    hint: '1',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _SheetField(
                    label: 'Unit Price',
                    controller: rateController,
                    hint: '0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'Add',
              onPressed: () {
                final desc = descController.text.trim();
                final qty =
                    double.tryParse(qtyController.text.trim()) ?? 1;
                final rate =
                    double.tryParse(rateController.text.trim()) ?? 0;
                if (desc.isEmpty || rate <= 0) return;

                ref
                    .read(createInvoiceViewModelProvider.notifier)
                    .addLineItem(
                      description: desc,
                      quantity: qty,
                      unitPrice: rate,
                    );
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ─── Totals Card ────────────────────────────────────────────

  Widget _buildTotalsCard(CreateInvoiceViewModel vm) {
    final state = ref.watch(createInvoiceViewModelProvider);
    final fmt = currencyFormat(state.currency);
    final hasTax = state.taxRate != null && state.taxRate! > 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          _TotalRow(
            label: 'Subtotal',
            value: fmt.format(vm.subtotal),
          ),
          if (hasTax) ...[
            const SizedBox(height: AppSpacing.md),
            _TotalRow(
              label: 'Tax (${state.taxRate!.toStringAsFixed(0)}%)',
              value: fmt.format(vm.taxAmount),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyles.heading3),
              Text(
                fmt.format(vm.total),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Options Section ────────────────────────────────────────

  Widget _buildOptionsSection(
      CreateInvoiceState state, CreateInvoiceViewModel vm) {
    final dateFormat = DateFormat('MMM d, y');
    return Column(
      children: [
        _OptionRow(
          icon: LucideIcons.calendar,
          label: 'Due Date',
          value: dateFormat.format(state.dueDate),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: state.dueDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) => Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: AppColors.accent,
                      ),
                ),
                child: child!,
              ),
            );
            if (picked != null) vm.setDueDate(picked);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _OptionRow(
          icon: LucideIcons.fileText,
          label: 'Notes',
          trailing: Icon(
            LucideIcons.chevronRight,
            size: AppSizing.iconSm,
            color: AppColors.textMuted,
          ),
          onTap: () {
            // TODO: notes editor
          },
        ),
      ],
    );
  }

  // ─── Preview ────────────────────────────────────────────────

  Future<void> _handlePreview(CreateInvoiceViewModel vm) async {
    final invoice = await vm.saveInvoice();
    if (invoice != null && mounted) {
      // TODO: navigate to preview screen
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Private sub-widgets
// ═══════════════════════════════════════════════════════════════

class _ClientChip extends StatelessWidget {
  const _ClientChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.pillBorder,
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ClientPickerBody extends ConsumerStatefulWidget {
  const _ClientPickerBody({
    required this.scrollController,
    required this.onSelect,
  });

  final ScrollController scrollController;
  final ValueChanged<Client> onSelect;

  @override
  ConsumerState<_ClientPickerBody> createState() => _ClientPickerBodyState();
}

class _ClientPickerBodyState extends ConsumerState<_ClientPickerBody> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientListProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Select Client', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: AppSizing.inputHeight,
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                prefixIcon: Icon(
                  LucideIcons.search,
                  size: AppSizing.iconSm,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.bgInset,
                border: OutlineInputBorder(
                  borderRadius: AppRadius.inputBorder,
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: clientsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) => Center(
                child: Text(
                  'Failed to load clients',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              data: (clients) {
                final filtered = _query.isEmpty
                    ? clients
                    : clients
                        .where((c) => c.name
                            .toLowerCase()
                            .contains(_query.toLowerCase()))
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      'No clients found',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  controller: widget.scrollController,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (_, i) {
                    final client = filtered[i];
                    return GestureDetector(
                      onTap: () => widget.onSelect(client),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgInset,
                          borderRadius: AppRadius.inputBorder,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              client.name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              client.email,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LineItemCard extends StatelessWidget {
  const _LineItemCard({
    required this.item,
    required this.onDelete,
    required this.currency,
  });

  final LineItem item;
  final VoidCallback onDelete;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.inputBorder,
      ),
      child: Column(
        children: [
          // Top: description + amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.description,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                currencyFormat(currency).format(item.amount),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Bottom: qty + rate pills
          Row(
            children: [
              _InfoPill(label: 'Qty:', value: item.quantity.toStringAsFixed(0)),
              const SizedBox(width: AppSpacing.md),
              _InfoPill(
                label: 'Rate:',
                value: currencyFormat(currency).format(item.unitPrice),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  LucideIcons.trash2,
                  size: AppSizing.iconSm,
                  color: AppColors.statusOverdue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgInset,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizing.inputHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.inputBorder,
        ),
        child: Row(
          children: [
            Icon(icon, size: AppSizing.iconSm, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (value != null)
              Text(
                value!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: AppSizing.inputHeight,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.accent,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
              filled: true,
              fillColor: AppColors.bgInset,
              border: OutlineInputBorder(
                borderRadius: AppRadius.inputBorder,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


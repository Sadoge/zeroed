import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uuid/uuid.dart';

import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/clients/presentation/client_list_view_model.dart';
import 'package:zeroed/models/client_model.dart';
import 'package:zeroed/shared/widgets/app_text_field.dart';

// ─── Avatar color from name ─────────────────────────────────

const _avatarColors = [
  AppColors.accent,
  Color(0xFF6366F1),
  Color(0xFFF59E0B),
  Color(0xFFEC4899),
  Color(0xFF14B8A6),
  Color(0xFF8B5CF6),
  Color(0xFFEF4444),
  Color(0xFF3B82F6),
];

Color _avatarColor(String name) {
  final hash = name.codeUnits.fold(0, (sum, c) => sum + c);
  return _avatarColors[hash % _avatarColors.length];
}

// ─── Screen ──────────────────────────────────────────────────

@RoutePage()
class ClientListScreen extends ConsumerStatefulWidget {
  const ClientListScreen({super.key});

  @override
  ConsumerState<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends ConsumerState<ClientListScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientListProvider);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),
              AppTextField(
                controller: _searchController,
                hintText: 'Search clients...',
                prefixIcon: LucideIcons.search,
                search: true,
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: clientsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(
                    child: Text(
                      'Failed to load clients',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  data: (allClients) {
                    final clients = _query.isEmpty
                        ? allClients
                        : allClients
                            .where((c) => c.name
                                .toLowerCase()
                                .contains(_query.toLowerCase()))
                            .toList();

                    if (clients.isEmpty) return _buildEmpty();

                    final grouped = <String, List<Client>>{};
                    for (final c in clients) {
                      final letter = c.name[0].toUpperCase();
                      grouped.putIfAbsent(letter, () => []).add(c);
                    }
                    final sortedKeys = grouped.keys.toList()..sort();

                    return ListView.builder(
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, i) {
                        final letter = sortedKeys[i];
                        final group = grouped[letter]!;
                        return _buildGroup(letter, group);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Clients', style: AppTextStyles.heading1),
        GestureDetector(
          onTap: () => _showAddClientSheet(),
          child: Container(
            width: AppSizing.iconButtonSize,
            height: AppSizing.iconButtonSize,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: AppRadius.iconButtonBorder,
            ),
            child: Center(
              child: Icon(
                LucideIcons.plus,
                size: AppSizing.iconMd,
                color: AppColors.textInverted,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroup(String letter, List<Client> clients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            letter,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ),
        ...clients.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: _ClientRow(client: c),
            )),
      ],
    );
  }

  Widget _buildEmpty() {
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

  void _showAddClientSheet() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
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
            Text('Add Client', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              controller: nameCtrl,
              label: 'Name',
              hintText: 'Client name',
              prefixIcon: LucideIcons.user,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: emailCtrl,
              label: 'Email',
              hintText: 'client@example.com',
              prefixIcon: LucideIcons.mail,
              keyboardType: TextInputType.emailAddress,
              compact: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameCtrl.text.trim();
                  final email = emailCtrl.text.trim();
                  if (name.isEmpty || email.isEmpty) return;

                  final userId =
                      ref.read(currentUserProvider)?.id ?? '';
                  final client = Client(
                    id: const Uuid().v4(),
                    userId: userId,
                    name: name,
                    email: email,
                    createdAt: DateTime.now(),
                  );

                  await ref
                      .read(clientListViewModelProvider.notifier)
                      .createClient(client);

                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                child: const Text('Add Client'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Client Row ──────────────────────────────────────────────

class _ClientRow extends StatelessWidget {
  const _ClientRow({required this.client});
  final Client client;

  @override
  Widget build(BuildContext context) {
    final initial = client.name[0].toUpperCase();
    final color = _avatarColor(client.name);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.inputBorder,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.iconButtonBorder,
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
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
          Icon(
            LucideIcons.chevronRight,
            size: AppSizing.iconSm,
            color: AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

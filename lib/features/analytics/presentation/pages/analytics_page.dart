import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../domain/services/analytics.dart';
import '../../../../shared/formatting/date_format.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_radius.dart';
import '../../../../shared/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';

final analyticsProvider = Provider<AnalyticsSnapshot?>((ref) {
  final dashboard = ref.watch(homeDashboardProvider).asData?.value;
  return dashboard?.analytics;
});

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final categories =
        ref.watch(transactionCategoriesProvider).asData?.value ?? [];
    final categoryMap = {for (final c in categories) c.id: c.name};

    return Scaffold(
      appBar: AppBar(title: const Text('Spending Analytics')),
      body:
          analytics == null ||
              (!analytics.hasSpending && analytics.upcomingPayments.isEmpty)
          ? const AppEmptyState(
              icon: Icons.insights_rounded,
              title: 'No analytics available',
              subtitle: 'Add transactions or import statements to see spending breakdowns.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pageHorizontal,
                12,
                AppSpacing.pageHorizontal,
                40,
              ),
              children: [
                // Current Month Overview
                const SectionHeader(
                  title: 'Current month',
                  subtitle: 'Total spending by currency',
                ),
                for (final curr in analytics.currentMonth)
                  _MonthSummaryHero(spending: curr),

                const SizedBox(height: 24),

                // Month-over-month history
                if (analytics.previousMonths.isNotEmpty) ...[
                  const SectionHeader(
                    title: 'Spending history',
                    subtitle: 'Previous months by currency',
                  ),
                  _HistoryComparisonCard(previous: analytics.previousMonths),
                  const SizedBox(height: 24),
                ],

                // Category Breakdown
                if (analytics.categories.isNotEmpty) ...[
                  const SectionHeader(
                    title: 'Categories',
                    subtitle: 'Spending distribution this month',
                  ),
                  _CategoryBreakdownCard(
                    categories: analytics.categories,
                    categoryMap: categoryMap,
                  ),
                  const SizedBox(height: 24),
                ],

                // Upcoming obligations
                if (analytics.upcomingPayments.isNotEmpty) ...[
                  const SectionHeader(
                    title: 'Upcoming payments',
                    subtitle: 'Due within next 30 days',
                  ),
                  for (final payment in analytics.upcomingPayments)
                    AppCard(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.calendar_today_outlined,
                              size: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${payment.displayName} •••• ${payment.lastFour}',
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Due ${formatShortDate(payment.dueDate)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          CurrencyText(
                            amountMinor: payment.amountMinor,
                            currencyCode: payment.currencyCode,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}

class _MonthSummaryHero extends StatelessWidget {
  const _MonthSummaryHero({required this.spending});

  final CurrencySpending spending;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: AppRadius.chip,
                ),
                child: Text(
                  spending.currencyCode,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Text(
                '${spending.transactionCount} transactions',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Total spent',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          CurrencyText(
            amountMinor: spending.amountMinor,
            currencyCode: spending.currencyCode,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryComparisonCard extends StatelessWidget {
  const _HistoryComparisonCard({required this.previous});

  final List<MonthSpending> previous;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final month in previous) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      _monthName(month.month),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final item in month.byCurrency)
                          CurrencyText(
                            amountMinor: item.amountMinor,
                            currencyCode: item.currencyCode,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        if (month.byCurrency.isEmpty)
                          Text('No spend', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (month != previous.last) const Divider(height: 12),
          ],
        ],
      ),
    );
  }

  String _monthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({
    required this.categories,
    required this.categoryMap,
  });

  final List<CategorySpending> categories;
  final Map<String, String> categoryMap;

  static const _palette = [
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF06B6D4),
    Color(0xFF64748B),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final total = categories.fold<int>(0, (sum, c) => sum + c.amountMinor);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (total > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 10,
                child: Row(
                  children: [
                    for (int i = 0; i < categories.length; i++)
                      Expanded(
                        flex: categories[i].amountMinor > 0
                            ? categories[i].amountMinor
                            : 1,
                        child: Container(
                          color: _palette[i % _palette.length],
                          margin: EdgeInsets.only(
                            right: i < categories.length - 1 ? 2 : 0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          for (int i = 0; i < categories.length; i++) ...[
            _CategoryRow(
              item: categories[i],
              color: _palette[i % _palette.length],
              name: categories[i].categoryId != null
                  ? (categoryMap[categories[i].categoryId] ??
                        categories[i].categoryId!)
                  : 'Uncategorised',
              percent: total > 0
                  ? (categories[i].amountMinor / total * 100)
                  : 0.0,
            ),
            if (i < categories.length - 1)
              Divider(
                height: 12,
                color: isDark ? AppColors.darkDivider : AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.item,
    required this.color,
    required this.name,
    required this.percent,
  });

  final CategorySpending item;
  final Color color;
  final String name;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${percent.toStringAsFixed(1)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          CurrencyText(
            amountMinor: item.amountMinor,
            currencyCode: item.currencyCode,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

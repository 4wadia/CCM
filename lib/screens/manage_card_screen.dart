import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../utils/format_currency.dart';
import '../widgets/physical_credit_card.dart';

class ManageCardScreen extends StatefulWidget {
  final CreditCardModel card;
  final List<TransactionModel> transactions;
  final VoidCallback onBack;
  final ValueChanged<CreditCardModel>? onCompleteCard;
  final ValueChanged<CreditCardModel>? onUpdateCard;
  final ValueChanged<CreditCardModel>? onDeleteCard;
  final bool isDarkMode;

  const ManageCardScreen({
    super.key,
    required this.card,
    this.transactions = const [],
    required this.onBack,
    this.onCompleteCard,
    this.onUpdateCard,
    this.onDeleteCard,
    required this.isDarkMode,
  });

  @override
  State<ManageCardScreen> createState() => _ManageCardScreenState();
}

class _ManageCardScreenState extends State<ManageCardScreen> {
  bool _balanceVisible = true;
  bool _showAllTransactions = false;

  CreditCardModel get card => widget.card;

  /// Only transactions that belong to this card are shown here. When a
  /// transaction carries a last-four we require it to match; when it only
  /// carries a bank/brand we use that as a fallback for older imports.
  List<TransactionModel> get _cardTransactions {
    return widget.transactions.where((tx) {
      final last4 = tx.cardLast4.trim();
      if (last4.isNotEmpty) {
        return last4 == card.lastFour &&
            (tx.cardBank == null || tx.cardBank == card.bankName);
      }
      return tx.cardBank == card.bankName &&
          (tx.cardBrand == null || tx.cardBrand == card.brand);
    }).toList();
  }

  double get _trackedSpend => _cardTransactions
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  double get _trackedCredits => _cardTransactions
      .where((tx) => tx.type == TransactionType.income)
      .fold(0.0, (sum, tx) => sum + tx.amount);

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) {
        final palette = OnyxPalette(widget.isDarkMode);
        final scale = OnyxScale.of(ctx);
        return AlertDialog(
          backgroundColor: palette.modalSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scale.s(20)),
          ),
          title: Text(
            'Remove ${card.cardTier}?',
            style: OnyxTypography.editorial(
              fontSize: scale.s(24),
              fontWeight: FontWeight.w600,
              color: palette.primaryText,
            ),
          ),
          content: Text(
            'This removes the card and its imported transactions from this '
            'device. This cannot be undone.',
            style: OnyxTypography.sans(
              fontSize: scale.s(12.5),
              color: palette.mutedText,
              height: 1.4,
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            scale.s(16),
            0,
            scale.s(16),
            scale.s(14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'CANCEL',
                style: OnyxTypography.mono(
                  fontSize: scale.s(10.5),
                  color: palette.mutedText,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            TextButton(
              key: const ValueKey('confirm-delete-card'),
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: scale.s(14),
                  vertical: scale.s(9),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(scale.s(8)),
                ),
              ),
              child: Text(
                'REMOVE CARD',
                style: OnyxTypography.mono(
                  fontSize: scale.s(10.5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      widget.onDeleteCard?.call(card);
    }
  }

  Future<void> _editLimit() async {
    final controller = TextEditingController(
      text: card.limit > 0 ? card.limit.toStringAsFixed(0) : '',
    );
    final formKey = GlobalKey<FormState>();

    final updatedLimit = await showDialog<double>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) {
        final palette = OnyxPalette(widget.isDarkMode);
        final scale = OnyxScale.of(ctx);
        return AlertDialog(
          backgroundColor: palette.modalSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(scale.s(20)),
          ),
          title: Text(
            'Credit limit',
            style: OnyxTypography.editorial(
              fontSize: scale.s(24),
              fontWeight: FontWeight.w600,
              color: palette.primaryText,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              style: OnyxTypography.sans(
                fontSize: scale.s(16),
                color: palette.primaryText,
                tabularFigures: true,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                hintText: '500000',
                hintStyle: OnyxTypography.sans(
                  fontSize: scale.s(14),
                  color: palette.subtleText,
                ),
                filled: true,
                fillColor: palette.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(scale.s(10)),
                  borderSide: BorderSide(color: palette.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(scale.s(10)),
                  borderSide: BorderSide(color: palette.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(scale.s(10)),
                  borderSide: BorderSide(color: palette.gold),
                ),
              ),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Enter a valid limit';
                }
                return null;
              },
            ),
          ),
          actionsPadding: EdgeInsets.fromLTRB(
            scale.s(16),
            0,
            scale.s(16),
            scale.s(14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'CANCEL',
                style: OnyxTypography.mono(
                  fontSize: scale.s(10.5),
                  color: palette.mutedText,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState?.validate() != true) return;
                Navigator.of(ctx).pop(double.parse(controller.text.trim()));
              },
              style: TextButton.styleFrom(
                backgroundColor: palette.gold,
                foregroundColor: widget.isDarkMode
                    ? const Color(0xFF111113)
                    : const Color(0xFFF8F7F4),
                padding: EdgeInsets.symmetric(
                  horizontal: scale.s(14),
                  vertical: scale.s(9),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(scale.s(8)),
                ),
              ),
              child: Text(
                'SAVE',
                style: OnyxTypography.mono(
                  fontSize: scale.s(10.5),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        );
      },
    );

    controller.dispose();
    if (updatedLimit != null && updatedLimit > 0 && mounted) {
      widget.onUpdateCard?.call(card.copyWith(limit: updatedLimit));
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final scale = OnyxScale.of(context);
    final transactions = _cardTransactions;
    final outstanding = card.balance;
    final limit = card.limit;
    final available = max(0.0, limit - outstanding);
    final utilization = limit > 0 ? (outstanding / limit).clamp(0.0, 1.0) : 0.0;
    final utilizationPercent = (utilization * 100).round();
    final utilizationColor = utilization >= 0.8
        ? const Color(0xFFF87171)
        : utilization >= 0.5
        ? const Color(0xFFFBBF24)
        : const Color(0xFF34D399);

    final initialCount = MediaQuery.sizeOf(context).height >= 760 ? 4 : 3;
    final initialTransactions = transactions.take(initialCount).toList();
    final extraTransactions = transactions.skip(initialCount).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(
        scale.s(20),
        scale.s(16),
        scale.s(20),
        scale.s(36),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top navigation bar
          SizedBox(
            height: scale.s(44),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      width: scale.s(44),
                      height: scale.s(44),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isDarkMode
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.white,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: scale.s(24),
                        color: palette.primaryText,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Manage Card',
                  style: OnyxTypography.editorial(
                    fontSize: scale.s(26),
                    fontWeight: FontWeight.w600,
                    color: palette.primaryText,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    key: const ValueKey('delete-card-button'),
                    onPressed: widget.onDeleteCard == null
                        ? null
                        : _confirmDelete,
                    tooltip: 'Remove card',
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: scale.s(21),
                      color: const Color(0xFFF87171),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(16)),

          if (card.isNeedsCompletion) ...[
            GestureDetector(
              onTap: () => widget.onCompleteCard?.call(card),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: scale.s(14),
                  vertical: scale.s(10),
                ),
                decoration: BoxDecoration(
                  color: palette.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(scale.s(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: scale.s(14),
                                color: palette.gold,
                              ),
                              SizedBox(width: scale.s(6)),
                              Text(
                                'AUTO-DETECTED · SETUP INCOMPLETE',
                                style: OnyxTypography.mono(
                                  fontSize: scale.s(9.5),
                                  fontWeight: FontWeight.w700,
                                  color: palette.gold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: scale.s(3)),
                          Text(
                            'Tap to choose your card model & verify card number',
                            style: OnyxTypography.sans(
                              fontSize: scale.s(11.5),
                              fontWeight: FontWeight.w500,
                              color: palette.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: scale.s(8)),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: scale.s(20),
                      color: palette.gold,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: scale.s(12)),
          ],

          // Hero physical card
          PhysicalCreditCard(card: card),
          SizedBox(height: scale.s(10)),

          // Balance summary
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _SummaryTile(
                    label: 'OUTSTANDING',
                    value: _balanceVisible
                        ? formatINR(outstanding)
                        : '••••••••',
                    caption: _balanceVisible
                        ? 'of ${formatINR(limit, compact: true)} limit'
                        : 'of •••• limit',
                    palette: palette,
                    scale: scale,
                    trailing: GestureDetector(
                      onTap: () =>
                          setState(() => _balanceVisible = !_balanceVisible),
                      child: Icon(
                        _balanceVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: scale.s(17),
                        color: palette.mutedText,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: scale.s(6)),
                Expanded(
                  child: _SummaryTile(
                    label: 'AVAILABLE',
                    value: _balanceVisible ? formatINR(available) : '••••••••',
                    caption: limit > 0
                        ? '$utilizationPercent% of limit used'
                        : 'Set a limit to track usage',
                    palette: palette,
                    scale: scale,
                    valueColor: utilization >= 0.8
                        ? const Color(0xFFF87171)
                        : palette.primaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(10)),

          // Real usage panel
          Container(
            padding: EdgeInsets.all(scale.s(20)),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(scale.s(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Card usage',
                        style: OnyxTypography.sans(
                          fontSize: scale.s(15.5),
                          fontWeight: FontWeight.w600,
                          color: palette.primaryText,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _editLimit,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: scale.s(8),
                          vertical: scale.s(4),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'EDIT LIMIT',
                        style: OnyxTypography.mono(
                          fontSize: scale.s(10),
                          fontWeight: FontWeight.w600,
                          color: palette.gold,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: scale.s(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      limit > 0
                          ? '${formatINR(outstanding)} used'
                          : 'No credit limit set',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(10.5),
                        color: palette.mutedText,
                        tabularFigures: true,
                      ),
                    ),
                    Text(
                      limit > 0 ? '$utilizationPercent%' : '—',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(11),
                        fontWeight: FontWeight.w700,
                        color: limit > 0 ? utilizationColor : palette.mutedText,
                        tabularFigures: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: scale.s(8)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: utilization,
                    minHeight: scale.s(8),
                    backgroundColor: palette.hoverFill,
                    valueColor: AlwaysStoppedAnimation<Color>(utilizationColor),
                  ),
                ),
                SizedBox(height: scale.s(16)),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _UsageMetric(
                          label: 'TRACKED SPEND',
                          value: formatINR(_trackedSpend, compact: true),
                          palette: palette,
                          scale: scale,
                        ),
                      ),
                      _VerticalDivider(palette: palette),
                      Expanded(
                        child: _UsageMetric(
                          label: 'CREDITS',
                          value: formatINR(_trackedCredits, compact: true),
                          palette: palette,
                          scale: scale,
                        ),
                      ),
                      _VerticalDivider(palette: palette),
                      Expanded(
                        child: _UsageMetric(
                          label: 'TRANSACTIONS',
                          value: '${transactions.length}',
                          palette: palette,
                          scale: scale,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(10)),

          // Real transactions for this card only
          Container(
            padding: EdgeInsets.all(scale.s(20)),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(scale.s(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Recent transactions',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: OnyxTypography.sans(
                          fontSize: scale.s(15.5),
                          fontWeight: FontWeight.w600,
                          color: palette.primaryText,
                        ),
                      ),
                    ),
                    if (extraTransactions.isNotEmpty) ...[
                      SizedBox(width: scale.s(8)),
                      GestureDetector(
                        onTap: () => setState(
                          () => _showAllTransactions = !_showAllTransactions,
                        ),
                        child: Text(
                          _showAllTransactions ? 'SHOW LESS' : 'VIEW ALL',
                          style: OnyxTypography.mono(
                            fontSize: scale.s(11.5),
                            color: palette.mutedText,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: scale.s(6)),
                if (transactions.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: scale.s(18)),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: scale.s(28),
                          color: palette.subtleText,
                        ),
                        SizedBox(height: scale.s(8)),
                        Text(
                          'No transactions for this card yet',
                          textAlign: TextAlign.center,
                          style: OnyxTypography.sans(
                            fontSize: scale.s(12.5),
                            fontWeight: FontWeight.w600,
                            color: palette.primaryText,
                          ),
                        ),
                        SizedBox(height: scale.s(3)),
                        Text(
                          'Imported SMS or statement transactions will appear '
                          'here automatically.',
                          textAlign: TextAlign.center,
                          style: OnyxTypography.sans(
                            fontSize: scale.s(11),
                            color: palette.mutedText,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  ...initialTransactions.map(
                    (tx) => _CardTxRow(
                      tx: tx,
                      palette: palette,
                      isDarkMode: widget.isDarkMode,
                    ),
                  ),
                  if (extraTransactions.isNotEmpty)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                      alignment: Alignment.topCenter,
                      child: _showAllTransactions
                          ? Column(
                              children: extraTransactions
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => TweenAnimationBuilder<double>(
                                      key: ValueKey(entry.value.id),
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: Duration(
                                        milliseconds: 240 + (entry.key * 35),
                                      ),
                                      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                                      builder: (context, val, child) {
                                        return Opacity(
                                          opacity: val,
                                          child: Transform.translate(
                                            offset: Offset(0, -6 * (1 - val)),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: _CardTxRow(
                                        tx: entry.value,
                                        palette: palette,
                                        isDarkMode: widget.isDarkMode,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            )
                          : const SizedBox.shrink(),
                    ),
                ],
              ],
            ),
          ),
          SizedBox(height: scale.s(14)),

          // Destructive action kept explicit and away from normal controls.
          OutlinedButton.icon(
            key: const ValueKey('remove-card-button'),
            onPressed: widget.onDeleteCard == null ? null : _confirmDelete,
            icon: Icon(Icons.delete_outline_rounded, size: scale.s(16)),
            label: Text(
              'Remove this card',
              style: OnyxTypography.sans(
                fontSize: scale.s(12.5),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFF87171),
              side: BorderSide(
                color: const Color(0xFFF87171).withValues(alpha: 0.35),
              ),
              padding: EdgeInsets.symmetric(vertical: scale.s(13)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(scale.s(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final OnyxPalette palette;
  final OnyxScale scale;
  final Widget? trailing;
  final Color? valueColor;

  const _SummaryTile({
    required this.label,
    required this.value,
    required this.caption,
    required this.palette,
    required this.scale,
    this.trailing,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scale.s(18),
        vertical: scale.s(16),
      ),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(scale.s(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: scale.s(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OnyxTypography.mono(
                      fontSize: scale.s(10.5),
                      color: palette.mutedText,
                      letterSpacing: 0.9,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: scale.s(6)),
                  trailing!,
                ],
              ],
            ),
          ),
          SizedBox(height: scale.s(8)),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: OnyxTypography.sans(
              fontSize: scale.s(20),
              fontWeight: FontWeight.w700,
              color: valueColor ?? palette.primaryText,
              tabularFigures: true,
            ),
          ),
          SizedBox(height: scale.s(4)),
          Text(
            caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: OnyxTypography.mono(
              fontSize: scale.s(10.5),
              color: palette.mutedText,
              tabularFigures: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsageMetric extends StatelessWidget {
  final String label;
  final String value;
  final OnyxPalette palette;
  final OnyxScale scale;

  const _UsageMetric({
    required this.label,
    required this.value,
    required this.palette,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: OnyxTypography.mono(
            fontSize: scale.s(9),
            color: palette.subtleText,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: scale.s(5)),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: OnyxTypography.sans(
            fontSize: scale.s(14),
            fontWeight: FontWeight.w700,
            color: palette.primaryText,
            tabularFigures: true,
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  final OnyxPalette palette;

  const _VerticalDivider({required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: palette.divider,
    );
  }
}

class _CardTxRow extends StatelessWidget {
  final TransactionModel tx;
  final OnyxPalette palette;
  final bool isDarkMode;

  const _CardTxRow({
    required this.tx,
    required this.palette,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final scale = OnyxScale.of(context);
    final isCredit = tx.type == TransactionType.income;
    final amountColor = isCredit
        ? (isDarkMode ? const Color(0xFF34D399) : const Color(0xFF047857))
        : palette.primaryText;
    final iconChar = tx.title.trim().isNotEmpty
        ? tx.title.trim().substring(0, 1).toUpperCase()
        : '•';

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: scale.s(10)),
        child: Row(
          children: [
            Container(
              width: scale.s(34),
              height: scale.s(34),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCredit
                    ? const Color(0xFF34D399).withValues(alpha: 0.14)
                    : palette.hoverFill,
              ),
              alignment: Alignment.center,
              child: Text(
                iconChar,
                style: OnyxTypography.sans(
                  fontSize: scale.s(12.5),
                  fontWeight: FontWeight.w700,
                  color: isCredit
                      ? const Color(0xFF34D399)
                      : palette.primaryText,
                ),
              ),
            ),
            SizedBox(width: scale.s(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OnyxTypography.sans(
                      fontSize: scale.s(14),
                      fontWeight: FontWeight.w500,
                      color: palette.primaryText,
                    ),
                  ),
                  SizedBox(height: scale.s(2)),
                  Text(
                    tx.time.isEmpty ? tx.date : '${tx.date} · ${tx.time}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OnyxTypography.mono(
                      fontSize: scale.s(10.5),
                      color: palette.subtleText,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: scale.s(10)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'}${formatINR(tx.amount)}',
                  style: OnyxTypography.sans(
                    fontSize: scale.s(14),
                    fontWeight: FontWeight.w600,
                    color: amountColor,
                    tabularFigures: true,
                  ),
                ),
                Text(
                  tx.status == TransactionStatus.completed
                      ? 'SETTLED'
                      : 'PENDING',
                  style: OnyxTypography.mono(
                    fontSize: scale.s(9),
                    color: tx.status == TransactionStatus.completed
                        ? (isDarkMode
                              ? const Color(0xFF34D399)
                              : const Color(0xFF047857))
                        : palette.gold,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

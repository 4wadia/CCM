import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../services/auto_sync_service.dart';
import '../theme/onyx_theme.dart';
import '../utils/format_currency.dart';

Future<SyncResult?> showCardSyncProgressDialog({
  required BuildContext context,
  required CreditCardModel card,
  required bool isDarkMode,
}) async {
  return showDialog<SyncResult>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.75),
    builder: (ctx) =>
        _CardSyncProgressDialog(card: card, isDarkMode: isDarkMode),
  );
}

class _CardSyncProgressDialog extends StatefulWidget {
  final CreditCardModel card;
  final bool isDarkMode;

  const _CardSyncProgressDialog({required this.card, required this.isDarkMode});

  @override
  State<_CardSyncProgressDialog> createState() =>
      _CardSyncProgressDialogState();
}

class _CardSyncProgressDialogState extends State<_CardSyncProgressDialog> {
  final _syncService = AutoSyncService();
  bool _isScanning = true;
  SyncResult? _result;

  @override
  void initState() {
    super.initState();
    _startAutoSync();
  }

  Future<void> _startAutoSync() async {
    // Small natural delay so user sees the scan animation
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final syncResult = await _syncService.syncLastMonthForCard(
      card: widget.card,
    );
    if (mounted) {
      setState(() {
        _isScanning = false;
        _result = syncResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final scale = OnyxScale.of(context);
    final card = widget.card;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(scale.s(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Container(
          padding: EdgeInsets.all(scale.s(22)),
          decoration: BoxDecoration(
            color: palette.modalSurface,
            borderRadius: BorderRadius.circular(scale.s(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Tag
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isScanning
                        ? 'AUTO-SYNC IN PROGRESS'
                        : 'AUTO-SYNC COMPLETE',
                    style: OnyxTypography.mono(
                      fontSize: scale.s(9),
                      color: palette.gold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Text(
                    'Last 30 Days',
                    style: OnyxTypography.mono(
                      fontSize: scale.s(9),
                      color: palette.mutedText,
                    ),
                  ),
                ],
              ),
              SizedBox(height: scale.s(14)),

              // Center Visual
              Center(
                child: Container(
                  width: scale.s(60),
                  height: scale.s(60),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isScanning
                        ? palette.gold.withValues(alpha: 0.15)
                        : const Color(0xFF10B981).withValues(alpha: 0.15),
                    border: Border.all(
                      color: _isScanning
                          ? palette.gold.withValues(alpha: 0.4)
                          : const Color(0xFF10B981).withValues(alpha: 0.4),
                    ),
                  ),
                  child: _isScanning
                      ? Center(
                          child: SizedBox(
                            width: scale.s(24),
                            height: scale.s(24),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: palette.gold,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.done_all_rounded,
                          size: scale.s(28),
                          color: const Color(0xFF10B981),
                        ),
                ),
              ),
              SizedBox(height: scale.s(14)),

              // Title
              Text(
                _isScanning
                    ? 'Scanning Messages & Statements'
                    : 'Synced ${card.cardTier}',
                textAlign: TextAlign.center,
                style: OnyxTypography.editorial(
                  fontSize: scale.s(22),
                  fontWeight: FontWeight.w600,
                  color: palette.primaryText,
                ),
              ),
              SizedBox(height: scale.s(4)),
              Text(
                _isScanning
                    ? 'Extracting last month\'s card transactions from SMS and bank emails...'
                    : 'Finished reading the available card transactions.',
                textAlign: TextAlign.center,
                style: OnyxTypography.sans(
                  fontSize: scale.s(11.5),
                  color: palette.mutedText,
                  height: 1.35,
                ),
              ),
              SizedBox(height: scale.s(18)),

              // Result Cards (when finished)
              if (!_isScanning && _result != null) ...[
                Container(
                  padding: EdgeInsets.all(scale.s(14)),
                  decoration: BoxDecoration(
                    color: palette.cardSurface,
                    borderRadius: BorderRadius.circular(scale.s(12)),
                    border: Border.all(color: palette.border),
                  ),
                  child: Column(
                    children: [
                      _StatRow(
                        label: 'Transactions Found',
                        value: '${_result!.syncedCount} records',
                        palette: palette,
                        scale: scale,
                      ),
                      Divider(color: palette.divider, height: scale.s(16)),
                      _StatRow(
                        label: 'Month Spend Extracted',
                        value: formatINR(_result!.monthSpend),
                        palette: palette,
                        scale: scale,
                      ),
                      Divider(color: palette.divider, height: scale.s(16)),
                      _StatRow(
                        label: 'Source',
                        value: _result!.sourceDescription,
                        palette: palette,
                        scale: scale,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: scale.s(18)),

                // Action Button
                SizedBox(
                  height: scale.s(44),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(_result),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isDarkMode
                          ? palette.gold
                          : const Color(0xFF111113),
                      foregroundColor: widget.isDarkMode
                          ? const Color(0xFF111113)
                          : const Color(0xFFF8F7F4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(scale.s(10)),
                      ),
                    ),
                    child: Text(
                      'View on Portfolio',
                      style: OnyxTypography.sans(
                        fontSize: scale.s(12.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final OnyxPalette palette;
  final OnyxScale scale;
  const _StatRow({
    required this.label,
    required this.value,
    required this.palette,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: OnyxTypography.sans(
            fontSize: scale.s(11.5),
            color: palette.mutedText,
          ),
        ),
        Text(
          value,
          style: OnyxTypography.mono(
            fontSize: scale.s(11.5),
            fontWeight: FontWeight.w600,
            color: palette.primaryText,
          ),
        ),
      ],
    );
  }
}

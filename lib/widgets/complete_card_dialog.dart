import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../utils/card_helpers.dart';
import 'physical_credit_card.dart';

Future<CreditCardModel?> showCompleteCardDialog({
  required BuildContext context,
  required CreditCardModel card,
  required bool isDarkMode,
  required ValueChanged<CreditCardModel> onCardCompleted,
}) {
  return showDialog<CreditCardModel>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.65),
    builder: (ctx) => _CompleteCardDialog(
      card: card,
      isDarkMode: isDarkMode,
      onCardCompleted: onCardCompleted,
    ),
  );
}

class _CompleteCardDialog extends StatefulWidget {
  final CreditCardModel card;
  final bool isDarkMode;
  final ValueChanged<CreditCardModel> onCardCompleted;

  const _CompleteCardDialog({
    required this.card,
    required this.isDarkMode,
    required this.onCardCompleted,
  });

  @override
  State<_CompleteCardDialog> createState() => _CompleteCardDialogState();
}

class _CompleteCardDialogState extends State<_CompleteCardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lastFourController;
  late final TextEditingController _holderController;
  late final TextEditingController _limitController;

  late IndianBank _selectedBank;
  late String _selectedVariantName;
  late CardSupplier _selectedBrand;

  @override
  void initState() {
    super.initState();
    final detectedDigits = widget.card.maskedNumber.replaceAll(
      RegExp(r'\D'),
      '',
    );
    _lastFourController = TextEditingController(
      text: detectedDigits.length >= 4
          ? detectedDigits.substring(detectedDigits.length - 4)
          : '',
    );
    _holderController = TextEditingController(text: widget.card.holderName);
    _limitController = TextEditingController(
      text: widget.card.limit > 0 ? widget.card.limit.toStringAsFixed(0) : '',
    );

    _selectedBank = widget.card.bankName;
    _selectedBrand = widget.card.brand;

    final variants = bankCardVariants[_selectedBank] ?? const [];
    final tierLower = widget.card.cardTier.toLowerCase();
    String? matchingVariant;
    for (final variant in variants) {
      if (tierLower.contains(variant.name.toLowerCase())) {
        matchingVariant = variant.name;
        break;
      }
    }
    _selectedVariantName =
        matchingVariant ??
        (variants.isNotEmpty ? variants.first.name : 'Credit Card');

    _lastFourController.addListener(_onFieldUpdated);
    _holderController.addListener(_onFieldUpdated);
  }

  void _onFieldUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _lastFourController.dispose();
    _holderController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  List<CardVariantPreset> get _bankVariants =>
      bankCardVariants[_selectedBank] ?? const [];

  CardVariantPreset get _selectedVariant => _bankVariants.firstWhere(
    (v) => v.name == _selectedVariantName,
    orElse: () => _bankVariants.isNotEmpty
        ? _bankVariants.first
        : CardVariantPreset(
            name: 'Credit Card',
            defaultBrand: _selectedBrand,
            color: const CardColorMatch(
              label: 'Classic',
              color: Color(0xFF1E2026),
              isLight: false,
            ),
          ),
  );

  String get _enteredLast4 {
    final digits = _lastFourController.text.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 4 ? digits.substring(digits.length - 4) : '';
  }

  CreditCardModel get _previewCard {
    final last4 = _enteredLast4;
    final masked = last4.isEmpty ? '•••• ••••' : '•••• $last4';

    return widget.card.copyWith(
      bankName: _selectedBank,
      cardTier: '${_selectedBank.shortName} ${_selectedVariant.name}',
      maskedNumber: masked,
      holderName: _holderController.text.trim().isNotEmpty
          ? _holderController.text.trim().toUpperCase()
          : widget.card.holderName,
      brand: _selectedBrand,
      limit: double.tryParse(_limitController.text.trim()) ?? widget.card.limit,
      isNeedsCompletion: false,
    );
  }

  void _handleBankChange(IndianBank bank) {
    final variants = bankCardVariants[bank] ?? const <CardVariantPreset>[];
    setState(() {
      _selectedBank = bank;
      _selectedVariantName = variants.isNotEmpty
          ? variants.first.name
          : 'Credit Card';
      _selectedBrand = variants.isNotEmpty
          ? variants.first.defaultBrand
          : CardSupplier.visa;
    });
  }

  void _handleVariantChange(String name) {
    final variant = _bankVariants.firstWhere(
      (v) => v.name == name,
      orElse: () => _selectedVariant,
    );
    setState(() {
      _selectedVariantName = variant.name;
      _selectedBrand = variant.defaultBrand;
    });
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updated = _previewCard;
      widget.onCardCompleted(updated);
      Navigator.of(context).pop(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final scale = OnyxScale.of(context);
    final detectedDigits = widget.card.maskedNumber.replaceAll(
      RegExp(r'\D'),
      '',
    );
    final detectedLast4 = detectedDigits.length >= 4
        ? detectedDigits.substring(detectedDigits.length - 4)
        : '••••';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: scale.s(16),
        vertical: scale.s(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: scale.s(420)),
        child: Container(
          decoration: BoxDecoration(
            color: palette.modalSurface,
            borderRadius: BorderRadius.circular(scale.s(24)),
          ),
          padding: EdgeInsets.all(scale.s(20)),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Status Tag & Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: scale.s(10),
                          vertical: scale.s(4),
                        ),
                        decoration: BoxDecoration(
                          color: palette.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: scale.s(11),
                              color: palette.gold,
                            ),
                            SizedBox(width: scale.s(5)),
                            Text(
                              'AUTO-DETECTED FROM SMS',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(9),
                                fontWeight: FontWeight.w600,
                                color: palette.gold,
                                letterSpacing: 0.9,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: scale.s(32),
                          height: scale.s(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: palette.hoverFill,
                          ),
                          child: Icon(
                            Icons.close,
                            size: scale.s(16),
                            color: palette.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scale.s(12)),

                  // Title & Description
                  Text(
                    'Complete Card Setup',
                    style: OnyxTypography.editorial(
                      fontSize: scale.s(24),
                      fontWeight: FontWeight.w600,
                      color: palette.primaryText,
                    ),
                  ),
                  SizedBox(height: scale.s(4)),
                  Text(
                    'We detected a card ending in $detectedLast4. Choose the bank that issued it, then confirm the card model, network and last four digits.',
                    style: OnyxTypography.sans(
                      fontSize: scale.s(11.5),
                      color: palette.mutedText,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: scale.s(16)),

                  // Live Interactive Physical Card Preview
                  PhysicalCreditCard(card: _previewCard, aspectRatio: 1.586),
                  SizedBox(height: scale.s(20)),

                  // Section 1: Which bank issued this card?
                  Text(
                    'WHICH BANK ISSUED THIS CARD?',
                    style: OnyxTypography.mono(
                      fontSize: scale.s(10),
                      fontWeight: FontWeight.w600,
                      color: palette.mutedText,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: scale.s(8)),
                  DropdownButtonFormField<IndianBank>(
                    initialValue: _selectedBank,
                    isExpanded: true,
                    menuMaxHeight: 340,
                    dropdownColor: palette.cardSurface,
                    style: OnyxTypography.sans(
                      fontSize: scale.s(12.5),
                      color: palette.primaryText,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: palette.hoverFill,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: scale.s(14),
                        vertical: scale.s(12),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(scale.s(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: IndianBank.values
                        .map(
                          (bank) => DropdownMenuItem(
                            value: bank,
                            child: Text(
                              bank.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (bank) {
                      if (bank != null) _handleBankChange(bank);
                    },
                  ),
                  SizedBox(height: scale.s(18)),

                  // Section 2: Which card model is this?
                  Text(
                    'WHICH CARD MODEL IS THIS?',
                    style: OnyxTypography.mono(
                      fontSize: scale.s(10),
                      fontWeight: FontWeight.w600,
                      color: palette.mutedText,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: scale.s(8)),

                  // Card Model Selection Chips
                  Wrap(
                    spacing: scale.s(8),
                    runSpacing: scale.s(8),
                    children: _bankVariants.map((variant) {
                      final isSelected = variant.name == _selectedVariantName;
                      return GestureDetector(
                        onTap: () => _handleVariantChange(variant.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                            horizontal: scale.s(14),
                            vertical: scale.s(9),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (widget.isDarkMode
                                      ? palette.gold
                                      : const Color(0xFF111113))
                                : palette.hoverFill,
                            borderRadius: BorderRadius.circular(scale.s(10)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: scale.s(13),
                                  color: widget.isDarkMode
                                      ? const Color(0xFF111113)
                                      : const Color(0xFFF8F7F4),
                                ),
                                SizedBox(width: scale.s(6)),
                              ],
                              Text(
                                variant.name,
                                style: OnyxTypography.sans(
                                  fontSize: scale.s(12),
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? (widget.isDarkMode
                                            ? const Color(0xFF111113)
                                            : const Color(0xFFF8F7F4))
                                      : palette.primaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: scale.s(18)),

                  // Section 3: Network + Last four digits
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD NETWORK',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(9.5),
                                color: palette.mutedText,
                                letterSpacing: 1.1,
                              ),
                            ),
                            SizedBox(height: scale.s(6)),
                            DropdownButtonFormField<CardSupplier>(
                              key: ValueKey(
                                'network-${_selectedBrand.name}-$_selectedVariantName',
                              ),
                              initialValue: _selectedBrand,
                              isExpanded: true,
                              dropdownColor: palette.cardSurface,
                              style: OnyxTypography.sans(
                                fontSize: scale.s(12.5),
                                fontWeight: FontWeight.w600,
                                color: palette.primaryText,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: palette.hoverFill,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: scale.s(12),
                                  vertical: scale.s(10),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    scale.s(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: CardSupplier.values
                                  .map(
                                    (brand) => DropdownMenuItem(
                                      value: brand,
                                      child: Text(
                                        brand.label,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (brand) {
                                if (brand != null) {
                                  setState(() => _selectedBrand = brand);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: scale.s(10)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD LAST 4 DIGITS',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(9.5),
                                color: palette.mutedText,
                                letterSpacing: 1.1,
                              ),
                            ),
                            SizedBox(height: scale.s(6)),
                            TextFormField(
                              controller: _lastFourController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              style: OnyxTypography.mono(
                                fontSize: scale.s(14),
                                fontWeight: FontWeight.w600,
                                color: palette.primaryText,
                                letterSpacing: 1.5,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: palette.hoverFill,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: scale.s(14),
                                  vertical: scale.s(12),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    scale.s(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: Icon(
                                  Icons.credit_card_rounded,
                                  size: scale.s(18),
                                  color: palette.mutedText,
                                ),
                                hintText: '8824',
                                hintStyle: OnyxTypography.mono(
                                  fontSize: scale.s(13),
                                  color: palette.mutedText.withValues(
                                    alpha: 0.5,
                                  ),
                                  letterSpacing: 1.2,
                                ),
                              ),
                              validator: (v) {
                                final digits = (v ?? '').replaceAll(
                                  RegExp(r'\D'),
                                  '',
                                );
                                if (digits.length != 4) {
                                  return 'Enter the last 4 digits';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scale.s(16)),

                  // Section 4: Cardholder Name & Limit Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARDHOLDER NAME',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(9.5),
                                color: palette.mutedText,
                                letterSpacing: 1.1,
                              ),
                            ),
                            SizedBox(height: scale.s(6)),
                            TextFormField(
                              controller: _holderController,
                              textCapitalization: TextCapitalization.characters,
                              style: OnyxTypography.sans(
                                fontSize: scale.s(12.5),
                                fontWeight: FontWeight.w600,
                                color: palette.primaryText,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: palette.hoverFill,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: scale.s(12),
                                  vertical: scale.s(10),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    scale.s(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'CARDHOLDER',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: scale.s(10)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CREDIT LIMIT',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(9.5),
                                color: palette.mutedText,
                                letterSpacing: 1.1,
                              ),
                            ),
                            SizedBox(height: scale.s(6)),
                            TextFormField(
                              controller: _limitController,
                              keyboardType: TextInputType.number,
                              style: OnyxTypography.mono(
                                fontSize: scale.s(12.5),
                                fontWeight: FontWeight.w600,
                                color: palette.primaryText,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: palette.hoverFill,
                                prefixText: '₹ ',
                                prefixStyle: OnyxTypography.mono(
                                  fontSize: scale.s(12.5),
                                  color: palette.mutedText,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: scale.s(12),
                                  vertical: scale.s(10),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    scale.s(10),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: '300000',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scale.s(22)),

                  // Save & Complete Button
                  ElevatedButton(
                    onPressed: _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isDarkMode
                          ? palette.gold
                          : const Color(0xFF111113),
                      foregroundColor: widget.isDarkMode
                          ? const Color(0xFF111113)
                          : const Color(0xFFF8F7F4),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: scale.s(14)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(scale.s(12)),
                      ),
                    ),
                    child: Text(
                      'Save & Complete Card Setup',
                      style: OnyxTypography.sans(
                        fontSize: scale.s(13.5),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

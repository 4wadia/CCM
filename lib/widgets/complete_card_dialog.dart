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
  late final TextEditingController _cardNumberController;
  late final TextEditingController _holderController;
  late final TextEditingController _limitController;

  late String _selectedVariantName;
  late CardSupplier _selectedBrand;

  @override
  void initState() {
    super.initState();
    final last4 = widget.card.maskedNumber.length >= 4
        ? widget.card.maskedNumber.substring(
            widget.card.maskedNumber.length - 4,
          )
        : '5168';

    _cardNumberController = TextEditingController(
      text: widget.card.cardNumber.contains('•')
          ? '4532 8920 4421 $last4'
          : widget.card.cardNumber,
    );
    _holderController = TextEditingController(text: widget.card.holderName);
    _limitController = TextEditingController(
      text: widget.card.limit > 0
          ? widget.card.limit.toStringAsFixed(0)
          : '300000',
    );

    final variants = bankCardVariants[widget.card.bankName] ?? [];
    _selectedVariantName = variants.isNotEmpty
        ? variants.first.name
        : widget.card.cardTier;
    _selectedBrand = widget.card.brand;

    _cardNumberController.addListener(_onFieldUpdated);
    _holderController.addListener(_onFieldUpdated);
  }

  void _onFieldUpdated() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _holderController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  List<CardVariantPreset> get _bankVariants =>
      bankCardVariants[widget.card.bankName] ?? const [];

  CardVariantPreset get _selectedVariant => _bankVariants.firstWhere(
    (v) => v.name == _selectedVariantName,
    orElse: () => _bankVariants.isNotEmpty
        ? _bankVariants.first
        : CardVariantPreset(
            name: widget.card.cardTier,
            defaultBrand: widget.card.brand,
            color: const CardColorMatch(
              label: 'Classic',
              color: Color(0xFF1E2026),
              isLight: false,
            ),
          ),
  );

  CardSupplier get _resolvedBrand =>
      detectCardBrandFromNumber(_cardNumberController.text) ?? _selectedBrand;

  CreditCardModel get _previewCard {
    final rawNumber = _cardNumberController.text.trim();
    final digits = rawNumber.replaceAll(RegExp(r'\D'), '');
    final last4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : (widget.card.maskedNumber.length >= 4
              ? widget.card.maskedNumber.substring(
                  widget.card.maskedNumber.length - 4,
                )
              : '5168');
    final masked = '•••• $last4';

    return widget.card.copyWith(
      cardTier: _selectedVariant.name,
      cardNumber: rawNumber.isNotEmpty ? rawNumber : widget.card.cardNumber,
      maskedNumber: masked,
      holderName: _holderController.text.trim().isNotEmpty
          ? _holderController.text.trim().toUpperCase()
          : widget.card.holderName,
      brand: _resolvedBrand,
      limit: double.tryParse(_limitController.text.trim()) ?? widget.card.limit,
      isNeedsCompletion: false,
    );
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
    final last4 = widget.card.maskedNumber.length >= 4
        ? widget.card.maskedNumber.substring(
            widget.card.maskedNumber.length - 4,
          )
        : '5168';

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
                  // Top Status Tag & Bank Info
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
                    'We detected your ${widget.card.bankName.displayName} card ending in $last4. Select your card model and verify card number to activate full features.',
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

                  // Section 1: Which card model is this?
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
                        onTap: () {
                          setState(() {
                            _selectedVariantName = variant.name;
                            _selectedBrand = variant.defaultBrand;
                          });
                        },
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
                                  color: isSelected
                                      ? (widget.isDarkMode
                                            ? const Color(0xFF111113)
                                            : const Color(0xFFF8F7F4))
                                      : palette.primaryText,
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

                  // Section 2: Card Number
                  Text(
                    'CARD NUMBER',
                    style: OnyxTypography.mono(
                      fontSize: scale.s(10),
                      fontWeight: FontWeight.w600,
                      color: palette.mutedText,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: scale.s(6)),
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      _CardNumberFormatter(),
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
                        borderRadius: BorderRadius.circular(scale.s(10)),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.credit_card_rounded,
                        size: scale.s(18),
                        color: palette.mutedText,
                      ),
                      hintText: '4532 8920 4421 $last4',
                      hintStyle: OnyxTypography.mono(
                        fontSize: scale.s(13),
                        color: palette.mutedText.withValues(alpha: 0.5),
                        letterSpacing: 1.2,
                      ),
                    ),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
                      if (digits.length < 4) {
                        return 'Card number must have at least 4 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: scale.s(16)),

                  // Section 3: Cardholder Name & Limit Row
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
                                hintText: 'ARJUN SHARMA',
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

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

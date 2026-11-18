import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../utils/card_helpers.dart';
import 'physical_credit_card.dart';

Future<void> showIssueCardDialog({
  required BuildContext context,
  required bool isDarkMode,
  required ValueChanged<CreditCardModel> onAddCard,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (ctx) =>
        _IssueCardDialog(isDarkMode: isDarkMode, onAddCard: onAddCard),
  );
}

class _IssueCardDialog extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<CreditCardModel> onAddCard;

  const _IssueCardDialog({required this.isDarkMode, required this.onAddCard});

  @override
  State<_IssueCardDialog> createState() => _IssueCardDialogState();
}

class _IssueCardDialogState extends State<_IssueCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _holderController = TextEditingController(text: '');
  final _limitController = TextEditingController(text: '300000');

  IndianBank _selectedBank = IndianBank.hdfc;
  late String _selectedVariantName;
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedVariantName = bankCardVariants[_selectedBank]!.first.name;
    _cardNumberController.addListener(_onFieldUpdated);
    _holderController.addListener(_onFieldUpdated);
  }

  Future<void> _pickCardPhoto() async {
    try {
      final result = await FilePicker.pickFiles(type: FileType.image);
      if (result.isNotEmpty && result.first.path != null) {
        setState(() {
          _pickedImagePath = result.first.path;
        });
      }
    } catch (_) {}
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
      bankCardVariants[_selectedBank] ?? const [];

  CardVariantPreset get _selectedVariant => _bankVariants.firstWhere(
    (v) => v.name == _selectedVariantName,
    orElse: () => _bankVariants.first,
  );

  CardSupplier? get _detectedBrand =>
      detectCardBrandFromNumber(_cardNumberController.text);

  CardSupplier get _resolvedBrand =>
      _detectedBrand ?? _selectedVariant.defaultBrand;

  CardColorMatch get _originalColor => fetchOriginalCardColor(
    _selectedBank,
    _selectedVariant.name,
    _resolvedBrand,
  );

  void _handleBankChange(IndianBank bank) {
    setState(() {
      _selectedBank = bank;
      _selectedVariantName = bankCardVariants[bank]!.first.name;
    });
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final random = Random();
    final digits = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final last4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : (1000 + random.nextInt(9000)).toString();

    final prefix = switch (_resolvedBrand) {
      CardSupplier.visa => '4532',
      CardSupplier.mastercard => '5421',
      CardSupplier.rupay => '6521',
      CardSupplier.diners => '3612',
      CardSupplier.amex => '3742',
    };

    final cleanNumber = digits.length >= 12
        ? formatCardNumberInput(digits, _resolvedBrand)
        : '$prefix ${1000 + random.nextInt(9000)} ${1000 + random.nextInt(9000)} $last4';

    final numericLimit = max(
      10000.0,
      double.tryParse(_limitController.text.trim()) ?? 300000.0,
    );
    final holder = _holderController.text.trim().isEmpty
        ? 'Arjun Sharma'
        : _holderController.text.trim();
    final original = _originalColor;

    final newCard = CreditCardModel(
      id: 'card-${DateTime.now().millisecondsSinceEpoch}',
      bankName: _selectedBank,
      holderName: holder,
      cardNumber: cleanNumber,
      maskedNumber: '•••• $last4',
      expiry: '09/30',
      cvv: (100 + random.nextInt(900)).toString(),
      balance: 0,
      limit: numericLimit,
      brand: _resolvedBrand,
      cardTier: '${_selectedBank.shortName} ${_selectedVariant.name}',
      cardColorValue: original.color.toARGB32(),
      isLightCard: original.isLight,
      dailyLimit: (numericLimit * 0.25).roundToDouble(),
      internationalEnabled: _resolvedBrand != CardSupplier.rupay,
      cardImagePath: _pickedImagePath,
      cardImageUrl: _pickedImagePath == null
          ? fetchOriginalCardImageUrl(_selectedBank, _selectedVariant.name)
          : null,
    );

    widget.onAddCard(newCard);
    Navigator.of(context).pop();
  }

  InputDecoration _inputDecoration(
    OnyxPalette palette, {
    String? hint,
    Widget? suffixIcon,
  }) {
    final borderSide = BorderSide(
      color: palette.border.withValues(alpha: 0.15),
      width: 0.8,
    );
    final focusedBorder = BorderSide(color: palette.gold, width: 1.2);

    return InputDecoration(
      hintText: hint,
      hintStyle: OnyxTypography.sans(
        fontSize: 12.5,
        color: palette.primaryText.withValues(alpha: 0.38),
      ),
      filled: true,
      fillColor: widget.isDarkMode ? const Color(0xFF0C0C0E) : Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: borderSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: focusedBorder,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final digits = _cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    final previewLast4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : '8824';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          decoration: BoxDecoration(
            color: palette.modalSurface,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(22),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.only(bottom: 14),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: palette.divider),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NEW PORTFOLIO INSTRUMENT',
                              style: OnyxTypography.mono(
                                fontSize: 9,
                                color: palette.gold,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Issue Card',
                              style: OnyxTypography.editorial(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: palette.primaryText,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: palette.border),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: palette.primaryText.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Live Original Design Preview with Real Artwork / Upload
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _pickedImagePath != null
                            ? 'CUSTOM CARD PHOTO'
                            : 'ORIGINAL CARD ART',
                        style: OnyxTypography.mono(
                          fontSize: 9,
                          color: palette.mutedText,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_pickedImagePath != null) ...[
                            GestureDetector(
                              onTap: () =>
                                  setState(() => _pickedImagePath = null),
                              child: Text(
                                'RESET',
                                style: OnyxTypography.mono(
                                  fontSize: 9,
                                  color: palette.mutedText,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                          GestureDetector(
                            onTap: _pickCardPhoto,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 13,
                                  color: palette.gold,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _pickedImagePath != null
                                      ? 'CHANGE'
                                      : '+ PHOTO',
                                  style: OnyxTypography.mono(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: palette.gold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PhysicalCreditCard(
                    card: CreditCardModel(
                      id: 'preview',
                      bankName: _selectedBank,
                      holderName: _holderController.text,
                      cardNumber: _cardNumberController.text,
                      maskedNumber: previewLast4,
                      expiry: '09/30',
                      cvv: '•••',
                      balance: 0,
                      limit: 500000,
                      brand: _resolvedBrand,
                      cardTier: _selectedVariant.name,
                      dailyLimit: 100000,
                      cardImagePath: _pickedImagePath,
                    ),
                    aspectRatio: 1.586,
                  ),
                  const SizedBox(height: 16),

                  // Card Number Input with BIN detection badge
                  Text(
                    'CARD NUMBER',
                    style: OnyxTypography.mono(
                      fontSize: 10,
                      color: palette.mutedText,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _cardNumberController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_CardNumberTextFormatter()],
                    style: OnyxTypography.mono(
                      fontSize: 12,
                      color: palette.primaryText,
                      letterSpacing: 1.1,
                      tabularFigures: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter card number';
                      }
                      return null;
                    },
                    decoration: _inputDecoration(
                      palette,
                      hint: '4532 •••• •••• ••••',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: _detectedBrand != null
                                    ? (widget.isDarkMode
                                          ? const Color(0xFFD4AF37)
                                          : const Color(0xFF111113))
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                _resolvedBrand.label,
                                style: OnyxTypography.mono(
                                  fontSize: 10,
                                  fontWeight: _detectedBrand != null
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: _detectedBrand != null
                                      ? (widget.isDarkMode
                                            ? const Color(0xFF111113)
                                            : const Color(0xFFF8F7F4))
                                      : palette.mutedText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Issuing Bank & Card Variant (Selection Lists Only)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ISSUING BANK',
                              style: OnyxTypography.mono(
                                fontSize: 10,
                                color: palette.mutedText,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<IndianBank>(
                              initialValue: _selectedBank,
                              isExpanded: true,
                              dropdownColor: palette.cardSurface,
                              style: OnyxTypography.sans(
                                fontSize: 12,
                                color: palette.primaryText,
                              ),
                              decoration: _inputDecoration(palette),
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARD VARIANT',
                              style: OnyxTypography.mono(
                                fontSize: 10,
                                color: palette.mutedText,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              key: ValueKey('variant-${_selectedBank.name}'),
                              initialValue: _selectedVariant.name,
                              isExpanded: true,
                              dropdownColor: palette.cardSurface,
                              style: OnyxTypography.sans(
                                fontSize: 12,
                                color: palette.primaryText,
                              ),
                              decoration: _inputDecoration(palette),
                              items: _bankVariants
                                  .map(
                                    (variant) => DropdownMenuItem(
                                      value: variant.name,
                                      child: Text(
                                        variant.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (name) {
                                if (name != null) {
                                  setState(() => _selectedVariantName = name);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Cardholder & Limit
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CARDHOLDER',
                              style: OnyxTypography.mono(
                                fontSize: 10,
                                color: palette.mutedText,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _holderController,
                              style: OnyxTypography.sans(
                                fontSize: 12.5,
                                color: palette.primaryText,
                              ),
                              decoration: _inputDecoration(
                                palette,
                                hint: 'Cardholder (Optional)',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LIMIT (₹)',
                              style: OnyxTypography.mono(
                                fontSize: 10,
                                color: palette.mutedText,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _limitController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: OnyxTypography.mono(
                                fontSize: 12.5,
                                color: palette.primaryText,
                                tabularFigures: true,
                              ),
                              validator: (val) {
                                final parsed = int.tryParse(val ?? '') ?? 0;
                                if (parsed < 10000) return 'Min ₹10,000';
                                return null;
                              },
                              decoration: _inputDecoration(
                                palette,
                                hint: '300000',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Submit Button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isDarkMode
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF111113),
                        foregroundColor: widget.isDarkMode
                            ? const Color(0xFF111113)
                            : const Color(0xFFF8F7F4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Issue Instrument',
                        style: OnyxTypography.sans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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

class _CardNumberTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final brand = detectCardBrandFromNumber(newValue.text);
    final formatted = formatCardNumberInput(newValue.text, brand);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

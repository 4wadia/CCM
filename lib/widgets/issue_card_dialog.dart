import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../utils/card_helpers.dart';
import 'physical_credit_card.dart';

Future<CreditCardModel?> showIssueCardDialog({
  required BuildContext context,
  required bool isDarkMode,
  String? holderName,
}) {
  return showDialog<CreditCardModel>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (ctx) =>
        _IssueCardDialog(isDarkMode: isDarkMode, holderName: holderName),
  );
}

class _IssueCardDialog extends StatefulWidget {
  final bool isDarkMode;
  final String? holderName;

  const _IssueCardDialog({required this.isDarkMode, required this.holderName});

  @override
  State<_IssueCardDialog> createState() => _IssueCardDialogState();
}

class _IssueCardDialogState extends State<_IssueCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _lastFourController = TextEditingController();
  final _holderController = TextEditingController(text: '');
  final _limitController = TextEditingController(text: '');

  IndianBank _selectedBank = IndianBank.hdfc;
  late String _selectedVariantName;
  late CardSupplier _selectedBrand;
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedVariantName = bankCardVariants[_selectedBank]!.first.name;
    _selectedBrand = bankCardVariants[_selectedBank]!.first.defaultBrand;
    _holderController.text = widget.holderName?.trim() ?? '';
    _lastFourController.addListener(_onFieldUpdated);
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
    _lastFourController.dispose();
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

  CardColorMatch get _originalColor => fetchOriginalCardColor(
    _selectedBank,
    _selectedVariant.name,
    _selectedBrand,
  );

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

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final digits = _lastFourController.text.replaceAll(RegExp(r'\D'), '');
    final last4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : '0000';
    final numericLimit = double.tryParse(_limitController.text.trim()) ?? 0;
    final holder = _holderController.text.trim().isEmpty
        ? 'CARDHOLDER'
        : _holderController.text.trim().toUpperCase();
    final original = _originalColor;
    final variantLabel = _selectedVariant.name.trim().isEmpty
        ? 'Credit Card'
        : _selectedVariant.name.trim();

    final newCard = CreditCardModel(
      id: 'card-${DateTime.now().millisecondsSinceEpoch}',
      bankName: _selectedBank,
      holderName: holder,
      maskedNumber: '•••• $last4',
      expiry: '',
      balance: 0,
      limit: numericLimit,
      brand: _selectedBrand,
      cardTier: '${_selectedBank.shortName} $variantLabel',
      cardColorValue: original.color.toARGB32(),
      isLightCard: original.isLight,
      dailyLimit: (numericLimit * 0.25).roundToDouble(),
      internationalEnabled: _selectedBrand != CardSupplier.rupay,
      cardImagePath: _pickedImagePath,
      cardImageUrl: _pickedImagePath == null
          ? fetchOriginalCardImageUrl(_selectedBank, _selectedVariant.name)
          : null,
    );

    // Close the form first. The caller adds the card to the portfolio after
    // this route is gone, so the add-card sheet can never remain on screen
    // while a sync dialog opens on top of it.
    Navigator.of(context).pop(newCard);
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
    final digits = _lastFourController.text.replaceAll(RegExp(r'\D'), '');
    final previewLast4 = digits.length >= 4
        ? digits.substring(digits.length - 4)
        : '••••';

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
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(
                            begin: 0.98,
                            end: 1,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: PhysicalCreditCard(
                      key: ValueKey(
                        'preview-${_selectedBank.name}-'
                        '$_selectedVariantName-${_selectedBrand.name}-'
                        '${_pickedImagePath ?? 'official'}',
                      ),
                      card: CreditCardModel(
                        id: 'preview',
                        bankName: _selectedBank,
                        holderName: _holderController.text.trim().isEmpty
                            ? 'CARDHOLDER'
                            : _holderController.text.trim().toUpperCase(),
                        maskedNumber: '•••• $previewLast4',
                        expiry: '',
                        balance: 0,
                        limit: 500000,
                        brand: _selectedBrand,
                        cardTier: _selectedVariant.name,
                        cardColorValue: _originalColor.color.toARGB32(),
                        isLightCard: _originalColor.isLight,
                        dailyLimit: 100000,
                        cardImagePath: _pickedImagePath,
                        cardImageUrl: _pickedImagePath == null
                            ? fetchOriginalCardImageUrl(
                                _selectedBank,
                                _selectedVariant.name,
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(
                        _pickedImagePath != null
                            ? Icons.photo_outlined
                            : fetchOriginalCardImageUrl(
                                    _selectedBank,
                                    _selectedVariant.name,
                                  ) !=
                                  null
                            ? Icons.cloud_done_outlined
                            : Icons.auto_awesome_outlined,
                        size: 12,
                        color: palette.gold,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          _pickedImagePath != null
                              ? 'Custom card photo selected.'
                              : fetchOriginalCardImageUrl(
                                      _selectedBank,
                                      _selectedVariant.name,
                                    ) !=
                                    null
                              ? 'Official card artwork loads automatically for this variant.'
                              : 'No official artwork for this variant yet — using the generated card design.',
                          style: OnyxTypography.mono(
                            fontSize: 8.5,
                            color: palette.mutedText,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Only the last four digits are collected. Full card numbers
                  // and security codes are never requested or stored.
                  Text(
                    'CARD LAST 4 DIGITS',
                    style: OnyxTypography.mono(
                      fontSize: 10,
                      color: palette.mutedText,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _lastFourController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    style: OnyxTypography.mono(
                      fontSize: 12,
                      color: palette.primaryText,
                      letterSpacing: 1.1,
                      tabularFigures: true,
                    ),
                    validator: (val) {
                      final digits = (val ?? '').replaceAll(RegExp(r'\D'), '');
                      if (digits.length != 4) {
                        return 'Enter the last 4 digits';
                      }
                      return null;
                    },
                    decoration: _inputDecoration(palette, hint: '8824'),
                  ),
                  const SizedBox(height: 14),

                  // Issuing Bank
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
                    menuMaxHeight: 340,
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
                  const SizedBox(height: 14),

                  // Card Variant & Network
                  Row(
                    children: [
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
                              menuMaxHeight: 340,
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
                                if (name != null) _handleVariantChange(name);
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
                              'NETWORK',
                              style: OnyxTypography.mono(
                                fontSize: 10,
                                color: palette.mutedText,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<CardSupplier>(
                              key: ValueKey(
                                'network-${_selectedBrand.name}-$_selectedVariantName',
                              ),
                              initialValue: _selectedBrand,
                              isExpanded: true,
                              dropdownColor: palette.cardSurface,
                              style: OnyxTypography.sans(
                                fontSize: 12,
                                color: palette.primaryText,
                              ),
                              decoration: _inputDecoration(palette),
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

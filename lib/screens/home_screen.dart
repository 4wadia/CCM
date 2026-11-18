import 'dart:async';

import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../theme/onyx_theme.dart';
import '../utils/format_currency.dart';
import '../widgets/app_logo.dart';

class HomeScreen extends StatefulWidget {
  final List<CreditCardModel> cards;
  final List<TransactionModel> transactions;
  final ValueChanged<TransactionModel> onSelectTransaction;
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  final UserProfileModel? profile;
  final VoidCallback? onOpenProfile;

  const HomeScreen({
    super.key,
    required this.cards,
    required this.transactions,
    required this.onSelectTransaction,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    this.profile,
    this.onOpenProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _balanceVisible = true;
  bool _showSearch = false;
  bool _notificationOpen = false;
  bool _showAllTransactions = false;
  bool _themeExpanded = false;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _themeTimer;
  Timer? _focusTimer;
  late final AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _themeTimer?.cancel();
    _focusTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() {
      _showSearch = true;
      _notificationOpen = false;
    });
    _focusTimer?.cancel();
    _focusTimer = Timer(const Duration(milliseconds: 220), () {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _closeSearch() {
    _searchFocusNode.unfocus();
    setState(() {
      _showSearch = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _handleToggleTheme() {
    widget.onToggleDarkMode();
    _rippleController.forward(from: 0.0);
    setState(() => _themeExpanded = true);
    _themeTimer?.cancel();
    _themeTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) setState(() => _themeExpanded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final scale = OnyxScale.of(context);
    final headerHeight = scale.s(46);
    final controlSize = scale.s(46);
    final controlIconSize = scale.s(22);
    final themeExpandedWidth = scale.s(108);

    final totalCombinedLimit = widget.cards.fold<double>(
      0,
      (sum, c) => sum + c.limit,
    );
    final totalCombinedSpend = widget.cards.fold<double>(
      0,
      (sum, c) => sum + c.balance,
    );
    final utilizationPercent = totalCombinedLimit > 0
        ? ((totalCombinedSpend / totalCombinedLimit) * 100).round().clamp(
            0,
            100,
          )
        : 0;

    final queryLower = _searchQuery.toLowerCase();
    final filteredTransactions = widget.transactions.where((tx) {
      if (queryLower.isEmpty) return true;
      return tx.title.toLowerCase().contains(queryLower) ||
          tx.category.toLowerCase().contains(queryLower) ||
          tx.merchant.toLowerCase().contains(queryLower) ||
          (tx.cardBank?.displayName.toLowerCase().contains(queryLower) ??
              false);
    }).toList();

    return GestureDetector(
      onTap: () {
        if (_notificationOpen) setState(() => _notificationOpen = false);
      },
      behavior: HitTestBehavior.translucent,
      child: LayoutBuilder(
        builder: (context, viewportConstraints) {
          final isTallViewport = viewportConstraints.maxHeight >= 760;
          final initialCount = isTallViewport ? 10 : 8;
          final initialTransactions = filteredTransactions
              .take(initialCount)
              .toList();
          final extraTransactions = filteredTransactions
              .skip(initialCount)
              .toList();

          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  scale.s(20),
                  scale.s(16),
                  scale.s(20),
                  scale.s(110),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top User Row with Inline Self-Expanding Search & Dark/Light Toggle
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: headerHeight,
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              // Left Avatar + Name (fades smoothly as Search expands)
                              Positioned(
                                left: 0,
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 280),
                                  curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                                  opacity: _showSearch ? 0.0 : 1.0,
                                  child: AnimatedSlide(
                                    duration: const Duration(milliseconds: 280),
                                    curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                                    offset: _showSearch
                                        ? const Offset(-0.08, 0)
                                        : Offset.zero,
                                    child: IgnorePointer(
                                      ignoring: _showSearch,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: widget.onOpenProfile,
                                        child: Container(
                                          width: scale.s(44),
                                          height: scale.s(44),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: palette.hoverFill,
                                          ),
                                          alignment: Alignment.center,
                                          child: ClipOval(
                                            child:
                                                widget.profile?.photoUrl !=
                                                        null &&
                                                    widget
                                                        .profile!
                                                        .photoUrl!
                                                        .isNotEmpty
                                                ? Image.network(
                                                    widget.profile!.photoUrl!,
                                                    width: scale.s(44),
                                                    height: scale.s(44),
                                                    cacheWidth: scale
                                                        .s(120)
                                                        .round(),
                                                    cacheHeight: scale
                                                        .s(120)
                                                        .round(),
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Center(
                                                          child: AppLogo(
                                                            size: scale.s(32),
                                                            withSquircle: false,
                                                          ),
                                                        ),
                                                  )
                                                : Center(
                                                    child: AppLogo(
                                                      size: scale.s(32),
                                                      withSquircle: false,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Right Controls: Search Pill + Theme Toggle + Bell
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Self-Expanding Search Pill
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                                      width: _showSearch
                                          ? constraints.maxWidth
                                          : controlSize,
                                      height: controlSize,
                                      clipBehavior: Clip.antiAlias,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: _showSearch
                                            ? scale.s(14)
                                            : 0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _showSearch
                                            ? palette.cardSurface
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: _showSearch
                                            ? () => _searchFocusNode
                                                  .requestFocus()
                                            : _openSearch,
                                        child: Row(
                                          mainAxisAlignment: _showSearch
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: controlIconSize,
                                              color: _showSearch
                                                  ? palette.gold
                                                  : palette.primaryText
                                                        .withValues(
                                                          alpha: 0.75,
                                                        ),
                                            ),
                                            if (_showSearch)
                                              Expanded(
                                                child: ClipRect(
                                                  child: OverflowBox(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    minWidth: 0,
                                                    maxWidth:
                                                        (constraints.maxWidth -
                                                                scale.s(56))
                                                            .clamp(
                                                              0.0,
                                                              double.infinity,
                                                            ),
                                                    child: SizedBox(
                                                      width:
                                                          (constraints.maxWidth -
                                                                  scale.s(56))
                                                              .clamp(
                                                                0.0,
                                                                double.infinity,
                                                              ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: scale.s(8),
                                                          ),
                                                          Expanded(
                                                            child: TextField(
                                                              controller:
                                                                  _searchController,
                                                              focusNode:
                                                                  _searchFocusNode,
                                                              onChanged: (v) =>
                                                                  setState(
                                                                    () =>
                                                                        _searchQuery =
                                                                            v,
                                                                  ),
                                                              style: OnyxTypography.sans(
                                                                fontSize: scale
                                                                    .s(13),
                                                                color: palette
                                                                    .primaryText,
                                                              ),
                                                              decoration: InputDecoration(
                                                                isCollapsed:
                                                                    true,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText: 'Search merchant, bank...',
                                                                hintStyle: OnyxTypography.sans(
                                                                  fontSize:
                                                                      scale.s(
                                                                        13,
                                                                      ),
                                                                  color: palette
                                                                      .primaryText
                                                                      .withValues(
                                                                        alpha:
                                                                            0.4,
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: _closeSearch,
                                                            child: Container(
                                                              width: scale.s(
                                                                28,
                                                              ),
                                                              height: scale.s(
                                                                28,
                                                              ),
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: palette
                                                                    .hoverFill,
                                                              ),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: scale.s(
                                                                  16,
                                                                ),
                                                                color: palette
                                                                    .primaryText
                                                                    .withValues(
                                                                      alpha:
                                                                          0.7,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Self-Expanding Dark/Light Mode Toggle + Bell (smoothly collapse when Search opens)
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 260),
                                    curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                                    child: AnimatedOpacity(
                                      duration: const Duration(
                                        milliseconds: 220,
                                      ),
                                      opacity: _showSearch ? 0.0 : 1.0,
                                      child: _showSearch
                                          ? const SizedBox.shrink()
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(width: scale.s(6)),
                                                Stack(
                                                  alignment: Alignment.center,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    AnimatedBuilder(
                                                      animation:
                                                          _rippleController,
                                                      builder: (context, _) {
                                                        if (_rippleController
                                                                    .value ==
                                                                0 ||
                                                            _rippleController
                                                                    .value ==
                                                                1) {
                                                          return const SizedBox.shrink();
                                                        }
                                                        final t = Curves
                                                            .easeOutCubic
                                                            .transform(
                                                              _rippleController
                                                                  .value,
                                                            );
                                                        return Transform.scale(
                                                          scale:
                                                              0.75 + (1.15 * t),
                                                          child: Opacity(
                                                            opacity:
                                                                (1.0 - t) *
                                                                0.65,
                                                            child: Container(
                                                              width:
                                                                  controlSize,
                                                              height:
                                                                  controlSize,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: palette
                                                                    .gold
                                                                    .withValues(
                                                                      alpha:
                                                                          0.25,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      onTap: _handleToggleTheme,
                                                      child: AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 300,
                                                            ),
                                                        curve: const Cubic(
                                                          0.22,
                                                          1.0,
                                                          0.36,
                                                          1.0,
                                                        ),
                                                        width: _themeExpanded
                                                            ? themeExpandedWidth
                                                            : controlSize,
                                                        height: controlSize,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  _themeExpanded
                                                                  ? scale.s(14)
                                                                  : 0,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: _themeExpanded
                                                              ? palette
                                                                    .cardSurface
                                                              : Colors
                                                                    .transparent,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                999,
                                                              ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            AnimatedSwitcher(
                                                              duration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        300,
                                                                  ),
                                                              transitionBuilder: (child, animation) {
                                                                return RotationTransition(
                                                                  turns:
                                                                      Tween<double>(
                                                                        begin:
                                                                            0.75,
                                                                        end:
                                                                            1.0,
                                                                      ).animate(
                                                                        animation,
                                                                      ),
                                                                  child: ScaleTransition(
                                                                    scale:
                                                                        animation,
                                                                    child: FadeTransition(
                                                                      opacity:
                                                                          animation,
                                                                      child:
                                                                          child,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: Icon(
                                                                widget.isDarkMode
                                                                    ? Icons
                                                                          .dark_mode_outlined
                                                                    : Icons
                                                                          .light_mode_outlined,
                                                                key: ValueKey(
                                                                  widget
                                                                      .isDarkMode,
                                                                ),
                                                                size:
                                                                    controlIconSize,
                                                                color:
                                                                    _themeExpanded
                                                                    ? palette
                                                                          .gold
                                                                    : palette
                                                                          .primaryText
                                                                          .withValues(
                                                                            alpha:
                                                                                0.75,
                                                                          ),
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: AnimatedSize(
                                                                duration:
                                                                    const Duration(
                                                                      milliseconds:
                                                                          280,
                                                                    ),
                                                                curve:
                                                                    const Cubic(
                                                                      0.22,
                                                                      1.0,
                                                                      0.36,
                                                                      1.0,
                                                                    ),
                                                                child:
                                                                    _themeExpanded
                                                                    ? Padding(
                                                                        padding: EdgeInsets.only(
                                                                          left: scale.s(
                                                                            6,
                                                                          ),
                                                                        ),
                                                                        child: Text(
                                                                          widget.isDarkMode
                                                                              ? 'DARK'
                                                                              : 'LIGHT',
                                                                          maxLines:
                                                                              1,
                                                                          softWrap:
                                                                              false,
                                                                          overflow:
                                                                              TextOverflow.clip,
                                                                          style: OnyxTypography.mono(
                                                                            fontSize: scale.s(
                                                                              11,
                                                                            ),
                                                                            color:
                                                                                palette.gold,
                                                                            letterSpacing:
                                                                                0.8,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : const SizedBox.shrink(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: scale.s(4)),
                                                GestureDetector(
                                                  onTap: () => setState(() {
                                                    _notificationOpen =
                                                        !_notificationOpen;
                                                  }),
                                                  child: Container(
                                                    width: controlSize,
                                                    height: controlSize,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: _notificationOpen
                                                          ? palette.hoverFill
                                                          : Colors.transparent,
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .notifications_none_rounded,
                                                      size: controlIconSize,
                                                      color: _notificationOpen
                                                          ? palette.gold
                                                          : palette.primaryText
                                                                .withValues(
                                                                  alpha: 0.65,
                                                                ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: scale.s(12)),

                    // Centered Editorial Stat Block (Luxury Proportion & Balanced Padding)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: scale.s(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'TOTAL MONTH SPEND',
                                style: OnyxTypography.mono(
                                  fontSize: scale.s(13),
                                  color: palette.mutedText,
                                  letterSpacing: 1.6,
                                ),
                              ),
                              SizedBox(width: scale.s(8)),
                              GestureDetector(
                                onTap: () => setState(
                                  () => _balanceVisible = !_balanceVisible,
                                ),
                                child: Icon(
                                  _balanceVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: scale.s(17),
                                  color: palette.primaryText.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: scale.s(10)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _balanceVisible
                                  ? formatINR(totalCombinedSpend)
                                  : '••••••••',
                              style: OnyxTypography.editorial(
                                fontSize: scale.s(48),
                                fontWeight: FontWeight.w600,
                                height: 1.05,
                                letterSpacing: -0.8,
                                color: palette.primaryText,
                                tabularFigures: true,
                              ),
                            ),
                          ),
                          SizedBox(height: scale.s(20)),

                          // Utilization Progress Track
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: double.infinity,
                              height: scale.s(6),
                              color: palette.divider,
                              alignment: Alignment.centerLeft,
                              child: AnimatedFractionallySizedBox(
                                duration: const Duration(milliseconds: 300),
                                widthFactor: (utilizationPercent / 100.0).clamp(
                                  0.0,
                                  1.0,
                                ),
                                heightFactor: 1.0,
                                child: Container(color: palette.gold),
                              ),
                            ),
                          ),
                          SizedBox(height: scale.s(12)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  'LIMIT USED',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: OnyxTypography.mono(
                                    fontSize: scale.s(16),
                                    fontWeight: FontWeight.w700,
                                    color: palette.primaryText.withValues(
                                      alpha: 0.85,
                                    ),
                                    letterSpacing: 1.3,
                                  ),
                                ),
                              ),
                              SizedBox(width: scale.s(8)),
                              Text(
                                '$utilizationPercent% OF ${_balanceVisible ? formatINR(totalCombinedLimit, compact: true).toUpperCase() : '••••'}',
                                maxLines: 1,
                                style: OnyxTypography.mono(
                                  fontSize: scale.s(16),
                                  fontWeight: FontWeight.w700,
                                  color: palette.primaryText,
                                  letterSpacing: 1.2,
                                  tabularFigures: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: scale.s(12)),

                    // Recent Activity Card (Elevated Luxury Card Container, No Border)
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
                                  'Recent Activity',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: OnyxTypography.sans(
                                    fontSize: scale.s(16.5),
                                    fontWeight: FontWeight.w600,
                                    color: palette.primaryText,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              if (extraTransactions.isNotEmpty) ...[
                                SizedBox(width: scale.s(8)),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _showAllTransactions =
                                        !_showAllTransactions,
                                  ),
                                  child: Text(
                                    _showAllTransactions ? 'LESS' : 'VIEW ALL',
                                    style: OnyxTypography.mono(
                                      fontSize: scale.s(11.5),
                                      color: palette.mutedText,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: scale.s(14)),

                          if (filteredTransactions.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: scale.s(24),
                              ),
                              child: Text(
                                'No matching transactions found.',
                                textAlign: TextAlign.center,
                                style: OnyxTypography.sans(
                                  fontSize: scale.s(12),
                                  color: palette.mutedText,
                                ),
                              ),
                            )
                          else ...[
                            ...initialTransactions.map(
                              (tx) => _ActivityRow(
                                tx: tx,
                                balanceVisible: _balanceVisible,
                                palette: palette,
                                scale: scale,
                                onTap: () => widget.onSelectTransaction(tx),
                              ),
                            ),

                            // Animated Expandable Extra Rows
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
                                              (
                                                entry,
                                              ) => TweenAnimationBuilder<double>(
                                                key: ValueKey(entry.value.id),
                                                tween: Tween(
                                                  begin: 0.0,
                                                  end: 1.0,
                                                ),
                                                duration: Duration(
                                                  milliseconds:
                                                      240 + (entry.key * 35),
                                                ),
                                                curve: const Cubic(
                                                  0.22,
                                                  1.0,
                                                  0.36,
                                                  1.0,
                                                ),
                                                builder: (context, val, child) {
                                                  return Opacity(
                                                    opacity: val,
                                                    child: Transform.translate(
                                                      offset: Offset(
                                                        0,
                                                        -6 * (1 - val),
                                                      ),
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: _ActivityRow(
                                                  tx: entry.value,
                                                  balanceVisible:
                                                      _balanceVisible,
                                                  palette: palette,
                                                  scale: scale,
                                                  onTap: () => widget
                                                      .onSelectTransaction(
                                                        entry.value,
                                                      ),
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
                  ],
                ),
              ),

              // Notification Popover Overlay
              if (_notificationOpen)
                Positioned(
                  right: 16,
                  top: 52,
                  child: Container(
                    width: 256,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: palette.cardSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: palette.divider),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PORTFOLIO ALERTS',
                                style: OnyxTypography.mono(
                                  fontSize: 10,
                                  color: palette.primaryText,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Text(
                                'Verified',
                                style: OnyxTypography.mono(
                                  fontSize: 10,
                                  color: palette.gold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              size: 14,
                              color: palette.gold,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RBI Tokenization Active',
                                    style: OnyxTypography.sans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: palette.primaryText,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Credentials verified across ${widget.cards.length} Indian banks.',
                                    style: OnyxTypography.sans(
                                      fontSize: 10,
                                      color: palette.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final TransactionModel tx;
  final bool balanceVisible;
  final OnyxPalette palette;
  final OnyxScale scale;
  final VoidCallback onTap;

  const _ActivityRow({
    required this.tx,
    required this.balanceVisible,
    required this.palette,
    required this.scale,
    required this.onTap,
  });

  static const List<Color> _badgePalette = [
    Color(0xFF4338CA), // Indigo
    Color(0xFFBE123C), // Rose
    Color(0xFF0E7490), // Cyan
    Color(0xFFB45309), // Amber
    Color(0xFF065F46), // Emerald
    Color(0xFF6D28D9), // Violet
    Color(0xFF1E293B), // Slate
    Color(0xFF0F766E), // Teal
  ];

  ({String letter, Color bg}) _resolveMerchantBadge(
    String title,
    String category,
  ) {
    final lower = '$title $category'.toLowerCase();
    if (lower.contains('starbucks') || lower.contains('coffee')) {
      return (letter: 'S', bg: const Color(0xFF065F46));
    }
    if (lower.contains('swiggy') ||
        lower.contains('instamart') ||
        lower.contains('zomato')) {
      return (letter: 'I', bg: const Color(0xFFD97706));
    }
    if (lower.contains('netflix')) {
      return (letter: 'N', bg: const Color(0xFF18181B));
    }
    if (lower.contains('apollo') || lower.contains('pharmacy')) {
      return (letter: 'A', bg: const Color(0xFF0F766E));
    }
    if (lower.contains('amazon') || lower.contains('flipkart')) {
      return (letter: 'A', bg: const Color(0xFFC2410C));
    }
    if (lower.contains('uber') || lower.contains('ola')) {
      return (letter: 'U', bg: const Color(0xFF1E293B));
    }
    if (lower.contains('apple')) {
      return (letter: 'A', bg: const Color(0xFF334155));
    }

    final trimmed = title.trim();
    final letter = trimmed.isNotEmpty ? trimmed[0].toUpperCase() : 'T';
    final code = letter.codeUnitAt(0);
    final bg = _badgePalette[code % _badgePalette.length];
    return (letter: letter, bg: bg);
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == TransactionType.income;
    final badge = _resolveMerchantBadge(tx.title, tx.category);

    return RepaintBoundary(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(scale.s(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: scale.s(9)),
          child: Row(
            children: [
              Container(
                width: scale.s(34),
                height: scale.s(34),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badge.bg,
                ),
                alignment: Alignment.center,
                child: Text(
                  badge.letter,
                  style: OnyxTypography.sans(
                    fontSize: scale.s(13),
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
                        fontSize: scale.s(14.5),
                        fontWeight: FontWeight.w500,
                        color: palette.primaryText,
                      ),
                    ),
                    SizedBox(height: scale.s(2)),
                    Text(
                      '${tx.cardBank?.displayName ?? 'Card'} · ${tx.date}',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(11),
                        fontWeight: FontWeight.w500,
                        color: palette.subtleText,
                        letterSpacing: 0.3,
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
                    '${isIncome ? '+' : '-'}${balanceVisible ? formatINR(tx.amount) : '••••'}',
                    style: OnyxTypography.sans(
                      fontSize: scale.s(14.5),
                      fontWeight: FontWeight.w600,
                      color: isIncome
                          ? const Color(0xFF059669)
                          : palette.primaryText,
                      tabularFigures: true,
                    ),
                  ),
                  SizedBox(height: scale.s(2)),
                  Text(
                    tx.status.name.toUpperCase(),
                    style: OnyxTypography.mono(
                      fontSize: scale.s(9),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF059669),
                      letterSpacing: 0.7,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

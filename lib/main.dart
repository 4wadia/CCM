import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/financial_models.dart';
import 'screens/cards_screen.dart';
import 'screens/home_screen.dart';
import 'screens/manage_card_screen.dart';
import 'screens/profile_screen.dart';
import 'services/auto_sync_service.dart';
import 'theme/onyx_theme.dart';
import 'widgets/complete_card_dialog.dart';
import 'widgets/floating_pill_nav.dart';
import 'widgets/galaxy_s26_ultra_frame.dart';
import 'widgets/issue_card_dialog.dart';
import 'widgets/permission_onboarding_dialog.dart';
import 'widgets/transaction_detail_sheet.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Low-end memory optimization: limit decoded image cache to prevent GC pauses
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      50 * 1024 * 1024; // 50 MB
  runApp(const OnyxCardsApp());
}

class OnyxCardsApp extends StatefulWidget {
  const OnyxCardsApp({super.key});

  @override
  State<OnyxCardsApp> createState() => _OnyxCardsAppState();
}

class _OnyxCardsAppState extends State<OnyxCardsApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _isDarkMode = true;
  ScreenId _activeTab = ScreenId.home;
  final List<ScreenId> _tabHistory = <ScreenId>[];
  ScreenId? _tabBeforeManage;
  CreditCardModel? _selectedCardForManage;
  List<CreditCardModel> _cards = <CreditCardModel>[];
  final List<TransactionModel> _transactions = <TransactionModel>[];
  String? _statusPillMessage;
  Timer? _toastTimer;
  bool _hasPromptedPermissions = false;

  UserProfileModel _userProfile = const UserProfileModel(name: '');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstLaunchPermissions();
    });
  }

  Future<void> _checkFirstLaunchPermissions() async {
    if (_hasPromptedPermissions) return;
    _hasPromptedPermissions = true;

    final service = AutoSyncService();
    final statuses = await service.checkPermissions();
    final allGranted =
        (statuses['sms'] ?? false) &&
        (statuses['notifications'] ?? false) &&
        _userProfile.isEmailConnected;

    if (!allGranted && mounted) {
      final navContext = _navigatorKey.currentContext;
      if (navContext != null && navContext.mounted) {
        unawaited(
          showPermissionOnboardingDialog(
            context: navContext,
            isDarkMode: _isDarkMode,
            onComplete: () {
              _runFirstTimeAutoSetup();
            },
            onProfileUpdated: (updated) {
              if (mounted) setState(() => _userProfile = updated);
            },
          ),
        );
      }
    } else {
      unawaited(_runFirstTimeAutoSetup());
    }
  }

  Future<void> _runFirstTimeAutoSetup() async {
    final service = AutoSyncService();
    final result = await service.autoDetectCardsAndSync(
      userProfile: _userProfile,
      currentCards: _cards,
    );

    if (!mounted) return;

    if (result.transactions.isNotEmpty) {
      setState(() {
        _transactions.insertAll(0, result.transactions);
      });
    }

    if (result.addedCards.isNotEmpty) {
      setState(() {
        _cards = [...result.addedCards, ..._cards];
      });

      _showStatusToast(
        'Auto-detected ${result.addedCards.length} cards from SMS (${result.transactions.length} txns synced)',
      );

      // Auto-prompt user to complete the detected card
      final firstIncomplete = result.addedCards.firstWhere(
        (c) => c.isNeedsCompletion,
        orElse: () => result.addedCards.first,
      );

      final navContext = _navigatorKey.currentContext;
      if (navContext != null && navContext.mounted) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) {
            _promptCompleteCard(firstIncomplete);
          }
        });
      }
    }
  }

  void _promptCompleteCard(CreditCardModel card) {
    final navContext = _navigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;

    showCompleteCardDialog(
      context: navContext,
      card: card,
      isDarkMode: _isDarkMode,
      onCardCompleted: (completed) {
        _handleUpdateCard(completed);
        _showStatusToast('${completed.cardTier} setup complete!');
      },
    );
  }

  void _handleUpdateCard(CreditCardModel updated) {
    setState(() {
      final idx = _cards.indexWhere((c) => c.id == updated.id);
      if (idx != -1) {
        _cards[idx] = updated;
      }
      if (_selectedCardForManage?.id == updated.id) {
        _selectedCardForManage = updated;
      }
    });
  }

  void _handleDeleteCard(CreditCardModel card) {
    setState(() {
      _cards.removeWhere((c) => c.id == card.id);
      _transactions.removeWhere((tx) => _transactionBelongsToCard(tx, card));
      if (_selectedCardForManage?.id == card.id) {
        _selectedCardForManage = null;
        _activeTab = _tabBeforeManage ?? _activeTab;
        _tabBeforeManage = null;
      }
    });
    _showStatusToast('${card.cardTier} removed');
  }

  static bool _transactionBelongsToCard(
    TransactionModel tx,
    CreditCardModel card,
  ) {
    final last4 = tx.cardLast4.trim();
    if (last4.isNotEmpty) {
      return last4 == card.lastFour &&
          (tx.cardBank == null || tx.cardBank == card.bankName);
    }
    return tx.cardBank == card.bankName &&
        (tx.cardBrand == null || tx.cardBrand == card.brand);
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  void _showStatusToast(String message) {
    setState(() => _statusPillMessage = message);
    _toastTimer?.cancel();
    _toastTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _statusPillMessage = null);
    });
  }

  Future<void> _openAddCard(BuildContext context) async {
    final newCard = await showIssueCardDialog(
      context: context,
      isDarkMode: _isDarkMode,
      holderName: _userProfile.name,
    );
    if (newCard == null || !mounted) return;
    _handleAddCard(newCard);
  }

  void _handleAddCard(CreditCardModel newCard) {
    setState(() {
      _cards = [newCard, ..._cards];
      _selectedCardForManage = null;
      _activeTab = ScreenId.cards;
    });
    _showStatusToast('New ${newCard.cardTier} added');

    // The form is already closed at this point. Scan in the background so the
    // new card is visible immediately instead of being covered by a modal.
    unawaited(_syncNewCard(newCard));
  }

  Future<void> _syncNewCard(CreditCardModel newCard) async {
    try {
      final syncResult = await AutoSyncService().syncLastMonthForCard(
        card: newCard,
      );
      if (!mounted) return;

      final index = _cards.indexWhere((c) => c.id == newCard.id);
      if (index == -1) return; // The card was removed while scanning.

      setState(() {
        if (syncResult.transactions.isNotEmpty) {
          _transactions.insertAll(0, syncResult.transactions);
        }
        if (syncResult.monthSpend > 0) {
          _cards[index] = _cards[index].copyWith(
            balance: syncResult.monthSpend,
          );
        }
      });

      if (syncResult.transactions.isNotEmpty) {
        _showStatusToast(
          'Auto-synced ${syncResult.transactions.length} transactions.',
        );
      }
    } catch (_) {
      // The card is already in the portfolio. A background scan failure should
      // not interrupt the user or reopen a blocking dialog.
    }
  }

  void _openManageCard(CreditCardModel card) {
    setState(() {
      _tabBeforeManage = _activeTab;
      _selectedCardForManage = card;
    });
  }

  void _closeManageCard() {
    if (!mounted) return;
    final destination = _tabBeforeManage ?? ScreenId.cards;
    setState(() {
      _selectedCardForManage = null;
      _activeTab = destination;
      _tabBeforeManage = null;
    });
  }

  void _selectTab(ScreenId tab) {
    if (tab == _activeTab) return;
    setState(() {
      _selectedCardForManage = null;
      _tabBeforeManage = null;
      _tabHistory.add(_activeTab);
      _activeTab = tab;
    });
  }

  void _handleBack() {
    if (!mounted) return;
    if (_selectedCardForManage != null) {
      _closeManageCard();
      return;
    }
    if (_activeTab == ScreenId.home) return;
    setState(() {
      _activeTab = _tabHistory.isNotEmpty
          ? _tabHistory.removeLast()
          : ScreenId.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(_isDarkMode);

    SystemChrome.setSystemUIOverlayStyle(
      _isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Onyx Cards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: palette.background,
        useMaterial3: true,
      ),
      builder: (context, child) {
        return GalaxyS26UltraFrame(
          isDarkMode: _isDarkMode,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Builder(
        builder: (innerContext) {
          return PopScope(
            // Back follows the same stack as the in-app back buttons: a managed
            // card returns to the tab it came from, and tabs return to the
            // previously visited tab before the app is allowed to close.
            canPop:
                _activeTab == ScreenId.home && _selectedCardForManage == null,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _handleBack();
            },
            child: Scaffold(
              backgroundColor: palette.background,
              body: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 412),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 260),
                            switchInCurve: const Cubic(0.22, 1.0, 0.36, 1.0),
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) {
                              return FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, 0.015),
                                    end: Offset.zero,
                                  ).animate(anim),
                                  child: child,
                                ),
                              );
                            },
                            child: _selectedCardForManage != null
                                ? ManageCardScreen(
                                    key: ValueKey(
                                      'screen-manage-${_selectedCardForManage!.id}',
                                    ),
                                    card: _selectedCardForManage!,
                                    transactions: _transactions,
                                    onBack: _closeManageCard,
                                    onCompleteCard: _promptCompleteCard,
                                    onUpdateCard: _handleUpdateCard,
                                    onDeleteCard: _handleDeleteCard,
                                    isDarkMode: _isDarkMode,
                                  )
                                : _activeTab == ScreenId.cards
                                ? CardsScreen(
                                    key: const ValueKey('screen-cards'),
                                    cards: _cards,
                                    onOpenNewCardModal: () =>
                                        _openAddCard(innerContext),
                                    onSelectCard: _openManageCard,
                                    onCompleteCard: _promptCompleteCard,
                                    isDarkMode: _isDarkMode,
                                  )
                                : _activeTab == ScreenId.profile
                                ? ProfileScreen(
                                    key: const ValueKey('screen-profile'),
                                    profile: _userProfile,
                                    onUpdateProfile: (updated) =>
                                        setState(() => _userProfile = updated),
                                    cards: _cards,
                                    transactions: _transactions,
                                    isDarkMode: _isDarkMode,
                                    onBack: _handleBack,
                                  )
                                : HomeScreen(
                                    key: const ValueKey('screen-home'),
                                    cards: _cards,
                                    transactions: _transactions,
                                    profile: _userProfile,
                                    onOpenProfile: () => setState(
                                      () => _activeTab = ScreenId.profile,
                                    ),
                                    onSelectTransaction: (tx) =>
                                        showTransactionDetailSheet(
                                          context: innerContext,
                                          transaction: tx,
                                          isDarkMode: _isDarkMode,
                                        ),
                                    isDarkMode: _isDarkMode,
                                    onToggleDarkMode: () => setState(
                                      () => _isDarkMode = !_isDarkMode,
                                    ),
                                  ),
                          ),
                        ),

                        // Floating Pill Action Switcher
                        if (_selectedCardForManage == null)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: OnyxScale.of(innerContext).s(16),
                            child: Center(
                              child: FloatingPillNav(
                                activeTab: _activeTab,
                                isDarkMode: _isDarkMode,
                                onSelectTab: _selectTab,
                              ),
                            ),
                          ),

                        // Subtle Top Toast Pill
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 220),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, -0.35),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: _statusPillMessage == null
                                  ? const SizedBox.shrink()
                                  : Container(
                                      key: ValueKey(_statusPillMessage),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF18181B),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFD4AF37)
                                              .withValues(alpha: 0.45),
                                        ),
                                      ),
                                      child: Text(
                                        _statusPillMessage!,
                                        style: OnyxTypography.mono(
                                          fontSize: 10,
                                          color: const Color(0xFFF8F7F4),
                                          letterSpacing: 0.6,
                                        ),
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
            ),
          );
        },
      ),
    );
  }
}

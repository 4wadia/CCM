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
import 'widgets/sync_progress_dialog.dart';
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

  Future<void> _handleAddCard(
    BuildContext context,
    CreditCardModel newCard,
  ) async {
    setState(() {
      _cards = [newCard, ..._cards];
    });
    _showStatusToast('New ${newCard.cardTier} Issued');

    // Trigger auto-scan for newly added card (last 30 days SMS/email statements)
    final syncResult = await showCardSyncProgressDialog(
      context: context,
      card: newCard,
      isDarkMode: _isDarkMode,
    );

    if (syncResult != null && mounted) {
      setState(() {
        if (syncResult.transactions.isNotEmpty) {
          _transactions.insertAll(0, syncResult.transactions);
        }
        final index = _cards.indexWhere((c) => c.id == newCard.id);
        if (index != -1) {
          _cards[index] = _cards[index].copyWith(
            balance: syncResult.monthSpend > 0
                ? syncResult.monthSpend
                : _cards[index].balance,
          );
        }
      });
      if (syncResult.transactions.isNotEmpty) {
        _showStatusToast(
          'Auto-synced ${syncResult.transactions.length} transactions.',
        );
      } else {
        _showStatusToast('No matching SMS transactions found yet.');
      }
    }
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
            // Android back should return to Home from Cards, Profile or a
            // managed card before it is allowed to close the app.
            canPop:
                _activeTab == ScreenId.home && _selectedCardForManage == null,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _handleBackToHome();
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
                                    onBack: () => setState(
                                      () => _selectedCardForManage = null,
                                    ),
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
                                        showIssueCardDialog(
                                          context: innerContext,
                                          isDarkMode: _isDarkMode,
                                          holderName: _userProfile.name,
                                          onAddCard: (card) => _handleAddCard(
                                            innerContext,
                                            card,
                                          ),
                                        ),
                                    onSelectCard: (card) => setState(
                                      () => _selectedCardForManage = card,
                                    ),
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
                                    onBack: () => setState(
                                      () => _activeTab = ScreenId.home,
                                    ),
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
                                onSelectTab: (tab) => setState(() {
                                  _selectedCardForManage = null;
                                  _activeTab = tab;
                                }),
                              ),
                            ),
                          ),

                        // Subtle Top Toast Pill
                        if (_statusPillMessage != null)
                          Positioned(
                            top: 8,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF18181B),
                                  borderRadius: BorderRadius.circular(999),
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

  void _handleBackToHome() {
    if (!mounted) return;
    if (_activeTab == ScreenId.home && _selectedCardForManage == null) return;
    setState(() {
      _selectedCardForManage = null;
      _activeTab = ScreenId.home;
    });
  }
}

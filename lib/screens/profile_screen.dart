import 'package:flutter/material.dart';

import '../models/financial_models.dart';
import '../services/auto_sync_service.dart';
import '../theme/onyx_theme.dart';
import '../widgets/app_logo.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfileModel profile;
  final ValueChanged<UserProfileModel> onUpdateProfile;
  final List<CreditCardModel> cards;
  final List<TransactionModel> transactions;
  final bool isDarkMode;
  final VoidCallback onBack;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onUpdateProfile,
    required this.cards,
    required this.transactions,
    required this.isDarkMode,
    required this.onBack,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _syncService = AutoSyncService();
  bool _isConnecting = false;
  String? _statusMessage;

  Future<void> _handleConnectGoogle() async {
    setState(() {
      _isConnecting = true;
      _statusMessage = null;
    });

    try {
      final updatedProfile = await _syncService.connectGoogleAccount();
      if (updatedProfile != null) {
        widget.onUpdateProfile(updatedProfile);
        setState(() {
          _statusMessage = 'Google profile synced successfully!';
        });
      } else {
        setState(() {
          _statusMessage = 'Google sign-in was not completed.';
        });
      }
    } catch (_) {
      setState(() {
        _statusMessage = 'Could not connect Google account.';
      });
    } finally {
      if (mounted) setState(() => _isConnecting = false);
    }
  }

  void _handleDisconnectGoogle() {
    widget.onUpdateProfile(
      widget.profile.copyWith(
        email: null,
        isEmailConnected: false,
        photoUrl: null,
      ),
    );
    setState(() {
      _statusMessage = 'Disconnected Google account.';
    });
  }

  Future<void> _handleToggleSms() async {
    final res = await _syncService.requestAllPermissions();
    widget.onUpdateProfile(
      widget.profile.copyWith(
        isSmsGranted: res['sms'] ?? false,
        isNotificationsGranted: res['notifications'] ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final scale = OnyxScale.of(context);
    final profile = widget.profile;

    final initials = profile.name.trim().isNotEmpty
        ? profile.name
              .trim()
              .split(RegExp(r'\s+'))
              .map((e) => e.isNotEmpty ? e[0].toUpperCase() : '')
              .take(2)
              .join()
        : '•';
    final displayName = profile.name.trim().isNotEmpty
        ? profile.name.trim()
        : 'Cardholder';

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        scale.s(20),
        scale.s(16),
        scale.s(20),
        scale.s(110),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Navigation Bar
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
                      width: scale.s(40),
                      height: scale.s(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.hoverFill,
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        size: scale.s(22),
                        color: palette.primaryText,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Profile & Access',
                  style: OnyxTypography.editorial(
                    fontSize: scale.s(24),
                    fontWeight: FontWeight.w600,
                    color: palette.primaryText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(18)),

          // User Card Profile Hero
          Container(
            padding: EdgeInsets.all(scale.s(24)),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(scale.s(18)),
            ),
            child: Column(
              children: [
                // Profile Avatar Photo / Initials
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: scale.s(76),
                      height: scale.s(76),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.hoverFill,
                      ),
                      child: ClipOval(
                        child:
                            profile.photoUrl != null &&
                                profile.photoUrl!.isNotEmpty
                            ? Image.network(
                                profile.photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Text(
                                        initials,
                                        style: OnyxTypography.mono(
                                          fontSize: scale.s(22),
                                          color: palette.gold,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                              )
                            : Center(
                                child: Text(
                                  initials,
                                  style: OnyxTypography.mono(
                                    fontSize: scale.s(22),
                                    color: palette.gold,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (profile.isEmailConnected)
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: palette.cardSurface,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: scale.s(12)),

                // Name
                Text(
                  displayName,
                  style: OnyxTypography.sans(
                    fontSize: scale.s(18),
                    fontWeight: FontWeight.w600,
                    color: palette.primaryText,
                  ),
                ),
                SizedBox(height: scale.s(4)),

                // Email badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      profile.isEmailConnected
                          ? Icons.verified_user_outlined
                          : Icons.mail_outline,
                      size: scale.s(13),
                      color: profile.isEmailConnected
                          ? const Color(0xFF10B981)
                          : palette.mutedText,
                    ),
                    SizedBox(width: scale.s(6)),
                    Text(
                      profile.email ?? 'No Google Email Connected',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(11),
                        color: profile.isEmailConnected
                            ? palette.primaryText
                            : palette.mutedText,
                      ),
                    ),
                  ],
                ),
                if (_statusMessage != null) ...[
                  SizedBox(height: scale.s(10)),
                  Text(
                    _statusMessage!,
                    style: OnyxTypography.mono(
                      fontSize: scale.s(10),
                      color: palette.gold,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: scale.s(22)),

          // Section 1: Connected Mail & Account Access
          Text(
            'MAIL & ACCOUNT ACCESS',
            style: OnyxTypography.mono(
              fontSize: scale.s(10),
              color: palette.mutedText,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: scale.s(10)),

          Container(
            padding: EdgeInsets.all(scale.s(20)),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(scale.s(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: scale.s(36),
                          height: scale.s(36),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: profile.isEmailConnected
                                ? const Color(0xFF10B981)
                                      .withValues(alpha: 0.15)
                                : palette.hoverFill,
                          ),
                          child: Icon(
                            Icons.alternate_email_rounded,
                            size: scale.s(18),
                            color: profile.isEmailConnected
                                ? const Color(0xFF10B981)
                                : palette.mutedText,
                          ),
                        ),
                        SizedBox(width: scale.s(12)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Google Account (Gmail)',
                              style: OnyxTypography.sans(
                                fontSize: scale.s(13),
                                fontWeight: FontWeight.w600,
                                color: palette.primaryText,
                              ),
                            ),
                            SizedBox(height: scale.s(2)),
                            Text(
                              profile.isEmailConnected
                                  ? (profile.email ?? 'Connected')
                                  : 'Not connected',
                              style: OnyxTypography.mono(
                                fontSize: scale.s(10.5),
                                color: profile.isEmailConnected
                                    ? palette.gold
                                    : palette.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale.s(8),
                        vertical: scale.s(4),
                      ),
                      decoration: BoxDecoration(
                        color: profile.isEmailConnected
                            ? const Color(0xFF10B981).withValues(alpha: 0.15)
                            : palette.hoverFill,
                        borderRadius: BorderRadius.circular(scale.s(6)),
                      ),
                      child: Text(
                        profile.isEmailConnected ? 'Active' : 'Offline',
                        style: OnyxTypography.mono(
                          fontSize: scale.s(9),
                          color: profile.isEmailConnected
                              ? const Color(0xFF10B981)
                              : palette.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: scale.s(12)),
                Text(
                  'Connected mail access allows Onyx to fetch your name, profile photo, credit card e-statements, monthly billing dues, and cashback records directly from bank emails.',
                  style: OnyxTypography.sans(
                    fontSize: scale.s(11),
                    color: palette.mutedText,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: scale.s(14)),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isConnecting ? null : _handleConnectGoogle,
                        icon: _isConnecting
                            ? SizedBox(
                                width: scale.s(12),
                                height: scale.s(12),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(Icons.sync, size: scale.s(14)),
                        label: Text(
                          profile.isEmailConnected
                              ? 'Re-Sync Google Info'
                              : 'Connect Google Mail',
                          style: OnyxTypography.sans(
                            fontSize: scale.s(11.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isDarkMode
                              ? palette.gold
                              : const Color(0xFF111113),
                          foregroundColor: widget.isDarkMode
                              ? const Color(0xFF111113)
                              : const Color(0xFFF8F7F4),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: scale.s(10)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(scale.s(8)),
                          ),
                        ),
                      ),
                    ),
                    if (profile.isEmailConnected) ...[
                      SizedBox(width: scale.s(8)),
                      OutlinedButton(
                        onPressed: _handleDisconnectGoogle,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: BorderSide(
                            color: const Color(0xFFEF4444)
                                .withValues(alpha: 0.4),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: scale.s(12),
                            vertical: scale.s(10),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(scale.s(8)),
                          ),
                        ),
                        child: Text(
                          'Disconnect',
                          style: OnyxTypography.sans(
                            fontSize: scale.s(11),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(22)),

          // Section 2: Device Permissions
          Text(
            'PERMISSIONS OVERVIEW',
            style: OnyxTypography.mono(
              fontSize: scale.s(10),
              color: palette.mutedText,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: scale.s(10)),

          Container(
            padding: EdgeInsets.all(scale.s(20)),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(scale.s(18)),
            ),
            child: Column(
              children: [
                _StatusRow(
                  label: 'SMS Spend Reading',
                  status: profile.isSmsGranted ? 'Granted' : 'Pending',
                  isActive: profile.isSmsGranted,
                  onAction: _handleToggleSms,
                  palette: palette,
                  scale: scale,
                ),
                Divider(color: palette.divider, height: scale.s(20)),
                _StatusRow(
                  label: 'Email / Gmail Access',
                  status: profile.isEmailConnected ? 'Active' : 'Disconnected',
                  isActive: profile.isEmailConnected,
                  onAction: _handleConnectGoogle,
                  palette: palette,
                  scale: scale,
                ),
                Divider(color: palette.divider, height: scale.s(20)),
                _StatusRow(
                  label: 'Payment Due Notifications',
                  status: profile.isNotificationsGranted
                      ? 'Enabled'
                      : 'Disabled',
                  isActive: profile.isNotificationsGranted,
                  onAction: _handleToggleSms,
                  palette: palette,
                  scale: scale,
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(22)),

          // Section 3: Portfolio & Vault Info
          Container(
            padding: EdgeInsets.all(scale.s(20)),
            decoration: BoxDecoration(
              color: palette.cardSurface,
              borderRadius: BorderRadius.circular(scale.s(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.cards.length}',
                      style: OnyxTypography.editorial(
                        fontSize: scale.s(24),
                        fontWeight: FontWeight.w700,
                        color: palette.primaryText,
                      ),
                    ),
                    SizedBox(height: scale.s(2)),
                    Text(
                      'Active Cards',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(9.5),
                        color: palette.mutedText,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: scale.s(32),
                  color: palette.divider,
                ),
                Column(
                  children: [
                    Text(
                      '${widget.transactions.length}',
                      style: OnyxTypography.editorial(
                        fontSize: scale.s(24),
                        fontWeight: FontWeight.w700,
                        color: palette.primaryText,
                      ),
                    ),
                    SizedBox(height: scale.s(2)),
                    Text(
                      'Transactions',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(9.5),
                        color: palette.mutedText,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: scale.s(32),
                  color: palette.divider,
                ),
                Column(
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: scale.s(20),
                      color: palette.gold,
                    ),
                    SizedBox(height: scale.s(4)),
                    Text(
                      'AES-256 Vault',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(9.5),
                        color: palette.gold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: scale.s(28)),

          // App Brand & Logo Footer
          Center(
            child: Column(
              children: [
                AppLogo(size: scale.s(52)),
                SizedBox(height: scale.s(10)),
                Text(
                  'CREDIT CARD MANAGER',
                  style: OnyxTypography.mono(
                    fontSize: scale.s(11),
                    fontWeight: FontWeight.w700,
                    color: palette.primaryText,
                    letterSpacing: 2.2,
                  ),
                ),
                SizedBox(height: scale.s(4)),
                Text(
                  'VERSION 0.3.0 · LUXURY ONYX EDITION',
                  style: OnyxTypography.mono(
                    fontSize: scale.s(9),
                    color: palette.mutedText,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: scale.s(32)),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  final String status;
  final bool isActive;
  final VoidCallback onAction;
  final OnyxPalette palette;
  final OnyxScale scale;

  const _StatusRow({
    required this.label,
    required this.status,
    required this.isActive,
    required this.onAction,
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
            fontSize: scale.s(12.5),
            fontWeight: FontWeight.w500,
            color: palette.primaryText,
          ),
        ),
        GestureDetector(
          onTap: onAction,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status,
                style: OnyxTypography.mono(
                  fontSize: scale.s(10),
                  color: isActive ? palette.gold : palette.mutedText,
                ),
              ),
              SizedBox(width: scale.s(4)),
              Icon(
                isActive ? Icons.check : Icons.arrow_forward_ios,
                size: scale.s(10),
                color: isActive ? palette.gold : palette.mutedText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

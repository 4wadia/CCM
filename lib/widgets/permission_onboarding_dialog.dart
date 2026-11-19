import 'package:flutter/material.dart';

import '../core/errors/app_failure.dart';
import '../models/financial_models.dart';
import '../services/auto_sync_service.dart';
import '../theme/onyx_theme.dart';
import 'app_logo.dart';
import 'google_setup_help_dialog.dart';

Future<void> showPermissionOnboardingDialog({
  required BuildContext context,
  required bool isDarkMode,
  required VoidCallback onComplete,
  required VoidCallback onSkip,
  required ValueChanged<UserProfileModel> onProfileUpdated,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (ctx) => _PermissionOnboardingSheet(
      isDarkMode: isDarkMode,
      onComplete: onComplete,
      onSkip: onSkip,
      onProfileUpdated: onProfileUpdated,
    ),
  );
}

class _PermissionOnboardingSheet extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onComplete;
  final VoidCallback onSkip;
  final ValueChanged<UserProfileModel> onProfileUpdated;

  const _PermissionOnboardingSheet({
    required this.isDarkMode,
    required this.onComplete,
    required this.onSkip,
    required this.onProfileUpdated,
  });

  @override
  State<_PermissionOnboardingSheet> createState() =>
      _PermissionOnboardingSheetState();
}

class _PermissionOnboardingSheetState
    extends State<_PermissionOnboardingSheet> {
  final _syncService = AutoSyncService();
  bool _smsGranted = false;
  bool _emailConnected = false;
  bool _notifsGranted = false;
  bool _isLoading = false;
  String? _connectedEmail;
  String? _profileName;
  String? _profilePhoto;
  String? _googleError;

  @override
  void initState() {
    super.initState();
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    final status = await _syncService.checkPermissions();
    if (mounted) {
      setState(() {
        _smsGranted = status['sms'] ?? false;
        _notifsGranted = status['notifications'] ?? false;
      });
    }
  }

  Future<void> _requestSms() async {
    setState(() => _isLoading = true);
    final res = await _syncService.requestAllPermissions();
    if (mounted) {
      setState(() {
        _smsGranted = res['sms'] ?? false;
        _notifsGranted = res['notifications'] ?? false;
        _isLoading = false;
      });
    }
  }

  Future<void> _connectEmail() async {
    setState(() {
      _isLoading = true;
      _googleError = null;
    });

    try {
      final profile = await _syncService.connectGoogleAccount();
      if (!mounted) return;
      setState(() {
        _emailConnected = true;
        _connectedEmail = profile.email;
        _profileName = profile.name;
        _profilePhoto = profile.photoUrl;
        _isLoading = false;
      });
      widget.onProfileUpdated(profile);
    } on AppFailure catch (error) {
      if (!mounted) return;
      setState(() {
        _googleError = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _googleError =
            'Could not connect Google. Check your connection and try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _grantAllAndProceed() async {
    setState(() {
      _isLoading = true;
      _googleError = null;
    });
    // Request SMS & Notifications
    final res = await _syncService.requestAllPermissions();
    _smsGranted = res['sms'] ?? false;
    _notifsGranted = res['notifications'] ?? false;

    // Connect Google Account if not yet connected. A Google Cloud OAuth
    // client is required; keep the sheet open so the error and setup help are
    // visible instead of silently continuing.
    if (!_emailConnected) {
      try {
        final profile = await _syncService.connectGoogleAccount();
        _emailConnected = true;
        _connectedEmail = profile.email;
        _profileName = profile.name;
        _profilePhoto = profile.photoUrl;
        widget.onProfileUpdated(profile);
      } on AppFailure catch (error) {
        if (!mounted) return;
        setState(() {
          _googleError = error.message;
          _isLoading = false;
        });
        return;
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _googleError =
              'Could not connect Google. Check your connection and try again.';
          _isLoading = false;
        });
        return;
      }
    } else if (_profileName != null) {
      widget.onProfileUpdated(
        UserProfileModel(
          name: _profileName!,
          email: _connectedEmail,
          photoUrl: _profilePhoto,
          isEmailConnected: _emailConnected,
          isSmsGranted: _smsGranted,
          isNotificationsGranted: _notifsGranted,
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pop();
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(widget.isDarkMode);
    final scale = OnyxScale.of(context);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            margin: EdgeInsets.all(scale.s(16)),
            padding: EdgeInsets.all(scale.s(22)),
            decoration: BoxDecoration(
              color: palette.modalSurface,
              borderRadius: BorderRadius.circular(scale.s(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: AppLogo(size: scale.s(48))),
                  SizedBox(height: scale.s(16)),

                  // Gold pill badge
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: scale.s(8),
                    runSpacing: scale.s(6),
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: scale.s(10),
                          vertical: scale.s(4),
                        ),
                        decoration: BoxDecoration(
                          color: palette.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: palette.gold.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          'SECURITY & PERMISSIONS',
                          style: OnyxTypography.mono(
                            fontSize: scale.s(9),
                            color: palette.gold,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      Text(
                        '100% On-Device',
                        style: OnyxTypography.mono(
                          fontSize: scale.s(9.5),
                          color: palette.mutedText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: scale.s(12)),

                  // Title
                  Text(
                    'Setup Smart Sync',
                    style: OnyxTypography.editorial(
                      fontSize: scale.s(26),
                      fontWeight: FontWeight.w600,
                      color: palette.primaryText,
                    ),
                  ),
                  SizedBox(height: scale.s(6)),
                  Text(
                    'To automate card spend detection and statement import, Onyx requires local read access.',
                    style: OnyxTypography.sans(
                      fontSize: scale.s(12),
                      color: palette.mutedText,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: scale.s(18)),

                  // Permission Item 1: SMS
                  _PermissionCard(
                    icon: Icons.sms_outlined,
                    title: 'SMS Spend Reading',
                    description: 'Automatically parses OTP-free bank debit SMS to track card transactions in real-time.',
                    isGranted: _smsGranted,
                    grantedLabel: 'SMS Granted',
                    actionLabel: 'Allow SMS',
                    onTap: _requestSms,
                    palette: palette,
                    scale: scale,
                  ),
                  SizedBox(height: scale.s(10)),

                  // Permission Item 2: Email (Gmail)
                  _PermissionCard(
                    icon: Icons.mark_email_read_outlined,
                    title: 'Email & Statement Access',
                    description: _emailConnected
                        ? 'Connected as ${_connectedEmail ?? 'Google Account'}. Name & profile photo synced.'
                        : 'Connect Gmail to import e-statements and sync your profile photo.',
                    isGranted: _emailConnected,
                    grantedLabel: _connectedEmail != null
                        ? 'Connected (${_connectedEmail!.split('@').first})'
                        : 'Connected',
                    actionLabel: 'Connect Gmail',
                    onTap: _connectEmail,
                    palette: palette,
                    scale: scale,
                  ),
                  if (_googleError != null) ...[
                    SizedBox(height: scale.s(6)),
                    Container(
                      padding: EdgeInsets.all(scale.s(10)),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(scale.s(9)),
                        border: Border.all(
                          color: const Color(0xFFEF4444)
                              .withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        _googleError!,
                        style: OnyxTypography.mono(
                          fontSize: scale.s(9.5),
                          color: const Color(0xFFF87171),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => showGoogleSetupHelpDialog(
                        context: context,
                        isDarkMode: widget.isDarkMode,
                      ),
                      icon: Icon(Icons.help_outline_rounded, size: scale.s(13)),
                      label: Text(
                        'Google sign-in setup help',
                        style: OnyxTypography.mono(
                          fontSize: scale.s(9.5),
                          color: palette.mutedText,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: scale.s(4),
                          vertical: scale.s(2),
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  SizedBox(height: scale.s(10)),

                  // Permission Item 3: Notifications
                  _PermissionCard(
                    icon: Icons.notifications_active_outlined,
                    title: 'Payment & Due Alerts',
                    description: 'Receive timely reminders before bill due dates to avoid interest and late fees.',
                    isGranted: _notifsGranted,
                    grantedLabel: 'Alerts Enabled',
                    actionLabel: 'Enable Alerts',
                    onTap: _requestSms,
                    palette: palette,
                    scale: scale,
                  ),
                  SizedBox(height: scale.s(20)),

                  // CTA Button
                  SizedBox(
                    height: scale.s(48),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _grantAllAndProceed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isDarkMode
                            ? palette.gold
                            : const Color(0xFF111113),
                        foregroundColor: widget.isDarkMode
                            ? const Color(0xFF111113)
                            : const Color(0xFFF8F7F4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(scale.s(12)),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: scale.s(20),
                              height: scale.s(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: widget.isDarkMode
                                    ? const Color(0xFF111113)
                                    : const Color(0xFFF8F7F4),
                              ),
                            )
                          : Text(
                              _smsGranted && _emailConnected
                                  ? 'Proceed to Dashboard'
                                  : 'Grant Permissions & Continue',
                              style: OnyxTypography.sans(
                                fontSize: scale.s(13),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: scale.s(10)),

                  // Skip option
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        widget.onSkip();
                      },
                      child: Text(
                        'Set up manually later',
                        style: OnyxTypography.mono(
                          fontSize: scale.s(10.5),
                          color: palette.mutedText,
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

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final String grantedLabel;
  final String actionLabel;
  final VoidCallback onTap;
  final OnyxPalette palette;
  final OnyxScale scale;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.grantedLabel,
    required this.actionLabel,
    required this.onTap,
    required this.palette,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(scale.s(14)),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(scale.s(12)),
        border: Border.all(
          color: isGranted
              ? palette.gold.withValues(alpha: 0.4)
              : palette.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: scale.s(36),
            height: scale.s(36),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isGranted
                  ? palette.gold.withValues(alpha: 0.15)
                  : palette.hoverFill,
            ),
            child: Icon(
              icon,
              size: scale.s(18),
              color: isGranted ? palette.gold : palette.mutedText,
            ),
          ),
          SizedBox(width: scale.s(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: OnyxTypography.sans(
                          fontSize: scale.s(13),
                          fontWeight: FontWeight.w600,
                          color: palette.primaryText,
                        ),
                      ),
                    ),
                    if (isGranted) ...[
                      SizedBox(width: scale.s(8)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: scale.s(14),
                            color: palette.gold,
                          ),
                          SizedBox(width: scale.s(4)),
                          Text(
                            'Active',
                            style: OnyxTypography.mono(
                              fontSize: scale.s(9),
                              color: palette.gold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                SizedBox(height: scale.s(4)),
                Text(
                  description,
                  style: OnyxTypography.sans(
                    fontSize: scale.s(11),
                    color: palette.mutedText,
                    height: 1.35,
                  ),
                ),
                if (!isGranted) ...[
                  SizedBox(height: scale.s(8)),
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: scale.s(10),
                        vertical: scale.s(5),
                      ),
                      decoration: BoxDecoration(
                        color: palette.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(scale.s(6)),
                        border: Border.all(
                          color: palette.gold.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Text(
                        actionLabel,
                        style: OnyxTypography.mono(
                          fontSize: scale.s(10),
                          fontWeight: FontWeight.w600,
                          color: palette.gold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

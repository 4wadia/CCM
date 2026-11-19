import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/onyx_theme.dart';

const String kAndroidPackageName = 'app.creditcardmanager';
const String kAndroidSigningSha1 =
    '09:7C:95:19:FE:C0:84:65:4A:43:B7:55:FE:04:D6:C9:BC:BF:EB:26';

/// Explains the one-time Google Cloud configuration required by the Android
/// Play-services authorization flow. The app cannot invent an OAuth client, so
/// failures should point users at this dialog instead of failing silently.
Future<void> showGoogleSetupHelpDialog({
  required BuildContext context,
  required bool isDarkMode,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.72),
    builder: (ctx) => _GoogleSetupHelpDialog(isDarkMode: isDarkMode),
  );
}

class _GoogleSetupHelpDialog extends StatelessWidget {
  final bool isDarkMode;

  const _GoogleSetupHelpDialog({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final palette = OnyxPalette(isDarkMode);
    final scale = OnyxScale.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: scale.s(18),
        vertical: scale.s(24),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          padding: EdgeInsets.all(scale.s(22)),
          decoration: BoxDecoration(
            color: palette.modalSurface,
            borderRadius: BorderRadius.circular(scale.s(22)),
            border: Border.all(color: palette.border),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: scale.s(38),
                      height: scale.s(38),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: palette.gold.withValues(alpha: 0.14),
                      ),
                      child: Icon(
                        Icons.key_rounded,
                        size: scale.s(19),
                        color: palette.gold,
                      ),
                    ),
                    SizedBox(width: scale.s(12)),
                    Expanded(
                      child: Text(
                        'Google sign-in setup',
                        style: OnyxTypography.editorial(
                          fontSize: scale.s(25),
                          fontWeight: FontWeight.w600,
                          color: palette.primaryText,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        size: scale.s(20),
                        color: palette.mutedText,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: scale.s(10)),
                Text(
                  'Google requires a one-time Android OAuth client before this '
                  'build can request Gmail access. The app uses Google Play '
                  'services, so no client secret is stored in the APK.',
                  style: OnyxTypography.sans(
                    fontSize: scale.s(12),
                    color: palette.mutedText,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: scale.s(14)),
                _CopyableValue(
                  label: 'PACKAGE NAME',
                  value: kAndroidPackageName,
                  palette: palette,
                  scale: scale,
                ),
                SizedBox(height: scale.s(8)),
                _CopyableValue(
                  label: 'SIGNING SHA-1',
                  value: kAndroidSigningSha1,
                  palette: palette,
                  scale: scale,
                ),
                SizedBox(height: scale.s(16)),
                Text(
                  'SETUP STEPS',
                  style: OnyxTypography.mono(
                    fontSize: scale.s(9.5),
                    color: palette.gold,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: scale.s(8)),
                _Step(
                  number: '1',
                  text:
                      'Open Google Cloud Console → APIs & Services → '
                      'Credentials.',
                  palette: palette,
                  scale: scale,
                ),
                _Step(
                  number: '2',
                  text:
                      'Create an Android OAuth client using the package name '
                      'and SHA-1 above.',
                  palette: palette,
                  scale: scale,
                ),
                _Step(
                  number: '3',
                  text:
                      'Enable the Gmail API for the same Google Cloud project.',
                  palette: palette,
                  scale: scale,
                ),
                _Step(
                  number: '4',
                  text:
                      'Configure the OAuth consent screen and add your Google '
                      'account as a test user while the app is in testing.',
                  palette: palette,
                  scale: scale,
                ),
                _Step(
                  number: '5',
                  text:
                      'Wait a few minutes, then return to Profile and tap '
                      'Connect Google Mail again.',
                  palette: palette,
                  scale: scale,
                ),
                SizedBox(height: scale.s(12)),
                Container(
                  padding: EdgeInsets.all(scale.s(12)),
                  decoration: BoxDecoration(
                    color: palette.cardSurface,
                    borderRadius: BorderRadius.circular(scale.s(10)),
                    border: Border.all(color: palette.border),
                  ),
                  child: Text(
                    'Using an APK signed with a different key? The SHA-1 must '
                    'match that APK. Check it with:\n'
                    'apksigner verify --print-certs <app.apk>',
                    style: OnyxTypography.mono(
                      fontSize: scale.s(9.5),
                      color: palette.subtleText,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: scale.s(14)),
                SizedBox(
                  height: scale.s(44),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? palette.gold
                          : const Color(0xFF111113),
                      foregroundColor: isDarkMode
                          ? const Color(0xFF111113)
                          : const Color(0xFFF8F7F4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(scale.s(10)),
                      ),
                    ),
                    child: Text(
                      'GOT IT',
                      style: OnyxTypography.mono(
                        fontSize: scale.s(10.5),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CopyableValue extends StatelessWidget {
  final String label;
  final String value;
  final OnyxPalette palette;
  final OnyxScale scale;

  const _CopyableValue({
    required this.label,
    required this.value,
    required this.palette,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: scale.s(12),
        vertical: scale.s(10),
      ),
      decoration: BoxDecoration(
        color: palette.cardSurface,
        borderRadius: BorderRadius.circular(scale.s(10)),
        border: Border.all(color: palette.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: OnyxTypography.mono(
                    fontSize: scale.s(8.5),
                    color: palette.subtleText,
                    letterSpacing: 0.9,
                  ),
                ),
                SizedBox(height: scale.s(3)),
                SelectableText(
                  value,
                  style: OnyxTypography.mono(
                    fontSize: scale.s(10.5),
                    color: palette.primaryText,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: scale.s(6)),
          IconButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: value));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$label copied'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            tooltip: 'Copy $label',
            icon: Icon(
              Icons.copy_rounded,
              size: scale.s(16),
              color: palette.gold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  final OnyxPalette palette;
  final OnyxScale scale;

  const _Step({
    required this.number,
    required this.text,
    required this.palette,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: scale.s(7)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: scale.s(20),
            height: scale.s(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.gold.withValues(alpha: 0.14),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: OnyxTypography.mono(
                fontSize: scale.s(9),
                fontWeight: FontWeight.w700,
                color: palette.gold,
              ),
            ),
          ),
          SizedBox(width: scale.s(9)),
          Expanded(
            child: Text(
              text,
              style: OnyxTypography.sans(
                fontSize: scale.s(11.5),
                color: palette.mutedText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

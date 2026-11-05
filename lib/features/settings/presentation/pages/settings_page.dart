import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      key: Key('settings-page'),
      title: 'Settings',
      description:
          'Gmail connections, sync preferences, permissions, backup and restore, '
          'and privacy controls will appear here.',
      icon: Icons.settings_outlined,
    );
  }
}

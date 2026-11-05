import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      key: Key('home-page'),
      title: 'Home',
      description:
          'Combined limits, utilisation, recent activity, and upcoming payments '
          'will appear here.',
      icon: Icons.dashboard_outlined,
    );
  }
}

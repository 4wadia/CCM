import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_view.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      key: Key('rewards-page'),
      title: 'Rewards',
      description: 'Cashback, reward points, expiry, and estimated value will appear here.',
      icon: Icons.stars_outlined,
    );
  }
}

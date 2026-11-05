import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_view.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      key: Key('cards-page'),
      title: 'Cards',
      description:
          'Add and manage credit cards, limits, billing cycles, and archive '
          'status here.',
      icon: Icons.credit_card_outlined,
    );
  }
}

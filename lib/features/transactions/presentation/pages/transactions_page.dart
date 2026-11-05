import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_view.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderView(
      key: Key('transactions-page'),
      title: 'Transactions',
      description:
          'Manual entry, imported transactions, filters, and the review queue '
          'will appear here.',
      icon: Icons.receipt_long_outlined,
    );
  }
}

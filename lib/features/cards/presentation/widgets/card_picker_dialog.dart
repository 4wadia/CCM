import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../domain/entities/credit_card.dart';
import '../providers/card_providers.dart';

/// Returns the chosen active card ID, or null if cancelled.
Future<String?> showCardPickerDialog(
  BuildContext context,
  WidgetRef ref, {
  String? selectedId,
}) async {
  final cards = await ref.read(creditCardsProvider.future);
  final active = cards.where((card) => card.isActive).toList(growable: false);
  if (!context.mounted) return null;
  if (active.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add an active card first.')));
    return null;
  }
  return showDialog<String>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Choose a card'),
      children: [
        for (final card in active)
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, card.id),
            child: Row(
              children: [
                Icon(
                  selectedId == card.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.displayName),
                      Text(
                        '•••• ${card.lastFour} · ${card.currencyCode}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

String cardLabel(CreditCard? card) {
  if (card == null) return 'No card';
  return '${card.displayName} •••• ${card.lastFour}';
}

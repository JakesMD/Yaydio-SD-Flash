import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/ui/views/decks/decks_pane.dart';
import 'package:yaydio_sd_flash/ui/views/decks/select_albums_pane.dart';
import 'package:yaydio_sd_flash/ui/views/decks/selected_deck_pane.dart';

/// {@template YYDecksView}
///
/// A view that displays a list of decks and allows the user to select a deck.
///
/// {@endtemplate}
class YDecksView extends StatelessWidget {
  /// {@macro YYDecksView}
  const YDecksView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 8,
      crossAxisAlignment: .stretch,
      children: [
        Expanded(child: YDecksPane()),
        Expanded(
          flex: 2,
          child: Column(
            spacing: 8,
            children: [
              Expanded(flex: 2, child: YSelectedDeckPane()),
              Expanded(child: YSelectAlbumsPane()),
            ],
          ),
        ),
      ],
    );
  }
}

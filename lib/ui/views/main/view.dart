import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/views/_views.dart';

/// {@template YMainView}
///
/// The main view of the application, which contains the navigation and main
/// content.
///
/// {@endtemplate}
class YMainView extends StatelessWidget {
  /// {@macro YMainView}
  const YMainView({
    required this.selectedIndex,
    required this.onIndexChanged,
    super.key,
  });

  /// The index of the currently selected navigation destination.
  final int selectedIndex;

  /// Called when the user selects a navigation destination.
  final void Function(int) onIndexChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.album_rounded),
                label: Text('Albums'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sd_card_rounded),
                label: Text('Decks'),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: onIndexChanged,
          ),
          Expanded(
            child: Padding(
              padding: const .all(8),
              child: selectedIndex == 0
                  ? const YAlbumsView()
                  : const YDecksView(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text(selectedIndex == 0 ? 'New album' : 'New deck'),
        icon: const Icon(Icons.add),
        onPressed: selectedIndex == 0
            ? () => context.read<YAlbumsManagerCubit>().addAlbum()
            : () => context.read<YDecksManagerCubit>().addDeck(),
      ),
    );
  }
}

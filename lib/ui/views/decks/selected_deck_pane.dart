import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/views/decks/deck_album_tile.dart';
import 'package:yaydio_sd_flash/ui/views/decks/formatted_confirm_dialog.dart';
import 'package:yaydio_sd_flash/ui/widgets/_widgets.dart';

/// {@template YSelectedDeckPane}
///
/// A pane that displays the selected deck and allows the user to edit it.
///
/// {@endtemplate}
class YSelectedDeckPane extends StatelessWidget {
  /// {@macro YSelectedDeckPane}
  const YSelectedDeckPane({super.key});

  Future<void> _onWritePressed(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const YFormattedConfirmDialog(),
    );

    if (result != true || !context.mounted) return;

    await context.read<YDeckWriterCubit>().writeDeck(
      context.read<YDecksManagerCubit>().state.selectedDeck!,
      context.read<YAlbumsManagerCubit>().state.albums,
    );
  }

  @override
  Widget build(BuildContext context) {
    final decksCubit = context.watch<YDecksManagerCubit>();
    final albumsCubit = context.watch<YAlbumsManagerCubit>();
    final state = decksCubit.state;

    if (state.selectedDeck == null) {
      return YPane(
        child: Center(
          child: Text(
            'Select a deck to edit its albums.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return YPane(
      title: YEditablePaneTitle(
        id: state.selectedDeck!.id,
        initialValue: state.selectedDeck!.name,
        hint: 'Deck name',
        onChanged: decksCubit.renameSelectedDeck,
        onDeletePressed: decksCubit.deleteSelectedDeck,
      ),
      actions: [
        FilledButton.tonalIcon(
          label: const Text('Write deck to SD card'),
          icon: const Icon(Icons.sd_card),
          onPressed: () => _onWritePressed(context),
        ),
      ],
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: decksCubit.reorderAlbums,
        itemCount: state.selectedDeck?.albumIDs.length ?? 0,
        itemBuilder: (context, index) => YDeckAlbumTile(
          album: albumsCubit.fetchAlbum(state.selectedDeck!.albumIDs[index]),
          index: index,
        ),
      ),
    );
  }
}

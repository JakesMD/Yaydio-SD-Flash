import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/widgets/_widgets.dart';

/// {@template YSelectAlbumsPane}
///
/// A pane that displays a list of albums and allows the user to select which
/// albums are in the selected deck.
///
/// {@endtemplate}
class YSelectAlbumsPane extends StatelessWidget {
  /// {@macro YSelectAlbumsPane}
  const YSelectAlbumsPane({super.key});

  @override
  Widget build(BuildContext context) {
    final decksState = context.watch<YDecksManagerCubit>().state;
    final albumsState = context.watch<YAlbumsManagerCubit>().state;

    if (decksState.selectedDeck == null) return const YPane(child: SizedBox());

    return YPane(
      child: ListView.builder(
        itemCount: albumsState.albums.length,
        itemBuilder: (context, index) => CheckboxListTile(
          title: Text(albumsState.albums[index].name),
          value: decksState.selectedDeck!.albumIDs.contains(
            albumsState.albums[index].id,
          ),
          onChanged: (value) => value ?? false
              ? context.read<YDecksManagerCubit>().addAlbum(
                  albumsState.albums[index].id,
                )
              : context.read<YDecksManagerCubit>().deleteAlbum(
                  albumsState.albums[index].id,
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/models/_models.dart';

/// {@template YDeckAlbumTile}
///
/// A tile that displays an album in a deck and allows the user to reorder or
/// delete it.
///
/// {@endtemplate}
class YDeckAlbumTile extends StatelessWidget {
  /// {@macro YDeckAlbumTile}
  YDeckAlbumTile({required this.album, required this.index})
    : super(key: Key(album.id));

  /// The album to display.
  final YAlbum album;

  /// The index of the album in the deck.
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(album.name),
      subtitle: Text((index + 1).toString().padLeft(4, '0')),
      leading: ReorderableDragStartListener(
        index: index,
        child: const MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Icon(Icons.drag_handle_rounded),
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () =>
            context.read<YDecksManagerCubit>().deleteAlbum(album.id),
      ),
    );
  }
}

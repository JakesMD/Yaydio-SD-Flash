import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/models/_models.dart';

/// {@template YAlbumTrackTile}
///
/// A tile that displays a track in an album and allows the user to reorder or
/// delete it.
///
/// {@endtemplate}
class YAlbumTrackTile extends StatelessWidget {
  /// {@macro YAlbumTrackTile}
  YAlbumTrackTile({required this.track, required this.index})
    : super(key: Key(track.id));

  /// The track to display.
  final Track track;

  /// The index of the track in the album.
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.name),
      subtitle: Text((index + 1).toString().padLeft(3, '0')),
      leading: ReorderableDragStartListener(
        index: index,
        child: const MouseRegion(
          cursor: SystemMouseCursors.grab,
          child: Icon(Icons.drag_handle_rounded),
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_rounded),
        onPressed: () => context.read<YAlbumsManagerCubit>().deleteTrack(index),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/views/albums/album_track_tile.dart';
import 'package:yaydio_sd_flash/ui/widgets/_widgets.dart';

/// {@template YSelectedAlbumPane}
///
/// A pane that allows the user to edit the selected album.
///
/// The user can rename the album, delete the album, reorder tracks, delete
/// tracks, and add tracks.
///
/// {@endtemplate}
class YSelectedAlbumPane extends StatelessWidget {
  /// {@macro YSelectedAlbumPane}
  const YSelectedAlbumPane({super.key});

  DropOperation _onDropOver(DropOverEvent event) {
    final hasMP3 = event.session.items.any(
      (item) => item.canProvide(Formats.mp3),
    );
    if (hasMP3) return DropOperation.copy;
    return DropOperation.forbidden;
  }

  Future<void> _onPerformDrop(
    PerformDropEvent event,
    YTrackCopyCubit trackCopyCubit,
    String albumID,
  ) async {
    for (final item in event.session.items) {
      final reader = item.dataReader!;
      if (!reader.canProvide(Formats.mp3)) continue;

      reader.getFile(Formats.mp3, (file) {
        trackCopyCubit.addTrackToQueue(
          file.fileName ?? 'Unknown Track',
          file.getStream(),
          albumID,
        );
      });
    }

    unawaited(trackCopyCubit.processQueue());
  }

  @override
  Widget build(BuildContext context) {
    final albumsCubit = context.watch<YAlbumsManagerCubit>();
    final trackCopyCubit = context.watch<YTrackCopyCubit>();
    final state = albumsCubit.state;

    if (state.selectedAlbum == null) {
      return YPane(
        child: Center(
          child: Text(
            'Select an album to edit its tracks.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return DropRegion(
      formats: const [Formats.fileUri],
      onDropOver: _onDropOver,
      onPerformDrop: (e) =>
          _onPerformDrop(e, trackCopyCubit, state.selectedAlbum!.id),
      child: YPane(
        title: YEditablePaneTitle(
          id: state.selectedAlbum!.id,
          initialValue: state.selectedAlbum!.name,
          hint: 'Album name',
          onChanged: albumsCubit.renameSelectedAlbum,
          onDeletePressed: albumsCubit.deleteSelectedAlbum,
        ),
        actions: [
          Text(
            trackCopyCubit.state.isCopying
                ? '''Copying ${trackCopyCubit.state.tracksToCopy.length} track(s)...'''
                : 'Drag and drop .mp3 files here.',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ],
        child: ReorderableListView.builder(
          buildDefaultDragHandles: false,
          onReorder: albumsCubit.reorderTracks,
          itemCount: state.selectedAlbum!.tracks.length,
          itemBuilder: (context, index) => YAlbumTrackTile(
            track: state.selectedAlbum!.tracks[index],
            index: index,
          ),
        ),
      ),
    );
  }
}

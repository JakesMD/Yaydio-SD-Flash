import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/globals.dart';

class _YTrackToCopy {
  _YTrackToCopy({
    required this.name,
    required this.dataStream,
    required this.albumID,
  }) : id = yUuid.v4();

  final String name;
  final String id;
  final Stream<Uint8List> dataStream;
  final String albumID;
}

/// {@template YTrackCopyState}
///
/// The state for the [YTrackCopyCubit].
///
/// {@endtemplate}
class YTrackCopyState with EquatableMixin {
  /// {@macro YTrackCopyState}
  const YTrackCopyState({required this.tracksToCopy, this.isCopying = false});

  /// The list of tracks that are currently queued to be copied.
  // ignore: library_private_types_in_public_api
  final List<_YTrackToCopy> tracksToCopy;

  /// Whether the copy process is currently active.
  final bool isCopying;

  YTrackCopyState _copyWith({
    List<_YTrackToCopy>? tracksToCopy,
    bool? isCopying,
  }) {
    return YTrackCopyState(
      tracksToCopy: tracksToCopy ?? this.tracksToCopy,
      isCopying: isCopying ?? this.isCopying,
    );
  }

  @override
  List<Object?> get props => [tracksToCopy, isCopying];
}

/// {@template YTrackCopyCubit}
///
/// Cubit that manages the queue of tracks to be copied and handles the copying
/// process.
///
/// {@endtemplate}
class YTrackCopyCubit extends Cubit<YTrackCopyState> {
  /// {@macro YTrackCopyCubit}
  YTrackCopyCubit({required this.onTrackSaved, required this.onCopyFailed})
    : super(const YTrackCopyState(tracksToCopy: []));

  /// Callback that is called when a track has been successfully saved.
  final void Function(String id, String name) onTrackSaved;

  /// Callback that is called when a track fails to copy.
  final void Function(String name) onCopyFailed;

  /// Adds a track to the copy queue.
  void addTrackToQueue(
    String name,
    Stream<Uint8List> dataStream,
    String albumID,
  ) {
    final newFiles = List.of(
      state.tracksToCopy,
    )..add(_YTrackToCopy(name: name, dataStream: dataStream, albumID: albumID));
    emit(state._copyWith(tracksToCopy: newFiles));
  }

  /// Removes all tracks from the copy queue that belong to the specified album.
  void removeAlbumFromQueue(String albumID) {
    final updatedFiles = state.tracksToCopy
        .where((file) => file.albumID != albumID)
        .toList();

    emit(state._copyWith(tracksToCopy: updatedFiles));
  }

  /// Processes the copy queue, copying each track to the appropriate location
  /// and calling the [onTrackSaved] callback for each successfully copied
  /// track.
  Future<void> processQueue() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));

    if (state.isCopying) return;

    emit(state._copyWith(isCopying: true));

    while (state.tracksToCopy.isNotEmpty) {
      await Future<dynamic>.delayed(const Duration(milliseconds: 100));

      final file = state.tracksToCopy.first;
      final albumDir = yAlbumDir(file.albumID);

      try {
        if (!albumDir.existsSync()) await albumDir.create(recursive: true);

        final outputFile = yTrackFile(file.albumID, file.id);
        await outputFile.openWrite().addStream(file.dataStream);
        onTrackSaved(file.id, file.name);
      } catch (e) {
        onCopyFailed(file.name);
      }

      emit(
        state._copyWith(tracksToCopy: List.of(state.tracksToCopy)..removeAt(0)),
      );
    }

    emit(state._copyWith(isCopying: false));
  }
}

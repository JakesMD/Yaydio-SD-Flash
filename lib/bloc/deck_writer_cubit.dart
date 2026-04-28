import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:mallard/mallard.dart';
import 'package:mallard_bloc/mallard_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/globals.dart';
import 'package:yaydio_sd_flash/models/_models.dart';

/// {@template YDeckWriterState}
///
/// State for [YDeckWriterCubit].
///
/// {@endtemplate}
class YDeckWriterState extends TaskBlocState<Nothing, String> {
  /// {@macro YDeckWriterState}
  YDeckWriterState.initial()
    : progress = 0.0,
      deck = null,
      destinationDir = null,
      super.initial();

  /// {@macro YDeckWriterState}
  YDeckWriterState.inProgress({
    required this.progress,
    required this.deck,
    required this.destinationDir,
  }) : super.inProgress();

  /// {@macro YDeckWriterState}
  YDeckWriterState.completed(super.result)
    : progress = 0.0,
      deck = null,
      destinationDir = null,
      super.completed();

  /// Progress of the deck writing process, between 0 and 1.
  final double progress;

  /// The deck being written.
  final YDeck? deck;

  /// The destination directory where the deck is being written to.
  final String? destinationDir;

  @override
  List<Object?> get props =>
      super.props..addAll([progress, deck, destinationDir]);
}

/// {@template YDeckWriterCubit}
///
/// Cubit responsible for writing a [YDeck] to an SD card.
///
/// {@endtemplate}
class YDeckWriterCubit extends Cubit<YDeckWriterState> {
  /// {@macro YDeckWriterCubit}
  YDeckWriterCubit() : super(.initial());

  /// Writes the given [deck] to an SD card, using the provided [allAlbums] to
  /// find the tracks to write.
  Future<void> writeDeck(YDeck deck, List<YAlbum> allAlbums) async {
    if (state.isInProgress) return;

    try {
      await FilePicker.skipEntitlementsChecks();
      final destinationDir = await FilePicker.getDirectoryPath(
        dialogTitle: 'Select the SD card',
      );

      if (destinationDir == null) return;

      final copiedAlbums = List.of(allAlbums);

      final totalTracks = deck.albumIDs
          .map((id) => allAlbums.firstWhere((a) => a.id == id).tracks.length)
          .reduce((a, b) => a + b);

      var copiedTracks = 0;

      emit(
        .inProgress(progress: 0, deck: deck, destinationDir: destinationDir),
      );

      for (
        var albumIndex = 0;
        albumIndex < deck.albumIDs.length;
        albumIndex++
      ) {
        final albumID = deck.albumIDs[albumIndex];
        final album = copiedAlbums.firstWhere((a) => a.id == albumID);
        final albumDir = Directory(
          path.join(
            destinationDir,
            (albumIndex + 1).toString().padLeft(4, '0'),
          ),
        );

        await albumDir.create(recursive: true);

        for (
          var trackIndex = 0;
          trackIndex < album.tracks.length;
          trackIndex++
        ) {
          final track = album.tracks[trackIndex];
          final trackFile = yTrackFile(albumID, track.id);

          if (trackFile.existsSync()) {
            await trackFile.copy(
              path.join(
                albumDir.path,
                '${(trackIndex + 1).toString().padLeft(3, '0')}.mp3',
              ),
            );
            copiedTracks++;
            emit(
              .inProgress(
                progress: copiedTracks / totalTracks,
                deck: deck,
                destinationDir: destinationDir,
              ),
            );
          }
        }
      }
      if (Platform.isMacOS) {
        var result = await Process.run('dot_clean', ['-mv', destinationDir]);
        if (result.exitCode != 0) throw Exception(result.stderr);
        result = await Process.run(
          '/usr/sbin/diskutil',
          ['unmount', destinationDir],
        );
        if (result.exitCode != 0) throw Exception(result.stderr);
      }
      emit(.completed(const Success(nothing)));
    } catch (e) {
      emit(.completed(Failure(e.toString())));
    }
  }

  /// Resets the cubit to its initial state.
  void reset() {
    if (state.isInProgress) return;
    emit(.initial());
  }
}

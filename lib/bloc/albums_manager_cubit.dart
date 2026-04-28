import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mallard/mallard.dart';
import 'package:yaydio_sd_flash/globals.dart';
import 'package:yaydio_sd_flash/models/album.dart';
import 'package:yaydio_sd_flash/models/track.dart';

/// {@template YAlbumsManagerCubit}
///
/// The state for the [YAlbumsManagerCubit].
///
/// {@endtemplate}
class YAlbumsManagerState with EquatableMixin {
  /// {@macro YAlbumsManagerCubit}
  const YAlbumsManagerState({required this.albums, this.selectedIndex});

  /// The list of albums.
  final List<YAlbum> albums;

  /// The index of the currently selected album, or null if no album is
  /// selected.
  final int? selectedIndex;

  /// The currently selected album, or null if no album is selected.
  YAlbum? get selectedAlbum =>
      selectedIndex != null ? albums[selectedIndex!] : null;

  YAlbumsManagerState _copyWith({
    List<YAlbum>? albums,
    Maybe<int>? selectedIndex,
  }) => YAlbumsManagerState(
    albums: albums ?? this.albums,
    selectedIndex: selectedIndex != null
        ? selectedIndex.asNullable
        : this.selectedIndex,
  );

  @override
  List<Object?> get props => [albums, selectedAlbum];
}

/// {@template YAlbumsManagerCubit}
///
/// Cubit that manages the list of albums and the currently selected album.
///
/// {@endtemplate}
class YAlbumsManagerCubit extends HydratedCubit<YAlbumsManagerState> {
  /// {@macro YAlbumsManagerCubit}
  YAlbumsManagerCubit({
    required this.onAlbumDeleted,
    required this.onDeleteFailed,
  }) : super(const YAlbumsManagerState(albums: []));

  /// Callback that is called when an album is deleted.
  final void Function(String albumID) onAlbumDeleted;

  /// Callback that is called when deleting an album fails.
  final void Function(String error) onDeleteFailed;

  /// Selects the album at the given index.
  void selectAlbum(int index) =>
      emit(state._copyWith(selectedIndex: present(index)));

  /// Adds a new album with a default name and an empty list of tracks, then
  /// selects it.
  void addAlbum() {
    final newAlbum = YAlbum(id: yUuid.v4(), name: 'New Album', tracks: []);
    final updatedAlbums = List.of(state.albums)
      ..add(newAlbum)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    emit(
      state._copyWith(
        albums: updatedAlbums,
        selectedIndex: present(updatedAlbums.indexOf(newAlbum)),
      ),
    );
  }

  /// Renames the currently selected album to the given name.
  void renameSelectedAlbum(String newName) {
    if (state.selectedIndex == null) return;

    var trimmedNewName = newName.trim();
    if (trimmedNewName.isEmpty) trimmedNewName = 'Untitled Album';
    final updatedAlbum = state.selectedAlbum!.copyWith(name: trimmedNewName);

    emit(_updateSelectedAlbum(updatedAlbum));
  }

  /// Deselects and deletes the currently selected album.
  Future<void> deleteSelectedAlbum() async {
    if (state.selectedIndex == null) return;

    final updatedAlbums = List.of(state.albums)..removeAt(state.selectedIndex!);
    final albumDir = yAlbumDir(state.selectedAlbum!.id);

    try {
      if (albumDir.existsSync()) await albumDir.delete(recursive: true);
      onAlbumDeleted(state.selectedAlbum!.id);
      emit(state._copyWith(albums: updatedAlbums, selectedIndex: absent()));
    } catch (e) {
      onDeleteFailed(e.toString());
    }
  }

  /// Reorders the tracks in the currently selected album by moving the track at
  /// [oldIndex] to [newIndex].
  void reorderTracks(int oldIndex, int newIndex) {
    if (state.selectedIndex == null) return;

    var index = newIndex;
    if (oldIndex < newIndex) index -= 1;
    final track = state.selectedAlbum!.tracks.removeAt(oldIndex);
    state.selectedAlbum!.tracks.insert(index, track);

    emit(state._copyWith(albums: List.from(state.albums)));
  }

  /// Deletes the track at the given index from the currently selected album.
  Future<void> deleteTrack(int index) async {
    if (state.selectedIndex == null) return;

    final file = yTrackFile(
      state.selectedAlbum!.id,
      state.selectedAlbum!.tracks[index].id,
    );
    if (file.existsSync()) await file.delete();

    final updatedTracks = List.of(state.selectedAlbum!.tracks)..removeAt(index);
    final updatedAlbum = state.selectedAlbum!.copyWith(tracks: updatedTracks);

    emit(_updateSelectedAlbum(updatedAlbum));
  }

  /// Adds a new track with the given file name and data to the currently
  /// selected album.
  Future<void> addTrack(String id, String name) async {
    if (state.selectedIndex == null) return;

    final newTrack = Track(id: id, name: name);
    final updatedTracks = List.of(state.selectedAlbum!.tracks)..add(newTrack);
    final updatedAlbum = state.selectedAlbum!.copyWith(tracks: updatedTracks);

    emit(_updateSelectedAlbum(updatedAlbum));
  }

  /// Fetches the album with the given ID from the list of albums.
  YAlbum fetchAlbum(String id) =>
      state.albums.firstWhere((album) => album.id == id);

  @override
  YAlbumsManagerState? fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('albums')) return null;

    return YAlbumsManagerState(
      albums: (json['albums'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (albumJson) => YAlbum(
              id: albumJson['id'] as String,
              name: albumJson['name'] as String,
              tracks: (albumJson['tracks'] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .map(
                    (tj) => Track(
                      id: tj['id'] as String,
                      name: tj['name'] as String,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(YAlbumsManagerState state) => {
    'albums': state.albums
        .map(
          (album) => {
            'id': album.id,
            'name': album.name,
            'tracks': album.tracks
                .map((track) => {'id': track.id, 'name': track.name})
                .toList(),
          },
        )
        .toList(),
  };

  YAlbumsManagerState _updateSelectedAlbum(YAlbum updatedAlbum) {
    final updatedAlbums = List.of(state.albums);
    updatedAlbums[state.selectedIndex!] = updatedAlbum;
    updatedAlbums.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return state._copyWith(
      albums: updatedAlbums,
      selectedIndex: present(updatedAlbums.indexOf(updatedAlbum)),
    );
  }

  @override
  String get storagePrefix => 'YAlbumsManagerCubit';
}

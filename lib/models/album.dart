import 'package:equatable/equatable.dart';
import 'package:yaydio_sd_flash/models/track.dart';

/// {@template YAlbum}
///
/// Represents a music album, which contains a list of tracks.
///
/// {@endtemplate}
class YAlbum with EquatableMixin {
  /// {@macro YAlbum}
  YAlbum({required this.id, required this.name, required this.tracks});

  /// The unique identifier for the album.
  ///
  /// This is used to associate decks with albums.
  final String id;

  /// The name of the album.
  final String name;

  /// The list of tracks in the album.
  final List<Track> tracks;

  /// Creates a copy of this album with the given fields replaced by new values.
  YAlbum copyWith({String? name, List<Track>? tracks}) =>
      YAlbum(id: id, name: name ?? this.name, tracks: tracks ?? this.tracks);

  @override
  List<Object?> get props => [id, name, tracks];
}

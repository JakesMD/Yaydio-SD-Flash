import 'package:equatable/equatable.dart';

/// {@template YTrack}
///
/// Represents a music track, which is a single song or piece of music.
///
/// {@endtemplate}
class Track with EquatableMixin {
  /// {@macro YTrack}
  Track({required this.id, required this.name});

  /// The unique identifier for the track.
  ///
  /// This is used instead of the name in case multiple tracks have the same
  /// name.
  final String id;

  /// The name of the track.
  final String name;

  @override
  List<Object?> get props => [id, name];
}

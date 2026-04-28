import 'package:equatable/equatable.dart';

/// {@template YDeck}
///
/// Represents a deck, which is a collection of albums that can be written to an
/// SD card.
///
/// {@endtemplate}
class YDeck with EquatableMixin {
  /// {@macro YDeck}
  YDeck({required this.id, required this.name, required this.albumIDs});

  /// The unique identifier for the deck.
  ///
  /// This is used instead of the name in case multiple decks have the same
  /// name.
  final String id;

  /// The name of the deck.
  final String name;

  /// The list of album IDs associated with this deck.
  final List<String> albumIDs;

  /// Creates a copy of this deck with the given fields replaced by new values.
  YDeck copyWith({String? name, List<String>? albumIDs}) => YDeck(
    id: id,
    name: name ?? this.name,
    albumIDs: albumIDs ?? this.albumIDs,
  );

  @override
  List<Object?> get props => [id, name, albumIDs];
}

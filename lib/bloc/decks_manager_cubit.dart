import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mallard/mallard.dart';
import 'package:yaydio_sd_flash/globals.dart';
import 'package:yaydio_sd_flash/models/deck.dart';

/// {@template YDecksManagerCubit}
///
/// The state for the [YDecksManagerCubit].
///
/// {@endtemplate}
class YDecksManagerState with EquatableMixin {
  /// {@macro YDecksManagerCubit}
  const YDecksManagerState({required this.decks, this.selectedIndex});

  /// The list of decks.
  final List<YDeck> decks;

  /// The index of the currently selected deck, or null if no deck is
  /// selected.
  final int? selectedIndex;

  /// The currently selected deck, or null if no deck is selected.
  YDeck? get selectedDeck =>
      selectedIndex != null ? decks[selectedIndex!] : null;

  YDecksManagerState _copyWith({
    List<YDeck>? decks,
    Maybe<int>? selectedIndex,
  }) => YDecksManagerState(
    decks: decks ?? this.decks,
    selectedIndex: selectedIndex != null
        ? selectedIndex.asNullable
        : this.selectedIndex,
  );

  @override
  List<Object?> get props => [decks, selectedDeck];
}

/// {@template YDecksManagerCubit}
///
/// Cubit that manages the list of decks and the currently selected deck.
///
/// {@endtemplate}
class YDecksManagerCubit extends HydratedCubit<YDecksManagerState> {
  /// {@macro YDecksManagerCubit}
  YDecksManagerCubit() : super(const YDecksManagerState(decks: []));

  /// Selects the deck at the given index.
  void selectDeck(int index) =>
      emit(state._copyWith(selectedIndex: present(index)));

  /// Adds a new deck with a default name and an empty list of albums, then
  /// selects it.
  void addDeck() {
    final newDeck = YDeck(id: yUuid.v4(), name: 'New Deck', albumIDs: []);
    final updatedDecks = List.of(state.decks)
      ..add(newDeck)
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    emit(
      state._copyWith(
        decks: updatedDecks,
        selectedIndex: present(updatedDecks.indexOf(newDeck)),
      ),
    );
  }

  /// Renames the currently selected deck.
  void renameSelectedDeck(String newName) {
    if (state.selectedDeck == null) return;

    final updatedDeck = state.selectedDeck!.copyWith(name: newName);

    emit(_updateSelectedDeck(updatedDeck));
  }

  /// Deletes the currently selected deck.
  void deleteSelectedDeck() {
    if (state.selectedDeck == null) return;

    final updatedDecks = List.of(state.decks)..removeAt(state.selectedIndex!);
    emit(state._copyWith(decks: updatedDecks, selectedIndex: absent()));
  }

  /// Reorders the albums in the currently selected deck by moving the album at
  /// [oldIndex] to [newIndex].
  void reorderAlbums(int oldIndex, int newIndex) {
    if (state.selectedDeck == null) return;

    var index = newIndex;
    if (oldIndex < newIndex) index -= 1;
    final albumID = state.selectedDeck!.albumIDs.removeAt(oldIndex);
    state.selectedDeck!.albumIDs.insert(index, albumID);

    emit(state);
  }

  /// Adds the album with the given ID to the currently selected deck.
  void addAlbum(String albumID) {
    if (state.selectedDeck == null) return;

    final updatedAlbums = List.of(state.selectedDeck!.albumIDs)..add(albumID);
    final updatedDeck = state.selectedDeck!.copyWith(albumIDs: updatedAlbums);

    emit(_updateSelectedDeck(updatedDeck));
  }

  /// Deletes the album with the given ID from the currently selected deck.
  Future<void> deleteAlbum(String albumID) async {
    if (state.selectedDeck == null) return;

    final updatedAlbums = List.of(state.selectedDeck!.albumIDs)
      ..remove(albumID);
    final updatedDeck = state.selectedDeck!.copyWith(albumIDs: updatedAlbums);

    emit(_updateSelectedDeck(updatedDeck));
  }

  /// Deletes the album with the given ID from all decks.
  void deleteAlbumFromAllDecks(String albumID) {
    final updatedDecks = state.decks.map((deck) {
      if (!deck.albumIDs.contains(albumID)) return deck;

      final updatedAlbumIDs = List.of(deck.albumIDs)..remove(albumID);
      return deck.copyWith(albumIDs: updatedAlbumIDs);
    }).toList();

    emit(state._copyWith(decks: updatedDecks));
  }

  @override
  YDecksManagerState? fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('decks')) return null;

    return YDecksManagerState(
      decks: (json['decks'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (deckJson) => YDeck(
              id: deckJson['id'] as String,
              name: deckJson['name'] as String,
              albumIDs: deckJson['albumIDs'] as List<String>,
            ),
          )
          .toList(),
    );
  }

  @override
  Map<String, dynamic>? toJson(YDecksManagerState state) => {
    'decks': state.decks
        .map(
          (deck) => {
            'id': deck.id,
            'name': deck.name,
            'albumIDs': deck.albumIDs,
          },
        )
        .toList(),
  };

  YDecksManagerState _updateSelectedDeck(YDeck updatedDeck) {
    final updatedDecks = List.of(state.decks);
    updatedDecks[state.selectedIndex!] = updatedDeck;
    updatedDecks.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return state._copyWith(
      decks: updatedDecks,
      selectedIndex: present(updatedDecks.indexOf(updatedDeck)),
    );
  }

  @override
  String get storagePrefix => 'YDecksManagerCubit';
}

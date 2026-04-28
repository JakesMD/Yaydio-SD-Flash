import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/views/_views.dart';

/// {@template YMainPage}
///
/// The home page of the application, which contains the navigation and main
/// views.
///
/// {@endtemplate}
class YMainPage extends StatefulWidget {
  /// {@macro YMainPage}
  const YMainPage({super.key});

  @override
  State<YMainPage> createState() => _YMainPageState();
}

class _YMainPageState extends State<YMainPage> {
  late final YDecksManagerCubit decksManagerCubit;
  late final YAlbumsManagerCubit albumsManagerCubit;
  late final YTrackCopyCubit trackCopyCubit;
  late final YDeckWriterCubit deckWriterCubit;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    decksManagerCubit = YDecksManagerCubit();
    albumsManagerCubit = YAlbumsManagerCubit(
      onAlbumDeleted: (id) => onAlbumDeleted(context, id),
      onDeleteFailed: (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete album: $error')),
      ),
    );
    trackCopyCubit = YTrackCopyCubit(
      onTrackSaved: albumsManagerCubit.addTrack,
      onCopyFailed: (name) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to copy track "$name"')),
      ),
    );
    deckWriterCubit = YDeckWriterCubit();
  }

  void onAlbumDeleted(BuildContext context, String id) {
    decksManagerCubit.deleteAlbumFromAllDecks(id);
    trackCopyCubit.removeAlbumFromQueue(id);
  }

  void onIndexChanged(int index) => setState(() => selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: decksManagerCubit),
        BlocProvider.value(value: albumsManagerCubit),
        BlocProvider.value(value: trackCopyCubit),
        BlocProvider.value(value: deckWriterCubit),
      ],
      child: BlocConsumer<YDeckWriterCubit, YDeckWriterState>(
        listenWhen: (_, state) => state.succeeded,
        listener: (context, state) =>
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Deck successfully written to SD card!'),
              ),
            ),
        builder: (context, state) => switch (state.status) {
          .initial => YMainView(
            selectedIndex: selectedIndex,
            onIndexChanged: onIndexChanged,
          ),
          .inProgress => const YWritingDeckView(),
          .succeeded => YMainView(
            selectedIndex: selectedIndex,
            onIndexChanged: onIndexChanged,
          ),
          .failed => const YWritingFailedView(),
        },
      ),
    );
  }
}

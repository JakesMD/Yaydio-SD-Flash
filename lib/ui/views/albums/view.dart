import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/ui/views/albums/albums_pane.dart';
import 'package:yaydio_sd_flash/ui/views/albums/selected_album_pane.dart';

/// {@template YAlbumsView}
///
/// A view that displays a list of albums and the tracks in the selected album.
///
/// {@endtemplate}
class YAlbumsView extends StatelessWidget {
  /// {@macro YAlbumsView}
  const YAlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: YAlbumsPane()),
        Expanded(flex: 2, child: YSelectedAlbumPane()),
      ],
    );
  }
}

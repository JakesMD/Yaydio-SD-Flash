import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/widgets/_widgets.dart';

/// {@template YAlbumsPane}
///
/// A pane that displays a list of albums and allows the user to select one.
///
/// {@endtemplate}
class YAlbumsPane extends StatelessWidget {
  /// {@macro YAlbumsPane}
  const YAlbumsPane({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<YAlbumsManagerCubit>().state;

    return YPane(
      child: ListView.builder(
        itemCount: state.albums.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(state.albums[index].name),
          selected: index == state.selectedIndex,
          onTap: () => context.read<YAlbumsManagerCubit>().selectAlbum(index),
        ),
      ),
    );
  }
}

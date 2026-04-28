import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/widgets/_widgets.dart';

/// {@template YDecksPane}
///
/// A pane that displays a list of decks and allows the user to select one.
///
/// {@endtemplate}
class YDecksPane extends StatelessWidget {
  /// {@macro YDecksPane}
  const YDecksPane({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<YDecksManagerCubit>().state;

    return YPane(
      child: ListView.builder(
        itemCount: state.decks.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(state.decks[index].name),
          selected: index == state.selectedIndex,
          onTap: () => context.read<YDecksManagerCubit>().selectDeck(index),
        ),
      ),
    );
  }
}

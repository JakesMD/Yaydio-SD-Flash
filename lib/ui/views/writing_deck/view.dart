import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/widgets/pane.dart';

/// {@template YWritingDeckView}
///
/// The view shown when writing a deck to the SD card.
///
/// {@endtemplate}
class YWritingDeckView extends StatelessWidget {
  /// {@macro YWritingDeckView}
  const YWritingDeckView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<YDeckWriterCubit>().state;

    return Scaffold(
      body: Padding(
        padding: const .all(8),
        child: YPane(
          child: Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '''Writing deck '${state.deck!.name}' to '${state.destinationDir!}'...''',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              LinearProgressIndicator(value: state.progress),
            ],
          ),
        ),
      ),
    );
  }
}

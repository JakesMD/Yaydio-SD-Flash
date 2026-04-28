import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/bloc/_bloc.dart';
import 'package:yaydio_sd_flash/ui/widgets/pane.dart';

/// {@template YWritingFailedView}
///
/// The view shown when writing a deck fails.
///
/// {@endtemplate}
class YWritingFailedView extends StatelessWidget {
  /// {@macro YWritingFailedView}
  const YWritingFailedView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<YDeckWriterCubit>();

    return Scaffold(
      body: Padding(
        padding: const .all(8),
        child: YPane(
          child: Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to write deck!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(cubit.state.failure!),
              FilledButton(
                onPressed: cubit.reset,
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

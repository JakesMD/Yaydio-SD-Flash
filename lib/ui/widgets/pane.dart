import 'package:flutter/material.dart';

/// {@template YPane}
///
/// A pane widget that can be used to display content in a structured way.
///
/// {@endtemplate}
class YPane extends StatelessWidget {
  /// {@macro YPane}
  const YPane({
    required this.child,
    this.title,
    this.actions = const [],
    super.key,
  });

  /// The content of the pane.
  final Widget child;

  /// An optional title for the pane.
  final Widget? title;

  /// An optional list of actions to display at the bottom of the pane.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: .circular(12),
      ),
      padding: const .all(8),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 16,
        children: [
          ?title,
          Expanded(child: ClipRect(child: child)),
          if (actions.isNotEmpty)
            Padding(
              padding: const .only(bottom: 8),
              child: Column(spacing: 8, children: actions),
            ),
        ],
      ),
    );
  }
}

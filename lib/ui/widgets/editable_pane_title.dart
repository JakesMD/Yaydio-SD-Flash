import 'package:flutter/material.dart';

/// {@template YEditablePaneTitle}
///
/// A widget that displays an editable title for a pane, along with a delete
/// button.
///
/// {@endtemplate}
class YEditablePaneTitle extends StatelessWidget {
  /// {@macro YEditablePaneTitle}
  const YEditablePaneTitle({
    required this.id,
    required this.initialValue,
    required this.hint,
    required this.onChanged,
    required this.onDeletePressed,
    super.key,
  });

  /// The unique identifier for the pane.
  final String id;

  /// The initial value of the title.
  final String initialValue;

  /// The hint text to display when the title is empty.
  final String hint;

  /// A callback that is called when the title is changed, with the new value.
  final void Function(String value) onChanged;

  /// A callback that is called when the delete button is pressed.
  final void Function() onDeletePressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .fromLTRB(16, 16, 16, 8),
      child: Row(
        spacing: 24,
        children: [
          Expanded(
            child: TextFormField(
              key: Key('$id-name-field'),
              initialValue: initialValue,
              onChanged: onChanged,
              style: Theme.of(context).textTheme.titleLarge,
              decoration: InputDecoration.collapsed(hintText: hint),
            ),
          ),
          IconButton.outlined(
            icon: const Icon(Icons.delete_rounded),
            onPressed: onDeletePressed,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// {@template YFormattedConfirmDialog}
///
/// A dialog that asks the user to confirm that they have formatted the SD card.
///
/// {@endtemplate}
class YFormattedConfirmDialog extends StatelessWidget {
  /// {@macro YFormattedConfirmDialog}
  const YFormattedConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Have you formatted the SD card?'),
      content: const Text('Make sure to format the SD card as FAT16 or FAT32.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

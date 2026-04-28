import 'package:flutter/material.dart';
import 'package:yaydio_sd_flash/ui/main_page.dart';

/// {@template YApp}
///
/// The root widget of the application.
///
/// {@endtemplate}
class YApp extends StatelessWidget {
  /// {@macro YApp}
  const YApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaydio SD Flash',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      // themeMode: ThemeMode.light,
      home: const YMainPage(),
    );
  }
}

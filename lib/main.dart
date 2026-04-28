import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:yaydio_sd_flash/globals.dart';
import 'package:yaydio_sd_flash/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final documentsDirectory = await getApplicationDocumentsDirectory();
  yDirectory = Directory(p.join(documentsDirectory.path, 'Yaydio-Data'));
  if (!yDirectory.existsSync()) await yDirectory.create(recursive: true);

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(yDirectory.path),
  );

  runApp(const YApp());
}

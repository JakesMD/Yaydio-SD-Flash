import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

/// A global instance of the Uuid class.
const yUuid = Uuid();

/// A global variable to hold the base directory for the application.
late Directory yDirectory;

/// Returns a File object for the specified track in the specified album.
File yTrackFile(String albumID, String trackID) => File(
  path.join(yAlbumDir(albumID).path, '$trackID.mp3'),
);

/// Returns a Directory object for the specified album.
Directory yAlbumDir(String albumID) => Directory(
  path.join(yDirectory.path, 'albums', albumID),
);

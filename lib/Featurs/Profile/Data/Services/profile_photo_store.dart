import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores the user's profile photo locally on the device (no network).
///
/// The picked image is copied into the app's documents directory and its path
/// is persisted in SharedPreferences, so it survives app restarts and
/// logout/login on the same device. Replacing the photo overwrites the same
/// file, and a missing file falls back to a null path.
class ProfilePhotoStore {
  static const String _pathKey = 'profile_photo_path';

  Future<String?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_pathKey);

    if (path == null) return null;

    final file = File(path);
    if (!await file.exists()) {
      await prefs.remove(_pathKey);
      return null;
    }

    return path;
  }

  Future<String> save(XFile picked) async {
    final dir = await getApplicationDocumentsDirectory();
    final path =
        '${dir.path}${Platform.pathSeparator}profile_photo.jpg';

    final target = File(path);
    if (await target.exists()) {
      await target.delete();
    }

    final source = File(picked.path);
    await source.copy(target.path);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pathKey, target.path);

    return target.path;
  }
}
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../Data/Services/profile_photo_store.dart';

/// Owns the locally stored profile photo and exposes it to the UI.
class ProfilePhotoProvider extends ChangeNotifier {
  final ProfilePhotoStore _store = ProfilePhotoStore();

  String? _path;
  bool _isLoading = false;
  String? _errorMessage;

  ProfilePhotoProvider() {
    _load();
  }

  String? get path => _path;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _load() async {
    final path = await _store.load();
    _path = path;
    notifyListeners();
  }

  /// Picks an image from the gallery and stores it locally.
  /// Returns `true` on success, `false` if cancelled or on error.
  Future<bool> updatePhoto() async {
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );

      if (picked == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final path = await _store.save(picked);
      _path = path;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Could not update profile photo';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studia/Core/Theme/app_palette.dart';
import 'package:studia/Core/Constants/assets.dart';

/// Single source of truth for the user avatar. Shows the local photo when
/// `photoPath` is set, otherwise the bundled default avatar. Optionally shows
/// an edit badge and an uploading overlay.
class ProfileAvatar extends StatelessWidget {
  final String? photoPath;
  final double size;
  final VoidCallback? onTap;
  final bool showEditBadge;
  final bool isUploading;

  const ProfileAvatar({
    super.key,
    this.photoPath,
    this.size = 120,
    this.onTap,
    this.showEditBadge = false,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.trim().isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: hasPhoto
                ? Image.file(
                    File(photoPath!),
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => _defaultAvatar(),
                  )
                : _defaultAvatar(),
          ),
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          if (showEditBadge)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Image.asset(
      AppAssets.profilePic,
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
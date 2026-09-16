import 'package:flutter/material.dart';
import '../Theme/app_palette.dart';

class AppLoader extends StatelessWidget {
  final double size;

  const AppLoader({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: context.accentColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

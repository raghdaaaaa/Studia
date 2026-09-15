import 'package:studia/Core/Widgets/app_fab.dart';
import 'package:studia/Core/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final int currentNavIndex;
  final bool showBottomNav;
  final bool showFab;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.currentNavIndex = 0,
    this.showBottomNav = true,
    this.showFab = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaffoldColor = backgroundColor ??
        (theme.brightness == Brightness.dark
            ? theme.scaffoldBackgroundColor
            : Colors.white);

    return Scaffold(
      backgroundColor: scaffoldColor,
      extendBody: true,
      bottomNavigationBar: showBottomNav
          ? AppBottomNavBar(currentIndex: currentNavIndex)
          : null,
      floatingActionButton: showFab ? const AppFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: body,
    );
  }
}
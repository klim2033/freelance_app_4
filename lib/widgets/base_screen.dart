import 'package:flutter/material.dart';
import 'animated_home_button.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool showHomeButton;

  const BaseScreen({
    super.key,
    required this.body,
    required this.title,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.showHomeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: actions,
      ),
      body: body,
      floatingActionButton: Stack(
        children: [
          if (floatingActionButton != null) floatingActionButton!,
          if (showHomeButton)
            Positioned(
              right: floatingActionButton != null ? 80 : 16,
              bottom: 16,
              child: const AnimatedHomeButton(),
            ),
        ],
      ),
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

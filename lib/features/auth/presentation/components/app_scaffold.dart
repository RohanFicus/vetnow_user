import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final bool useSafeArea;

  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.bottom,
    this.centerTitle = true,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              centerTitle: centerTitle,
              actions: actions,
              bottom: bottom,
            ),
      body: body,
      floatingActionButton: floatingActionButton,
    );

    return useSafeArea ? SafeArea(child: content) : content;
  }
}

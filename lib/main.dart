import 'package:flutter/material.dart';
import 'package:tree_view_app/src/assets/presentation/home_page.dart';

void main() {
  runApp(const TreeViewApp());
}

class TreeViewApp extends StatelessWidget {
  const TreeViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tree View App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Home Page'),
    );
  }
}

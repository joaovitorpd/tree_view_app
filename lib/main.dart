import 'package:flutter/material.dart';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('data'),
          ],
        ),
      ),
    );
  }
}

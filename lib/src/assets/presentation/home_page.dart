import 'package:flutter/material.dart';
import 'package:tree_view_app/src/assets/domain/entities/level.dart';
import 'package:tree_view_app/src/assets/presentation/tree.dart';
import 'package:tree_view_app/src/assets/presentation/tree_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  List<Level> allLevels = [];
  List<Level> tree = [];
  Tree treeClass = Tree();
  List<Level> items = [];

  @override
  void initState() {
    // var treeClass = Tree();

    // widget.allLevels = treeClass.getData();
    // widget.tree = treeClass.buidTree(widget.allLevels);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //List<Level> searchedItems = [];
    Future<List<Level>> allItems = treeClass.getData();
    //List<Level> tree = [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<List<Level>>(
            future: allItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                items = snapshot.data!;
                //searchedItems = snapshot.data!;

                //tree = treeClass.buidTree(searchedItems);

                return TreeWidget(
                    searchController: searchController,
                    treeClass: treeClass,
                    allItems: items);
              }
              return const Center(child: CircularProgressIndicator());
            },
          )),
        ],
      ),
    );
  }
}

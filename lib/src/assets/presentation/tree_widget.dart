import 'package:flutter/material.dart';
import 'package:tree_view_app/src/assets/domain/entities/level.dart';
import 'package:tree_view_app/src/assets/presentation/tree.dart';

class TreeWidget extends StatefulWidget {
  const TreeWidget(
      {super.key,
      required this.searchController,
      required this.treeClass,
      required this.allItems});

  final Tree treeClass;
  final List<Level> allItems;
  final TextEditingController searchController;

  @override
  State<TreeWidget> createState() => _TreeWidgetState();
}

class _TreeWidgetState extends State<TreeWidget> {
  List<Level> searchedItems = [];
  List<Level> tree = [];

  @override
  void initState() {
    searchedItems = List<Level>.from(widget.allItems).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tree = widget.treeClass.buidTree(searchedItems
        .map((e) => Level(
            id: e.id,
            name: e.name,
            treeLevel: e.treeLevel,
            parentId: e.parentId,
            sensorId: e.sensorId,
            sensorType: e.sensorType,
            status: e.status,
            gatewayId: e.gatewayId,
            children: []))
        .toList());
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: TextFormField(
            decoration: const InputDecoration(label: Text("Search")),
            controller: widget.searchController,
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              if (widget.searchController.text.isNotEmpty) {
                searchedItems = searchedItems
                    .where((item) => item.name!
                        .toLowerCase()
                        .contains(widget.searchController.text.toLowerCase()))
                    .toList();

                searchedItems = _parentBuilder(widget.allItems, searchedItems);
              } else {
                searchedItems = List.from(widget.allItems);
              }
              FocusScope.of(context).unfocus();
              setState(() {});
            },
            onChanged: (value) {
              if (value.isEmpty) {
                searchedItems = widget.allItems;
                setState(() {});
              }
            },
            /* onChanged: (value) {
              if (value.length > 2) {
                setState(() {
                  searchedItems
                      .where((item) =>
                          item.name!.contains(widget.searchController.text))
                      .toList();
                  tree = widget.treeClass.buidTree(searchedItems);
                });
              }
              widget.searchController.text = value;
            }, */
          ),
        ),
        Expanded(
          flex: 9,
          child: ListView.builder(
            itemCount: tree.length,
            itemBuilder: (context, index) {
              return _printTreeBranch(tree[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _printTreeBranch(Level item) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: Text(item.name ?? "Unnamed"),
        childrenPadding: const EdgeInsets.only(left: 20),
        controlAffinity: ListTileControlAffinity.leading,
        leading: item.children.isEmpty ? const SizedBox.shrink() : null,
        children: item.children.isEmpty
            ? []
            : item.children.map((child) => _printTreeBranch(child)).toList(),
      ),
    );
  }

  List<Level> _parentBuilder(List<Level> allItems, List<Level> levels) {
    for (var i = 0; i < levels.length; i++) {
      if (allItems.any((item) => item.id == levels[i].parentId)) {
        var parent =
            allItems.firstWhere((item) => item.id == levels[i].parentId);

        if (!levels.any((level) => level.id == parent.id)) {
          levels.add(parent);
          //levels.addAll(allItems.where((item) => item.id == levels[i].parentId));
        }
      }
    }
    return levels;
  }
}

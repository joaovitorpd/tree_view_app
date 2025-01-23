import 'package:flutter/material.dart';
import 'package:tree_view_app/core/utils/constants.dart';
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
  bool energySelected = false;
  bool criticalSelected = false;

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
        SizedBox(
          width: MediaQuery.of(context).size.height,
          height: MediaQuery.of(context).size.height * 0.12,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height * 0.05,
                child: TextFormField(
                  decoration: const InputDecoration(label: Text("Search")),
                  controller: widget.searchController,
                  textInputAction: TextInputAction.done,
                  onEditingComplete: () {
                    if (widget.searchController.text.isNotEmpty) {
                      searchedItems = searchedItems
                          .where((item) => item.name!.toLowerCase().contains(
                              widget.searchController.text.toLowerCase()))
                          .toList();

                      searchedItems =
                          _treeRebuilder(widget.allItems, searchedItems);
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
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Energy Sensor Filter Button
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          energySelected ? Colors.blue : Colors.white,
                    ),
                    onPressed: () {
                      if (energySelected) {
                        energySelected = false;
                      } else {
                        energySelected = true;
                      }
                      energySelected
                          ? searchedItems = searchedItems
                              .where((item) =>
                                  item.sensorType == SensorType.energy)
                              .toList()
                          : searchedItems = List.from(widget.allItems);
                      searchedItems =
                          _treeRebuilder(widget.allItems, searchedItems);
                      setState(() {});
                    },
                    child: Text(
                      "Sensor de Energia",
                      style: TextStyle(
                        color: energySelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  //Critical Filter Button
                  const SizedBox(
                    width: 10.0,
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          criticalSelected ? Colors.blue : Colors.white,
                    ),
                    onPressed: () {
                      if (criticalSelected) {
                        criticalSelected = false;
                      } else {
                        criticalSelected = true;
                      }
                      criticalSelected
                          ? searchedItems = searchedItems
                              .where((item) => item.status == Status.alert)
                              .toList()
                          : searchedItems = List.from(widget.allItems);
                      searchedItems =
                          _treeRebuilder(widget.allItems, searchedItems);
                      setState(() {});
                    },
                    child: Text(
                      "Crítico",
                      style: TextStyle(
                        color: criticalSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          //flex: 7,
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

  List<Level> _treeRebuilder(List<Level> allItems, List<Level> levels) {
    List<Level> missingParents = [];
    for (var i = 0; i < levels.length; i++) {
      if (levels[i].parentId != null &&
          !levels.any((item) => item.id == levels[i].parentId)) {
        _parentFinder(allItems, missingParents, levels[i]);
      }
    }
    levels.addAll(missingParents);
    return levels;
  }

  void _parentFinder(
      List<Level> allItems, List<Level> missingParents, Level item) {
    if (item.parentId != null &&
        !missingParents.any((e) => e.id == item.parentId)) {
      var parent = allItems.firstWhere((x) => x.id == item.parentId);
      missingParents.add(parent);
      _parentFinder(allItems, missingParents, parent);
    }
  }
}

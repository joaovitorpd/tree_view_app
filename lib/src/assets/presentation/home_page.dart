import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tree_view_app/src/assets/data/datasources/assets_data_source.dart';
import 'package:tree_view_app/src/assets/data/datasources/location_data_source.dart';
import 'package:tree_view_app/src/assets/data/models/assets_model.dart';
import 'package:tree_view_app/src/assets/data/models/location_model.dart';
import 'package:tree_view_app/src/assets/domain/entities/asset.dart';
import 'package:tree_view_app/src/assets/domain/entities/component.dart';
import 'package:tree_view_app/src/assets/domain/entities/level.dart';
import 'package:tree_view_app/src/assets/domain/entities/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var tree = Tree().buidTree();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: tree,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return printTreeBranch(snapshot.data![index]);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  List<Level> children = [];
  Widget printTreeBranch(Level item) {
    if (item.children!.isNotEmpty) {
      for (var i = 0; i < item.children!.length; i++) {
        children.add(item.children![i]);
        printTreeBranch(item.children![i]);
      }
      var childrenToPrint = children;
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 120.0,
              child: Text(item.name!),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 150.0,
              child: ListView.builder(
                itemCount: childrenToPrint.length,
                itemBuilder: (context, index) {
                  children = [];
                  return Text(childrenToPrint[index].name!);
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Text(item.name!);
    }
  }
}

class Tree {
  Client client = Client();

  Future<List> buidTree() async {
    var allLocationsModel =
        await LocationDataSource(client: client).getLocations();
    var allAssetsModel = await AssetsDataSource(client: client).getAssets();
    List<dynamic> root = [];

    var allLocations = _locationModelToLocation(allLocationsModel);
    var allAssets = _assetsModelToAssets(allAssetsModel);
    var components = _assetsModelToComponents(allAssetsModel);

    root = _treeBuilder(allLocations, allAssets, components);
    return root;
  }

  List<Level> _locationModelToLocation(List<LocationModel> allLocationsModel) {
    List<Level> allLocations = [];

    for (var i = 0; i < allLocationsModel.length; i++) {
      Location location = Location(
        id: allLocationsModel[i].id,
        name: allLocationsModel[i].name,
        parentId: allLocationsModel[i].parentId,
        children: [],
      );
      allLocations.add(location);
    }

    return allLocations;
  }

  List<Level> _assetsModelToAssets(List<AssetsModel> allAssetsModel) {
    List<Level> allAssets = [];

    for (var i = 0; i < allAssetsModel.length; i++) {
      if (allAssetsModel[i].sensorType == null &&
          allAssetsModel[i].status == null &&
          allAssetsModel[i].sensorId == null) {
        Asset asset = Asset(
          id: allAssetsModel[i].id,
          name: allAssetsModel[i].name,
          parentId: allAssetsModel[i].parentId ?? allAssetsModel[i].locationId,
          children: [],
        );
        allAssets.add(asset);
      }
    }
    return allAssets;
  }

  List<Level> _assetsModelToComponents(List<AssetsModel> allAssetsModel) {
    List<Level> components = [];

    for (var i = 0; i < allAssetsModel.length; i++) {
      if (allAssetsModel[i].sensorType != null &&
          allAssetsModel[i].status != null &&
          allAssetsModel[i].sensorId != null) {
        Component component = Component(
          id: allAssetsModel[i].id,
          name: allAssetsModel[i].name,
          parentId: allAssetsModel[i].parentId ?? allAssetsModel[i].locationId,
          sensorId: allAssetsModel[i].sensorId,
          sensorType: allAssetsModel[i].sensorType,
          status: allAssetsModel[i].status,
          gatewayId: allAssetsModel[i].gatewayId,
          children: [],
        );
        components.add(component);
      }
    }

    return components;
  }

  List<Level> _treeBuilder(
      List<Level> allLocations, List<Level> allAssets, List<Level> components) {
    List<Level> root = [];

    _childrenAssignig(childrenList: components, parentsList: allAssets);

    _childrenAssignig(childrenList: allAssets, parentsList: allAssets);

    _childrenAssignig(childrenList: components, parentsList: allLocations);

    _childrenAssignig(childrenList: allAssets, parentsList: allLocations);

    _childrenAssignig(childrenList: allLocations, parentsList: allLocations);

    components.removeWhere((x) => x.parentId != null);
    allAssets.removeWhere((x) => x.parentId != null);
    allLocations.removeWhere((x) => x.parentId != null);

    root = components + allAssets + allLocations;
    return root;
  }

  List<Level> _childrenAssignig({
    required List<Level> childrenList,
    required List<Level> parentsList,
  }) {
    for (var i = 0; i < parentsList.length; i++) {
      List<Level> children =
          childrenList.where((x) => x.parentId == parentsList[i].id).toList();

      parentsList[i].children?.addAll(children);
    }
    return parentsList;
  }
}

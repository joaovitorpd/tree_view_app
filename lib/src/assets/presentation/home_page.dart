import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tree_view_app/src/assets/data/datasources/assets_data_source.dart';
import 'package:tree_view_app/src/assets/data/datasources/location_data_source.dart';
import 'package:tree_view_app/src/assets/data/models/assets_model.dart';
import 'package:tree_view_app/src/assets/data/models/location_model.dart';
import 'package:tree_view_app/src/assets/domain/entities/asset.dart';
import 'package:tree_view_app/src/assets/domain/entities/component.dart';
import 'package:tree_view_app/src/assets/domain/entities/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<LocationModel> allLocations;

  @override
  Widget build(BuildContext context) {
    Client client = Client();

    buidTree(client);

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

  void buidTree(Client client) async {
    var allLocationsModel =
        await LocationDataSource(client: client).getLocations();
    var allAssetsModel = await AssetsDataSource(client: client).getAssets();
    List<dynamic> root = [];

    var allLocations = locationModelToLocation(allLocationsModel);
    var allAssets = assetsModelToAssets(allAssetsModel);
    var components = assetsModelToComponents(allAssetsModel);

    root = treeBuilder(allLocations, allAssets, components);
  }
}

List locationModelToLocation(List<LocationModel> allLocationsModel) {
  var allLocations = [];

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

List assetsModelToAssets(List<AssetsModel> allAssetsModel) {
  var allAssets = [];

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

List assetsModelToComponents(List<AssetsModel> allAssetsModel) {
  var components = [];

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
      );
      components.add(component);
    }
  }

  return components;
}

List treeBuilder(List allLocations, List allAssets, List components) {
  List root = [];

  /* for (var i = 0; i < allAssets.length; i++) {
    var children =
        components.where((x) => x.parentId == allAssets[i].id).toList();
    components.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allAssets[i].children.add(children[t]);
    }
  } */

  childrenAssignig(childrenList: components, parentsList: allAssets);

  /* var subAssets = allAssets.where((x) => x.parentId != null).toList();
  allAssets.removeWhere((x) => subAssets.contains(x)); */

  /* for (var i = 0; i < allAssets.length; i++) {
    var children =
        subAssets.where((x) => x.parentId == allAssets[i].id).toList();
    subAssets.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allAssets[i].children.add(children[t]);
    }
  } */

  childrenAssignig(childrenList: allAssets, parentsList: allAssets);

  /* for (var i = 0; i < allLocations.length; i++) {
    var children =
        components.where((x) => x.locationId == allLocations[i].id).toList();
    components.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allLocations[i].children.add(children[t]);
    }
  } */

  childrenAssignig(childrenList: components, parentsList: allLocations);

  /* for (var i = 0; i < allLocations.length; i++) {
    var children =
        allAssets.where((x) => x.locationId == allLocations[i].id).toList();
    allAssets.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allLocations[i].children.add(children[t]);
    }
  } */

  childrenAssignig(childrenList: allAssets, parentsList: allLocations);

  /* var subLocations = allLocations.where((x) => x.parentId != null).toList();
  allLocations.removeWhere((x) => subLocations.contains(x)); */

  /* for (var i = 0; i < allLocations.length; i++) {
    var children =
        subLocations.where((x) => x.parentId == allLocations[i].id).toList();
    subLocations.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allLocations[i].children.add(children[t]);
    }
  } */

  childrenAssignig(childrenList: allLocations, parentsList: allLocations);
  components.removeWhere((x) => x.parentId != null);
  allAssets.removeWhere((x) => x.parentId != null);
  allLocations.removeWhere((x) => x.parentId != null);

  root = components + allAssets + allLocations;
  return root;
}

List<dynamic> childrenAssignig({
  required List childrenList,
  required List parentsList,
}) {
  for (var i = 0; i < parentsList.length; i++) {
    var children =
        childrenList.where((x) => x.parentId == parentsList[i].id).toList();

    parentsList[i].children.addAll(children);

    /* for (var t = 0; t < children.length; t++) {
      parentsList[i].children.add(children[t]);
    }
    childrenList.removeWhere((x) => children.contains(x)); */
  }
  return parentsList;
}

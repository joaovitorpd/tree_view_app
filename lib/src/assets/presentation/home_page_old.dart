import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tree_view_app/src/assets/data/datasources/assets_data_source.dart';
import 'package:tree_view_app/src/assets/data/datasources/location_data_source.dart';
import 'package:tree_view_app/src/assets/data/models/assets_model.dart';
import 'package:tree_view_app/src/assets/data/models/location_model.dart';
import 'package:tree_view_app/src/assets/domain/entities/asset.dart';
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
    var allLocations = await LocationDataSource(client: client).getLocations();
    var allAssets = await AssetsDataSource(client: client).getAssets();
    List<dynamic> root = [];

    root = locations(allLocations, allAssets);
    root = subLocationsFinder(allLocations, allAssets, root);

    root = rootAssetsFinder(allAssets, root);
    root = assetsFinder(allAssets, root);
  }
}

List locations(List<LocationModel> allLocations, List<AssetsModel> allAssets) {
  List root = [];

  var rootLocations =
      allLocations.where((location) => location.parentId == null).toList();

  for (var i = 0; i < rootLocations.length; i++) {
    Location location = Location(
      id: rootLocations[i].id,
      name: rootLocations[i].name,
      parentId: rootLocations[i].parentId,
      children: [],
    );
    root.add(location);
  }

  return root;
}

List subLocationsFinder(
    List<LocationModel> allLocations, List<AssetsModel> allAssets, List root) {
  var subLocations =
      allLocations.where((location) => location.parentId != null).toList();

  var subAssets = allAssets
      .where((asset) => asset.locationId != null && asset.sensorId == null)
      .toList();

  for (var i = 0; i < subLocations.length; i++) {
    if (root.any((location) => location.id == subLocations[i].parentId)) {
      var location = root.firstWhere((x) => x.id == subLocations[i].parentId);
      var childrenAssetsModel =
          subAssets.where((x) => x.locationId == subLocations[i].id).toList();
      List children = [];

      for (var t = 0; t < childrenAssetsModel.length; t++) {
        Asset asset = Asset(
          gatewayId: childrenAssetsModel[t].gatewayId,
          id: childrenAssetsModel[t].id,
          locationId: childrenAssetsModel[t].locationId,
          name: childrenAssetsModel[t].name,
          parentId: childrenAssetsModel[t].parentId,
          sensorId: childrenAssetsModel[t].sensorId,
          sensorType: childrenAssetsModel[t].sensorType,
          status: childrenAssetsModel[t].status,
          children: [],
        );
        children.add(asset);
      }

      Location child = Location(
        id: subLocations[i].id,
        name: subLocations[i].name,
        parentId: subLocations[i].parentId,
        children: children,
      );
      location.children!.add(child);
    }
  }

  return root;
}

List rootAssetsFinder(
    List<AssetsModel> allAssets, List<dynamic> rootLocations) {
  var root = allAssets
      .where((asset) => asset.locationId == null && asset.parentId == null)
      .toList();

  for (var i = 0; i < root.length; i++) {
    Asset asset = Asset(
      gatewayId: root[i].gatewayId,
      id: root[i].id,
      locationId: root[i].locationId,
      name: root[i].name,
      parentId: root[i].parentId,
      sensorId: root[i].sensorId,
      sensorType: root[i].sensorType,
      status: root[i].status,
      children: [],
    );
    rootLocations.add(asset);
  }
  return rootLocations;
}

List assetsFinder(List<AssetsModel> allAssets, List<dynamic> root) {
  var subAssets = allAssets
      .where((asset) => asset.parentId != null && asset.sensorId == null)
      .toList();

  var assets = allAssets
      .where((asset) => asset.locationId != null && asset.sensorId == null)
      .toList();
  var components = componentsFinder(allAssets);

  for (var i = 0; i < assets.length; i++) {
    if (root.any((x) => x.id == assets[i].locationId)) {
      Location location = root.firstWhere((x) => x.id == assets[i].locationId);
      var children =
          components.where((x) => x.parentId == location.id).toList();

      Asset asset = Asset(
        gatewayId: assets[i].gatewayId,
        id: assets[i].id,
        locationId: assets[i].locationId,
        name: assets[i].name,
        parentId: assets[i].parentId,
        sensorId: assets[i].sensorId,
        sensorType: assets[i].sensorType,
        status: assets[i].status,
        children: children,
      );
      location.children!.add(asset);
    }

    if (subAssets.any((x) => x.parentId == assets[i].id)) {
      var childrenAssetsModel =
          subAssets.where((x) => x.parentId == assets[i].id).toList();
      List<Asset> childrenAssets = [];
      for (var i = 0; i < childrenAssetsModel.length; i++) {
        Asset asset = Asset(
          gatewayId: childrenAssetsModel[i].gatewayId,
          id: childrenAssetsModel[i].id,
          locationId: childrenAssetsModel[i].locationId,
          name: childrenAssetsModel[i].name,
          parentId: childrenAssetsModel[i].parentId,
          sensorId: childrenAssetsModel[i].sensorId,
          sensorType: childrenAssetsModel[i].sensorType,
          status: childrenAssetsModel[i].status,
          children: [],
        );
        childrenAssets.add(asset);
      }
      var childrenComponents =
          components.where((x) => x.parentId == assets[i].id).toList();

      List<Asset> children = childrenAssets + childrenComponents;
    }
  }

  return root;
}

List<Asset> componentsFinder(List<AssetsModel> allAssets) {
  var componentsAssetModel = allAssets
      .where(
          (x) => x.sensorId != null && x.sensorType != null && x.status != null)
      .toList();
  List<Asset> components = [];

  for (var i = 0; i < componentsAssetModel.length; i++) {
    Asset component = Asset(
      gatewayId: componentsAssetModel[i].gatewayId,
      id: componentsAssetModel[i].id,
      locationId: componentsAssetModel[i].locationId,
      name: componentsAssetModel[i].name,
      parentId: componentsAssetModel[i].parentId,
      sensorId: componentsAssetModel[i].sensorId,
      sensorType: componentsAssetModel[i].sensorType,
      status: componentsAssetModel[i].status,
      children: [],
    );
    components.add(component);
  }
  return components;
}

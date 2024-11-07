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
    var allLocationsModel =
        await LocationDataSource(client: client).getLocations();
    var allAssetsModel = await AssetsDataSource(client: client).getAssets();
    List<dynamic> root = [];

    var allLocations = locationModelToLocal(allLocationsModel);
    var allAssets = assetsModelToLocal(allAssetsModel);

    root = treeBuilder(allLocations, allAssets);
  }
}

List locationModelToLocal(List<LocationModel> allLocationsModel) {
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

List assetsModelToLocal(List<AssetsModel> allAssetsModel) {
  var allAssets = [];

  for (var i = 0; i < allAssetsModel.length; i++) {
    Asset asset = Asset(
      gatewayId: allAssetsModel[i].gatewayId,
      id: allAssetsModel[i].id,
      locationId: allAssetsModel[i].locationId,
      name: allAssetsModel[i].name,
      parentId: allAssetsModel[i].parentId,
      sensorId: allAssetsModel[i].sensorId,
      sensorType: allAssetsModel[i].sensorType,
      status: allAssetsModel[i].status,
      children: [],
    );
    allAssets.add(asset);
  }
  return allAssets;
}

List treeBuilder(List allLocations, List allAssets) {
  List root = [];
  var components =
      allAssets.where((x) => x.sensorType != null && x.status != null).toList();
  allAssets.removeWhere((x) => components.contains(x));

  for (var i = 0; i < allAssets.length; i++) {
    var children =
        components.where((x) => x.parentId == allAssets[i].id).toList();
    components.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allAssets[i].children.add(children[t]);
    }
  }

  var subAssets = allAssets
      .where((x) => x.parentId != null && x.locationId == null)
      .toList();
  allAssets.removeWhere((x) => subAssets.contains(x));

  for (var i = 0; i < allAssets.length; i++) {
    var children =
        subAssets.where((x) => x.parentId == allAssets[i].id).toList();
    subAssets.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allAssets[i].children.add(children[t]);
    }
  }

  for (var i = 0; i < allLocations.length; i++) {
    var children =
        components.where((x) => x.locationId == allLocations[i].id).toList();
    components.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allLocations[i].children.add(children[t]);
    }
  }

  for (var i = 0; i < allLocations.length; i++) {
    var children =
        allAssets.where((x) => x.locationId == allLocations[i].id).toList();
    allAssets.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allLocations[i].children.add(children[t]);
    }
  }

  var subLocations = allLocations.where((x) => x.parentId != null).toList();
  allLocations.removeWhere((x) => subLocations.contains(x));

  for (var i = 0; i < allLocations.length; i++) {
    var children =
        subLocations.where((x) => x.parentId == allLocations[i].id).toList();
    subLocations.removeWhere((x) => children.contains(x));
    for (var t = 0; t < children.length; t++) {
      allLocations[i].children.add(children[t]);
    }
  }

  root = components + allAssets + allLocations;
  return root;
}

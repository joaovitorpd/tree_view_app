import 'package:http/http.dart';
import 'package:tree_view_app/core/utils/constants.dart';
import 'package:tree_view_app/src/assets/data/datasources/assets_data_source.dart';
import 'package:tree_view_app/src/assets/data/datasources/location_data_source.dart';
import 'package:tree_view_app/src/assets/data/models/assets_model.dart';
import 'package:tree_view_app/src/assets/data/models/location_model.dart';
import 'package:tree_view_app/src/assets/domain/entities/level.dart';

class Tree {
  Client client = Client();

  Future<List<Level>> getData() async {
    List<LocationModel> allLocationsModel =
        await LocationDataSource(client: client).getLocations();
    List<AssetsModel> allAssetsModel =
        await AssetsDataSource(client: client).getAssets();

    var allLocations = _locationModelToLocation(allLocationsModel);
    var allAssets = _assetsModelToAssets(allAssetsModel);
    var components = _assetsModelToComponents(allAssetsModel);

    return allLocations + allAssets + components;
  }

  List<Level> buidTree(List<Level> allItems) {
    List<Level> root = [];

    root = List.from(allItems.where((x) => x.parentId == null));

    _builder(allItems, root);

    return root;
  }

  void _builder(List<Level> allItems, List<Level> levels) {
    for (var i = 0; i < levels.length; i++) {
      levels[i]
          .children
          .addAll(List.from(allItems.where((x) => x.parentId == levels[i].id)));
      _builder(allItems, levels[i].children);
    }
  }

  List<Level> _locationModelToLocation(List<LocationModel> allLocationsModel) {
    List<Level> allLocations = [];

    for (var i = 0; i < allLocationsModel.length; i++) {
      Level location = Level(
        id: allLocationsModel[i].id,
        name: allLocationsModel[i].name,
        treeLevel: TreeLevel.location,
        parentId: allLocationsModel[i].parentId,
        sensorId: null,
        sensorType: null,
        status: null,
        gatewayId: null,
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
        Level asset = Level(
          id: allAssetsModel[i].id,
          name: allAssetsModel[i].name,
          treeLevel: TreeLevel.asset,
          parentId: allAssetsModel[i].parentId ?? allAssetsModel[i].locationId,
          sensorId: null,
          sensorType: null,
          status: null,
          gatewayId: null,
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
        Level component = Level(
          id: allAssetsModel[i].id,
          name: allAssetsModel[i].name,
          treeLevel: TreeLevel.component,
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
}

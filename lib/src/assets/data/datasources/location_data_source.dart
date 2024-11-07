import 'dart:convert';

import 'package:http/http.dart';
import 'package:tree_view_app/core/utils/constants.dart';
import 'package:tree_view_app/core/utils/typedef.dart';
import 'package:tree_view_app/src/assets/data/models/location_model.dart';

class LocationDataSource {
  LocationDataSource({required this.client});

  final Client client;

  Future<List<LocationModel>> getLocations() async {
    final response =
        await client.get(Uri.parse('$kBaseUrl/$locationsEndPoint'));
    if (response.statusCode == 200) {
      return List<DataMap>.from(
              jsonDecode(utf8.decode(response.bodyBytes)) as List)
          .map((location) => LocationModel.fromMap(location))
          .toList();
    } else {
      throw Exception('Failure to get Locations');
    }
  }
}

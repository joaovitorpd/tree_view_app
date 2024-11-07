import 'dart:convert';
import 'package:http/http.dart';
import 'package:tree_view_app/core/utils/constants.dart';
import 'package:tree_view_app/core/utils/typedef.dart';
import 'package:tree_view_app/src/assets/data/models/assets_model.dart';

class AssetsDataSource {
  AssetsDataSource({required this.client});

  Client client;

  Future<List<AssetsModel>> getAssets() async {
    var response = await client.get(Uri.parse('$kBaseUrl/$assetsEndPoint'));
    if (response.statusCode == 200) {
      return List<DataMap>.from(jsonDecode(utf8.decode(response.bodyBytes)))
          .map((asset) => AssetsModel.fromMap(asset))
          .toList();
    } else {
      throw Exception('Assets API not responding');
    }
  }
}

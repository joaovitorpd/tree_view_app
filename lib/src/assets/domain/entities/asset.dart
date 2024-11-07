import 'package:equatable/equatable.dart';
import 'package:tree_view_app/core/utils/constants.dart';

class Asset extends Equatable {
  const Asset({
    required this.gatewayId,
    required this.id,
    required this.locationId,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.children,
  });

  const Asset.empty()
      : gatewayId = null,
        id = null,
        locationId = null,
        name = null,
        parentId = null,
        sensorId = null,
        sensorType = null,
        status = null,
        children = null;

  final String? gatewayId;
  final String? id;
  final String? locationId;
  final String? name;
  final String? parentId;
  final String? sensorId;
  final SensorType? sensorType;
  final Status? status;
  final List? children;

  @override
  List<Object?> get props =>
      [id, locationId, name, parentId, sensorType, status];
}

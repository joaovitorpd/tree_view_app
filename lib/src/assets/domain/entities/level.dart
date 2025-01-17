import 'package:equatable/equatable.dart';
import 'package:tree_view_app/core/utils/constants.dart';

class Level {
  Level({
    required this.id,
    required this.name,
    required this.treeLevel,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    required this.children,
  });

  /* const Level.empty()
      : id = null,
        name = null,
        treeLevel = null,
        parentId = null,
        sensorId = null,
        sensorType = null,
        status = null,
        gatewayId = null,
        children = []; */

  final String? id;
  final String? name;
  final TreeLevel? treeLevel;
  final String? parentId;
  final String? sensorId;
  final SensorType? sensorType;
  final Status? status;
  final String? gatewayId;
  final List<Level> children;

/*   @override
  List<Object?> get props => [
        id,
        name,
        treeLevel,
        parentId,
        sensorId,
        sensorType,
        status,
        gatewayId,
        children
      ]; */
}

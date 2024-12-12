import 'package:tree_view_app/core/utils/constants.dart';
import 'package:tree_view_app/src/assets/domain/entities/level.dart';

/* class Component extends Equatable {
  const Component({
    required this.id,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
    required this.children,
  });

  final String? id;
  final String? name;
  final String? parentId;
  final String? sensorId;
  final SensorType? sensorType;
  final Status? status;
  final String? gatewayId;
  final List<dynamic>? children;

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
        sensorId,
        sensorType,
        status,
        gatewayId,
        children,
      ];
} */

class Component extends Level {
  const Component({
    required super.id,
    required super.name,
    required super.parentId,
    required super.children,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
  });

  const Component.empty()
      : sensorId = null,
        sensorType = null,
        status = null,
        gatewayId = null,
        super.empty();

  final String? sensorId;
  final SensorType? sensorType;
  final Status? status;
  final String? gatewayId;

  @override
  List<Object?> get props => [
        id,
        name,
        parentId,
        sensorId,
        sensorType,
        status,
        gatewayId,
        children,
      ];
}

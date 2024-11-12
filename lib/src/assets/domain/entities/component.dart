import 'package:equatable/equatable.dart';
import 'package:tree_view_app/core/utils/constants.dart';

class Component extends Equatable {
  const Component({
    required this.id,
    required this.name,
    required this.parentId,
    required this.sensorId,
    required this.sensorType,
    required this.status,
    required this.gatewayId,
  });

  final String? id;
  final String? name;
  final String? parentId;
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
      ];
}

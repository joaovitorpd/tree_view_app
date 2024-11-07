import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:tree_view_app/core/utils/constants.dart';
import 'package:tree_view_app/core/utils/typedef.dart';

class AssetsModel extends Equatable {
  const AssetsModel(
      {this.gatewayId,
      this.id,
      this.locationId,
      this.name,
      this.parentId,
      this.sensorId,
      this.sensorType,
      this.status});

  final String? gatewayId;
  final String? id;
  final String? locationId;
  final String? name;
  final String? parentId;
  final String? sensorId;
  final SensorType? sensorType;
  final Status? status;

  const AssetsModel.empty()
      : this(
          gatewayId: null,
          id: null,
          locationId: null,
          name: null,
          parentId: null,
          sensorId: null,
          sensorType: null,
          status: null,
        );

  AssetsModel copyWith({
    String? gatewayId,
    String? id,
    String? locationId,
    String? name,
    String? parentId,
    String? sensorId,
    SensorType? sensorType,
    Status? status,
  }) {
    return AssetsModel(
        gatewayId: gatewayId,
        id: id,
        locationId: locationId,
        name: name,
        parentId: parentId,
        sensorId: sensorId,
        sensorType: sensorType,
        status: status);
  }

  factory AssetsModel.fromJson(String source) =>
      AssetsModel.fromMap(jsonDecode(source) as DataMap);

  AssetsModel.fromMap(DataMap map)
      : this(
          gatewayId: map['gatewayId'] as String?,
          id: map['id'] as String?,
          locationId: map['locationId'] as String?,
          name: map['name'] as String?,
          parentId: map['parentId'] as String?,
          sensorId: map['sensorId'] as String?,
          sensorType: _fromStringSensorType(map['sensorType'] as String?),
          status: _fromStringStatus(map['status'] as String?),
        );

  DataMap toMap() => {
        'gatewayId': gatewayId,
        'id': id,
        'locationId': locationId,
        'name': name,
        'parentId': parentId,
        'sensorId': sensorId,
        'sensorType': _toStringSensorType(sensorType),
        'status': _toStringStatus(status),
      };

  String toJson() => jsonEncode(toMap());

  static SensorType? _fromStringSensorType(String? sensorTypeString) {
    if (sensorTypeString == null) {
      return null;
    } else {
      return SensorType.values.firstWhere(
          (x) => x.toString().split('.').last == sensorTypeString,
          orElse: () => throw Exception('Invalid SensorType'));
    }
  }

  static String? _toStringSensorType(SensorType? sensorType) {
    return sensorType?.toString().split('.').last;
  }

  static Status? _fromStringStatus(String? statusString) {
    if (statusString == null) {
      return null;
    } else {
      return Status.values.firstWhere(
          (x) => x.toString().split('.').last == statusString,
          orElse: () => throw Exception('Invalid Sensor Status'));
    }
  }

  static String? _toStringStatus(Status? status) {
    return status?.toString().split('.').last;
  }

  @override
  List<Object?> get props => [id, locationId, name, parentId, status];
}

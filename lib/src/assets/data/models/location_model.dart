import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:tree_view_app/core/utils/typedef.dart';

class LocationModel extends Equatable {
  const LocationModel({
    required this.id,
    required this.name,
    required this.parentId,
  });

  const LocationModel.empty()
      : this(
          id: null,
          name: null,
          parentId: null,
        );

  final String? id;
  final String? name;
  final String? parentId;

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(jsonDecode(source) as DataMap);

  LocationModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String?,
          name: map['name'] as String?,
          parentId: map['parentId'] as String?,
        );

  LocationModel copyWith({
    String? id,
    String? name,
    String? parentId,
  }) {
    return LocationModel(
      id: id,
      name: name,
      parentId: parentId,
    );
  }

  DataMap toMap() => {
        'id': id,
        'name': name,
        'parentId': parentId,
      };

  String toJson() => jsonEncode(toMap());

  @override
  List<Object?> get props => [id, name, parentId];
}

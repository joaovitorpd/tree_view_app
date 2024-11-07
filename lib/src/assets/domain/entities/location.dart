import 'package:equatable/equatable.dart';

class Location extends Equatable {
  const Location({
    required this.id,
    required this.name,
    required this.parentId,
    required this.children,
  });

  const Location.empty()
      : id = null,
        name = null,
        parentId = null,
        children = null;

  final String? id;
  final String? name;
  final String? parentId;
  final List<dynamic>? children;

  @override
  List<Object?> get props => [id, name, parentId, children];
}

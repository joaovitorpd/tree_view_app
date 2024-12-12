import 'package:tree_view_app/src/assets/domain/entities/level.dart';

/* class Location extends Level {
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
  final List<Level>? children;

  @override
  List<Object?> get props => [id, name, parentId, children];
} */

class Location extends Level {
  const Location(
      {required super.id,
      required super.name,
      required super.parentId,
      required super.children});
}

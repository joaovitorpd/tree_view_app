import 'package:tree_view_app/src/assets/domain/entities/level.dart';

/* class Asset extends Equatable {
  const Asset({
    required this.id,
    required this.name,
    required this.parentId,
    required this.children,
  });

  const Asset.empty()
      : id = null,
        name = null,
        parentId = null,
        children = null;

  final String? id;
  final String? name;
  final String? parentId;
  final List? children;

  @override
  List<Object?> get props => [id, name, parentId, children];
} */

class Asset extends Level {
  const Asset(
      {required super.id,
      required super.name,
      required super.parentId,
      required super.children});
}

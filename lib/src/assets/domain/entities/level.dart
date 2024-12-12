import 'package:equatable/equatable.dart';

class Level extends Equatable {
  const Level({
    required this.id,
    required this.name,
    required this.parentId,
    required this.children,
  });

  const Level.empty()
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
}

import 'package:equatable/equatable.dart';

class Asset extends Equatable {
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
}

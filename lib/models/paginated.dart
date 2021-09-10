import 'package:json_annotation/json_annotation.dart';

part 'paginated.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Paginated<T> {
  List<T> data;
  bool hasMore;
  String? cursor;
  int totalCount;

  Paginated(
      {required this.data,
      required this.hasMore,
      this.cursor,
      required this.totalCount});

  factory Paginated.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PaginatedFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      _$PaginatedToJson(this, toJsonT);
}

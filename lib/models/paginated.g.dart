// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paginated<T> _$PaginatedFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return Paginated<T>(
    data: (json['data'] as List<dynamic>).map(fromJsonT).toList(),
    hasMore: json['hasMore'] as bool,
    cursor: json['cursor'] as String?,
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$PaginatedToJson<T>(
  Paginated<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': instance.data.map(toJsonT).toList(),
      'hasMore': instance.hasMore,
      'cursor': instance.cursor,
      'totalCount': instance.totalCount,
    };

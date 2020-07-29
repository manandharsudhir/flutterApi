// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Department _$DepartmentFromJson(Map<String, dynamic> json) {
  return Department(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
  );
}

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employe-model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeModel _$EmployeModelFromJson(Map<String, dynamic> json) {
  return EmployeModel(
    id: json['id'] as int,
    department: json['department'] == null
        ? null
        : Department.fromJson(json['department'] as Map<String, dynamic>),
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    salary: json['salary'] as int,
  );
}

Map<String, dynamic> _$EmployeModelToJson(EmployeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'salary': instance.salary,
      'department': instance.department,
    };

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'department-model.g.dart';

@JsonSerializable()
class Department {
  int id;
  String name = '';
  String description = '';

  Department({
    @required this.id,
    this.name,
    this.description,
  });

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
//  Department.fromJson(Map<String, dynamic> json)
//      : id = json['id'],
//        name = json['name'],
//        description = json['description'];
//
//  Map<String, dynamic> toJson() => {
//        'id': id,
//        'name': name,
//        'description': description,
//      };
}

//class DepartmentList {
//  final List<Department> department;
//  DepartmentList(this.department);
//
//  DepartmentList.fromJson(List<dynamic> depJson)
//      : department = depJson.map((dep) => Department.fromJson(dep)).toList();
//}

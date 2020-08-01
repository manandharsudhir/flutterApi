import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'department-model.g.dart';

@JsonSerializable()
class Department {
  int id;
  String name;
  String description;

  Department({
    this.id,
    this.name,
    this.description,
  });

  factory Department.fromJson(Map<String, dynamic> json) =>
      _$DepartmentFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}

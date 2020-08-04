import 'package:flutter/material.dart';
import 'package:flutterapi/domains/department/department.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employe.g.dart';

@JsonSerializable()
class EmployeModel {
  int id;
  String firstName;
  String lastName;
  int salary;
  Department department;

  EmployeModel({
    this.id,
    @required this.department,
    @required this.firstName,
    @required this.lastName,
    @required this.salary,
  });

  factory EmployeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeModelToJson(this);
}

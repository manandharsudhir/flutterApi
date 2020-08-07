import 'package:flutter/material.dart';
import 'package:flutterapi/domains/department/department.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employe.g.dart';

@JsonSerializable()
class Employee {
  int id;
  String firstName;
  String lastName;
  int salary;
  Department department;

  Employee({
    this.id,
    @required this.department,
    @required this.firstName,
    @required this.lastName,
    @required this.salary,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}

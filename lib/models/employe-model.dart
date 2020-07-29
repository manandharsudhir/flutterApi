import 'package:flutter/material.dart';
import 'package:flutterapi/models/department-model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employe-model.g.dart';

@JsonSerializable()
class EmployeModel {
  final int id;
  final String firstName;
  final String lastName;
  final String salary;
  final Department department;

  EmployeModel({
    @required this.id,
    @required this.department,
    @required this.firstName,
    @required this.lastName,
    @required this.salary,
  });

  factory EmployeModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeModelToJson(this);
}

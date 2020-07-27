import 'package:flutter/material.dart';
import 'package:flutterapi/providers/department-model.dart';

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
}

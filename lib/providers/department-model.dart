import 'dart:convert';

import 'package:flutter/material.dart';

class Department {
  int id;
  String name = '';
  String description = '';

  Department({
    @required this.id,
    this.name,
    this.description,
  });

  Department.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}

class DepartmentList {
  final List<Department> department;
  DepartmentList(this.department);

  DepartmentList.fromJson(List<dynamic> depJson)
      : department = depJson.map((dep) => Department.fromJson(dep)).toList();
}

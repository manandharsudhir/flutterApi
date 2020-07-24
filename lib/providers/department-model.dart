import 'package:flutter/material.dart';

class Department {
  final String id;
  String name='';
  String description='';

  Department({
    @required this.id,
    this.name,
    this.description,
  });
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapi/domains/department/department.dart';
import 'package:http/http.dart' as http;

class DepartmentProvider with ChangeNotifier {
  List<Department> _departments = [];

  List<Department> get departments {
    return _departments;
  }

  Department findById(String name) {
    return _departments.firstWhere((dep) => dep.name == name);
  }

  static const String url =
      "https://employee-crud-node-list.herokuapp.com/api/departments";

  Future<void> getDepartment() async {
    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);
      List<dynamic> department = extractedData['data'];
      _departments =
          department.map((json) => Department.fromJson(json)).toList();
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateDepartment(int id, Department newdep) async {
    final depindex = _departments.indexWhere((item) => item.id == id);
    String _existingname = _departments[depindex].name;
    String _exisitingDes = _departments[depindex].description;
    _departments[depindex].name = newdep.name;
    _departments[depindex].description = newdep.description;
    notifyListeners();
    try {
      if (depindex >= 0) {
        final url =
            "https://employee-crud-node-list.herokuapp.com/api/departments/$id";
        await http.put(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(newdep));
        _existingname = null;
        _exisitingDes = null;
        notifyListeners();
      }
    } catch (error) {
      _departments[depindex].name = _existingname;
      _departments[depindex].description = _exisitingDes;
      notifyListeners();
      throw error;
    }
  }

  Future<void> addDepartment(Department dep) async {
    try {
      await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dep));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteDepartment(int id) async {
    String url =
        'https://employee-crud-node-list.herokuapp.com/api/departments/$id';
    final existingDepartmentIndex =
        _departments.indexWhere((item) => item.id == id);
    var existingDepartment = _departments[existingDepartmentIndex];
    _departments.removeAt(existingDepartmentIndex);
    notifyListeners();
    try {
      await http.delete(url);
      existingDepartment = null;
    } catch (error) {
      _departments.insert(existingDepartmentIndex, existingDepartment);
      notifyListeners();
      throw error;
    }
  }
}

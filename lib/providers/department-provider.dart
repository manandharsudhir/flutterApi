import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapi/providers/department-model.dart';
import 'package:http/http.dart' as http;

class DepartmentProvider with ChangeNotifier {
  List<Department> _items = [];

  List<Department> get item {
    return [..._items];
  }

  Department findById(String name) {
    return _items.firstWhere((dep) => dep.name == name);
  }

  static const String url =
      "https://employee-crud-node-list.herokuapp.com/api/departments";

  Future<void> getDepartment() async {
    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);

      _items = DepartmentList.fromJson(extractedData['data']).department;
      print(_items[0].name);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateDepartment(int id, Department newdep) async {
    final depindex = _items.indexWhere((item) => item.id == id);
    String _existingname = _items[depindex].name;
    String _exisitingDes = _items[depindex].description;
    _items[depindex].name = newdep.name;
    _items[depindex].description = newdep.description;
    notifyListeners();
    try {
      if (depindex >= 0) {
        final url =
            "https://employee-crud-node-list.herokuapp.com/api/departments/$id";
        await http.put(url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': id,
              'name': newdep.name,
              'description': newdep.description,
            }));
        _existingname = null;
        _exisitingDes = null;
        notifyListeners();
      }
    } catch (error) {
      _items[depindex].name = _existingname;
      _items[depindex].description = _exisitingDes;
      notifyListeners();
      throw error;
    }
  }

  Future<void> addDepartment(Department dep) async {
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': dep.name,
            'description': dep.description,
          }));
      _items.add(Department(
          id: json.decode(response.body)['id'],
          name: dep.name,
          description: dep.description));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteDepartment(int id) async {
    String url =
        'https://employee-crud-node-list.herokuapp.com/api/departments/$id';
    final existingDepartmentIndex = _items.indexWhere((item) => item.id == id);
    var existingDepartment = _items[existingDepartmentIndex];
    _items.removeAt(existingDepartmentIndex);
    notifyListeners();
    try {
      await http.delete(url);
      existingDepartment = null;
    } catch (error) {
      _items.insert(existingDepartmentIndex, existingDepartment);
      notifyListeners();
      throw error;
    }
  }
}

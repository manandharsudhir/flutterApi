import 'dart:convert';

import 'package:flutterapi/domains/department/department.dart';
import 'package:http/http.dart' as http;

class DepartmentDao {
  static const String baseUrl =
      'https://employee-crud-node-list.herokuapp.com/api/';
  static const String url = "${baseUrl}departments";

  Future<List<Department>> findAll() async {
    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);
      List<dynamic> department = extractedData['data'];
      return department.map((json) => Department.fromJson(json)).toList();
    } catch (error) {
      throw error;
    }
  }

  Future<Department> update(Department newdep) async {
    try {
      final response = await http.put("$url/${newdep.id}",
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newdep));
      Map<String, dynamic> department = json.decode(response.body)['data'];
      return Department.fromJson(department);
    } catch (error) {
      throw error;
    }
  }

  Future<Department> save(Department dep) async {
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dep));
      Map<String, dynamic> department = json.decode(response.body);
      return Department.fromJson(department);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> delete(int id) async {
    try {
      await http.delete('$url/$id');
    } catch (error) {
      throw error;
    }
  }
}

import 'dart:convert';

import 'package:flutterapi/domains/department/department.dart';
import 'package:http/http.dart' as http;

class DepartmentDao {
  static const String baseUrl =
      'https://employee-crud-node-list.herokuapp.com/api/';
  static const String url = "${baseUrl}departments";

  Future<List<Department>> getDepartment() async {
    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);
      List<dynamic> department = extractedData['data'];
      return department.map((json) => Department.fromJson(json)).toList();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateDepartment(Department newdep) async {
    try {
      await http.put("$url/${newdep.id}",
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newdep));
    } catch (error) {
      throw error;
    }
  }

  Future<void> addDepartment(Department dep) async {
    try {
      await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dep));
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteDepartment(int id) async {
    try {
      await http.delete('$url/$id');
    } catch (error) {
      throw error;
    }
  }
}

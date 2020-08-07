import 'dart:convert';
import './employe.dart';
import 'package:http/http.dart' as http;

class EmployeeDao {
  static const String baseUrl =
      "https://employee-crud-node-list.herokuapp.com/api/";
  static const String url = "${baseUrl}employees";

  Future<List<Employee>> findAll() async {
    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);
      List<dynamic> employees = extractedData['data'];
      return employees.map((json) => Employee.fromJson(json)).toList();
    } catch (error) {
      throw error;
    }
  }

  Future<Employee> update(Employee newEmployee) async {
    try {
      final response = await http.put("$url/${newEmployee.id}",
          headers: {'Content-Type': 'application/json'},
          body: json.encode(newEmployee));
      Map<String, dynamic> employee = json.decode(response.body)['data'];
      return Employee.fromJson(employee);
    } catch (error) {
      throw error;
    }
  }

  Future<Employee> save(Employee employee) async {
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(employee));
      Map<String, dynamic> newEmployee = json.decode(response.body);
      return Employee.fromJson(newEmployee);
    } catch (error) {
      print(error);
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

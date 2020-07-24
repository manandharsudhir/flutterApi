import 'package:flutter/material.dart';
import 'package:flutterapi/providers/department-model.dart';
import 'package:flutterapi/providers/employe-model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeProvider with ChangeNotifier {
  List<EmployeModel> _items = [];
  List<EmployeModel> get item {
    return [..._items];
  }

  Future<void> getEmploye() async {
    const String url =
        "https://employee-crud-node-list.herokuapp.com/api/employees";
    final response = await http.get(url);
    final extractedData = json.decode(response.body)["data"] as List;
    final List<EmployeModel> loadedEmploye = [];
    extractedData.forEach((item) {
      loadedEmploye.add(EmployeModel(
          id: item["id"].toString(),
          department: Department(
              id: item["department"]["id"].toString(),
              name: item["department"]["name"],
              description: item["department"]["description"]),
          firstName: item["firstName"],
          lastName: item["lastName"],
          salary: item["salary"].toString()));
    });
    _items = loadedEmploye;
    notifyListeners();
  }

  List<EmployeModel> dep = [];
  void findByDepartment(String id) {
    List<EmployeModel> newDep = [];
    _items.forEach((item) {
      if (item.department.id == id) {
        newDep.add(item);
      }
    });
    dep = newDep;
    notifyListeners();
  }

  Future<void> getLatestUpdate(String id) async {
    await getEmploye();
    List<EmployeModel> newDep = [];
    _items.forEach((item) {
      if (item.department.id == id) {
        newDep.add(item);
      }
    });
    dep = newDep;
    notifyListeners();
  }

  Future<void> addEmploye(EmployeModel employe) async {
    const String url =
        "https://employee-crud-node-list.herokuapp.com/api/employees";
    final response = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: json.encode({
          'firstName': employe.firstName,
          'lastName': employe.lastName,
          'salary': employe.salary,
          'department': {'id': int.parse(employe.department.id)}
        }));
    print(response.body);
    getLatestUpdate(employe.department.id);
    notifyListeners();
  }

  Future<void> updateEmploye(String id, EmployeModel emp) async {
    final depindex = dep.indexWhere((item) => item.id == id);
    if (depindex >= 0) {
      final url =
          "https://employee-crud-node-list.herokuapp.com/api/employees/$id";
      await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'id': int.parse(id),
            'firstName': emp.firstName,
            'lastName': emp.lastName,
            'department': {'id': int.parse(emp.department.id)}
          },
        ),
      );
      getLatestUpdate(id);
      notifyListeners();
    }
  }

  Future<void> deleteEmploye(String id, index) async {
    dep.removeAt(index);
    notifyListeners();
    String url =
        'https://employee-crud-node-list.herokuapp.com/api/employees/$id';
    await http.delete(url);
  }
}

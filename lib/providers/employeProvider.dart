import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/employes.dart';
import 'package:flutterapi/domains/department/department.dart';
import 'package:flutterapi/domains/employee/employe.dart';
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
    Map<String, dynamic> extractedData = json.decode(response.body);
    List<dynamic> employes = extractedData['data'];
    _items = employes.map((employ) => EmployeModel.fromJson(employ)).toList();
    notifyListeners();
  }

  List<EmployeModel> dep = [];
  void findByDepartment(int id) {
    List<EmployeModel> newDep = [];
    _items.forEach((item) {
      if (item.department.id == id) {
        newDep.add(item);
      }
    });
    dep = newDep;
    notifyListeners();
  }

  Future<void> getLatestUpdate(int id) async {
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
        body: json.encode(employe));
    print(response.body);
    getLatestUpdate(employe.department.id);
    notifyListeners();
  }

  Future<void> updateEmploye(int id, EmployeModel emp) async {
    final depindex = dep.indexWhere((item) => item.id == id);
    if (depindex >= 0) {
      final response = json.encode(emp);
      print(response);
      final url =
          "https://employee-crud-node-list.herokuapp.com/api/employees/$id";
      await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(emp),
      );
      getLatestUpdate(id);
      notifyListeners();
    }
  }

  Future<void> deleteEmploye(int id, index) async {
    dep.removeAt(index);
    notifyListeners();
    String url =
        'https://employee-crud-node-list.herokuapp.com/api/employees/$id';
    await http.delete(url);
  }
}

import 'package:flutter/material.dart';
import 'department.dart';
import './department-dao.dart';

class DepartmentService with ChangeNotifier {
  List<Department> _departments = [];

  List<Department> get departments {
    return _departments;
  }

  final DepartmentDao departmentDao = DepartmentDao();
  static const String url =
      "https://employee-crud-node-list.herokuapp.com/api/departments";

  Future<void> getDepartment() async {
    try {
      _departments = await departmentDao.getDepartment();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Department findById(String name) {
    return _departments.firstWhere((dep) => dep.name == name);
  }

  Future<void> updateDepartment(Department newdep) async {
    await departmentDao.updateDepartment(newdep);
  }

  Future<void> addDepartment(Department dep) async {
    await departmentDao.addDepartment(dep);
  }

  Future<void> deleteDepartment(int id) async {
    await departmentDao.deleteDepartment(id);
  }
}

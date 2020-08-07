import 'package:flutter/material.dart';
import 'department.dart';
import './department-dao.dart';

class DepartmentService with ChangeNotifier {
  List<Department> _departments = [];

  List<Department> get departments {
    return _departments;
  }

  DepartmentDao departmentDao = new DepartmentDao();
  Future<void> getDepartment() async {
    try {
      _departments = await departmentDao.findAll();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Department findById(String name) {
    return _departments.firstWhere((dep) => dep.name == name);
  }

  Future<void> updateDepartment(Department newdep) async {
    try {
      await departmentDao.update(newdep);
      await getDepartment();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addDepartment(Department dep) async {
    try {
      await departmentDao.save(dep);
      await getDepartment();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteDepartment(int id) async {
    await departmentDao.deleteDepartment(id);
  }
}

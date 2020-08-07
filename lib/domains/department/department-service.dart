import 'package:flutter/material.dart';
import 'department.dart';
import './department-dao.dart';

class DepartmentService with ChangeNotifier {
  List<Department> _departments = [];

  List<Department> get departments {
    return _departments;
  }

  DepartmentDao departmentDao = new DepartmentDao();
  Future<void> findAll() async {
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

  Future<void> update(Department newdep) async {
    try {
      await departmentDao.update(newdep);
      await findAll();
    } catch (error) {
      throw error;
    }
  }

  Future<void> save(Department dep) async {
    try {
      await departmentDao.save(dep);
      await findAll();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delete(int id) async {
    await departmentDao.delete(id);
  }
}

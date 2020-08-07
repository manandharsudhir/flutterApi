import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapi/domains/employee/employe-dao.dart';
import 'package:flutterapi/domains/employee/employe.dart';

class EmployeeService with ChangeNotifier {
  List<Employee> _employees = [];
  List<Employee> get employee {
    return _employees;
  }

  EmployeeDao employeeDao = new EmployeeDao();
  Future<void> findAll() async {
    try {
      _employees = await employeeDao.findAll();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Employee> dep = [];
  void findByDepartment(int id) {
    List<Employee> newDep = [];
    _employees.forEach((item) {
      if (item.department.id == id) {
        newDep.add(item);
      }
    });
    dep = newDep;
    notifyListeners();
  }

  Future<void> getLatestUpdate(int id) async {
    await findAll();
    List<Employee> newDep = [];
    _employees.forEach((item) {
      if (item.department.id == id) {
        newDep.add(item);
      }
    });
    dep = newDep;
    notifyListeners();
  }

  Future<void> save(Employee employee) async {
    try {
      await employeeDao.save(employee);
      await findAll();
    } catch (error) {
      throw error;
    }
  }

  Future<void> update(Employee emp) async {
    try {
      await employeeDao.update(emp);
      await findAll();
    } catch (error) {
      throw error;
    }
  }

  Future<void> delete(int id, index) async {
    await employeeDao.delete(id);
  }
}

import 'package:flutter/material.dart';
import 'package:flutterapi/domains/department/department-service.dart';
import 'package:flutterapi/employes.dart';
import './domains/employee/employe-service.dart';
import './homepage.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: DepartmentService(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeeService(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Homepage(),
        routes: {Employe.routeName: (context) => Employe()},
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutterapi/employes.dart';
import 'package:flutterapi/providers/department-provider.dart';
import 'package:flutterapi/providers/employeProvider.dart';
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
          value: DepartmentProvider(),
        ),
        ChangeNotifierProvider.value(
          value: EmployeProvider(),
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

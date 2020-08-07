import 'package:flutter/material.dart';
import 'package:flutterapi/employes.dart';
import 'package:flutterapi/domains/department/department.dart';
import 'package:provider/provider.dart';
import './domains/employee/employe-service.dart';
import 'domains/department/department-service.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();

  String title = '';
  String subtitle = '';
  bool isInit = true;
  bool isLoading = false;
  bool hasError = false;

  void error(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  List<Department> loadedDepartment;
  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<DepartmentService>(context).getDepartment().then((_) {
        setState(() {
          isLoading = false;
        });
      }).catchError((_) {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      });
    }

    isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<DepartmentService>(context).getDepartment().then((_) {
      setState(() {
        hasError = false;
      });
    }).catchError(
      (error) {
        setState(
          () {
            hasError = true;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final departments = Provider.of<DepartmentService>(context);
    loadedDepartment = departments.departments;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: (context),
            builder: (BuildContext context) => Container(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Column(children: [
                      TextField(
                        controller: titleController,
                        decoration:
                            InputDecoration(labelText: 'Department title'),
                      ),
                      TextField(
                        controller: subtitleController,
                        decoration: InputDecoration(labelText: 'Description'),
                      ),
                      FlatButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              await departments.addDepartment(Department(
                                  name: titleController.text,
                                  description: subtitleController.text));
                            } catch (_) {
                              setState(() {
                                hasError = true;
                              });
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: Text('submit'))
                    ]),
                  ),
                )),
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: SafeArea(
          child: hasError
              ? ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text('Oops! Something went wrong'),
                      ),
                    )
                  ],
                )
              : isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(Employe.routeName,
                                arguments: loadedDepartment[index].name);
                            Provider.of<EmployeeService>(context)
                                .findByDepartment(loadedDepartment[index].id);
                          },
                          child: Card(
                            child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${loadedDepartment[index].id}'),
                                ),
                                title: Text(loadedDepartment[index].name == null
                                    ? ''
                                    : loadedDepartment[index].name),
                                subtitle: Text(
                                    loadedDepartment[index].description == null
                                        ? ''
                                        : loadedDepartment[index].description),
                                trailing: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => showModalBottomSheet(
                                            context: (context),
                                            builder: (BuildContext context) =>
                                                Container(
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    child: Column(children: [
                                                      TextField(
                                                        controller:
                                                            titleController,
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'Department title'),
                                                      ),
                                                      TextField(
                                                        controller:
                                                            subtitleController,
                                                      ),
                                                      FlatButton(
                                                          onPressed: () async {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {
                                                              isLoading = true;
                                                            });
                                                            try {
                                                              await departments.updateDepartment(Department(
                                                                  id: loadedDepartment[
                                                                          index]
                                                                      .id,
                                                                  name:
                                                                      titleController
                                                                          .text,
                                                                  description:
                                                                      subtitleController
                                                                          .text));
                                                            } catch (_) {
                                                              hasError = true;
                                                            } finally {
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }
                                                          },
                                                          child: Text('submit'))
                                                    ]),
                                                  ),
                                                )),
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            try {
                                              await departments
                                                  .deleteDepartment(
                                                      loadedDepartment[index]
                                                          .id);
                                              Scaffold.of(context)
                                                  .hideCurrentSnackBar();
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: (Text(
                                                          'Delete Successfull'))));
                                            } catch (_) {
                                              Scaffold.of(context)
                                                  .hideCurrentSnackBar();
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      duration:
                                                          Duration(seconds: 2),
                                                      content: (Text(
                                                          'Delete Failed'))));
                                            }
                                          })
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        itemCount: loadedDepartment.length,
                      ),
                    ),
        ),
      ),
    );
  }
}

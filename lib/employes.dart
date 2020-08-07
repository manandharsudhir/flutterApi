import 'package:flutter/material.dart';
import 'package:flutterapi/domains/department/department.dart';
import 'package:flutterapi/domains/employee/employe.dart';
import './domains/department/department-service.dart';
import 'package:provider/provider.dart';
import './domains/employee/employe-service.dart';

class Employe extends StatefulWidget {
  static const String routeName = './employe';

  @override
  _EmployeState createState() => _EmployeState();
}

class _EmployeState extends State<Employe> {
  bool isInit = true;
  bool isLoading = false;
  bool hasError = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<EmployeeService>(context).findAll().then((_) {
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

  Future<void> _refresh(BuildContext context, int id) async {
    await Provider.of<EmployeeService>(context).getLatestUpdate(id);
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<DepartmentService>(context, listen: false)
        .findById(productId);
    final employee = Provider.of<EmployeeService>(context);
    TextEditingController firstName = TextEditingController();

    TextEditingController lastName = TextEditingController();

    TextEditingController salary = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
      ),
      body: hasError
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
              : RefreshIndicator(
                  onRefresh: () => _refresh(context, loadedProduct.id),
                  child: ListView.builder(
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(
                            '${employee.dep[index].firstName} ${employee.dep[index].lastName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(employee.dep[index].department.name),
                            Text('Salary:Rs${employee.dep[index].salary}'),
                          ],
                        ),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () => showModalBottomSheet(
                                    context: (context),
                                    builder: (BuildContext context) {
                                      return Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          children: <Widget>[
                                            TextField(
                                              controller: firstName,
                                            ),
                                            TextField(
                                              controller: lastName,
                                            ),
                                            TextField(
                                              controller: salary,
                                            ),
                                            FlatButton(
                                              onPressed: () async {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                try {
                                                  await employee.update(
                                                    Employee(
                                                      department: Department(
                                                        id: loadedProduct.id,
                                                      ),
                                                      id: employee
                                                          .dep[index].id,
                                                      firstName: firstName.text,
                                                      lastName: lastName.text,
                                                      salary: int.parse(
                                                          salary.text),
                                                    ),
                                                  );
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
                                              child: Text(
                                                'submit',
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    employee.delete(
                                        employee.dep[index].id, index);
                                    Scaffold.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Delete Successful'),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                    itemCount: employee.dep.length,
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: (context),
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: firstName,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    TextField(
                      controller: lastName,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    TextField(
                      controller: salary,
                      decoration: InputDecoration(labelText: 'Salary'),
                    ),
                    FlatButton(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          await employee.save(
                            Employee(
                              department: Department(
                                id: loadedProduct.id,
                              ),
                              firstName: firstName.text,
                              lastName: lastName.text,
                              salary: int.parse(salary.text),
                            ),
                          );
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
                      child: Text(
                        'submit',
                      ),
                    )
                  ],
                ),
              );
            }),
        child: Icon(Icons.add),
      ),
    );
  }
}

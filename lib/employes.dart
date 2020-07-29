import 'package:flutter/material.dart';
import 'package:flutterapi/models/department-model.dart';
import 'package:flutterapi/models/employe-model.dart';
import './providers/department-provider.dart';
import 'package:provider/provider.dart';
import './providers/employeProvider.dart';

class Employe extends StatefulWidget {
  static const String routeName = './employe';

  @override
  _EmployeState createState() => _EmployeState();
}

class _EmployeState extends State<Employe> {
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<EmployeProvider>(context).getEmploye().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _refresh(BuildContext context, int id) async {
    await Provider.of<EmployeProvider>(context).getLatestUpdate(id);
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<DepartmentProvider>(context, listen: false)
            .findById(productId);
    final employe = Provider.of<EmployeProvider>(context);
    TextEditingController firstName = TextEditingController();

    TextEditingController lastName = TextEditingController();

    TextEditingController salary = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refresh(context, loadedProduct.id),
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    title: Text(
                        '${employe.dep[index].firstName} ${employe.dep[index].lastName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(employe.dep[index].department.name),
                        Text('Salary:Rs${employe.dep[index].salary}'),
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
                                          onPressed: () {
                                            employe.updateEmploye(
                                              employe.dep[index].id,
                                              EmployeModel(
                                                department: Department(
                                                  id: loadedProduct.id,
                                                ),
                                                firstName: firstName.text,
                                                lastName: lastName.text,
                                                salary: salary.text,
                                              ),
                                            );
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
                                employe.deleteEmploye(
                                    employe.dep[index].id, index);
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
                itemCount: employe.dep.length,
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
                      onPressed: () {
                        employe.addEmploye(
                          EmployeModel(
                            department: Department(
                              id: loadedProduct.id,
                            ),
                            firstName: firstName.text,
                            lastName: lastName.text,
                            salary: salary.text,
                          ),
                        );
                        _refresh(context, loadedProduct.id);
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

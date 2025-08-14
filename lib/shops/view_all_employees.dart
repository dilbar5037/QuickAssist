// main.dart
import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/employee_model.dart';
import 'package:quickassitnew/services/employee_service.dart';
import 'package:quickassitnew/shops/add_employee.dart';
import 'package:quickassitnew/widgets/apptext.dart';




class EmployeeListScreen extends StatefulWidget {
  final String? shopId;
  EmployeeListScreen({this.shopId});
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {


  final EmployeeService _employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'All Employee',color: Colors.white,size: 16,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: StreamBuilder<List<Employee>>(
          stream: _employeeService.getEmployeesByShopId(widget.shopId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            List<Employee> employees = snapshot.data ?? [];

            return ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return Card(
                  color: AppColors.scaffoldColor,
                  child: ListTile(
                    trailing: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () async {
                          // Delete employee
                          await _employeeService.deleteEmployee(employees[index]!.id.toString());
                          // Navigate back to the employee list screen
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.delete,color: Colors.red,),
                      
                      ),
                    ),
                    title: AppText(data:employees[index].name ?? '',color: Colors.white,),
                    subtitle: AppText(data:employees[index].jobType.toString(),color: Colors.white,),
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmployeeDetailScreen(
                            employee: employees[index],
                            employeeService: _employeeService,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),

    );
  }
}
//
class EmployeeDetailScreen extends StatefulWidget {
  final EmployeeService employeeService;
  final Employee? employee;

  EmployeeDetailScreen({required this.employeeService, this.employee});

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late TextEditingController _nameController;
  late TextEditingController _jobTypeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _jobTypeController = TextEditingController(text: widget.employee?.jobType.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(data:'Edit Employee',color: Colors.white, ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _jobTypeController,
              decoration: InputDecoration(labelText: 'Job Type'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Save or update employee
                if (widget.employee != null) {
                  // Update existing employee
                  Employee updatedEmployee =Employee(
                    name: _nameController.text,
                    jobType: _jobTypeController.text,
                  );
                  await widget.employeeService.updateEmployee(updatedEmployee);
                }

                // Navigate back to the employee list screen
                Navigator.pop(context);
              },
              child: Text(widget.employee != null ? 'Update' : 'Add'),
            ),

          ],
        ),
      ),
    );
  }
}

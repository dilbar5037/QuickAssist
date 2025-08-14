import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/employee_model.dart';
import 'package:quickassitnew/models/shop_model.dart';
import 'package:quickassitnew/models/user_model.dart';
import 'package:quickassitnew/services/employee_service.dart';
import 'package:quickassitnew/services/shopService_service.dart';
import 'package:quickassitnew/services/shop_service.dart';
import 'package:quickassitnew/services/userservice.dart';
import 'package:quickassitnew/widgets/apptext.dart';


class ViewAllEmployee extends StatefulWidget {
  const ViewAllEmployee({super.key});

  @override
  State<ViewAllEmployee> createState() => _ViewAllEmployeeState();
}

class _ViewAllEmployeeState extends State<ViewAllEmployee> {
  @override
  Widget build(BuildContext context) {
    final themedata=Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        title: AppText(data:'All Employee',color: Colors.white,size: 16,),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("All Employee",style: themedata.textTheme.displaySmall,),
            SizedBox(height: 20,),
          StreamBuilder(stream: EmployeeService().getAllEmployees(), builder: (context,snapshot){

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Some Error Occured",
                    style: themedata.textTheme.displaySmall,
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data!.length == 0) {
                return Center(
                  child: Text(
                    "No Employees added",
                    style: themedata.textTheme.displaySmall,
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data!.length != 0) {
                List<Employee> users = snapshot.data ?? [];
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final _user = users[index];
                      print(_user);

                      return Card(
                        elevation: 5.0,
                        color:AppColors.scaffoldColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              Icons.circle,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            "${_user.name}",
                            style: themedata.textTheme.displaySmall,
                          ),
                          subtitle: Text(
                            "${_user.email}",
                            style: themedata.textTheme.displaySmall,
                          ),

                        ),
                      );
                    });
              }

              return Center(
                child: Text(
                  "hello",
                  style: themedata.textTheme.displaySmall,
                ),
              );


            })
          ],
        ),
      ),

    );
  }
}

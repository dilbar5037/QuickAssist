import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/user_model.dart';
import 'package:quickassitnew/services/userservice.dart';


class ViewAllUsers extends StatefulWidget {
  const ViewAllUsers({super.key});

  @override
  State<ViewAllUsers> createState() => _ViewAllUsersState();
}

class _ViewAllUsersState extends State<ViewAllUsers> {
  @override
  Widget build(BuildContext context) {
    final themedata=Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("All Users",style: themedata.textTheme.displaySmall,),
            SizedBox(height: 20,),
            FutureBuilder(future: UserService().GetAll(), builder: (context,snapshot){

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
                    "No Users added",
                    style: themedata.textTheme.displaySmall,
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data!.length != 0) {
                List<UserModel> users = snapshot.data ?? [];
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
                          trailing: Container(
                            width:50,
                            child: Row(
                              children: [

                                IconButton(
                                    onPressed: () {
                                      //_taskService.deleteTask(_user.id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
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

import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/models/shop_model.dart';
import 'package:quickassitnew/models/user_model.dart';
import 'package:quickassitnew/services/shopService_service.dart';
import 'package:quickassitnew/services/shop_service.dart';
import 'package:quickassitnew/services/userservice.dart';


class ViewAllShops extends StatefulWidget {
  const ViewAllShops({super.key});

  @override
  State<ViewAllShops> createState() => _ViewAllShopsState();
}

class _ViewAllShopsState extends State<ViewAllShops> {
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
            Text("All Shops",style: themedata.textTheme.displaySmall,),
            SizedBox(height: 20,),
            FutureBuilder(future: ShopService().getShops(), builder: (context,snapshot){

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
                List<Shop> users = snapshot.data ?? [];
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
                            "${_user.shopName}",
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

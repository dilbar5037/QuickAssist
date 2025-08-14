

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/admin/allpayment.dart';
import 'package:quickassitnew/admin/notification/pages/allfeedbacks.dart';
import 'package:quickassitnew/admin/notification/pages/sendnotification.dart';
import 'package:quickassitnew/admin/notification/pages/viewallnotification.dart';
import 'package:quickassitnew/admin/viewall_emplyee.dart';
import 'package:quickassitnew/admin/viewall_shops.dart';
import 'package:quickassitnew/admin/viewall_users.dart';
import 'package:quickassitnew/common/login_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/shops/view_all_employees.dart';
import 'package:quickassitnew/widgets/customcontainer.dart';
import 'package:quickassitnew/widgets/dashboard_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  String? _type;
  String? uid;
  String? name;
  String? email;
  String? phone;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email = await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');

    setState(() {});
  }

  int shopCount = 0;
  int userCount = 0;
  Future<void> fetchStudentCount() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').get();
      QuerySnapshot<Map<String, dynamic>> trainersnapshot = await FirebaseFirestore.instance.collection('shops').get();

      userCount = snapshot.size;
      shopCount=trainersnapshot.size;
      setState(() {});
    } catch (error) {
      print('Error fetching student count: $error');
    }
  }

  @override
  void initState() {
    getData();
    fetchStudentCount();
    super.initState();
  }
  final _scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
     endDrawer: Drawer(
       elevation: 5.0,
       backgroundColor: AppColors.scaffoldColor,
       child: ListView(
         children: [
           DrawerHeader
             (

               decoration: BoxDecoration(

                   color: Colors.transparent),
               child: Row(
             children: [
               CircleAvatar(),
               SizedBox(width: 15,),
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                 Text("$name",style: themedata.textTheme.displaySmall,),
                 Text("$email",style: themedata.textTheme.displaySmall,),
               ],),
             ],
           )),
           ListTile(
  onTap: ()async{
    SharedPreferences _pref =
        await SharedPreferences.getInstance();
    FirebaseAuth.instance.signOut().then((value) {
      _pref.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);

    });

  },
             title: Text("Logout",style: themedata.textTheme.displaySmall,),
           )
         ],
       ),
     ),
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap:(){
                  _scaffoldKey.currentState!.openEndDrawer();
                },child: CircleAvatar()),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Admin Dashboard",
                    style: themedata.textTheme.displayMedium,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Text(
                          "Hi",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "${name.toString()}",
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(child: dashboardCountWidth(themedata: themedata,text: "Users",data: userCount,)),
                SizedBox(width: 20,),
                Expanded(child: dashboardCountWidth(themedata: themedata,text: "Shops",data:shopCount,)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            DashboardItemWidget(
                onTap1: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllUsers()));
                },
                onTap2: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllShops()));

                },
                titleOne: "All users",
                titleTwo: "All Shops"),
            SizedBox(
              height: 20,
            ),
            DashboardItemWidget(
                onTap1: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllEmployee()));
                },
                onTap2: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllFeedbackAdmin()));

                },
                titleOne: "All Employees",
                titleTwo: "All Feedbcaks"),



            SizedBox(
              height: 20,
            ),
            DashboardItemWidget(
                onTap1: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SendNotification()));
                },
                onTap2: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllNotifications()));

                },
                titleOne: "Add Notification",
                titleTwo: "View All Notification"),

            SizedBox(
              height: 20,
            ),
            DashboardItemWidget(
                onTap1: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentListPage()));
                },
                onTap2: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewAllNotifications()));

                },
                titleOne: "Payments",
                titleTwo: "")
          ],
        ),
      ),
    );
  }
}

class dashboardCountWidth extends StatelessWidget {
  const dashboardCountWidth({
    super.key,
    required this.themedata,
    this.data=0,this.text
  });

  final ThemeData themedata;
  final int?data;
  final String?text;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16.0,
      color: Color(0xff153b50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Container(

          height: 100,
          width: 150,
          decoration: BoxDecoration(

              color: Color(0xff153b50),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Total ${text ??"Schools"}", style: themedata.textTheme.displayMedium,
              ),
              SizedBox(height: 5,),
              Text(

                "${data}",
                textAlign: TextAlign.center,
                style: themedata.textTheme.displayLarge,
              )
            ],
          ),
        ),
      ),
    );
  }
}

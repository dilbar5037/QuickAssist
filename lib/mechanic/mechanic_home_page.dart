import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/common/login_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/mechanic/viewAll_works.dart';
import 'package:quickassitnew/user/settings_page.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/dashboard_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicHome extends StatefulWidget {
  const MechanicHome({super.key});

  @override
  State<MechanicHome> createState() => _MechanicHomeState();
}

class _MechanicHomeState extends State<MechanicHome> {


  String? _type;
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? img;
  String? address;
  String? location;
  String? account;
  String? gst;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email = await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');
    address = await _pref.getString('address');
    location = await _pref.getString('location');
    account = await _pref.getString('account');
    gst = await _pref.getString('jobtype');

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      drawer: Drawer(
        backgroundColor: AppColors.scaffoldColor,
        child: ListView(
          children: [
            DrawerHeader(
                child: Row(
                  children: [
                    CircleAvatar(
                      child: AppText(
                        data: "${name![0]}",
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    AppText(
                      data: "$name",
                      color: Colors.white,
                    )
                  ],
                )),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Settingpage()));
              },
              title: AppText(data: "Setting",color: Colors.white,),
            ),
            ListTile(
              onTap: () async{
                SharedPreferences _pref =
                await SharedPreferences.getInstance();
                FirebaseAuth.instance.signOut().then((value) {
                  _pref.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()),
                  );
                });
              },
              title: AppText(data: "Logout",color: Colors.white,),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: AppText(
          data: "Mechanic Home",
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(

          children: [
            DashboardItemWidget(onTap1: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkAssigned()));
            }, onTap2: (){}, titleOne: "Assigned Work", titleTwo: "Work Completed")
          ],
        ),
      ),
    );
  }
}

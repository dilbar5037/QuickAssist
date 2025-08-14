import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/common/login_page.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/shops/add_employee.dart';
import 'package:quickassitnew/shops/add_ofers.dart';
import 'package:quickassitnew/shops/add_service.dart';
import 'package:quickassitnew/shops/asignedwork_all.dart';
import 'package:quickassitnew/shops/shopBooking.dart';
import 'package:quickassitnew/shops/view_all_employees.dart';
import 'package:quickassitnew/shops/view_all_services.dart';
import 'package:quickassitnew/shops/view_oofers.dart';
import 'package:quickassitnew/user/settings_page.dart';
import 'package:quickassitnew/widgets/apptext.dart';
import 'package:quickassitnew/widgets/dashboard_widget.dart';
import 'package:quickassitnew/widgets/mydivider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {
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
    gst = await _pref.getString('gst');

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
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                });
              },
              title: AppText(data: "Logout",color: Colors.white,),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: AppText(
          data: "Shop Home",
          color: Colors.white,
        ),
      ),
      body: Container(
        
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            
            DashboardItemWidget(onTap1: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOfferScreen(),
                ),
              );
            }, onTap2: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OfferListScreen(),
                ),
              );
            }, titleOne: "Add Offer", titleTwo: "ViewAll Offers"),


            MyDivider(),

            DashboardItemWidget(onTap1: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddServiceScreen(),
                ),
              );
            }, onTap2: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceListScreen(uid: uid,),
                ),
              );
            }, titleOne: "Add Service", titleTwo: "ViewAll Services"),

            MyDivider(),
            DashboardItemWidget(onTap1: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopBookings(uid:uid),
                ),
              );
            }, onTap2: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignedWorkPage(),
                ),
              );
            }, titleOne: "All Bookings", titleTwo: "Assigned Work"),



            MyDivider(),
            DashboardItemWidget(onTap1: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEmployeeScreen(shopId: uid!),
                ),
              );
            }, onTap2: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeListScreen(shopId: uid,),
                ),
              );
            }, titleOne: "Add Employee", titleTwo: "ViewAll Employee")
          ],
        ),
      ),
    );
  }
}

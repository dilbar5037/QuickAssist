

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quickassitnew/admin/admin_home_page.dart';
import 'package:quickassitnew/common/login_page.dart';
import 'package:quickassitnew/common/login_view.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/mechanic/mechanic_home_page.dart';
import 'package:quickassitnew/shops/shop_home_page.dart';
import 'package:quickassitnew/user/bottomnavigation_page.dart';
import 'package:quickassitnew/widgets/errorpage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:svg_flutter/svg.dart';
class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {

  final String assetName = 'assets/svg/logo.svg';

  String? _type;
  String?uid;
  String?name;
  String?email;
  String?phone;

  Map<String,dynamic>data={};


  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email= await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');

    setState(() {

      data={

        'uid':uid,
        'name':name,
        'email':email,
        'type':_type,
        'phone':phone
      };
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences _pref=await SharedPreferences.getInstance();
  final token= _pref.getString('token');

    if (token==null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginView()));
    } else {
      if (_type == "admin" ) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AdminHomePage()),
                (route) => false);
      }else if(_type=="user" ){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationPage(data: data,)),
                (route) => false);
      }
      else if(_type=="shop" ){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ShopHomePage()),
                (route) => false);
      }
      else if(_type=="emloyee" ){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MechanicHome()),
                (route) => false);
      }

      else{
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ErrorPage(errorMessage: "Contact Administrator")),
                (route) => false);
      }

    }
  }
  @override
  void initState() {


    getData();
    // Future.delayed(
    //   Duration(seconds: 3),
    //     ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()))
    // );
    var d = Duration(seconds:5);
    Future.delayed(d, () {
      _checkLoginStatus();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,

      body:Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           SvgPicture.asset('assets/svg/logo.svg'),

          ],
        ),
      ),
    );
  }
}

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/user/homePage.dart';
import 'package:quickassitnew/user/mybookings.dart';
import 'package:quickassitnew/user/profilepage.dart';
import 'package:quickassitnew/user/settings_page.dart';

class BottomNavigationPage extends StatefulWidget {
  final  data;
  const BottomNavigationPage({super.key, this.data});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _selectedIndex = 0;
  final iconList = <IconData>[
    Icons.home,
    Icons.bookmark,
    Icons.settings,
    Icons.person,
  ];
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetOptions = [

      Homepage(),
      MyBookings(),
     Settingpage(),
      ProfilePage( data:widget.data)
    ];
  }
final scaffoldKey=GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      backgroundColor: AppColors.scaffoldColor,

        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 20,

        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.contColor5,
          onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => Addpage(data: widget.data,)),
            // );
          },
          child: Icon(
            Icons.add,
            color:Colors.white,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          activeColor:  AppColors.contColor5,
          iconSize: 25,
          icons: iconList,
          activeIndex: _selectedIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _selectedIndex = index),
          //other params
        ),
        body: _widgetOptions.elementAt(_selectedIndex));
  }
}

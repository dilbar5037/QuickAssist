import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:quickassitnew/constans/colors.dart';
import 'package:quickassitnew/user/edit_profile.dart';
import 'package:quickassitnew/user/mybookings.dart';
import 'package:shared_preferences/shared_preferences.dart';





class ProfilePage extends StatefulWidget {
  final  data;
  const ProfilePage({super.key,this.data});


  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? _type;

  String?uid;

  String?name;

  String?email;

  String?phone;
  String?address;
  String?location;
  String?img;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _type = await _pref.getString('type');
    email= await _pref.getString('email');
    name = await _pref.getString('name');
    phone = await _pref.getString('phone');
    uid = await _pref.getString('uid');
    img = await _pref.getString('imgurl');
    address = await _pref.getString('address');
    location = await _pref.getString('location');




    setState(() {});
  }

  @override
  void initState() {
   getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final themedata=Theme.of(context);
    return Scaffold( backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Center(
              child: SizedBox(
                height: 240,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: img != null
                          ? NetworkImage(img!)
                          : AssetImage('assets/img/profile.png') as ImageProvider<Object>,
                      fit: BoxFit.cover, // You can adjust the BoxFit as needed
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Profile",
                    style: themedata.textTheme.displaySmall
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    child: InkWell(
                      onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Editprofilepage()),
                        );
                      },
                      child: Text("Edit",
                          style: themedata.textTheme.displaySmall),
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:20),
                  child: Text(

                    "Personal information",
                   style: themedata.textTheme.displaySmall
                  ),
                ),

              ],
            ),
           SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.only(left: 20,),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person,color: Colors.white,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('${widget.data['name']}',
                        style: themedata.textTheme.displaySmall),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Divider(
                thickness: 1.5,
                color: AppColors.btnPrimaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.phone,color: Colors.white,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(widget.data!['phone'],
                        style: themedata.textTheme.displaySmall),),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Divider(
                thickness: 1.5,
                color: AppColors.btnPrimaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.email_rounded,color: Colors.white,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(widget.data!['email'],
                      style: themedata.textTheme.displaySmall),
                  )

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Divider(
                thickness: 1.5,
                color: AppColors.btnPrimaryColor,
              ),
            ),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.only(left: 30,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.list,color: Colors.white,),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>MyBookings()));
                    },
                    child: Text("Your Bookings",style: themedata.textTheme.displaySmall,),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }


}
